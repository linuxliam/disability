import re
import os

pbxproj_path = 'DisabilityAdvocacy.xcodeproj/project.pbxproj'

with open(pbxproj_path, 'r') as f:
    content = f.read()

# 1. Update existing paths
content = re.sub(r'path = \.\./(.*?);', r'path = \1;', content)

actual_paths = {
    'Resources.json': 'Resources/Resources.json',
    'Assets.xcassets': 'Resources/Assets.xcassets',
    'Events.json': 'Resources/Events.json',
    'Localizable.xcstrings': 'Resources/Localizable.xcstrings',
    'PrivacyInfo.xcprivacy': 'Resources/PrivacyInfo.xcprivacy',
    'AdvocacyApp.swift': 'iOS/AdvocacyApp.swift',
    'HomeView.swift': 'iOS/Views/HomeView.swift',
    'ContentView.swift': 'iOS/Views/ContentView.swift',
    'Info.plist': 'iOS/Info.plist',
}

file_refs = re.findall(r'(\w+) /\* (.*?) \*/ = \{isa = PBXFileReference; (.*?)\};', content)

for file_id, filename, settings in file_refs:
    if filename in actual_paths:
        target_path = actual_paths[filename]
        new_settings = re.sub(r'path = .*?(;|$)', f'path = {target_path}\\1', settings)
        new_settings = re.sub(r'sourceTree = .*?(;|$)', 'sourceTree = "<group>"\\1', new_settings)
        content = content.replace(f'{file_id} /* {filename} */ = {{isa = PBXFileReference; {settings}}};', 
                                  f'{file_id} /* {filename} */ = {{isa = PBXFileReference; {new_settings}}};')

# 2. Fix group paths
content = re.sub(r'path = \.\./.*?;', 'path = "";', content)

# 3. Fix Info.plist
content = re.sub(r'INFOPLIST_FILE = (?!macOS).*?;', 'INFOPLIST_FILE = iOS/Info.plist;', content)

with open(pbxproj_path, 'w') as f:
    f.write(content)

print("Paths fixed.")
