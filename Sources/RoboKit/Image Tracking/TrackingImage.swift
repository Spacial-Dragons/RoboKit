import RealityKit
import ARKit
import UIKit

/// Represents a tracking image with its associated metadata.
/// This structure is used to define a Tracking image's name and its physical offset relative to a reference point.
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
        // Try .main Bundle first, then .module Bundle
        let foundImage = UIImage(named: imageName, in: .main, with: .none)
            ?? UIImage(named: imageName, in: .module, with: .none)
        
        guard foundImage != nil else {
            fatalError("""
            ❌ Tracking image '\(imageName)' not found in the Assets catalog.
            Please ensure that:
            • The image exists in the .xcassets catalog in the reference folder.
            • The name exactly matches the texture name.
            • The image is included in the app target.
            """)
        }
        
        self.imageName = imageName
        self.rootOffset = rootOffset
    }
}
