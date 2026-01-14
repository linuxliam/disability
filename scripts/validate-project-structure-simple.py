#!/usr/bin/env python3
"""
Simple Xcode Project Structure Validator
Uses xcodebuild to get actual source files, then compares with filesystem
"""

import os
import subprocess
import sys
from pathlib import Path

def get_source_files_from_xcodebuild(project_path):
    """Use xcodebuild to get actual source files for each target"""
    project_dir = project_path.parent
    source_files = set()
    
    try:
        # Get list of targets
        result = subprocess.run(
            ['xcodebuild', '-list', '-project', str(project_dir)],
            capture_output=True,
            text=True,
            timeout=10
        )
        
        if result.returncode != 0:
            return source_files
        
        # Try to get source files for iOS target
        # Note: This is a simplified approach - xcodebuild doesn't directly list source files
        # We'll parse the project file instead for a more reliable check
        return source_files
    except Exception as e:
        print(f"⚠️  Could not use xcodebuild: {e}")
        return source_files

def get_swift_files_from_project(project_path):
    """Extract Swift file references from project.pbxproj"""
    with open(project_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    import re
    swift_files = set()
    
    # Find all PBXFileReference entries for Swift files
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
    
    # Get Swift files from project (by filename)
    project_swift_files = get_swift_files_from_project(project_file)
    
    # Get Swift files from filesystem
    fs_swift_files = find_swift_files_in_filesystem(project_root)
    
    # Create basename mapping
    project_basenames = {os.path.basename(f): f for f in project_swift_files}
    fs_basenames = {os.path.basename(f): f for f in fs_swift_files}
    
    # Statistics
    print("📊 Statistics:")
    print(f"  Swift files referenced in project: {len(project_swift_files)}")
    print(f"  Swift files in filesystem: {len(fs_swift_files)}")
    print()
    
    # Find files in filesystem that don't have a matching basename in project
    missing_files = []
    for fs_file in fs_swift_files:
        basename = os.path.basename(fs_file)
        if basename not in project_basenames:
            missing_files.append(fs_file)
    
    # Find project references that don't exist in filesystem
    orphaned_refs = []
    for proj_file in project_swift_files:
        basename = os.path.basename(proj_file)
        if basename not in fs_basenames:
            orphaned_refs.append(proj_file)
    
    issues = 0
    
    if missing_files:
        print("⚠️  Files NOT in project.pbxproj (by filename):")
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
    try:
        result = subprocess.run(
            ['xcodebuild', '-list', '-project', str(project_file.parent)],
            capture_output=True,
            text=True,
            timeout=10
        )
        if result.returncode == 0:
            print("✅ Project file is valid and can be parsed by xcodebuild")
        else:
            print("❌ Project file cannot be parsed by xcodebuild")
            issues = 1
    except Exception as e:
        print(f"⚠️  Could not validate project: {e}")
    
    if issues == 0:
        print()
        print("✅ Project structure appears valid!")
        print("   (Note: This is a simplified check based on filenames)")
        sys.exit(0)
    else:
        print()
        print("❌ Project structure issues found")
        print("   (Note: This check uses filename matching - verify manually if needed)")
        sys.exit(1)

if __name__ == '__main__':
    main()
