#!/usr/bin/env python3
"""
Complete generator for Xcode project.pbxproj file with all sections
"""

import uuid
import os
from pathlib import Path
from collections import defaultdict

def generate_uuid():
    return uuid.uuid4().hex[:24].upper()

# Key UUIDs
PROJECT_UUID = "EDAC707BAB27479DAE963252"
ROOT_GROUP = "A1B2C3D4E5F6789012345678"
IOS_TARGET = "53A5232FEB1E4BE9BFAD6EFA"
MACOS_TARGET = "F2D4BA4E0CE94DE5BA9D4F9C"
IOS_TEST_TARGET = "A787BB4B9E5E4A4092088898"
IOS_UI_TEST_TARGET = "6D40DB7C8AAC486BA4747B5E"

base = Path("/Users/liammatthews/Desktop/APP/DA")

# Collect all files
files_by_category = defaultdict(list)

for swift_file in (base / "Shared").rglob("*.swift"):
    files_by_category['shared'].append(str(swift_file.relative_to(base)))

for swift_file in (base / "iOS").rglob("*.swift"):
    if "Tests" not in str(swift_file):
        files_by_category['ios'].append(str(swift_file.relative_to(base)))

if (base / "iOS" / "Info.plist").exists():
    files_by_category['ios'].append("iOS/Info.plist")

for swift_file in (base / "macOS").rglob("*.swift"):
    files_by_category['macos'].append(str(swift_file.relative_to(base)))

if (base / "macOS" / "Info.plist").exists():
    files_by_category['macos'].append("macOS/Info.plist")
if (base / "macOS" / "AdvocacyApp.entitlements").exists():
    files_by_category['macos'].append("macOS/AdvocacyApp.entitlements")

for swift_file in (base / "iOS" / "DisabilityAdvocacyTests").rglob("*.swift"):
    files_by_category['tests'].append(str(swift_file.relative_to(base)))

for swift_file in (base / "iOS" / "DisabilityAdvocacyUITests").rglob("*.swift"):
    files_by_category['ui_tests'].append(str(swift_file.relative_to(base)))

files_by_category['resources'] = [
    "Resources/Assets.xcassets",
    "Resources/Events.json",
    "Resources/Resources.json",
    "Resources/Localizable.xcstrings",
    "Resources/PrivacyInfo.xcprivacy",
]

all_files = sorted(set(sum(files_by_category.values(), [])))

# Generate UUIDs
file_refs = {f: generate_uuid() for f in all_files}
build_files = {f: generate_uuid() for f in all_files}

# Groups
groups = {
    'Shared': generate_uuid(),
    'iOS': generate_uuid(),
    'macOS': generate_uuid(),
    'Resources': generate_uuid(),
    'Products': generate_uuid(),
    'Shared/Managers': generate_uuid(),
    'Shared/Models': generate_uuid(),
    'Shared/Models/Core': generate_uuid(),
    'Shared/Models/Navigation': generate_uuid(),
    'Shared/Models/Persistence': generate_uuid(),
    'Shared/Models/UI': generate_uuid(),
    'Shared/ViewModels': generate_uuid(),
    'Shared/Views': generate_uuid(),
    'Shared/Views/Admin': generate_uuid(),
    'Shared/Views/Components': generate_uuid(),
    'Shared/Views/Main': generate_uuid(),
    'Shared/Views/Navigation': generate_uuid(),
    'Shared/Views/Onboarding': generate_uuid(),
    'Shared/Views/Search': generate_uuid(),
    'Shared/Views/Settings': generate_uuid(),
    'Shared/Utilities': generate_uuid(),
    'Shared/Extensions': generate_uuid(),
    'iOS/Views': generate_uuid(),
    'macOS/Views': generate_uuid(),
    'macOS/Extensions': generate_uuid(),
    'iOS/DisabilityAdvocacyTests': generate_uuid(),
    'iOS/DisabilityAdvocacyTests/Helpers': generate_uuid(),
    'iOS/DisabilityAdvocacyTests/Helpers/Mocks': generate_uuid(),
    'iOS/DisabilityAdvocacyTests/TestData': generate_uuid(),
    'iOS/DisabilityAdvocacyTests/UnitTests': generate_uuid(),
    'iOS/DisabilityAdvocacyTests/UnitTests/Utilities': generate_uuid(),
    'iOS/DisabilityAdvocacyTests/UnitTests/ViewModels': generate_uuid(),
    'iOS/DisabilityAdvocacyUITests': generate_uuid(),
}

# Products
ios_product = generate_uuid()
macos_product = generate_uuid()
test_product = generate_uuid()
uitest_product = generate_uuid()

# Build phases
ios_sources = generate_uuid()
ios_resources = generate_uuid()
ios_frameworks = generate_uuid()
macos_sources = generate_uuid()
macos_resources = generate_uuid()
macos_frameworks = generate_uuid()
test_sources = generate_uuid()
test_frameworks = generate_uuid()
uitest_sources = generate_uuid()
uitest_frameworks = generate_uuid()

# Configurations
project_debug = generate_uuid()
project_release = generate_uuid()
ios_debug = generate_uuid()
ios_release = generate_uuid()
macos_debug = generate_uuid()
macos_release = generate_uuid()
test_debug = generate_uuid()
test_release = generate_uuid()
uitest_debug = generate_uuid()
uitest_release = generate_uuid()

config_list_project = generate_uuid()
config_list_ios = generate_uuid()
config_list_macos = generate_uuid()
config_list_test = generate_uuid()
config_list_uitest = generate_uuid()

test_dependency = generate_uuid()

def get_file_type(path):
    if path.endswith('Contents.json'):
        return 'text.json'
    ext = os.path.splitext(path)[1]
    return {
        '.swift': 'sourcecode.swift',
        '.plist': 'text.plist.xml',
        '.entitlements': 'text.plist.entitlements',
        '.json': 'text.json',
        '.xcstrings': 'text.plist.strings',
        '.xcprivacy': 'text',
        '.xcassets': 'folder.assetcatalog',
    }.get(ext, 'text')

