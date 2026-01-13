import re
import uuid
import os

def generate_id():
    return str(uuid.uuid4()).replace('-', '').upper()[:24]

pbxproj_path = 'DisabilityAdvocacy.xcodeproj/project.pbxproj'

with open(pbxproj_path, 'r') as f:
    content = f.read()

# IDs for targets
ios_target_id = '945FEF4C421343D4931F4152'
ios_sources_phase_id = '5FFBBCDEBB91435B90BD6C11'
ios_resources_phase_id = 'D8665895AD334914AE1AB62A'

# 1. Add macOS files to FileReference section
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
    fid = generate_id()
    macos_file_ids[name] = fid
    ext = path.split('.')[-1]
    ftype = 'sourcecode.swift' if ext == 'swift' else 'text.plist.entitlements' if ext == 'entitlements' else 'text'
    new_ref = f'\t\t{fid} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = {ftype}; path = {path}; sourceTree = "<group>"; }};\n'
    content = content.replace('/* End PBXFileReference section */', new_ref + '/* End PBXFileReference section */')

# 2. Add macOS target ID and phase IDs
mac_target_id = generate_id()
mac_sources_phase_id = generate_id()
mac_frameworks_phase_id = generate_id()
mac_resources_phase_id = generate_id()
mac_product_ref_id = generate_id()
mac_build_config_list_id = generate_id()
mac_debug_config_id = generate_id()
mac_release_config_id = generate_id()

# 3. Add macOS App Product Reference
new_product_ref = f'\t\t{mac_product_ref_id} /* DisabilityAdvocacyMac.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = DisabilityAdvocacyMac.app; sourceTree = BUILT_PRODUCTS_DIR; }};\n'
content = content.replace('/* End PBXFileReference section */', new_product_ref + '/* End PBXFileReference section */')

# 4. Add to Products group (D6A4505DDC5441BB86BAA96A)
content = re.sub(r'(D6A4505DDC5441BB86BAA96A /\* Products \*/ = \{[\s\S]*?children = \()([\s\S]*?)(\);)', 
                 r'\1\2\t\t\t\t' + mac_product_ref_id + ' /* DisabilityAdvocacyMac.app */,\n\3', content)

# 5. Build Phases
# Sources
ios_sources_match = re.search(f'{ios_sources_phase_id} /\\* Sources \\*/ = {{[\\s\\S]*?files = \\(([\\s\\S]*?)\\);', content)
ios_source_lines = ios_sources_match.group(1).strip().split('\n')
mac_source_lines = []
for line in ios_source_lines:
    line = line.strip()
    if not line: continue
    if any(x in line for x in ['AdvocacyApp.swift', 'HomeView.swift', 'ContentView.swift']):
        continue
    ref_match = re.search(r'fileRef = (\w+)', line)
    if not ref_match: continue
    file_ref_id = ref_match.group(1)
    name_match = re.search(r'/\* (.*?) \*/', line)
    if not name_match: continue
    file_name = name_match.group(1).replace(' in Sources', '')
    bid = generate_id()
    new_build_file = f'\t\t{bid} /* {file_name} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /* {file_name} */; }};\n'
    content = content.replace('/* Begin PBXBuildFile section */', f'/* Begin PBXBuildFile section */\n{new_build_file}')
    mac_source_lines.append(f'\t\t\t\t{bid} /* {file_name} in Sources */,')

# Add macOS specific source files
for name, fid in macos_file_ids.items():
    if name.endswith('.swift'):
        bid = generate_id()
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
ios_resources_match = re.search(f'{ios_resources_phase_id} /\\* Resources \\*/ = {{[\\s\\S]*?files = \\(([\\s\\S]*?)\\);', content)
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
    bid = generate_id()
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

# 6. Configs
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

# 7. Native Target
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

# 8. Add to Project targets (DE4A9804284A4A3494FDF2E1)
content = re.sub(r'(targets = \(\n[\s\S]*?945FEF4C421343D4931F4152 /\* DisabilityAdvocacy \*/,)', 
                 r'\1\n\t\t\t\t' + mac_target_id + ' /* DisabilityAdvocacyMac */,', content)

with open(pbxproj_path, 'w') as f:
    f.write(content)

print("macOS target added.")
