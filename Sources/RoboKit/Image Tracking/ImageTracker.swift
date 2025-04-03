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
    
    private let logger = AppLogger.shared.logger(for: .tracking)

    /// Initializes a new `ImageTracker` with the specified AR resource group and tracking images.
    /// - Parameters:
    ///   - arResourceGroupName: The name of the asset catalog group containing the AR reference images.
    ///   - images: An array of `TrackingImage` instances with their associated offsets.
    /// - Note: If a reference image is not found, the initializer will trigger a fatal error.
    public init(arResourceGroupName: String, images: [TrackingImage]) {
        self.referenceImages = ARKit.ReferenceImage.loadReferenceImages(inGroupNamed: arResourceGroupName)
        self.referenceImagesMap = images.reduce(into: [:]) { map, image in
            guard let refImage = self.referenceImages.first(where: { $0.name == image.imageName }) else {
                fatalError("❌ Reference image \(image.imageName) not found")
                logger.fault("❌ Reference image '\(image.imageName, privacy: .public)' not found in asset group '\(arResourceGroupName, privacy: .public)'")

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
    private func initializeImageTracking() {
        guard ImageTrackingProvider.isSupported else {
            logger.warning("Image tracking not supported in this environment. Simulator: Return an identity matrix as a default.")
            return
        }
        
        logger.info("Starting ARKit session with image tracking provider...")
        imageTracking = ImageTrackingProvider(referenceImages: referenceImages)
        Task {
            do {
                try await arKitSession.run([imageTracking!])
                monitorAnchorUpdates()
            } catch {
                logger.error("Failed to start ARKit session: \(error.localizedDescription, privacy: .public)")
            }
        }
    }
    
    /// Retrieves the transformation matrices for the currently tracked images.
    /// - Returns: An array of `simd_float4x4` representing the tracked images' transforms.
    /// - Note: The implementation differs based on the target environment.
    private func getTrackedImagesTransform() -> [simd_float4x4] {
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
    private func monitorAnchorUpdates() {
        logger.debug("🔄 Monitoring anchor updates...")
        Task {
            guard let provider = imageTracking else { return }
            for await update in provider.anchorUpdates {
                logger.info("Anchor \(update.anchor.id.uuidString, privacy: .public) \(String(describing: update.event), privacy: .public)")
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
    private func removeAnchor(_ anchor: ImageAnchor) {
        logger.info("Removing anchor with ID: \(anchor.id.uuidString, privacy: .public)")
        trackedAnchorsMap.removeValue(forKey: anchor.id)
    }
    
    /// Updates an existing anchor entity or creates a new one based on the provided image anchor.
    /// - Parameter anchor: The `ImageAnchor` containing updated tracking information.
    /// - Note: Only anchors that are currently tracked are processed.
    private func updateOrCreateEntity(for anchor: ImageAnchor) {
        logger.debug("Updating tracked anchor for image: \(anchor.referenceImage.name ?? "N/A", privacy: .public)")
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
    private func computeRootPosition() -> simd_float4x4? {
        #if targetEnvironment(simulator)
        logger.info("computeRootPosition: Running in simulator — returning identity matrix.")
        return matrix_identity_float4x4

        #elseif os(visionOS)
        var totalPosition = SIMD3<Float>(0, 0, 0)
        var count = 0

        logger.debug("computeRootPosition: Calculating from \(trackedAnchorsMap.count) tracked anchors.")

        for anchorData in trackedAnchorsMap.values {
            guard let trackingImage = referenceImagesMap[anchorData.imageName]?.0 else {
                logger.warning("computeRootPosition: No tracking image found for anchor named \(anchorData.imageName, privacy: .public)")
                continue
            }

            let adjustedOffset = anchorData.transform.orientation.act(trackingImage.rootOffset)
            let estimatedRootPosition = anchorData.transform.position - adjustedOffset

            logger.debug("Anchor '\(anchorData.imageName, privacy: .public)': estimated root position = \(estimatedRootPosition.debugDescription, privacy: .public)")

            totalPosition += estimatedRootPosition
            count += 1
        }

        if count > 0 {
            let averagePosition = totalPosition / Float(count)
            var rootTransform = matrix_identity_float4x4
            rootTransform.columns.3 = SIMD4<Float>(averagePosition, 1)

            logger.info("computeRootPosition: Computed average position from \(count) anchors: \(averagePosition.debugDescription, privacy: .public)")
            return rootTransform
        }

        logger.info("computeRootPosition: No valid tracked anchors. Returning nil.")
        return nil
        #endif
    }
}