def get_group_for_file(filepath):
    """Determine which group a file belongs to"""
    if filepath.startswith('Shared/Managers/'):
        return 'Shared/Managers'
    elif filepath.startswith('Shared/Models/Core/'):
        return 'Shared/Models/Core'
    elif filepath.startswith('Shared/Models/Navigation/'):
        return 'Shared/Models/Navigation'
    elif filepath.startswith('Shared/Models/Persistence/'):
        return 'Shared/Models/Persistence'
    elif filepath.startswith('Shared/Models/UI/'):
        return 'Shared/Models/UI'
    elif filepath.startswith('Shared/ViewModels/'):
        return 'Shared/ViewModels'
    elif filepath.startswith('Shared/Views/Admin/'):
        return 'Shared/Views/Admin'
    elif filepath.startswith('Shared/Views/Components/'):
        return 'Shared/Views/Components'
    elif filepath.startswith('Shared/Views/Main/'):
        return 'Shared/Views/Main'
    elif filepath.startswith('Shared/Views/Navigation/'):
        return 'Shared/Views/Navigation'
    elif filepath.startswith('Shared/Views/Onboarding/'):
        return 'Shared/Views/Onboarding'
    elif filepath.startswith('Shared/Views/Search/'):
        return 'Shared/Views/Search'
    elif filepath.startswith('Shared/Views/Settings/'):
        return 'Shared/Views/Settings'
    elif filepath.startswith('Shared/Utilities/'):
        return 'Shared/Utilities'
    elif filepath.startswith('Shared/Extensions/'):
        return 'Shared/Extensions'
    elif filepath.startswith('iOS/Views/'):
        return 'iOS/Views'
    elif filepath.startswith('macOS/Views/'):
        return 'macOS/Views'
    elif filepath.startswith('macOS/Extensions/'):
        return 'macOS/Extensions'
    elif filepath.startswith('iOS/DisabilityAdvocacyTests/Helpers/Mocks/'):
        return 'iOS/DisabilityAdvocacyTests/Helpers/Mocks'
    elif filepath.startswith('iOS/DisabilityAdvocacyTests/Helpers/'):
        return 'iOS/DisabilityAdvocacyTests/Helpers'
    elif filepath.startswith('iOS/DisabilityAdvocacyTests/TestData/'):
        return 'iOS/DisabilityAdvocacyTests/TestData'
    elif filepath.startswith('iOS/DisabilityAdvocacyTests/UnitTests/Utilities/'):
        return 'iOS/DisabilityAdvocacyTests/UnitTests/Utilities'
    elif filepath.startswith('iOS/DisabilityAdvocacyTests/UnitTests/ViewModels/'):
        return 'iOS/DisabilityAdvocacyTests/UnitTests/ViewModels'
    elif filepath.startswith('iOS/DisabilityAdvocacyTests/'):
        return 'iOS/DisabilityAdvocacyTests'
    elif filepath.startswith('iOS/DisabilityAdvocacyUITests/'):
        return 'iOS/DisabilityAdvocacyUITests'
    elif filepath.startswith('iOS/'):
        return 'iOS'
    elif filepath.startswith('macOS/'):
        return 'macOS'
    elif filepath.startswith('Resources/'):
        return 'Resources'
    return None

# Organize files by group
files_by_group = defaultdict(list)
for f in all_files:
    group = get_group_for_file(f)
    if group:
        files_by_group[group].append(f)

# Start building the complete project file
output = []
output.append('// !$*UTF8*$!')
output.append('{')
output.append('\tarchiveVersion = 1;')
output.append('\tclasses = {')
output.append('\t};')
output.append('\tobjectVersion = 56;')
output.append('\tobjects = {')
output.append('')

# PBXBuildFile section
output.append('\t\t/* Begin PBXBuildFile section */')

# iOS sources (shared + iOS)
ios_source_files = files_by_category['shared'] + files_by_category['ios']
for f in ios_source_files:
    if f.endswith('.swift'):
        bf_uuid = build_files[f]
        fr_uuid = file_refs[f]
        name = os.path.basename(f)
        output.append(f'\t\t{bf_uuid} /* {name} in Sources */ = {{isa = PBXBuildFile; fileRef = {fr_uuid} /* {name} */; }};')

# macOS sources (shared + macOS)
macos_source_files = files_by_category['shared'] + files_by_category['macos']
for f in macos_source_files:
    if f.endswith('.swift'):
        bf_uuid = build_files[f]
        fr_uuid = file_refs[f]
        name = os.path.basename(f)
        output.append(f'\t\t{bf_uuid} /* {name} in Sources */ = {{isa = PBXBuildFile; fileRef = {fr_uuid} /* {name} */; }};')

# Test sources
for f in files_by_category['tests']:
    if f.endswith('.swift'):
        bf_uuid = build_files[f]
        fr_uuid = file_refs[f]
        name = os.path.basename(f)
        output.append(f'\t\t{bf_uuid} /* {name} in Sources */ = {{isa = PBXBuildFile; fileRef = {fr_uuid} /* {name} */; }};')

# UI Test sources
for f in files_by_category['ui_tests']:
    if f.endswith('.swift'):
        bf_uuid = build_files[f]
        fr_uuid = file_refs[f]
        name = os.path.basename(f)
        output.append(f'\t\t{bf_uuid} /* {name} in Sources */ = {{isa = PBXBuildFile; fileRef = {fr_uuid} /* {name} */; }};')

# Resources (for both iOS and macOS)
for f in files_by_category['resources']:
    bf_uuid = build_files[f]
    fr_uuid = file_refs[f]
    name = os.path.basename(f)
    output.append(f'\t\t{bf_uuid} /* {name} in Resources */ = {{isa = PBXBuildFile; fileRef = {fr_uuid} /* {name} */; }};')

output.append('\t\t/* End PBXBuildFile section */')
output.append('')

# PBXFileReference section
output.append('\t\t/* Begin PBXFileReference section */')
output.append(f'\t\t{ios_product} /* DisabilityAdvocacy.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = DisabilityAdvocacy.app; sourceTree = BUILT_PRODUCTS_DIR; }};')
output.append(f'\t\t{macos_product} /* DisabilityAdvocacy.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = DisabilityAdvocacy.app; sourceTree = BUILT_PRODUCTS_DIR; }};')
output.append(f'\t\t{test_product} /* DisabilityAdvocacyTests.xctest */ = {{isa = PBXFileReference; explicitFileType = wrapper.cfbundle; includeInIndex = 0; path = DisabilityAdvocacyTests.xctest; sourceTree = BUILT_PRODUCTS_DIR; }};')
output.append(f'\t\t{uitest_product} /* DisabilityAdvocacyUITests.xctest */ = {{isa = PBXFileReference; explicitFileType = wrapper.cfbundle; includeInIndex = 0; path = DisabilityAdvocacyUITests.xctest; sourceTree = BUILT_PRODUCTS_DIR; }};')

