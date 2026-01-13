import re
import uuid
import os

def generate_id():
    return str(uuid.uuid4()).replace('-', '').upper()[:24]

pbxproj_path = 'DisabilityAdvocacy.xcodeproj/project.pbxproj'

with open(pbxproj_path, 'r') as f:
    content = f.read()

# 1. Fix existing paths (remove ../ and map to actual locations)
actual_paths = {
    'Resources.json': 'Resources/Resources.json',
    'Assets.xcassets': 'Resources/Assets.xcassets',
    'Events.json': 'Resources/Events.json',
    'Localizable.xcstrings': 'Resources/Localizable.xcstrings',
    'PrivacyInfo.xcprivacy': 'Resources/PrivacyInfo.xcprivacy',
    'AdvocacyApp.swift': 'iOS/AdvocacyApp.swift',
    'HomeView.swift': 'iOS/Views/HomeView.swift',
    'ContentView.swift': 'iOS/Views/Navigation/ContentView.swift',
    'Info.plist': 'iOS/Info.plist',
}

# Update file references
file_refs = re.findall(r'(\w+) /\* (.*?) \*/ = \{isa = PBXFileReference; (.*?)\};', content)
for file_id, filename, settings in file_refs:
    if filename in actual_paths:
        target_path = actual_paths[filename]
        new_settings = re.sub(r'path = .*?(;|$)', f'path = {target_path}\\1', settings)
        new_settings = re.sub(r'sourceTree = .*?(;|$)', 'sourceTree = "<group>"\\1', new_settings)
        content = content.replace(f'{file_id} /* {filename} */ = {{isa = PBXFileReference; {settings}}};', 
                                  f'{file_id} /* {filename} */ = {{isa = PBXFileReference; {new_settings}}};')
    elif 'path = ../' in settings:
        new_settings = re.sub(r'path = \.\./(.*?;|$)', r'path = \1', settings)
        new_settings = re.sub(r'sourceTree = .*?(;|$)', 'sourceTree = "<group>"\\1', new_settings)
        content = content.replace(f'{file_id} /* {filename} */ = {{isa = PBXFileReference; {settings}}};', 
                                  f'{file_id} /* {filename} */ = {{isa = PBXFileReference; {new_settings}}};')

# Fix group paths
group_matches = re.findall(r'(\w+) /\* (.*?) \*/ = \{[\s\S]*?path = (.*?);', content)
for group_id, group_name, group_path in group_matches:
    if '../' in group_path or group_name in ['Models', 'Views', 'Managers', 'Utilities', 'ViewModels', 'Components', 'Main', 'Navigation', 'Admin', 'Onboarding', 'Search', 'Settings', 'Persistence', 'Core', 'UI']:
        content = content.replace(f'path = {group_path};', 'path = "";')

# 2. Add macOS target
mac_target_id = 'MAC' + generate_id()[3:]
mac_sources_phase_id = 'MAC' + generate_id()[3:]
mac_frameworks_phase_id = 'MAC' + generate_id()[3:]
mac_resources_phase_id = 'MAC' + generate_id()[3:]
mac_product_ref_id = 'MAC' + generate_id()[3:]
mac_build_config_list_id = 'MAC' + generate_id()[3:]
mac_debug_config_id = 'MAC' + generate_id()[3:]
mac_release_config_id = 'MAC' + generate_id()[3:]

# Product Ref
new_product_ref = f'\t\t{mac_product_ref_id} /* DisabilityAdvocacyMac.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = DisabilityAdvocacyMac.app; sourceTree = BUILT_PRODUCTS_DIR; }};\n'
content = content.replace('/* End PBXFileReference section */', new_product_ref + '/* End PBXFileReference section */')

