import re
import uuid
import os

def generate_id():
    return str(uuid.uuid4()).replace('-', '').upper()[:24]

pbxproj_path = 'DisabilityAdvocacy.xcodeproj/project.pbxproj'

with open(pbxproj_path, 'r') as f:
    content = f.read()

# 1. Identify Targets and Phases
ios_target_id = '945FEF4C421343D4931F4152'
mac_target_id = 'MAC58156EC1B42BD856C6D5D'

ios_sources_phase_id = '5FFBBCDEBB91435B90BD6C11'
mac_sources_phase_id = 'MAC02A5D5663446AA07A2AD4'

ios_resources_phase_id = 'D8665895AD334914AE1AB62A'
mac_resources_phase_id = 'MAC39E41758846A99ECAE466'

# 2. Clear Build Phases
def clear_phase(phase_id):
    global content
    pattern = f'({phase_id} /\* .*? \*/ = {{[\s\S]*?files = \()([\s\S]*?)(\);)'
    content = re.sub(pattern, r'\1\n\3', content)

clear_phase(ios_sources_phase_id)
clear_phase(mac_sources_phase_id)
clear_phase(ios_resources_phase_id)
clear_phase(mac_resources_phase_id)

# 3. Clear existing PBXBuildFile and PBXFileReference sections
# We'll keep the section headers but remove most content.
# We MUST keep references to .app and .xctest products.
product_refs = re.findall(r'(\w+ /\* (?:.*?\.app|.*?\.xctest) \*/ = \{isa = PBXFileReference; .*?\};\n)', content)

# Clear FileReferences
content = re.sub(r'/\* Begin PBXFileReference section \*/[\s\S]*?/\* End PBXFileReference section \*/', 
                 '/* Begin PBXFileReference section */\n' + ''.join(product_refs) + '/* End PBXFileReference section */', content)

# Clear BuildFiles
content = re.sub(r'/\* Begin PBXBuildFile section \*/[\s\S]*?/\* End PBXBuildFile section \*/', 
                 '/* Begin PBXBuildFile section */\n/* End PBXBuildFile section */', content)

# 4. Find all files on disk
files_on_disk = []
for root, dirs, files in os.walk('.'):
    if 'build' in root or '.xcodeproj' in root or '.git' in root or 'terminals' in root:
        continue
    for file in files:
        if file.endswith('.swift') or file.endswith('.json') or file.endswith('.xcassets') or file.endswith('.xcstrings') or file.endswith('.xcprivacy') or file.endswith('.plist') or file.endswith('.entitlements'):
            path = os.path.join(root, file).replace('./', '')
            files_on_disk.append((file, path))

# 5. Add them back
file_refs_for_group = []

def add_file_ref(name, path):
    global content
    file_id = generate_id()
    ext = path.split('.')[-1]
    if ext == 'swift':
        file_type = 'sourcecode.swift'
    elif ext == 'json':
        file_type = 'text.json'
    elif ext == 'xcassets':
        file_type = 'folder.assetcatalog'
    elif ext == 'xcstrings':
        file_type = 'text.json'
    elif ext == 'xcprivacy':
        file_type = 'text.xml'
    elif ext == 'plist':
        file_type = 'text.plist.xml'
    elif ext == 'entitlements':
        file_type = 'text.plist.entitlements'
    else:
        file_type = 'text'
    
    new_ref = f'\t\t{file_id} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = {file_type}; path = {path}; sourceTree = "<group>"; }};\n'
    content = content.replace('/* End PBXFileReference section */', new_ref + '/* End PBXFileReference section */')
    file_refs_for_group.append(f"\t\t\t\t{file_id} /* {name} */,\n")
    return file_id

def add_to_sources(file_id, name, phase_id):
    global content
    build_id = generate_id()
    new_build_file = f'\t\t{build_id} /* {name} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_id} /* {name} */; }};\n'
    content = content.replace('/* Begin PBXBuildFile section */', f'/* Begin PBXBuildFile section */\n{new_build_file}')
    
    # Add to the phase
    phase_pattern = f'({phase_id} /\* Sources \*/ = {{[\s\S]*?files = \(\n)'
    content = re.sub(phase_pattern, r'\1\t\t\t\t' + build_id + f' /* {name} in Sources */,\n', content)

def add_to_resources(file_id, name, phase_id):
    global content
    build_id = generate_id()
    new_build_file = f'\t\t{build_id} /* {name} in Resources */ = {{isa = PBXBuildFile; fileRef = {file_id} /* {name} */; }};\n'
    content = content.replace('/* Begin PBXBuildFile section */', f'/* Begin PBXBuildFile section */\n{new_build_file}')
    
    # Add to the phase
    phase_pattern = f'({phase_id} /\* Resources \*/ = {{[\s\S]*?files = \(\n)'
    content = re.sub(phase_pattern, r'\1\t\t\t\t' + build_id + f' /* {name} in Resources */,\n', content)

# Map groups to paths (for completeness, though we set group paths to "")
group_to_files = {
    'Models': [], 'Views': [], 'Managers': [], 'Utilities': [], 'ViewModels': [], 'Extensions': [], 'Resources': [], 'iOS': [], 'macOS': []
}

for name, path in files_on_disk:
    # Skip build artifacts
    if '/DerivedSources/' in path: continue
    
    file_id = add_file_ref(name, path)
    
    is_shared = path.startswith('Shared/')
    is_ios = path.startswith('iOS/')
    is_mac = path.startswith('macOS/')
    is_resource = path.startswith('Resources/')

    if path.endswith('.swift'):
        if is_shared or is_ios:
            add_to_sources(file_id, name, ios_sources_phase_id)
        if is_shared or is_mac:
            add_to_sources(file_id, name, mac_sources_phase_id)
    elif is_resource:
        add_to_resources(file_id, name, ios_resources_phase_id)
        add_to_resources(file_id, name, mac_resources_phase_id)

# 6. Update Groups
# We'll just put EVERYTHING in the root group for now to avoid complexity,
# then we can organize later if needed. Actually, let's try to put them in groups.
# Root group ID: C64FBDEA5C8640F4ABFB474B
root_group_id = 'C64FBDEA5C8640F4ABFB474B'

# Clear root group children
content = re.sub(r'(C64FBDEA5C8640F4ABFB474B = \{[\s\S]*?children = \()([\s\S]*?)(\);)', 
                 r'\1\n\3', content)

# Add all file IDs to root group
content = re.sub(r'(C64FBDEA5C8640F4ABFB474B = \{[\s\S]*?children = \(\n)', r'\1' + "".join(file_refs_for_group), content)

with open(pbxproj_path, 'w') as f:
    f.write(content)

print("Project structure rebuilt from disk.")
