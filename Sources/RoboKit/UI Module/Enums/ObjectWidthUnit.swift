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

<<<<<<< HEAD
/// An enumeration representing different units of measurement for object width.
///
/// This enum provides standardized width units that can be used throughout the RoboKit
/// application for consistent measurement display and conversion. Each case includes
/// both a raw string value for display and an accessibility description for screen readers.
///
/// ## Usage
/// ```swift
/// let unit = ObjectWidthUnit.millimeters
/// print(unit.rawValue) // "MM"
/// print(unit.accessibilityDescription) // "millimeters"
/// ```
public enum ObjectWidthUnit: String, CaseIterable {
    /// Millimeters - represented as "MM"
    case millimeters = "MM"

    /// Centimeters - represented as "CM"
    case centimeters = "CM"

    /// Meters - represented as "METERS"
    case meters = "METERS"

    /// A human-readable description of the unit for accessibility purposes.
    ///
    /// This property provides a full word description of each unit that can be
    /// used by screen readers and other accessibility features to provide clear
    /// information about the measurement unit.
=======
public enum ObjectWidthUnit: String, CaseIterable {
    case millimeters = "MM"
    case centimeters = "CM"
    case meters = "METERS"

>>>>>>> main
    var accessibilityDescription: String {
        switch self {
        case .millimeters:
            return "millimeters"
        case .centimeters:
            return "centimeters"
        case .meters:
            return "meters"
        }
    }
}