for f in all_files:
    file_uuid = file_refs[f]
    name = os.path.basename(f)
    file_type = get_file_type(f)
    if file_type == 'folder.assetcatalog':
        output.append(f'\t\t{file_uuid} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = {file_type}; path = {name}; sourceTree = "<group>"; }};')
    else:
        output.append(f'\t\t{file_uuid} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = {file_type}; path = "{f}"; sourceTree = "<group>"; }};')

output.append('\t\t/* End PBXFileReference section */')
output.append('')

# PBXGroup section - organize files into groups
output.append('\t\t/* Begin PBXGroup section */')

# Helper function to build group entries
def build_group_entry(group_name, group_uuid, children_items):
    """children_items is a list of (uuid, name) tuples"""
    if not children_items:
        return None
    children_str = ',\n\t\t\t\t'.join([f'{uuid} /* {name} */' for uuid, name in children_items])
    path_name = group_name.split("/")[-1] if "/" in group_name else group_name
    return f'\t\t{group_uuid} /* {group_name} */ = {{\n\t\t\tisa = PBXGroup;\n\t\t\tchildren = (\n\t\t\t\t{children_str}\n\t\t\t);\n\t\t\tpath = {path_name};\n\t\t\tsourceTree = "<group>";\n\t\t}};'

# Build groups hierarchically
# First, collect files by their immediate group
group_files = defaultdict(list)
for f in all_files:
    group = get_group_for_file(f)
    if group:
        group_files[group].append((file_refs[f], os.path.basename(f)))

# Build nested group structure
def get_subgroups(parent_group):
    """Get all subgroups that belong to a parent group"""
    subgroups = []
    for group_name in groups.keys():
        if group_name.startswith(parent_group + "/") and group_name != parent_group:
            # Check if this is a direct child (only one level deeper)
            remaining = group_name[len(parent_group)+1:]
            if "/" not in remaining:
                subgroups.append((groups[group_name], remaining))
    return subgroups

# Build group entries from leaf to root
group_entries = {}

# Start with leaf groups (those with files or no subgroups)
for group_name, group_uuid in groups.items():
    children = []
    # Add files
    if group_name in group_files:
        children.extend(group_files[group_name])
    # Add subgroups
    subgroups = get_subgroups(group_name)
    children.extend(subgroups)
    
    if children:
        group_entries[group_name] = build_group_entry(group_name, group_uuid, children)

# Add Products group
products_children = [
    (ios_product, 'DisabilityAdvocacy.app'),
    (macos_product, 'DisabilityAdvocacy.app'),
    (test_product, 'DisabilityAdvocacyTests.xctest'),
    (uitest_product, 'DisabilityAdvocacyUITests.xctest'),
]
group_entries['Products'] = build_group_entry('Products', groups['Products'], products_children)

# Output all group entries
for group_name in sorted(groups.keys()):
    if group_name in group_entries and group_entries[group_name]:
        output.append(group_entries[group_name])

# Add Products group
if 'Products' in group_entries:
    output.append(group_entries['Products'])

# Root group
root_children = [
    (groups['Shared'], 'Shared'),
    (groups['iOS'], 'iOS'),
    (groups['macOS'], 'macOS'),
    (groups['Resources'], 'Resources'),
    (groups['Products'], 'Products'),
]
root_children_str = ',\n\t\t\t\t'.join([f'{uuid} /* {name} */' for uuid, name in root_children])
output.append(f'\t\t{ROOT_GROUP} = {{\n\t\t\tisa = PBXGroup;\n\t\t\tchildren = (\n\t\t\t\t{root_children_str}\n\t\t\t);\n\t\t\tsourceTree = "<group>";\n\t\t}};')

output.append('\t\t/* End PBXGroup section */')
output.append('')

# PBXSourcesBuildPhase sections
output.append('\t\t/* Begin PBXSourcesBuildPhase section */')

# iOS sources phase
ios_source_build_files = [build_files[f] for f in ios_source_files if f.endswith('.swift')]
ios_sources_entries = ',\n\t\t\t\t'.join([f'{bf} /* {os.path.basename(f)} in Sources */' for bf, f in zip(ios_source_build_files, [f for f in ios_source_files if f.endswith('.swift')])])
output.append(f'\t\t{ios_sources} /* Sources */ = {{\n\t\t\tisa = PBXSourcesBuildPhase;\n\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = (\n\t\t\t\t{ios_sources_entries}\n\t\t\t);\n\t\t\trunOnlyForDeploymentPostprocessing = 0;\n\t\t}};')

# macOS sources phase
macos_source_build_files = [build_files[f] for f in macos_source_files if f.endswith('.swift')]
macos_sources_entries = ',\n\t\t\t\t'.join([f'{bf} /* {os.path.basename(f)} in Sources */' for bf, f in zip(macos_source_build_files, [f for f in macos_source_files if f.endswith('.swift')])])
output.append(f'\t\t{macos_sources} /* Sources */ = {{\n\t\t\tisa = PBXSourcesBuildPhase;\n\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = (\n\t\t\t\t{macos_sources_entries}\n\t\t\t);\n\t\t\trunOnlyForDeploymentPostprocessing = 0;\n\t\t}};')

# Test sources phase
test_source_build_files = [build_files[f] for f in files_by_category['tests'] if f.endswith('.swift')]
test_sources_entries = ',\n\t\t\t\t'.join([f'{bf} /* {os.path.basename(f)} in Sources */' for bf, f in zip(test_source_build_files, [f for f in files_by_category['tests'] if f.endswith('.swift')])])
output.append(f'\t\t{test_sources} /* Sources */ = {{\n\t\t\tisa = PBXSourcesBuildPhase;\n\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = (\n\t\t\t\t{test_sources_entries}\n\t\t\t);\n\t\t\trunOnlyForDeploymentPostprocessing = 0;\n\t\t}};')

