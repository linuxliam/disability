#!/usr/bin/env python3
"""
Automatically add missing Swift files to Xcode project
Uses a simpler, more reliable approach
"""

import os
import re
import sys
import uuid
import subprocess
from pathlib import Path

def generate_uuid():
    """Generate a 24-character hex UUID for Xcode project"""
    return ''.join([format(b, '02X') for b in uuid.uuid4().bytes[:12]])

def determine_targets(file_path):
    """Determine which targets a file should be added to based on path"""
    targets = []
    
    if file_path.startswith('Shared/'):
        targets = ['iOS', 'macOS']
    elif file_path.startswith('iOS/'):
        targets = ['iOS']
    elif file_path.startswith('macOS/'):
        targets = ['macOS']
    elif 'DisabilityAdvocacyTests' in file_path or '/Tests/' in file_path:
        if 'UITests' in file_path:
            targets = ['UITests']
        else:
            targets = ['Tests']
    
    return targets

def find_group_id_for_path(project_content, file_path):
    """Find the group ID that matches the file's directory path"""
    path_parts = file_path.split('/')
    if len(path_parts) < 2:
        return None
    
    filename = path_parts[-1]
    dir_parts = path_parts[:-1]  # All directory parts
    
    # Parse all groups first - need to get both file refs and subgroups
    groups = {}
    group_pattern = r'(\w+) = \{isa = PBXGroup;([^}]+)\};'
    for match in re.finditer(group_pattern, project_content, re.DOTALL):
        group_id = match.group(1)
        group_content = match.group(2)
        
        path_match = re.search(r'path = ([^;]+);', group_content)
        path = path_match.group(1).strip().strip('"') if path_match else None
        
        children_match = re.search(r'children = \(([^)]+)\);', group_content, re.DOTALL)
        children = []
        if children_match:
            children_content = children_match.group(1)
            # Match both file references (with /* name */) and subgroup references (with /* GroupName */)
            # Pattern: ID /* Name */ or just ID
            child_pattern = r'(\w+)(?: /\* ([^*]+) \*/)?'
            for child_match in re.finditer(child_pattern, children_content):
                child_id = child_match.group(1)
                child_name = child_match.group(2) if child_match.group(2) else None
                children.append((child_id, child_name))
        
        groups[group_id] = {
            'path': path,
            'children': children
        }
    
    # Find root group (Shared, iOS, macOS)
    root_group_id = None
    for group_id, group_info in groups.items():
        if group_info['path'] and group_info['path'].strip().strip('"') == dir_parts[0]:
            root_group_id = group_id
            break
    
    # If we can't find root group, return None (caller will handle fallback)
    if not root_group_id:
        return None
    
    # Traverse down the hierarchy
    current_group_id = root_group_id
    for dir_part in dir_parts[1:]:
        found = False
        current_group = groups.get(current_group_id)
        if not current_group:
            break
        
        # Look for child group with matching path
        # Children can be subgroups (with /* GroupName */) or file refs (with /* filename.swift */)
        for child_id, child_name in current_group['children']:
            child_group = groups.get(child_id)
            if child_group:
                # Check if this child group's path matches
                if child_group['path'] == dir_part:
                    current_group_id = child_id
                    found = True
                    break
                # Also check if the name in comment matches (for groups without explicit path)
                elif child_name and child_name == dir_part and not child_name.endswith('.swift'):
                    current_group_id = child_id
                    found = True
                    break
        
        if not found:
            # Couldn't find nested group, use current group as fallback
            # This is acceptable - Xcode will organize files correctly
            break
    
    return current_group_id

