import simd
import ARKit
import SwiftUI

/// A class responsible for tracking images using ARKit and providing corresponding transformation data.
/// It handles the initialization of AR sessions, image tracking, and updates for tracked anchors.
/// - Note: This class supports different platforms (simulator and visionOS) with platform-specific implementations.
///

enum TrackingError: Error {
    case imageNotFound(imageName: String)
}

@MainActor
@Observable
public class ImageTracker {

    /// The publicly available computed root transformation matrix of the tracked image set.
    public var rootTransform: simd_float4x4? { computeRootPosition() }

    /// A publicly available array of transformation matrices for each tracked image.
    public var trackedImagesTransform: [simd_float4x4] { getTrackedImagesTransform() }

    // Mapping of reference image names to their corresponding tracking image and AR reference image.
    private var referenceImagesMap: [String: (TrackingImage, ARKit.ReferenceImage)] = [:]

    // Array of AR reference images loaded from the specified asset group.
    private var referenceImages: [ARKit.ReferenceImage]

    // ARKit session manager.
    private var arKitSession = ARKitSession()

    // Provider responsible for handling image tracking.
    private var imageTracking: ImageTrackingProvider?

    // Mapping of tracked anchor UUIDs to their corresponding AnchorData.
    private var trackedAnchorsMap: [UUID: AnchorData] = [:]

    /// Initializes a new `ImageTracker` with the specified AR resource group and tracking images.
    /// - Parameters:
    ///   - arResourceGroupName: The name of the asset catalog group containing the AR reference images.
    ///   - images: An array of `TrackingImage` instances with their associated offsets.
    /// - Note: If a reference image is not found, the initializer will trigger a fatal error.
    public init(arResourceGroupName: String, images: [TrackingImage]) {
        // Load images from both main bundle and from the module bundle
        let mainSet = ARKit.ReferenceImage.loadReferenceImages(inGroupNamed: arResourceGroupName, bundle: .main)
        let moduleSet = ARKit.ReferenceImage.loadReferenceImages(inGroupNamed: arResourceGroupName, bundle: .module)
        self.referenceImages = mainSet + moduleSet

        self.referenceImagesMap = images.reduce(into: [:]) { map, image in
            guard let refImage = self.referenceImages.first(where: { $0.name == image.imageName }) else {
                fatalError("❌ Reference image \(image.imageName) not found")
                AppLogger.shared.fault(
                    "❌ Reference image '\(image.imageName)' not found in asset group '\(arResourceGroupName)'",
                    category: .tracking
                )
                /// TODO: Replace fatalError with a proper error propagation mechanism.
                /// The current RoboKit Demo app does not support handling throwing initializers directly
                /// To improve resilience, implement a way
                /// to pass errors from ImageTracker initialization (missing reference images)
                /// back to the app.

                /// throw TrackingError.imageNotFound(imageName: image.imageName)
            }
            map[image.imageName] = (image, refImage)
        }
        initializeImageTracking()
    }

    /// Initializes the image tracking provider and starts the AR session.
    /// - Note: This method checks for platform support. In the simulator, image tracking is not supported.
    internal func initializeImageTracking() {
        guard ImageTrackingProvider.isSupported else {
            AppLogger.shared.warning(
                "Image tracking not supported in this environment. Simulator: Return an identity matrix as a default.",
                category: .tracking
            )
            return
        }

        AppLogger.shared.info("Starting ARKit session with image tracking provider...", category: .tracking)

        imageTracking = ImageTrackingProvider(referenceImages: referenceImages)
        Task {
            do {
                try await arKitSession.run([imageTracking!])
                monitorAnchorUpdates()
            } catch {
                AppLogger.shared.error(
                    "Failed to start ARKit session: \(error.localizedDescription)",
                    category: .tracking
                )
            }
        }
    }

    /// Retrieves the transformation matrices for the currently tracked images.
    /// - Returns: An array of `simd_float4x4` representing the tracked images' transforms.
    /// - Note: The implementation differs based on the target environment.
    internal func getTrackedImagesTransform() -> [simd_float4x4] {
        #if targetEnvironment(simulator)
        // Simulator: Return a default transform for each reference image.
        return referenceImagesMap.values.compactMap { trackingImage, _ in
            var transform = matrix_identity_float4x4
            transform.position = trackingImage.rootOffset
            return transform
        }
        #elseif os(visionOS)
        // visionOS: Return the transform of each tracked anchor.
        return trackedAnchorsMap.values.map { $0.transform }
        #else
        // For other environments, return an empty array.
        return []
        #endif
    }