# UI Test sources phase
uitest_source_build_files = [build_files[f] for f in files_by_category['ui_tests'] if f.endswith('.swift')]
uitest_sources_entries = ',\n\t\t\t\t'.join([f'{bf} /* {os.path.basename(f)} in Sources */' for bf, f in zip(uitest_source_build_files, [f for f in files_by_category['ui_tests'] if f.endswith('.swift')])])
output.append(f'\t\t{uitest_sources} /* Sources */ = {{\n\t\t\tisa = PBXSourcesBuildPhase;\n\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = (\n\t\t\t\t{uitest_sources_entries}\n\t\t\t);\n\t\t\trunOnlyForDeploymentPostprocessing = 0;\n\t\t}};')

output.append('\t\t/* End PBXSourcesBuildPhase section */')
output.append('')

# PBXResourcesBuildPhase sections
output.append('\t\t/* Begin PBXResourcesBuildPhase section */')

# iOS resources
ios_resource_build_files = [build_files[f] for f in files_by_category['resources']]
ios_resources_entries = ',\n\t\t\t\t'.join([f'{bf} /* {os.path.basename(f)} in Resources */' for bf, f in zip(ios_resource_build_files, files_by_category['resources'])])
output.append(f'\t\t{ios_resources} /* Resources */ = {{\n\t\t\tisa = PBXResourcesBuildPhase;\n\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = (\n\t\t\t\t{ios_resources_entries}\n\t\t\t);\n\t\t\trunOnlyForDeploymentPostprocessing = 0;\n\t\t}};')

# macOS resources
macos_resource_build_files = [build_files[f] for f in files_by_category['resources']]
macos_resources_entries = ',\n\t\t\t\t'.join([f'{bf} /* {os.path.basename(f)} in Resources */' for bf, f in zip(macos_resource_build_files, files_by_category['resources'])])
output.append(f'\t\t{macos_resources} /* Resources */ = {{\n\t\t\tisa = PBXResourcesBuildPhase;\n\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = (\n\t\t\t\t{macos_resources_entries}\n\t\t\t);\n\t\t\trunOnlyForDeploymentPostprocessing = 0;\n\t\t}};')

output.append('\t\t/* End PBXResourcesBuildPhase section */')
output.append('')

# PBXFrameworksBuildPhase sections
output.append('\t\t/* Begin PBXFrameworksBuildPhase section */')
output.append(f'\t\t{ios_frameworks} /* Frameworks */ = {{\n\t\t\tisa = PBXFrameworksBuildPhase;\n\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = (\n\t\t\t);\n\t\t\trunOnlyForDeploymentPostprocessing = 0;\n\t\t}};')
output.append(f'\t\t{macos_frameworks} /* Frameworks */ = {{\n\t\t\tisa = PBXFrameworksBuildPhase;\n\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = (\n\t\t\t);\n\t\t\trunOnlyForDeploymentPostprocessing = 0;\n\t\t}};')
output.append(f'\t\t{test_frameworks} /* Frameworks */ = {{\n\t\t\tisa = PBXFrameworksBuildPhase;\n\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = (\n\t\t\t);\n\t\t\trunOnlyForDeploymentPostprocessing = 0;\n\t\t}};')
output.append(f'\t\t{uitest_frameworks} /* Frameworks */ = {{\n\t\t\tisa = PBXFrameworksBuildPhase;\n\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = (\n\t\t\t);\n\t\t\trunOnlyForDeploymentPostprocessing = 0;\n\t\t}};')
output.append('\t\t/* End PBXFrameworksBuildPhase section */')
output.append('')

# PBXTargetDependency
target_proxy_uuid = generate_uuid()
output.append('\t\t/* Begin PBXTargetDependency section */')
output.append(f'\t\t{test_dependency} /* PBXTargetDependency */ = {{\n\t\t\tisa = PBXTargetDependency;\n\t\t\ttarget = {IOS_TARGET} /* DisabilityAdvocacy-iOS */;\n\t\t\ttargetProxy = {target_proxy_uuid} /* PBXContainerItemProxy */;\n\t\t}};')
output.append('\t\t/* End PBXTargetDependency section */')
output.append('')

# XCBuildConfiguration sections
output.append('\t\t/* Begin XCBuildConfiguration section */')

# Project Debug
output.append(f'\t\t{project_debug} /* Debug */ = {{\n\t\t\tisa = XCBuildConfiguration;\n\t\t\tbuildSettings = {{\n\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;\n\t\t\t\tCLANG_ANALYZER_NONNULL = YES;\n\t\t\t\tCLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;\n\t\t\t\tCLANG_CXX_LANGUAGE_STANDARD = "gnu++20";\n\t\t\t\tCLANG_ENABLE_MODULES = YES;\n\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;\n\t\t\t\tCLANG_ENABLE_OBJC_WEAK = YES;\n\t\t\t\tCLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;\n\t\t\t\tCLANG_WARN_BOOL_CONVERSION = YES;\n\t\t\t\tCLANG_WARN_COMMA = YES;\n\t\t\t\tCLANG_WARN_CONSTANT_CONVERSION = YES;\n\t\t\t\tCLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;\n\t\t\t\tCLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;\n\t\t\t\tCLANG_WARN_DOCUMENTATION_COMMENTS = YES;\n\t\t\t\tCLANG_WARN_EMPTY_BODY = YES;\n\t\t\t\tCLANG_WARN_ENUM_CONVERSION = YES;\n\t\t\t\tCLANG_WARN_INFINITE_RECURSION = YES;\n\t\t\t\tCLANG_WARN_INT_CONVERSION = YES;\n\t\t\t\tCLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;\n\t\t\t\tCLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;\n\t\t\t\tCLANG_WARN_OBJC_LITERAL_CONVERSION = YES;\n\t\t\t\tCLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;\n\t\t\t\tCLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;\n\t\t\t\tCLANG_WARN_RANGE_LOOP_ANALYSIS = YES;\n\t\t\t\tCLANG_WARN_STRICT_PROTOTYPES = YES;\n\t\t\t\tCLANG_WARN_SUSPICIOUS_MOVE = YES;\n\t\t\t\tCLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;\n\t\t\t\tCLANG_WARN_UNREACHABLE_CODE = YES;\n\t\t\t\tCLANG_WARN__DUPLICATE_METHOD_MATCH = YES;\n\t\t\t\tCOPY_PHASE_STRIP = NO;\n\t\t\t\tDEBUG_INFORMATION_FORMAT = dwarf;\n\t\t\t\tENABLE_STRICT_OBJC_MSGSEND = YES;\n\t\t\t\tENABLE_TESTABILITY = YES;\n\t\t\t\tGCC_C_LANGUAGE_STANDARD = gnu17;\n\t\t\t\tGCC_DYNAMIC_NO_PIC = NO;\n\t\t\t\tGCC_NO_COMMON_BLOCKS = YES;\n\t\t\t\tGCC_OPTIMIZATION_LEVEL = 0;\n\t\t\t\tGCC_PREPROCESSOR_DEFINITIONS = (\n\t\t\t\t\t"DEBUG=1",\n\t\t\t\t\t"$(inherited)",\n\t\t\t\t);\n\t\t\t\tGCC_WARN_64_TO_32_BIT_CONVERSION = YES;\n\t\t\t\tGCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;\n\t\t\t\tGCC_WARN_UNDECLARED_SELECTOR = YES;\n\t\t\t\tGCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;\n\t\t\t\tGCC_WARN_UNUSED_FUNCTION = YES;\n\t\t\t\tGCC_WARN_UNUSED_VARIABLE = YES;\n\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 18.0;\n\t\t\t\tMACOSX_DEPLOYMENT_TARGET = 15.0;\n\t\t\t\tMTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;\n\t\t\t\tMTL_FAST_MATH = YES;\n\t\t\t\tONLY_ACTIVE_ARCH = YES;\n\t\t\t\tSDKROOT = auto;\n\t\t\t\tSWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;\n\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-Onone";\n\t\t\t}};\n\t\t\tname = Debug;\n\t\t}};')

