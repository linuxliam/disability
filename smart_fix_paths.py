import re
import os

pbxproj_path = 'DisabilityAdvocacy.xcodeproj/project.pbxproj'

with open(pbxproj_path, 'r') as f:
    content = f.read()

# 1. Find all Swift files on disk and build a mapping: name -> path
disk_files = {}
for root, dirs, files in os.walk('.'):
    if 'build' in root or '.xcodeproj' in root or '.git' in root or 'terminals' in root:
        continue
    for file in files:
        if file.endswith('.swift') or file.endswith('.json') or file.endswith('.xcassets') or file.endswith('.xcstrings') or file.endswith('.xcprivacy') or file.endswith('.plist') or file.endswith('.entitlements'):
            path = os.path.join(root, file).replace('./', '')
            if '/DerivedSources/' in path: continue
            if file not in disk_files:
                disk_files[file] = []
            disk_files[file].append(path)

# 2. Update existing PBXFileReference entries
file_refs = re.findall(r'(\w+) /\* (.*?) \*/ = \{isa = PBXFileReference; (.*?)\};', content)

for file_id, filename, settings in file_refs:
    if filename in disk_files:
        # If there's only one file with this name, use it.
        # If multiple, try to find the best match based on current path or just pick one.
        paths = disk_files[filename]
        
        # Current path in settings
        path_match = re.search(r'path = (.*?);', settings)
        current_path = path_match.group(1).strip('"') if path_match else ""
        
        best_path = paths[0]
        if len(paths) > 1:
            # Try to match based on directory name
            for p in paths:
                if any(part in p for x in current_path.split('/') for part in [x] if part and part != '..'):
                    best_path = p
                    break
        
        new_settings = re.sub(r'path = .*?(;|$)', f'path = {best_path}\\1', settings)
        new_settings = re.sub(r'sourceTree = .*?(;|$)', 'sourceTree = "<group>"\\1', new_settings)
        content = content.replace(f'{file_id} /* {filename} */ = {{isa = PBXFileReference; {settings}}};', 
                                  f'{file_id} /* {filename} */ = {{isa = PBXFileReference; {new_settings}}};')

# 3. Fix all group paths to "" to ensure file-ref paths are absolute-ish
content = re.sub(r'path = .*?;', 'path = "";', content)

# 4. Fix Info.plist
content = re.sub(r'INFOPLIST_FILE = (?!macOS).*?;', 'INFOPLIST_FILE = iOS/Info.plist;', content)

with open(pbxproj_path, 'w') as f:
    f.write(content)

print("Smart path fix completed.")