# macOS specific files
macos_files = {
    'AdvocacyApp_macOS.swift': 'macOS/AdvocacyApp.swift',
    'ContentView_macOS.swift': 'macOS/Views/ContentView.swift',
    'HomeView_macOS.swift': 'macOS/Views/HomeView.swift',
    'AccessibilityExtensions.swift': 'macOS/Extensions/AccessibilityExtensions.swift',
    'ContextualMenuExtensions.swift': 'macOS/Extensions/ContextualMenuExtensions.swift',
    'TooltipExtensions.swift': 'macOS/Extensions/TooltipExtensions.swift',
    'AdvocacyApp.entitlements': 'macOS/AdvocacyApp.entitlements',
}
macos_file_ids = {}
for name, path in macos_files.items():
    fid = 'MAC' + generate_id()[3:]
    macos_file_ids[name] = fid
    ext = path.split('.')[-1]
    ftype = 'sourcecode.swift' if ext == 'swift' else 'text.plist.entitlements' if ext == 'entitlements' else 'text'
    new_ref = f'\t\t{fid} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = {ftype}; path = {path}; sourceTree = "<group>"; }};\n'
    content = content.replace('/* End PBXFileReference section */', new_ref + '/* End PBXFileReference section */')

# Add to Products group
content = re.sub(r'(children = \(\n[\s\S]*?F3D0605D6EB141D7A5F7EECB /\* DisabilityAdvocacy.app \*/,)', 
                 r'\1\n\t\t\t\t' + mac_product_ref_id + ' /* DisabilityAdvocacyMac.app */,', content)

# 3. Build Phases
# We need to collect all shared files from iOS target
ios_sources_id = '5FFBBCDEBB91435B90BD6C11'
ios_sources_match = re.search(f'{ios_sources_id} /\* Sources \*/ = {{[\s\S]*?files = \(([\s\S]*?)\);', content)
ios_source_lines = ios_sources_match.group(1).strip().split('\n')

mac_source_lines = []
for line in ios_source_lines:
    line = line.strip()
    if not line: continue
    # Skip platform specific
    if any(x in line for x in ['AdvocacyApp.swift', 'HomeView.swift', 'ContentView.swift']):
        continue
    
    # Create build file for Mac target
    ref_match = re.search(r'fileRef = (\w+)', line)
    if not ref_match: continue
    file_ref_id = ref_match.group(1)
    
    name_match = re.search(r'/\* (.*?) \*/', line)
    if not name_match: continue
    file_name = name_match.group(1).replace(' in Sources', '')
    
    bid = 'MAC' + generate_id()[3:]
    new_build_file = f'\t\t{bid} /* {file_name} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /* {file_name} */; }};\n'
    content = content.replace('/* Begin PBXBuildFile section */', f'/* Begin PBXBuildFile section */\n{new_build_file}')
    mac_source_lines.append(f'\t\t\t\t{bid} /* {file_name} in Sources */,')

# Add macOS specific source files
for name, fid in macos_file_ids.items():
    if name.endswith('.swift'):
        bid = 'MAC' + generate_id()[3:]
        new_build_file = f'\t\t{bid} /* {name} in Sources */ = {{isa = PBXBuildFile; fileRef = {fid} /* {name} */; }};\n'
        content = content.replace('/* Begin PBXBuildFile section */', f'/* Begin PBXBuildFile section */\n{new_build_file}')
        mac_source_lines.append(f'\t\t\t\t{bid} /* {name} in Sources */,')

mac_sources_phase = f"""\t\t{mac_sources_phase_id} /* Sources */ = {{
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
{chr(10).join(mac_source_lines)}
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};"""

mac_frameworks_phase = f"""\t\t{mac_frameworks_phase_id} /* Frameworks */ = {{
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};"""

# Resources
ios_resources_id = 'D8665895AD334914AE1AB62A'
ios_resources_match = re.search(f'{ios_resources_id} /\\* Resources \\*/ = {{[\\s\\S]*?files = \\(([\\s\\S]*?)\\);', content)
ios_res_lines = ios_resources_match.group(1).strip().split('\n')
mac_res_lines = []
for line in ios_res_lines:
    line = line.strip()
    if not line: continue
    
    ref_match = re.search(r'fileRef = (\w+)', line)
    if not ref_match: continue
    file_ref_id = ref_match.group(1)
    
    name_match = re.search(r'/\* (.*?) \*/', line)
    if not name_match: continue
    file_name = name_match.group(1).replace(' in Resources', '')
    
    bid = 'MAC' + generate_id()[3:]
    new_build_file = f'\t\t{bid} /* {file_name} in Resources */ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /* {file_name} */; }};\n'
    content = content.replace('/* Begin PBXBuildFile section */', f'/* Begin PBXBuildFile section */\n{new_build_file}')
    mac_res_lines.append(f'\t\t\t\t{bid} /* {file_name} in Resources */,')