# Project Release
output.append(f'\t\t{project_release} /* Release */ = {{\n\t\t\tisa = XCBuildConfiguration;\n\t\t\tbuildSettings = {{\n\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;\n\t\t\t\tCLANG_ANALYZER_NONNULL = YES;\n\t\t\t\tCLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;\n\t\t\t\tCLANG_CXX_LANGUAGE_STANDARD = "gnu++20";\n\t\t\t\tCLANG_ENABLE_MODULES = YES;\n\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;\n\t\t\t\tCLANG_ENABLE_OBJC_WEAK = YES;\n\t\t\t\tCLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;\n\t\t\t\tCLANG_WARN_BOOL_CONVERSION = YES;\n\t\t\t\tCLANG_WARN_COMMA = YES;\n\t\t\t\tCLANG_WARN_CONSTANT_CONVERSION = YES;\n\t\t\t\tCLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;\n\t\t\t\tCLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;\n\t\t\t\tCLANG_WARN_DOCUMENTATION_COMMENTS = YES;\n\t\t\t\tCLANG_WARN_EMPTY_BODY = YES;\n\t\t\t\tCLANG_WARN_ENUM_CONVERSION = YES;\n\t\t\t\tCLANG_WARN_INFINITE_RECURSION = YES;\n\t\t\t\tCLANG_WARN_INT_CONVERSION = YES;\n\t\t\t\tCLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;\n\t\t\t\tCLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;\n\t\t\t\tCLANG_WARN_OBJC_LITERAL_CONVERSION = YES;\n\t\t\t\tCLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;\n\t\t\t\tCLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;\n\t\t\t\tCLANG_WARN_RANGE_LOOP_ANALYSIS = YES;\n\t\t\t\tCLANG_WARN_STRICT_PROTOTYPES = YES;\n\t\t\t\tCLANG_WARN_SUSPICIOUS_MOVE = YES;\n\t\t\t\tCLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;\n\t\t\t\tCLANG_WARN_UNREACHABLE_CODE = YES;\n\t\t\t\tCLANG_WARN__DUPLICATE_METHOD_MATCH = YES;\n\t\t\t\tCOPY_PHASE_STRIP = NO;\n\t\t\t\tDEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";\n\t\t\t\tENABLE_NS_ASSERTIONS = NO;\n\t\t\t\tENABLE_STRICT_OBJC_MSGSEND = YES;\n\t\t\t\tGCC_C_LANGUAGE_STANDARD = gnu17;\n\t\t\t\tGCC_NO_COMMON_BLOCKS = YES;\n\t\t\t\tGCC_WARN_64_TO_32_BIT_CONVERSION = YES;\n\t\t\t\tGCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;\n\t\t\t\tGCC_WARN_UNDECLARED_SELECTOR = YES;\n\t\t\t\tGCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;\n\t\t\t\tGCC_WARN_UNUSED_FUNCTION = YES;\n\t\t\t\tGCC_WARN_UNUSED_VARIABLE = YES;\n\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 18.0;\n\t\t\t\tMACOSX_DEPLOYMENT_TARGET = 15.0;\n\t\t\t\tMTL_ENABLE_DEBUG_INFO = NO;\n\t\t\t\tMTL_FAST_MATH = YES;\n\t\t\t\tSDKROOT = auto;\n\t\t\t\tSWIFT_COMPILATION_MODE = wholemodule;\n\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-O";\n\t\t\t}};\n\t\t\tname = Release;\n\t\t}};')

# iOS Debug
output.append(f'\t\t{ios_debug} /* Debug */ = {{\n\t\t\tisa = XCBuildConfiguration;\n\t\t\tbuildSettings = {{\n\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;\n\t\t\t\tASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;\n\t\t\t\tCODE_SIGN_STYLE = Automatic;\n\t\t\t\tCURRENT_PROJECT_VERSION = 1;\n\t\t\t\tDEVELOPMENT_TEAM = "";\n\t\t\t\tGENERATE_INFOPLIST_FILE = NO;\n\t\t\t\tINFOPLIST_FILE = iOS/Info.plist;\n\t\t\t\tINFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;\n\t\t\t\tINFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;\n\t\t\t\tINFOPLIST_KEY_UILaunchScreen_Generation = YES;\n\t\t\t\tINFOPLIST_KEY_UISupportedInterfaceOrientations = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";\n\t\t\t\tINFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";\n\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 18.0;\n\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (\n\t\t\t\t\t"$(inherited)",\n\t\t\t\t\t"@executable_path/Frameworks",\n\t\t\t\t);\n\t\t\t\tMARKETING_VERSION = 1.0;\n\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.disabilityadvocacy.ios;\n\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";\n\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;\n\t\t\t\tSWIFT_VERSION = 5.0;\n\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";\n\t\t\t}};\n\t\t\tname = Debug;\n\t\t}};')

