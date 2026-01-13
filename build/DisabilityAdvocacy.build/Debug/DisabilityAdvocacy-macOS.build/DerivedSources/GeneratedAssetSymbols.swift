import Foundation
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

    /// The "accentBlue" asset catalog color resource.
    static let accentBlue = DeveloperToolsSupport.ColorResource(name: "accentBlue", bundle: resourceBundle)

    /// The "accentGreen" asset catalog color resource.
    static let accentGreen = DeveloperToolsSupport.ColorResource(name: "accentGreen", bundle: resourceBundle)

    /// The "accentOrange" asset catalog color resource.
    static let accentOrange = DeveloperToolsSupport.ColorResource(name: "accentOrange", bundle: resourceBundle)

    /// The "accentPink" asset catalog color resource.
    static let accentPink = DeveloperToolsSupport.ColorResource(name: "accentPink", bundle: resourceBundle)

    /// The "accentPurple" asset catalog color resource.
    static let accentPurple = DeveloperToolsSupport.ColorResource(name: "accentPurple", bundle: resourceBundle)

    /// The "accentRed" asset catalog color resource.
    static let accentRed = DeveloperToolsSupport.ColorResource(name: "accentRed", bundle: resourceBundle)

    /// The "accentTeal" asset catalog color resource.
    static let accentTeal = DeveloperToolsSupport.ColorResource(name: "accentTeal", bundle: resourceBundle)

    /// The "accentYellow" asset catalog color resource.
    static let accentYellow = DeveloperToolsSupport.ColorResource(name: "accentYellow", bundle: resourceBundle)

    /// The "appBackground" asset catalog color resource.
    static let appBackground = DeveloperToolsSupport.ColorResource(name: "appBackground", bundle: resourceBundle)

    /// The "borderColor" asset catalog color resource.
    static let border = DeveloperToolsSupport.ColorResource(name: "borderColor", bundle: resourceBundle)

    /// The "cardBackground" asset catalog color resource.
    static let cardBackground = DeveloperToolsSupport.ColorResource(name: "cardBackground", bundle: resourceBundle)

    /// The "dividerColor" asset catalog color resource.
    static let divider = DeveloperToolsSupport.ColorResource(name: "dividerColor", bundle: resourceBundle)

    /// The "groupedBackground" asset catalog color resource.
    static let groupedBackground = DeveloperToolsSupport.ColorResource(name: "groupedBackground", bundle: resourceBundle)

    /// The "primaryText" asset catalog color resource.
    static let primaryText = DeveloperToolsSupport.ColorResource(name: "primaryText", bundle: resourceBundle)

    /// The "secondaryCardBackground" asset catalog color resource.
    static let secondaryCardBackground = DeveloperToolsSupport.ColorResource(name: "secondaryCardBackground", bundle: resourceBundle)

    /// The "secondaryText" asset catalog color resource.
    static let secondaryText = DeveloperToolsSupport.ColorResource(name: "secondaryText", bundle: resourceBundle)

    /// The "surfaceElevated" asset catalog color resource.
    static let surfaceElevated = DeveloperToolsSupport.ColorResource(name: "surfaceElevated", bundle: resourceBundle)

    /// The "surfaceSecondary" asset catalog color resource.
    static let surfaceSecondary = DeveloperToolsSupport.ColorResource(name: "surfaceSecondary", bundle: resourceBundle)

    /// The "tertiaryText" asset catalog color resource.
    static let tertiaryText = DeveloperToolsSupport.ColorResource(name: "tertiaryText", bundle: resourceBundle)

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

}