def add_file_to_project(project_path, file_path, dry_run=False):
    """Add a Swift file to the Xcode project"""
    filename = os.path.basename(file_path)
    
    # Read project file
    with open(project_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Check if file already exists
    if f'/* {filename} */' in content:
        print(f"⚠️  File {filename} already exists in project")
        return False
    
    # Generate IDs
    file_ref_id = generate_uuid()
    build_file_id = generate_uuid()
    
    # Find appropriate group
    group_id = find_group_id_for_path(content, file_path)
    if not group_id:
        # Try fallback: find root group (Shared, iOS, macOS) by searching directly
        path_parts = file_path.split('/')
        root_path = path_parts[0] if path_parts else None
        
        if root_path:
            # Try multiple patterns to find root group
            escaped_root = re.escape(root_path)
            
            # Pattern 1: ID /* Name */ = {isa = PBXGroup; ... path = root_path; ...}
            # Example: 1C48819584B74449A148E167 /* Shared */ = {isa = PBXGroup; ... path = Shared; ...}
            pattern1 = r'(\w+) /\* ' + escaped_root + r' \*/ = \{isa = PBXGroup;.*?path\s*=\s*' + escaped_root + r'\s*;'
            match = re.search(pattern1, content, re.DOTALL)
            
            # Pattern 2: Just look for path = root_path in any group (more flexible)
            if not match:
                pattern2 = r'(\w+) = \{isa = PBXGroup;.*?path\s*=\s*' + escaped_root + r'\s*;'
                match = re.search(pattern2, content, re.DOTALL)
            
            # Pattern 3: Look for group with name in comment that matches (simplest - just ID and name)
            if not match:
                pattern3 = r'(\w+) /\* ' + escaped_root + r' \*/ = \{'
                match = re.search(pattern3, content)
                # Verify it's actually a PBXGroup by checking a bit further
                if match:
                    verify_start = match.end()
                    verify_snippet = content[verify_start:verify_start+50]
                    if 'isa = PBXGroup' not in verify_snippet:
                        match = None
            
            if match:
                group_id = match.group(1)
                print(f"⚠️  Using root group '{root_path}' as fallback for {file_path}")
            else:
                print(f"❌ Could not find appropriate group for {file_path}")
                print(f"   Tried to find group matching: {os.path.dirname(file_path)} or root: {root_path}")
                # For debugging, show what groups exist
                all_groups = re.findall(r'(\w+) /\* ([^*]+) \*/ = \{isa = PBXGroup;', content)
                root_groups = [g for g in all_groups if g[1] in ['Shared', 'iOS', 'macOS']]
                if root_groups:
                    print(f"   Available root groups: {[g[1] for g in root_groups]}")
                return False
        else:
            print(f"❌ Could not find appropriate group for {file_path}")
            return False
    
    if dry_run:
        targets = determine_targets(file_path)
        target_phase_map = {
            'iOS': '71766063671C46D7A2A2068A',
            'macOS': 'F5BF35698B7347C5BA2563DF',
            'Tests': '577E390F15AA4C7EA2BEF50D',
            'UITests': '8473A0E265DA4DCCA7A91DFF'
        }
        
        # Determine which phases will be updated
        phases_to_update = []
        for target in targets:
            if target in target_phase_map:
                phases_to_update.append(target_phase_map[target])
        
        # If Shared file, add to both iOS and macOS
        if 'Shared' in file_path:
            phases_to_update.extend(['71766063671C46D7A2A2068A', 'F5BF35698B7347C5BA2563DF'])
            phases_to_update = list(set(phases_to_update))  # Remove duplicates
        
        print(f"🔍 [DRY RUN] Would add {file_path}:")
        print(f"   File Reference ID: {file_ref_id}")
        print(f"   Build File ID: {build_file_id}")
        print(f"   Target Group ID: {group_id}")
        print(f"   Targets: {', '.join(targets)}")
        print(f"   Build Phases: {len(phases_to_update)} phase(s) will be updated")
        return True
    
    # Add PBXFileReference
    file_ref_entry = f"\t\t{file_ref_id} /* {filename} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {filename}; sourceTree = \"<group>\"; }};\n"
    
    # Find PBXFileReference section end
    file_ref_end = content.find('/* End PBXFileReference section */')
    if file_ref_end == -1:
        print("❌ Could not find PBXFileReference section")
        return False
    
    # Insert before end marker (maintain indentation)
    content = content[:file_ref_end] + file_ref_entry + '\t' + content[file_ref_end:]
    
    # Add PBXBuildFile
    build_file_entry = f"\t\t{build_file_id} /* {filename} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /* {filename} */; }};\n"
    
    build_file_end = content.find('/* End PBXBuildFile section */')
    if build_file_end == -1:
        print("❌ Could not find PBXBuildFile section")
        return False
    
    content = content[:build_file_end] + build_file_entry + '\t' + content[build_file_end:]
    
    # Add file reference to group's children
    group_pattern = f'({re.escape(group_id)}) = \\{{isa = PBXGroup;([^}}]+)\\}};'
    group_match = re.search(group_pattern, content, re.DOTALL)
    if group_match:
        group_start = group_match.start()
        group_end = group_match.end()
        group_content = group_match.group(2)
        
        children_match = re.search(r'children = \(([^)]+)\);', group_content, re.DOTALL)
        if children_match:
            # Calculate absolute position of children end in full content
            children_content = children_match.group(1)
            children_start_in_group = children_match.start(1)
            children_end_in_group = children_match.end(1)
            
            # Position relative to group start
            group_header_len = len(group_match.group(1)) + len(' = {isa = PBXGroup;')
            children_start_abs = group_start + group_header_len + children_match.start(1)
            children_end_abs = group_start + group_header_len + children_match.end(1)
            
            # Add file reference to children (before closing parenthesis)
            new_child = f'\t\t\t\t{file_ref_id} /* {filename} */,\n'
            
            # Insert the new child before the closing paren
            content = content[:children_end_abs] + new_child + '\t\t\t\t' + content[children_end_abs:]
        else:
            # Group has no children yet - create children section
            # Find where to insert (after group header, before closing brace)
            group_header = f'{group_id} = {{isa = PBXGroup;'
            header_end = group_match.start() + len(group_header)
            
            # Insert children section
            children_section = f'\t\tchildren = (\n\t\t\t\t{file_ref_id} /* {filename} */,\n\t\t\t);\n'
            content = content[:header_end] + children_section + '\t\t' + content[header_end:]
    
    # Add to build phases for appropriate targets
    targets = determine_targets(file_path)
    
    # Map target names to their Sources build phase IDs (from project file analysis)
    target_phase_map = {
        'iOS': '71766063671C46D7A2A2068A',      # iOS Sources phase
        'macOS': 'F5BF35698B7347C5BA2563DF',   # macOS Sources phase
        'Tests': '577E390F15AA4C7EA2BEF50D',    # Tests Sources phase
        'UITests': '8473A0E265DA4DCCA7A91DFF'  # UITests Sources phase
    }
    
    # Find all Sources build phases and add to appropriate ones
    sources_phase_pattern = r'(\w+) = \{isa = PBXSourcesBuildPhase;[^}]*files = \(([^)]+)\);'
    
    phases_to_update = []
    for target in targets:
        if target in target_phase_map:
            phases_to_update.append(target_phase_map[target])
    
    # If Shared file, add to both iOS and macOS
    if 'Shared' in file_path:
        if '71766063671C46D7A2A2068A' not in phases_to_update:
            phases_to_update.append('71766063671C46D7A2A2068A')  # iOS
        if 'F5BF35698B7347C5BA2563DF' not in phases_to_update:
            phases_to_update.append('F5BF35698B7347C5BA2563DF')  # macOS
    
    # Update each phase
    for phase_match in re.finditer(sources_phase_pattern, content, re.DOTALL):
        phase_id = phase_match.group(1)
        
        if phase_id in phases_to_update:
            # Insert build file reference before closing parenthesis
            files_content = phase_match.group(2)
            new_build_ref = f'\t\t\t\t{build_file_id} /* {filename} in Sources */,\n'
            
            # Find the end of the files list (before closing paren)
            files_end = phase_match.end(2)
            content = content[:files_end] + new_build_ref + '\t\t\t\t' + content[files_end:]
            
            # Remove from list to avoid duplicate additions
            phases_to_update.remove(phase_id)
            
            # If we've updated all phases, we're done
            if not phases_to_update:
                break
    
    # Write back
    with open(project_path, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"✅ Added {file_path} to project")
    return True

def get_swift_files_from_project(project_path):
    """Extract Swift file references from project.pbxproj"""
    with open(project_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    swift_files = set()
    pattern = r'(\w+) /\* ([^*]+\.swift) \*/ = \{isa = PBXFileReference;'
    for match in re.finditer(pattern, content):
        filename = match.group(2)
        swift_files.add(filename)
    
    return swift_files

def find_swift_files_in_filesystem(root_dir):
    """Find all Swift files in the filesystem"""
    swift_files = set()
    root_path = Path(root_dir)
    
    for swift_file in root_path.rglob('*.swift'):
        if '.xcodeproj' in str(swift_file):
            continue
        if 'DerivedData' in str(swift_file):
            continue
        if '.build' in str(swift_file):
            continue
        
        rel_path = str(swift_file.relative_to(root_path))
        swift_files.add(rel_path)
    
    return swift_files

def find_missing_files():
    """Find Swift files that are not in the project"""
    project_path = Path('DisabilityAdvocacy.xcodeproj/project.pbxproj')
    fs_files = find_swift_files_in_filesystem('.')
    project_files = get_swift_files_from_project(project_path)
    
    project_basenames = {os.path.basename(f): f for f in project_files}
    
    missing = []
    for fs_file in fs_files:
        basename = os.path.basename(fs_file)
        if basename not in project_basenames:
            missing.append(fs_file)
    
    return missing

def main():
    import argparse
    
    parser = argparse.ArgumentParser(description='Automatically add missing Swift files to Xcode project')
    parser.add_argument('--dry-run', action='store_true', help='Show what would be done without making changes')
    parser.add_argument('--file', help='Specific file to add (relative to project root)')
    parser.add_argument('--project', default='DisabilityAdvocacy.xcodeproj/project.pbxproj', help='Path to project.pbxproj')
    parser.add_argument('--auto', action='store_true', help='Automatically add all missing files without prompting')
    args = parser.parse_args()
    
    project_path = Path(args.project)
    if not project_path.exists():
        print(f"❌ Project file not found: {project_path}")
        sys.exit(1)
    
    if args.file:
        # Add specific file
        file_path = Path(args.file)
        if not file_path.exists():
            print(f"❌ File not found: {file_path}")
            sys.exit(1)
        
        # Get relative path from project root
        project_root = project_path.parent.parent
        try:
            rel_path = str(file_path.relative_to(project_root))
        except ValueError:
            rel_path = str(file_path)
        
        add_file_to_project(project_path, rel_path, dry_run=args.dry_run)
    else:
        # Find and add all missing files
        missing = find_missing_files()
        
        if not missing:
            print("✅ No missing files found!")
            return
        
        print(f"Found {len(missing)} missing files:")
        for file in missing:
            print(f"  - {file}")
        
        if args.dry_run:
            print("\n[DRY RUN] Would add the following files:")
            for file in missing:
                add_file_to_project(project_path, file, dry_run=True)
        elif args.auto:
            print(f"\nAutomatically adding {len(missing)} files to project...")
            for file in missing:
                add_file_to_project(project_path, file, dry_run=False)
        else:
            response = input(f"\nAdd {len(missing)} files to project? (y/N): ")
            if response.lower() == 'y':
                for file in missing:
                    add_file_to_project(project_path, file, dry_run=False)
            else:
                print("Cancelled.")

if __name__ == '__main__':
    main()