# iOS Release
output.append(f'\t\t{ios_release} /* Release */ = {{\n\t\t\tisa = XCBuildConfiguration;\n\t\t\tbuildSettings = {{\n\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;\n\t\t\t\tASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;\n\t\t\t\tCODE_SIGN_STYLE = Automatic;\n\t\t\t\tCURRENT_PROJECT_VERSION = 1;\n\t\t\t\tDEVELOPMENT_TEAM = "";\n\t\t\t\tGENERATE_INFOPLIST_FILE = NO;\n\t\t\t\tINFOPLIST_FILE = iOS/Info.plist;\n\t\t\t\tINFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;\n\t\t\t\tINFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;\n\t\t\t\tINFOPLIST_KEY_UILaunchScreen_Generation = YES;\n\t\t\t\tINFOPLIST_KEY_UISupportedInterfaceOrientations = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";\n\t\t\t\tINFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";\n\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 18.0;\n\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (\n\t\t\t\t\t"$(inherited)",\n\t\t\t\t\t"@executable_path/Frameworks",\n\t\t\t\t);\n\t\t\t\tMARKETING_VERSION = 1.0;\n\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.disabilityadvocacy.ios;\n\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";\n\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;\n\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-Owholemodule";\n\t\t\t\tSWIFT_VERSION = 5.0;\n\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";\n\t\t\t}};\n\t\t\tname = Release;\n\t\t}};')

# macOS Debug
output.append(f'\t\t{macos_debug} /* Debug */ = {{\n\t\t\tisa = XCBuildConfiguration;\n\t\t\tbuildSettings = {{\n\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;\n\t\t\t\tCODE_SIGN_ENTITLEMENTS = macOS/AdvocacyApp.entitlements;\n\t\t\t\tCODE_SIGN_STYLE = Automatic;\n\t\t\t\tCURRENT_PROJECT_VERSION = 1;\n\t\t\t\tDEVELOPMENT_TEAM = "";\n\t\t\t\tGENERATE_INFOPLIST_FILE = NO;\n\t\t\t\tINFOPLIST_FILE = macOS/Info.plist;\n\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (\n\t\t\t\t\t"$(inherited)",\n\t\t\t\t\t"@executable_path/../Frameworks",\n\t\t\t);\n\t\t\t\tMACOSX_DEPLOYMENT_TARGET = 15.0;\n\t\t\t\tMARKETING_VERSION = 1.0;\n\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.disabilityadvocacy.macos;\n\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";\n\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;\n\t\t\t\tSWIFT_VERSION = 5.0;\n\t\t\t}};\n\t\t\tname = Debug;\n\t\t}};')

# macOS Release
output.append(f'\t\t{macos_release} /* Release */ = {{\n\t\t\tisa = XCBuildConfiguration;\n\t\t\tbuildSettings = {{\n\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;\n\t\t\t\tCODE_SIGN_ENTITLEMENTS = macOS/AdvocacyApp.entitlements;\n\t\t\t\tCODE_SIGN_STYLE = Automatic;\n\t\t\t\tCURRENT_PROJECT_VERSION = 1;\n\t\t\t\tDEVELOPMENT_TEAM = "";\n\t\t\t\tGENERATE_INFOPLIST_FILE = NO;\n\t\t\t\tINFOPLIST_FILE = macOS/Info.plist;\n\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (\n\t\t\t\t\t"$(inherited)",\n\t\t\t\t\t"@executable_path/../Frameworks",\n\t\t\t);\n\t\t\t\tMACOSX_DEPLOYMENT_TARGET = 15.0;\n\t\t\t\tMARKETING_VERSION = 1.0;\n\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.disabilityadvocacy.macos;\n\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";\n\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;\n\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-Owholemodule";\n\t\t\t\tSWIFT_VERSION = 5.0;\n\t\t\t}};\n\t\t\tname = Release;\n\t\t}};')

# Test Debug
output.append(f'\t\t{test_debug} /* Debug */ = {{\n\t\t\tisa = XCBuildConfiguration;\n\t\t\tbuildSettings = {{\n\t\t\t\tBUNDLE_LOADER = "$(TEST_HOST)";\n\t\t\t\tCODE_SIGN_STYLE = Automatic;\n\t\t\t\tCURRENT_PROJECT_VERSION = 1;\n\t\t\t\tDEVELOPMENT_TEAM = "";\n\t\t\t\tGENERATE_INFOPLIST_FILE = YES;\n\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 18.0;\n\t\t\t\tMARKETING_VERSION = 1.0;\n\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.disabilityadvocacy.ios.tests;\n\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";\n\t\t\t\tSWIFT_EMIT_LOC_STRINGS = NO;\n\t\t\t\tSWIFT_VERSION = 5.0;\n\t\t\t\tTEST_HOST = "$(BUILT_PRODUCTS_DIR)/DisabilityAdvocacy.app/DisabilityAdvocacy";\n\t\t\t}};\n\t\t\tname = Debug;\n\t\t}};')

# Test Release
output.append(f'\t\t{test_release} /* Release */ = {{\n\t\t\tisa = XCBuildConfiguration;\n\t\t\tbuildSettings = {{\n\t\t\t\tBUNDLE_LOADER = "$(TEST_HOST)";\n\t\t\t\tCODE_SIGN_STYLE = Automatic;\n\t\t\t\tCURRENT_PROJECT_VERSION = 1;\n\t\t\t\tDEVELOPMENT_TEAM = "";\n\t\t\t\tGENERATE_INFOPLIST_FILE = YES;\n\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 18.0;\n\t\t\t\tMARKETING_VERSION = 1.0;\n\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.disabilityadvocacy.ios.tests;\n\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";\n\t\t\t\tSWIFT_EMIT_LOC_STRINGS = NO;\n\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-Owholemodule";\n\t\t\t\tSWIFT_VERSION = 5.0;\n\t\t\t\tTEST_HOST = "$(BUILT_PRODUCTS_DIR)/DisabilityAdvocacy.app/DisabilityAdvocacy";\n\t\t\t}};\n\t\t\tname = Release;\n\t\t}};')