mac_resources_phase = f"""\t\t{mac_resources_phase_id} /* Resources */ = {{
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
{chr(10).join(mac_res_lines)}
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};"""

content = content.replace('/* End PBXSourcesBuildPhase section */', mac_sources_phase + '\n/* End PBXSourcesBuildPhase section */')
content = content.replace('/* End PBXFrameworksBuildPhase section */', mac_frameworks_phase + '\n/* End PBXFrameworksBuildPhase section */')
content = content.replace('/* End PBXResourcesBuildPhase section */', mac_resources_phase + '\n/* End PBXResourcesBuildPhase section */')

# 4. Configs
mac_settings = """{
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CODE_SIGN_ENTITLEMENTS = macOS/AdvocacyApp.entitlements;
				CODE_SIGN_STYLE = Automatic;
				COMBINE_HIDPI_IMAGES = YES;
				CURRENT_PROJECT_VERSION = 1;
				ENABLE_HARDENED_RUNTIME = YES;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = macOS/Info.plist;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MACOSX_DEPLOYMENT_TARGET = 14.0;
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.disabilityadvocacy.macos;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SDKROOT = macosx;
				SWIFT_VERSION = 6.0;
			}"""

mac_debug_config = f'\t\t{mac_debug_config_id} /* Debug */ = {{\n\t\t\tisa = XCBuildConfiguration;\n\t\t\tbuildSettings = {mac_settings};\n\t\t\tname = Debug;\n\t\t}};'
mac_release_config = f'\t\t{mac_release_config_id} /* Release */ = {{\n\t\t\tisa = XCBuildConfiguration;\n\t\t\tbuildSettings = {mac_settings};\n\t\t\tname = Release;\n\t\t}};'
mac_config_list = f"""\t\t{mac_build_config_list_id} /* Build configuration list for PBXNativeTarget "DisabilityAdvocacyMac" */ = {{
			isa = XCConfigurationList;
			buildConfigurations = (
				{mac_debug_config_id} /* Debug */,
				{mac_release_config_id} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		}};"""

content = content.replace('/* End XCBuildConfiguration section */', mac_debug_config + '\n' + mac_release_config + '\n/* End XCBuildConfiguration section */')
content = content.replace('/* End XCConfigurationList section */', mac_config_list + '\n/* End XCConfigurationList section */')

# 5. Native Target
mac_target = f"""\t\t{mac_target_id} /* DisabilityAdvocacyMac */ = {{
			isa = PBXNativeTarget;
			buildConfigurationList = {mac_build_config_list_id} /* Build configuration list for PBXNativeTarget "DisabilityAdvocacyMac" */;
			buildPhases = (
				{mac_sources_phase_id} /* Sources */,
				{mac_frameworks_phase_id} /* Frameworks */,
				{mac_resources_phase_id} /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = DisabilityAdvocacyMac;
			productName = DisabilityAdvocacyMac;
			productReference = {mac_product_ref_id} /* DisabilityAdvocacyMac.app */;
			productType = "com.apple.product-type.application";
		}};"""

content = content.replace('/* End PBXNativeTarget section */', mac_target + '\n/* End PBXNativeTarget section */')

# Add to Project targets
content = re.sub(r'(targets = \(\n[\s\S]*?945FEF4C421343D4931F4152 /\* DisabilityAdvocacy \*/,)', 
                 r'\1\n\t\t\t\t' + mac_target_id + ' /* DisabilityAdvocacyMac */,', content)

# 6. Final cleanup: ensure Info.plist is correct for iOS
content = re.sub(r'INFOPLIST_FILE = (?!macOS).*?;', 'INFOPLIST_FILE = iOS/Info.plist;', content)

with open(pbxproj_path, 'w') as f:
    f.write(content)

print("Successfully consolidated project.")
