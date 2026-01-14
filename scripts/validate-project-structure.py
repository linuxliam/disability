#!/usr/bin/env python3
"""
Validate Xcode Project Structure
Checks that all Swift files are properly included in the project
"""

import os
import re
import sys
from pathlib import Path
from collections import defaultdict

def parse_project_file(project_path):
    """Parse project.pbxproj and extract file references with their paths"""
    with open(project_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Extract PBXFileReference entries
    file_refs = {}
    file_ref_pattern = r'(\w+) /\* ([^*]+) \*/ = \{isa = PBXFileReference; ([^}]+)\};'
    
    for match in re.finditer(file_ref_pattern, content):
        file_id = match.group(1)
        filename = match.group(2).strip()
        settings = match.group(3)
        
        # Extract path if present
        path_match = re.search(r'path = ([^;]+);', settings)
        path = path_match.group(1).strip().strip('"') if path_match else filename
        
        file_refs[file_id] = {
            'id': file_id,
            'filename': filename,
            'path': path,
            'settings': settings
        }
    
    # Extract PBXGroup entries to build directory hierarchy
    groups = {}
    group_pattern = r'(\w+) = \{isa = PBXGroup;([^}]+)\};'
    
    for match in re.finditer(group_pattern, content, re.DOTALL):
        group_id = match.group(1)
        group_content = match.group(2)
        
        # Extract path
        path_match = re.search(r'path = ([^;]+);', group_content)
        path = path_match.group(1).strip().strip('"') if path_match else None
        
        # Extract children
        children_match = re.search(r'children = \(([^)]+)\);', group_content, re.DOTALL)
        children = []
        if children_match:
            children_content = children_match.group(1)
            # Extract file references and subgroups
            child_pattern = r'(\w+) /\* ([^*]+) \*/'
            for child_match in re.finditer(child_pattern, children_content):
                child_id = child_match.group(1)
                child_name = child_match.group(2).strip()
                children.append((child_id, child_name))
        
        groups[group_id] = {
            'id': group_id,
            'path': path,
            'children': children
        }
    
    # Build a map of file_id to group paths
    file_to_groups = {}
    def find_file_in_groups(file_id, current_groups=None):
        """Find which groups contain a file"""
        if current_groups is None:
            current_groups = []
        
        for group_id, group_info in groups.items():
            for child_id, child_name in group_info['children']:
                if child_id == file_id:
                    group_path = group_info['path'] or ""
                    full_path = current_groups + ([group_path] if group_path else [])
                    file_to_groups[file_id] = full_path
                    return
                elif child_id in groups:
                    # Recursively search subgroups
                    subgroup_path = groups[child_id].get('path', '')
                    find_file_in_groups(file_id, current_groups + ([subgroup_path] if subgroup_path else []))
    
    # Find all files in groups
    for file_id in file_refs:
        find_file_in_groups(file_id)
    
    # Get all Swift files in project
    swift_files_in_project = set()
    for file_id, file_info in file_refs.items():
        if file_info['filename'].endswith('.swift'):
            # Try to build full path from groups
            if file_id in file_to_groups:
                group_paths = file_to_groups[file_id]
                # Build path from groups
                full_path_parts = [p for p in group_paths if p]
                if full_path_parts:
                    full_path = '/'.join(full_path_parts)
                    if file_info['path'] != file_info['filename']:
                        # Path is specified, use it
                        swift_files_in_project.add(file_info['path'])
                    else:
                        # Use group path + filename
                        full_path = os.path.join(full_path, file_info['filename']).replace('\\', '/')
                        swift_files_in_project.add(full_path)
                else:
                    # No group path, just use filename (will be matched by basename)
                    swift_files_in_project.add(file_info['filename'])
            elif file_info['path'] != file_info['filename']:
                # Path is specified in file reference
                swift_files_in_project.add(file_info['path'])
            else:
                # Just filename, add it (will need basename matching)
                swift_files_in_project.add(file_info['filename'])
    
    return swift_files_in_project

def find_swift_files_in_filesystem(root_dir):
    """Find all Swift files in the filesystem"""
    swift_files = set()
    root_path = Path(root_dir)
    
    for swift_file in root_path.rglob('*.swift'):
        # Skip Xcode project internals and build artifacts
        if '.xcodeproj' in str(swift_file):
            continue
        if 'DerivedData' in str(swift_file):
            continue
        if '.build' in str(swift_file):
            continue
        
        rel_path = str(swift_file.relative_to(root_path))
        swift_files.add(rel_path)
    
    return swift_files

def main():
    project_root = Path('.')
    project_file = project_root / 'DisabilityAdvocacy.xcodeproj' / 'project.pbxproj'
    
    if not project_file.exists():
        print(f"❌ Project file not found: {project_file}")
        sys.exit(1)
    
    print("🔍 Analyzing Xcode project structure...")
    print()
    
    # Parse project file
    try:
        swift_files_in_project = parse_project_file(project_file)
    except Exception as e:
        print(f"❌ Error parsing project file: {e}")
        sys.exit(1)
    
    # Find files in filesystem
    swift_files_in_fs = find_swift_files_in_filesystem(project_root)
    
    # Statistics
    print("📊 Statistics:")
    print(f"  Files in project.pbxproj: {len(swift_files_in_project)}")
    print(f"  Files in filesystem: {len(swift_files_in_fs)}")
    print()
    
    # Normalize paths for comparison (handle both full paths and basenames)
    # Create a mapping of basenames to full paths for project files
    project_basename_map = {}
    for proj_file in swift_files_in_project:
        basename = os.path.basename(proj_file)
        if basename not in project_basename_map:
            project_basename_map[basename] = []
        project_basename_map[basename].append(proj_file)
    
    # Match filesystem files to project files
    matched_project_files = set()
    missing_files = set()
    
    for fs_file in swift_files_in_fs:
        basename = os.path.basename(fs_file)
        # Try exact match first
        if fs_file in swift_files_in_project:
            matched_project_files.add(fs_file)
        # Try basename match
        elif basename in project_basename_map:
            # Found by basename, consider it matched
            for proj_file in project_basename_map[basename]:
                matched_project_files.add(proj_file)
        else:
            # Not found in project
            missing_files.add(fs_file)
    
    # Find orphaned references (in project but not in filesystem)
    orphaned_refs = swift_files_in_project - matched_project_files
    # Filter out orphaned refs that are just basenames (not full paths)
    orphaned_refs = {ref for ref in orphaned_refs if os.path.dirname(ref) or os.path.exists(ref)}
    
    issues = 0
    
    if missing_files:
        print("⚠️  Files NOT in project.pbxproj:")
        for file in sorted(missing_files):
            print(f"  - {file}")
        print()
        issues = 1
    
    if orphaned_refs:
        print("⚠️  Orphaned references in project.pbxproj:")
        for file in sorted(orphaned_refs):
            print(f"  - {file}")
        print()
        issues = 1
    
    # Validate project can be parsed
    import subprocess
    try:
        result = subprocess.run(
            ['xcodebuild', '-list', '-project', str(project_file.parent)],
            capture_output=True,
            text=True,
            timeout=10
        )
        if result.returncode == 0:
            print("✅ Project file is valid")
        else:
            print("❌ Project file cannot be parsed")
            issues = 1
    except Exception as e:
        print(f"⚠️  Could not validate project: {e}")
    
    if issues == 0:
        print()
        print("✅ Project structure is valid!")
        sys.exit(0)
    else:
        print()
        print("❌ Project structure issues found")
        sys.exit(1)

if __name__ == '__main__':
    main()
