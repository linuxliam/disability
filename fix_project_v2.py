import re
import os

pbxproj_path = 'DisabilityAdvocacy.xcodeproj/project.pbxproj'

with open(pbxproj_path, 'r') as f:
    content = f.read()

# 1. Update existing paths
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

# Find all file references
file_refs = re.findall(r'(\w+) /\* (.*?) \*/ = \{isa = PBXFileReference; (.*?)\};', content)

valid_file_ids = set()
broken_file_ids = set()

for file_id, filename, settings in file_refs:
    path_match = re.search(r'path = (.*?);', settings)
    if not path_match: continue
    path = path_match.group(1).strip('"')
    
    # Resolve path
    if filename in actual_paths:
        target_path = actual_paths[filename]
    elif path.startswith('../'):
        target_path = path[3:]
    else:
        target_path = path
    
    # Check if exists on disk
    if os.path.exists(target_path):
        new_settings = re.sub(r'path = .*?(;|$)', f'path = {target_path}\\1', settings)
        new_settings = re.sub(r'sourceTree = .*?(;|$)', 'sourceTree = "<group>"\\1', new_settings)
        content = content.replace(f'{file_id} /* {filename} */ = {{isa = PBXFileReference; {settings}}};', 
                                  f'{file_id} /* {filename} */ = {{isa = PBXFileReference; {new_settings}}};')
        valid_file_ids.add(file_id)
    else:
        print(f"Broken path: {path} (for {filename}) -> {target_path}")
        broken_file_ids.add(file_id)

# 2. Remove broken references from build phases and groups
for fid in broken_file_ids:
    # Remove from PBXBuildFile section
    build_file_matches = re.findall(r'(\w+) /\* .*? \*/ = \{isa = PBXBuildFile; fileRef = ' + fid + r' /\* .*? \*/; \};', content)
    for bfid in build_file_matches:
        content = re.sub(rf'\t\t{bfid} /\* .*? \*/ = {{isa = PBXBuildFile; fileRef = {fid} /\* .*? \*/; }};\n', '', content)
        # Also remove from phases
        content = content.replace(f'{bfid} /*', f'// REMOVED {bfid} /*') # Temporary comment out to avoid regex issues
        content = re.sub(rf'\t\t\t\t{bfid} /\* .*? \*/,\n', '', content)

    # Remove from Groups
    content = re.sub(rf'\t\t\t\t{fid} /\* .*? \*/,\n', '', content)
    
    # Remove from PBXFileReference
    content = re.sub(rf'\t\t{fid} /\* .*? \*/ = {{isa = PBXFileReference; .*?}};\n', '', content)

# 3. Add macOS target if missing (though it seems to be there in the healthy version)
# We'll just ensure it's there.

# 4. Fix group paths
group_matches = re.findall(r'(\w+) /\* (.*?) \*/ = \{[\s\S]*?path = (.*?);', content)
for group_id, group_name, group_path in group_matches:
    if group_name in ['Models', 'Views', 'Managers', 'Utilities', 'ViewModels', 'Components', 'Main', 'Navigation', 'Admin', 'Onboarding', 'Search', 'Settings', 'Persistence', 'Core', 'UI']:
        content = content.replace(f'path = {group_path};', 'path = "";')

# 5. Fix Info.plist
content = re.sub(r'INFOPLIST_FILE = (?!macOS).*?;', 'INFOPLIST_FILE = iOS/Info.plist;', content)

with open(pbxproj_path, 'w') as f:
    f.write(content)

print("Project fixed and cleaned up.")