# UI Test Debug
output.append(f'\t\t{uitest_debug} /* Debug */ = {{\n\t\t\tisa = XCBuildConfiguration;\n\t\t\tbuildSettings = {{\n\t\t\t\tCODE_SIGN_STYLE = Automatic;\n\t\t\t\tCURRENT_PROJECT_VERSION = 1;\n\t\t\t\tDEVELOPMENT_TEAM = "";\n\t\t\t\tGENERATE_INFOPLIST_FILE = YES;\n\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 18.0;\n\t\t\t\tMARKETING_VERSION = 1.0;\n\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.disabilityadvocacy.ios.uitests;\n\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";\n\t\t\t\tSWIFT_EMIT_LOC_STRINGS = NO;\n\t\t\t\tSWIFT_VERSION = 5.0;\n\t\t\t\tTEST_TARGET_NAME = DisabilityAdvocacy-iOS;\n\t\t\t}};\n\t\t\tname = Debug;\n\t\t}};')

# UI Test Release
output.append(f'\t\t{uitest_release} /* Release */ = {{\n\t\t\tisa = XCBuildConfiguration;\n\t\t\tbuildSettings = {{\n\t\t\t\tCODE_SIGN_STYLE = Automatic;\n\t\t\t\tCURRENT_PROJECT_VERSION = 1;\n\t\t\t\tDEVELOPMENT_TEAM = "";\n\t\t\t\tGENERATE_INFOPLIST_FILE = YES;\n\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 18.0;\n\t\t\t\tMARKETING_VERSION = 1.0;\n\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.disabilityadvocacy.ios.uitests;\n\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";\n\t\t\t\tSWIFT_EMIT_LOC_STRINGS = NO;\n\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-Owholemodule";\n\t\t\t\tSWIFT_VERSION = 5.0;\n\t\t\t\tTEST_TARGET_NAME = DisabilityAdvocacy-iOS;\n\t\t\t}};\n\t\t\tname = Release;\n\t\t}};')

output.append('\t\t/* End XCBuildConfiguration section */')
output.append('')

# XCConfigurationList sections
output.append('\t\t/* Begin XCConfigurationList section */')
output.append(f'\t\t{config_list_project} /* Build configuration list for PBXProject "DisabilityAdvocacy" */ = {{\n\t\t\tisa = XCConfigurationList;\n\t\t\tbuildConfigurations = (\n\t\t\t\t{project_debug} /* Debug */,\n\t\t\t\t{project_release} /* Release */,\n\t\t\t);\n\t\t\tdefaultConfigurationIsVisible = 0;\n\t\t\tdefaultConfigurationName = Release;\n\t\t}};')
output.append(f'\t\t{config_list_ios} /* Build configuration list for PBXNativeTarget "DisabilityAdvocacy-iOS" */ = {{\n\t\t\tisa = XCConfigurationList;\n\t\t\tbuildConfigurations = (\n\t\t\t\t{ios_debug} /* Debug */,\n\t\t\t\t{ios_release} /* Release */,\n\t\t\t);\n\t\t\tdefaultConfigurationIsVisible = 0;\n\t\t\tdefaultConfigurationName = Release;\n\t\t}};')
output.append(f'\t\t{config_list_macos} /* Build configuration list for PBXNativeTarget "DisabilityAdvocacy-macOS" */ = {{\n\t\t\tisa = XCConfigurationList;\n\t\t\tbuildConfigurations = (\n\t\t\t\t{macos_debug} /* Debug */,\n\t\t\t\t{macos_release} /* Release */,\n\t\t\t);\n\t\t\tdefaultConfigurationIsVisible = 0;\n\t\t\tdefaultConfigurationName = Release;\n\t\t}};')
output.append(f'\t\t{config_list_test} /* Build configuration list for PBXNativeTarget "DisabilityAdvocacyTests" */ = {{\n\t\t\tisa = XCConfigurationList;\n\t\t\tbuildConfigurations = (\n\t\t\t\t{test_debug} /* Debug */,\n\t\t\t\t{test_release} /* Release */,\n\t\t\t);\n\t\t\tdefaultConfigurationIsVisible = 0;\n\t\t\tdefaultConfigurationName = Release;\n\t\t}};')
output.append(f'\t\t{config_list_uitest} /* Build configuration list for PBXNativeTarget "DisabilityAdvocacyUITests" */ = {{\n\t\t\tisa = XCConfigurationList;\n\t\t\tbuildConfigurations = (\n\t\t\t\t{uitest_debug} /* Debug */,\n\t\t\t\t{uitest_release} /* Release */,\n\t\t\t);\n\t\t\tdefaultConfigurationIsVisible = 0;\n\t\t\tdefaultConfigurationName = Release;\n\t\t}};')
output.append('\t\t/* End XCConfigurationList section */')
output.append('')

# PBXNativeTarget sections
output.append('\t\t/* Begin PBXNativeTarget section */')

# iOS Target
output.append(f'\t\t{IOS_TARGET} /* DisabilityAdvocacy-iOS */ = {{\n\t\t\tisa = PBXNativeTarget;\n\t\t\tbuildConfigurationList = {config_list_ios} /* Build configuration list for PBXNativeTarget "DisabilityAdvocacy-iOS" */;\n\t\t\tbuildPhases = (\n\t\t\t\t{ios_sources} /* Sources */,\n\t\t\t\t{ios_resources} /* Resources */,\n\t\t\t\t{ios_frameworks} /* Frameworks */,\n\t\t\t);\n\t\t\tbuildRules = (\n\t\t\t);\n\t\t\tdependencies = (\n\t\t\t);\n\t\t\tname = DisabilityAdvocacy-iOS;\n\t\t\tproductName = DisabilityAdvocacy;\n\t\t\tproductReference = {ios_product} /* DisabilityAdvocacy.app */;\n\t\t\tproductType = "com.apple.product-type.application";\n\t\t}};')

