#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"com.disabilityadvocacy.macos";

/// The "accentBlue" asset catalog color resource.
static NSString * const ACColorNameAccentBlue AC_SWIFT_PRIVATE = @"accentBlue";

/// The "accentGreen" asset catalog color resource.
static NSString * const ACColorNameAccentGreen AC_SWIFT_PRIVATE = @"accentGreen";

/// The "accentOrange" asset catalog color resource.
static NSString * const ACColorNameAccentOrange AC_SWIFT_PRIVATE = @"accentOrange";

/// The "accentPink" asset catalog color resource.
static NSString * const ACColorNameAccentPink AC_SWIFT_PRIVATE = @"accentPink";

/// The "accentPurple" asset catalog color resource.
static NSString * const ACColorNameAccentPurple AC_SWIFT_PRIVATE = @"accentPurple";

/// The "accentRed" asset catalog color resource.
static NSString * const ACColorNameAccentRed AC_SWIFT_PRIVATE = @"accentRed";

/// The "accentTeal" asset catalog color resource.
static NSString * const ACColorNameAccentTeal AC_SWIFT_PRIVATE = @"accentTeal";

/// The "accentYellow" asset catalog color resource.
static NSString * const ACColorNameAccentYellow AC_SWIFT_PRIVATE = @"accentYellow";

/// The "appBackground" asset catalog color resource.
static NSString * const ACColorNameAppBackground AC_SWIFT_PRIVATE = @"appBackground";

/// The "borderColor" asset catalog color resource.
static NSString * const ACColorNameBorderColor AC_SWIFT_PRIVATE = @"borderColor";

/// The "cardBackground" asset catalog color resource.
static NSString * const ACColorNameCardBackground AC_SWIFT_PRIVATE = @"cardBackground";

/// The "dividerColor" asset catalog color resource.
static NSString * const ACColorNameDividerColor AC_SWIFT_PRIVATE = @"dividerColor";

/// The "groupedBackground" asset catalog color resource.
static NSString * const ACColorNameGroupedBackground AC_SWIFT_PRIVATE = @"groupedBackground";

/// The "primaryText" asset catalog color resource.
static NSString * const ACColorNamePrimaryText AC_SWIFT_PRIVATE = @"primaryText";

/// The "secondaryCardBackground" asset catalog color resource.
static NSString * const ACColorNameSecondaryCardBackground AC_SWIFT_PRIVATE = @"secondaryCardBackground";

/// The "secondaryText" asset catalog color resource.
static NSString * const ACColorNameSecondaryText AC_SWIFT_PRIVATE = @"secondaryText";

/// The "surfaceElevated" asset catalog color resource.
static NSString * const ACColorNameSurfaceElevated AC_SWIFT_PRIVATE = @"surfaceElevated";

/// The "surfaceSecondary" asset catalog color resource.
static NSString * const ACColorNameSurfaceSecondary AC_SWIFT_PRIVATE = @"surfaceSecondary";

/// The "tertiaryText" asset catalog color resource.
static NSString * const ACColorNameTertiaryText AC_SWIFT_PRIVATE = @"tertiaryText";

#undef AC_SWIFT_PRIVATE
