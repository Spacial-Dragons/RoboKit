import RealityKit
import ARKit
import UIKit

/// Represents a tracking image with its associated metadata.
/// This structure is used to define a Data Matrix image's name and its physical offset relative to a reference point.

@MainActor
public struct TrackingImage {

    /// The name of the image in the asset catalog.
    /// Must match the image's name exactly as it appears in the Assets catalog.
    let imageName: String
    
    /// The physical offset from the root point, expressed in meters.
    /// Use the RealityKit coordinate system for measurements.
    /// For example, 12.5 / 100 represents an offset of 12.5 centimeters.
    let rootOffset: SIMD3<Float>
    
    /// Initializes a new TrackingImage instance.
    /// - Parameters:
    ///   - imageName: The exact name of the image in the asset catalog.
    ///   - rootOffset: The physical offset from the root point in meters.
    
    ///
    /// The initializer validates that the image exists in the asset catalog. If the image is not found,
    /// it triggers a fatal error with detailed instructions to resolve the issue.
    public init(imageName: String, rootOffset: SIMD3<Float>) {
        // Validate that the image exists in the asset catalog.
        guard UIImage(named: imageName) != nil else {
            fatalError("""
            ❌ Data Matrix image '\(imageName)' not found in the Assets catalog.
            Please ensure that:
            • The image exists in the .xcassets catalog in the reference folder.
            • The name exactly matches the texture name.
            • The image is included in the app target.
            """)
            
            AppLogger.shared.fault("""
                    ❌ TrackingImage init failed: Image '\(imageName)' not found in asset catalog.
                    Possible causes:
                    - Missing from .xcassets
                    - Name mismatch
                    - Not included in target
                    """, category: .tracking)
            /// TODO: Replace fatalError with a proper error propagation mechanism.
            /// The current RoboKit Demo app does not support handling throwing initializers directly
            /// To improve resilience, implement a way
            /// to pass errors from TrackingImage initialization (missing reference images)
            /// back to the app.
            
            /// throw TrackingError.imageNotFound(imageName: image.imageName)
        }
        
        AppLogger.shared.info("TrackingImage created for image '\(imageName)' with root offset \(rootOffset.debugDescription)", category: .tracking)
        
        self.imageName = imageName
        self.rootOffset = rootOffset
    }
}
