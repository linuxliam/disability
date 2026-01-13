import re
import os

pbxproj_path = 'DisabilityAdvocacy.xcodeproj/project.pbxproj'

with open(pbxproj_path, 'r') as f:
    content = f.read()

# 1. Find all Swift files on disk
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

# 2. Fix group paths (ONLY if they start with ../ or point to Shared/iOS/macOS/Resources)
def fix_group_paths(match):
    gid = match.group(1)
    gname = match.group(2)
    gpath = match.group(3)
    if '../' in gpath or any(x in gpath for x in ['Shared', 'iOS', 'macOS', 'Resources']):
        return f'{gid} /* {gname} */ = {{\n\t\t\tisa = PBXGroup;\n\t\t\tchildren = (\n'
    return match.group(0)

# This is tricky because of the children list. Let's just use a simpler regex for the path line.
# We'll match only lines like 'path = "../Shared";' within a PBXGroup section.
content = re.sub(r'(isa = PBXGroup;[\s\S]*?)path = .*?;', r'\1path = "";', content)

# 3. Update existing PBXFileReference entries
file_refs = re.findall(r'(\w+) /\* (.*?) \*/ = \{isa = PBXFileReference; (.*?)\};', content)

for file_id, filename, settings in file_refs:
    if filename in disk_files:
        paths = disk_files[filename]
        # Pick the best path. For iOS target, prefer iOS/ or Shared/
        best_path = paths[0]
        for p in paths:
            if p.startswith('Shared/') or p.startswith('iOS/') or p.startswith('Resources/'):
                best_path = p
                break
        
        new_settings = re.sub(r'path = .*?(;|$)', f'path = {best_path}\\1', settings)
        new_settings = re.sub(r'sourceTree = .*?(;|$)', 'sourceTree = "<group>"\\1', new_settings)
        content = content.replace(f'{file_id} /* {filename} */ = {{isa = PBXFileReference; {settings}}};', 
                                  f'{file_id} /* {filename} */ = {{isa = PBXFileReference; {new_settings}}};')

# 4. Special cases
content = re.sub(r'INFOPLIST_FILE = (?!macOS).*?;', 'INFOPLIST_FILE = iOS/Info.plist;', content)

with open(pbxproj_path, 'w') as f:
    f.write(content)

print("Smart fix v2 completed.")