    /// Monitors anchor updates from the image tracking provider.
    /// - Note: This method listens for added, updated, and removed events and processes them accordingly.
    internal func monitorAnchorUpdates() {
        AppLogger.shared.debug("🔄 Monitoring anchor updates...", category: .tracking)
        Task {
            guard let provider = imageTracking else { return }
            for await update in provider.anchorUpdates {
                AppLogger.shared.info(
                    "Anchor \(update.anchor.id.uuidString) \(String(describing: update.event))",
                    category: .tracking
                )
                switch update.event {
                case .added, .updated:
                    updateOrCreateEntity(for: update.anchor)
                case .removed:
                    removeAnchor(update.anchor)
                }
            }
        }
    }

    /// Removes a tracked anchor from the internal mapping.
    /// - Parameter anchor: The `ImageAnchor` to be removed.
    internal func removeAnchor(_ anchor: ImageAnchor) {
        AppLogger.shared.info("Removing anchor with ID: \(anchor.id.uuidString)", category: .tracking)
        trackedAnchorsMap.removeValue(forKey: anchor.id)
    }

    /// Updates an existing anchor entity or creates a new one based on the provided image anchor.
    /// - Parameter anchor: The `ImageAnchor` containing updated tracking information.
    /// - Note: Only anchors that are currently tracked are processed.
    internal func updateOrCreateEntity(for anchor: ImageAnchor) {
        AppLogger.shared.debug(
            "Updating tracked anchor for image: \(anchor.referenceImage.name ?? "N/A")",
            category: .tracking
        )
        if anchor.isTracked {
            trackedAnchorsMap[anchor.id] = AnchorData(
                transform: anchor.originFromAnchorTransform,
                imageName: anchor.referenceImage.name ?? "N/A"
            )
        }
    }

    /// Computes the estimated root transformation matrix based on the tracked anchors.
    /// - Returns: A `simd_float4x4` representing the averaged root transform, or `nil` if no anchors are tracked.
    /// - Note: The computation adjusts each anchor's transform by its associated image offset.
    internal func computeRootPosition() -> simd_float4x4? {
        #if targetEnvironment(simulator)
        AppLogger.shared.info("Running in simulator — returning identity matrix.", category: .tracking)
        return matrix_identity_float4x4

        #elseif os(visionOS)
        var totalPosition = SIMD3<Float>(0, 0, 0)
        var count = 0

        // Aggregate estimated root positions from all tracked anchors.
        AppLogger.shared.debug("Calculating from \(trackedAnchorsMap.count) tracked anchors.", category: .tracking)
        for anchorData in trackedAnchorsMap.values {
            guard let trackingImage = referenceImagesMap[anchorData.imageName]?.0 else {
                AppLogger.shared.warning(
                    "No tracking image found for anchor named \(anchorData.imageName)",
                    category: .tracking
                )
                continue
            }

            let adjustedOffset = anchorData.transform.orientation.act(trackingImage.rootOffset)
            let estimatedRootPosition = anchorData.transform.position - adjustedOffset

            AppLogger.shared.debug(
                "Anchor '\(anchorData.imageName)': estimated root position = \(estimatedRootPosition.debugDescription)",
                category: .tracking
            )
            totalPosition += estimatedRootPosition
            count += 1
        }

        // Compute the average position if at least one anchor is tracked.
        if count > 0 {
            let averagePosition = totalPosition / Float(count)
            var rootTransform = matrix_identity_float4x4
            rootTransform.columns.3 = SIMD4<Float>(averagePosition, 1)

            AppLogger.shared.info(
                "Computed average position from \(count) anchors: \(averagePosition.debugDescription)",
                category: .tracking
            )
            return rootTransform
        }

        AppLogger.shared.info("No valid tracked anchors. Returning nil.", category: .tracking)
        return nil
        #endif
    }
}