# macOS Target
output.append(f'\t\t{MACOS_TARGET} /* DisabilityAdvocacy-macOS */ = {{\n\t\t\tisa = PBXNativeTarget;\n\t\t\tbuildConfigurationList = {config_list_macos} /* Build configuration list for PBXNativeTarget "DisabilityAdvocacy-macOS" */;\n\t\t\tbuildPhases = (\n\t\t\t\t{macos_sources} /* Sources */,\n\t\t\t\t{macos_resources} /* Resources */,\n\t\t\t\t{macos_frameworks} /* Frameworks */,\n\t\t\t);\n\t\t\tbuildRules = (\n\t\t\t);\n\t\t\tdependencies = (\n\t\t\t);\n\t\t\tname = DisabilityAdvocacy-macOS;\n\t\t\tproductName = DisabilityAdvocacy;\n\t\t\tproductReference = {macos_product} /* DisabilityAdvocacy.app */;\n\t\t\tproductType = "com.apple.product-type.application";\n\t\t}};')

# Test Target
output.append(f'\t\t{IOS_TEST_TARGET} /* DisabilityAdvocacyTests */ = {{\n\t\t\tisa = PBXNativeTarget;\n\t\t\tbuildConfigurationList = {config_list_test} /* Build configuration list for PBXNativeTarget "DisabilityAdvocacyTests" */;\n\t\t\tbuildPhases = (\n\t\t\t\t{test_sources} /* Sources */,\n\t\t\t\t{test_frameworks} /* Frameworks */,\n\t\t\t);\n\t\t\tbuildRules = (\n\t\t\t);\n\t\t\tdependencies = (\n\t\t\t\t{test_dependency} /* PBXTargetDependency */,\n\t\t\t);\n\t\t\tname = DisabilityAdvocacyTests;\n\t\t\tproductName = DisabilityAdvocacyTests;\n\t\t\tproductReference = {test_product} /* DisabilityAdvocacyTests.xctest */;\n\t\t\tproductType = "com.apple.product-type.bundle.unit-test";\n\t\t}};')

# UI Test Target
output.append(f'\t\t{IOS_UI_TEST_TARGET} /* DisabilityAdvocacyUITests */ = {{\n\t\t\tisa = PBXNativeTarget;\n\t\t\tbuildConfigurationList = {config_list_uitest} /* Build configuration list for PBXNativeTarget "DisabilityAdvocacyUITests" */;\n\t\t\tbuildPhases = (\n\t\t\t\t{uitest_sources} /* Sources */,\n\t\t\t\t{uitest_frameworks} /* Frameworks */,\n\t\t\t);\n\t\t\tbuildRules = (\n\t\t\t);\n\t\t\tdependencies = (\n\t\t\t\t{test_dependency} /* PBXTargetDependency */,\n\t\t\t);\n\t\t\tname = DisabilityAdvocacyUITests;\n\t\t\tproductName = DisabilityAdvocacyUITests;\n\t\t\tproductReference = {uitest_product} /* DisabilityAdvocacyUITests.xctest */;\n\t\t\tproductType = "com.apple.product-type.bundle.ui-testing";\n\t\t}};')

output.append('\t\t/* End PBXNativeTarget section */')
output.append('')

# PBXProject section
output.append('\t\t/* Begin PBXProject section */')
output.append(f'\t\t{PROJECT_UUID} /* Project object */ = {{\n\t\t\tisa = PBXProject;\n\t\t\tattributes = {{\n\t\t\t\tLastSwiftUpdateCheck = 2620;\n\t\t\t\tLastUpgradeCheck = 2620;\n\t\t\t\tORGANIZATIONNAME = "Disability Advocacy";\n\t\t\t\tTargetAttributes = {{\n\t\t\t\t\t{IOS_TARGET} = {{\n\t\t\t\t\t\tCreatedOnToolsVersion = 26.2;\n\t\t\t\t\t}};\n\t\t\t\t\t{MACOS_TARGET} = {{\n\t\t\t\t\t\tCreatedOnToolsVersion = 26.2;\n\t\t\t\t}};\n\t\t\t\t\t{IOS_TEST_TARGET} = {{\n\t\t\t\t\t\tCreatedOnToolsVersion = 26.2;\n\t\t\t\t\t\tTestTargetID = {IOS_TARGET};\n\t\t\t\t}};\n\t\t\t\t\t{IOS_UI_TEST_TARGET} = {{\n\t\t\t\t\t\tCreatedOnToolsVersion = 26.2;\n\t\t\t\t\t\tTestTargetID = {IOS_TARGET};\n\t\t\t\t}};\n\t\t\t\t}};\n\t\t\t}};\n\t\t\tbuildConfigurationList = {config_list_project} /* Build configuration list for PBXProject "DisabilityAdvocacy" */;\n\t\t\tcompatibilityVersion = "Xcode 14.0";\n\t\t\tdevelopmentRegion = en;\n\t\t\thasScannedForEncodings = 0;\n\t\t\tknownRegions = (\n\t\t\t\ten,\n\t\t\t\tBase,\n\t\t\t);\n\t\t\tmainGroup = {ROOT_GROUP};\n\t\t\tproductRefGroup = {groups["Products"]} /* Products */;\n\t\t\tprojectDirPath = "";\n\t\t\tprojectRoot = "";\n\t\t\ttargets = (\n\t\t\t\t{IOS_TARGET} /* DisabilityAdvocacy-iOS */,\n\t\t\t\t{MACOS_TARGET} /* DisabilityAdvocacy-macOS */,\n\t\t\t\t{IOS_TEST_TARGET} /* DisabilityAdvocacyTests */,\n\t\t\t\t{IOS_UI_TEST_TARGET} /* DisabilityAdvocacyUITests */,\n\t\t\t);\n\t\t}};')
output.append('\t\t/* End PBXProject section */')
output.append('')

# Close objects and root
output.append('\t};')
output.append('\trootObject = ' + PROJECT_UUID + ' /* Project object */;')
output.append('}')

# Write complete file
output_file = base / "DisabilityAdvocacy.xcodeproj" / "project.pbxproj"
with open(output_file, 'w') as f:
    f.write('\n'.join(output))

print(f"✅ Generated complete project file at {output_file}")
print(f"Total lines: {len(output)}")
print(f"Files: {len(file_refs)}")
print(f"Groups: {len(groups)}")
print("✅ Project file generation complete!")
