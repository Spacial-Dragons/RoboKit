//
// ===----------------------------------------------------------------------=== //
//
// This source file is part of the RoboKit open source project
//
//
// Licensed under MIT
//
// See LICENSE for license information
// See "Contributors" section on GitHub for the list of project authors
//
// SPDX-License-Identifier: MIT
//
// ===----------------------------------------------------------------------=== //

import simd

/// A structure representing anchor data linking a transformation matrix with an associated image name.
/// This is part of the framework's internal data handling for image tracking.
struct AnchorData: Equatable {
    /// The transformation matrix representing the anchor's position, orientation, and scale.
    let transform: simd_float4x4

    /// The name of the image associated with the anchor.
    let imageName: String

    /// Compares two `AnchorData` instances for equality based solely on their transformation matrices.
    /// - Parameters:
    ///   - lhs: The left-hand side `AnchorData` instance.
    ///   - rhs: The right-hand side `AnchorData` instance.
    /// - Returns: `true` if the transformation matrices are identical; otherwise, `false`.
    /// - Note: The `imageName` property is intentionally excluded from the equality check.
    static func == (lhs: AnchorData, rhs: AnchorData) -> Bool {
        lhs.transform == rhs.transform
    }
}
