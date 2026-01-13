#!/usr/bin/env python3
"""
Comprehensive Xcode Project Validator and Fixer
Checks for errors relating to file structure and build process

Usage:
    python3 project_validator.py                    # Check for issues
    python3 project_validator.py --fix              # Check and attempt fixes (not fully implemented)
    python3 project_validator.py --project <path>   # Specify custom project path

This tool performs comprehensive validation of Xcode project files:
1. File Structure Audit - Checks for missing Swift files
2. Resource Files Verification - Verifies all resource files are referenced
3. Group Structure Verification - Checks PBXGroup paths are empty
4. Build Settings Verification - Validates iOS target build settings
5. Project File Integrity - Checks for syntax errors

Exit codes:
    0 - No errors found
    1 - Errors found
"""

import re
import os
import sys
import argparse
from pathlib import Path
from collections import defaultdict

class ProjectValidator:
    def __init__(self, project_path='DisabilityAdvocacy.xcodeproj/project.pbxproj', fix=False):
        self.project_path = project_path
        self.fix = fix
        self.project_root = Path('.')
        self.issues = []
        self.warnings = []
        
    def run(self):
        """Run all validation checks"""
        print("=" * 70)
        print("Xcode Project Validator")
        print("=" * 70)
        print()
        
        if not os.path.exists(self.project_path):
            print(f"ERROR: Project file not found: {self.project_path}")
            return False
        
        # Read project file
        with open(self.project_path, 'r') as f:
            self.content = f.read()
        
        # Run all checks
        self.check_file_structure()
        self.check_resource_files()
        self.check_group_structure()
        self.check_build_settings()
        self.check_project_integrity()
        
        # Print summary
        self.print_summary()
        
        # Apply fixes if requested
        if self.fix and self.issues:
            return self.apply_fixes()
        
        return len(self.issues) == 0
    
    def check_file_structure(self):
        """Check file structure and missing files"""
        print("=" * 70)
        print("1. FILE STRUCTURE AUDIT")
        print("=" * 70)
        print()
        
        # Find all Swift files
        all_swift_files = {}
        for swift_file in self.project_root.rglob('*.swift'):
            if '.xcodeproj' in str(swift_file) or 'Tests' in str(swift_file) or 'UITests' in str(swift_file):
                continue
            rel_path = str(swift_file.relative_to(self.project_root))
            all_swift_files[rel_path] = {
                'path': rel_path,
                'filename': swift_file.name,
                'directory': str(swift_file.parent.relative_to(self.project_root))
            }
        
        print(f"Found {len(all_swift_files)} Swift files (excluding tests)")
        print(f"  - Shared/: {len([f for f in all_swift_files if f.startswith('Shared/')])}")
        print(f"  - iOS/: {len([f for f in all_swift_files if f.startswith('iOS/')])}")
        print(f"  - macOS/: {len([f for f in all_swift_files if f.startswith('macOS/')])}")
        print()
        
        # Extract file references
        file_refs = {}
        file_ref_pattern = r'(\w+) /\* ([^*]+) \*/ = \{isa = PBXFileReference; ([^}]+)\};'
        for match in re.finditer(file_ref_pattern, self.content):
            file_id = match.group(1)
            filename = match.group(2).strip()
            settings = match.group(3)
            path_match = re.search(r'path = ([^;]+);', settings)
            if path_match:
                path = path_match.group(1).strip()
                file_refs[file_id] = {
                    'id': file_id,
                    'filename': filename,
                    'path': path,
                    'settings': settings
                }
        
        print(f"Found {len(file_refs)} file references in project")
        
        # Extract build files
        build_files = {}
        build_file_pattern = r'(\w+) /\* ([^*]+) in Sources \*/ = \{isa = PBXBuildFile; fileRef = (\w+)'
        for match in re.finditer(build_file_pattern, self.content):
            build_id = match.group(1)
            filename = match.group(2).strip()
            file_ref_id = match.group(3)
            build_files[build_id] = {
                'id': build_id,
                'filename': filename,
                'file_ref_id': file_ref_id
            }
        
        print(f"Found {len(build_files)} build file entries")
        print()
        
        # Check for missing files
        project_paths = set()
        for ref in file_refs.values():
            project_paths.add(ref['path'])
        
        missing_from_project = []
        for file_path in all_swift_files:
            if file_path not in project_paths:
                missing_from_project.append(file_path)
        
        if missing_from_project:
            self.issues.append({
                'type': 'missing_files',
                'severity': 'error',
                'message': f'{len(missing_from_project)} files missing from project',
                'details': missing_from_project[:20],
                'count': len(missing_from_project)
            })
            print(f"✗ Files missing from project: {len(missing_from_project)}")
            for path in sorted(missing_from_project)[:10]:
                print(f"  - {path}")
            if len(missing_from_project) > 10:
                print(f"  ... and {len(missing_from_project) - 10} more")
        else:
            print("✓ All Swift files are referenced in project")
        
        # Check for files in project but not on disk
        missing_from_disk = []
        for ref in file_refs.values():
            if ref['path'] not in all_swift_files and not ref['path'].startswith('Resources/'):
                if not os.path.exists(ref['path']):
                    missing_from_disk.append(ref['path'])
        
        if missing_from_disk:
            self.issues.append({
                'type': 'orphaned_references',
                'severity': 'warning',
                'message': f'{len(missing_from_disk)} files referenced but not on disk',
                'details': missing_from_disk[:10],
                'count': len(missing_from_disk)
            })
            print(f"\n⚠ Files in project but not on disk: {len(missing_from_disk)}")
            for path in sorted(missing_from_disk)[:5]:
                print(f"  - {path}")
        
        # Check for orphaned build files
        build_file_refs = set()
        for build_file in build_files.values():
            build_file_refs.add(build_file['file_ref_id'])
        
        missing_file_refs = []
        for build_id, build_file in build_files.items():
            if build_file['file_ref_id'] not in file_refs:
                missing_file_refs.append(build_file)
        
        if missing_file_refs:
            self.issues.append({
                'type': 'orphaned_build_files',
                'severity': 'error',
                'message': f'{len(missing_file_refs)} build files with missing file references',
                'details': [bf['filename'] for bf in missing_file_refs[:10]],
                'count': len(missing_file_refs)
            })
            print(f"\n✗ Build files with missing file references: {len(missing_file_refs)}")
        
        print()
    
    def check_resource_files(self):
        """Check resource files"""
        print("=" * 70)
        print("2. RESOURCE FILES VERIFICATION")
        print("=" * 70)
        print()
        
        required_resources = {
            'Resources/Resources.json': 'text.json',
            'Resources/Assets.xcassets': 'folder.assetcatalog',
            'Resources/Events.json': 'text.json',
            'Resources/Localizable.xcstrings': 'text.plist.strings',
            'Resources/PrivacyInfo.xcprivacy': 'text',
        }
        
        missing_resources = []
        for file_path, file_type in required_resources.items():
            filename = file_path.split('/')[-1]
            pattern = rf'(\w+) /\* {re.escape(filename)} \*/ = \{{isa = PBXFileReference[^}}]+path = {re.escape(file_path)}[^}}]+\}};'
            match = re.search(pattern, self.content)
            
            if not match:
                missing_resources.append((file_path, file_type))
                print(f"✗ {filename} - Missing from project")
            elif not os.path.exists(file_path):
                self.warnings.append(f"Resource file {file_path} is referenced but doesn't exist on disk")
                print(f"⚠ {filename} - Referenced but file missing on disk")
            else:
                print(f"✓ {filename} - OK")
        
        if missing_resources:
            self.issues.append({
                'type': 'missing_resources',
                'severity': 'error',
                'message': f'{len(missing_resources)} resource files missing from project',
                'details': [r[0] for r in missing_resources],
                'count': len(missing_resources)
            })
        
        # Check if resources are in Resources build phase
        resources_in_phase = re.findall(r'(\w+) /\* ([^*]+) in Resources \*/', self.content)
        print(f"\nResources in build phase: {len(resources_in_phase)}")
        print()
    
    def check_group_structure(self):
        """Check PBXGroup structure"""
        print("=" * 70)
        print("3. GROUP STRUCTURE VERIFICATION")
        print("=" * 70)
        print()
        
        # Find all PBXGroup entries
        group_pattern = r'(\w+) /\* ([^*]+) \*/ = \{[\s\S]*?isa = PBXGroup;[\s\S]*?\};'
        groups = {}
        
        for match in re.finditer(group_pattern, self.content):
            group_id = match.group(1)
            group_name = match.group(2).strip()
            group_content = match.group(0)
            
            path_match = re.search(r'path = ([^;]+);', group_content)
            path = path_match.group(1).strip() if path_match else None
            
            groups[group_id] = {
                'name': group_name,
                'path': path,
                'content': group_content
            }
        
        print(f"Found {len(groups)} PBXGroup entries")
        
        # Check for groups with non-empty paths
        path_issues = []
        for group_id, group in groups.items():
            if group['path'] and group['path'] not in ['""', '', 'None']:
                path_issues.append((group_id, group['name'], group['path']))
        
        if path_issues:
            self.issues.append({
                'type': 'group_paths',
                'severity': 'warning',
                'message': f'{len(path_issues)} groups with non-empty paths',
                'details': [f"{name}: {path}" for _, name, path in path_issues[:10]],
                'count': len(path_issues)
            })
            print(f"\n⚠ Groups with non-empty paths: {len(path_issues)}")
            for group_id, group_name, path in path_issues[:5]:
                print(f"  - {group_name}: {path}")
        else:
            print("✓ All group paths are empty")
        
        print()
    
    def check_build_settings(self):
        """Check build settings"""
        print("=" * 70)
        print("4. BUILD SETTINGS VERIFICATION")
        print("=" * 70)
        print()
        
        # Find target build configurations - look for the configuration list
        # First find the target's build configuration list ID
        target_match = re.search(r'buildConfigurationList = (\w+) /\* Build configuration list for PBXNativeTarget', self.content)
        if not target_match:
            self.issues.append({
                'type': 'build_config',
                'severity': 'error',
                'message': 'Could not find target build configuration list',
                'details': [],
                'count': 1
            })
            print("✗ Could not find target build configuration list")
            return
        
        config_list_id = target_match.group(1)
        
        # Find the configuration list
        config_list_pattern = rf'{re.escape(config_list_id)} /\* Build configuration list for PBXNativeTarget[\s\S]*?buildConfigurations = \(([\s\S]*?)\);'
        config_list_match = re.search(config_list_pattern, self.content)
        if not config_list_match:
            self.issues.append({
                'type': 'build_config',
                'severity': 'error',
                'message': 'Could not find target build configurations',
                'details': [],
                'count': 1
            })
            print("✗ Could not find target build configurations")
            return
        
        config_ids = re.findall(r'(\w+) /\* (Debug|Release) \*/', config_list_match.group(1))
        
        expected_settings = {
            'INFOPLIST_FILE': 'iOS/Info.plist',
            'GENERATE_INFOPLIST_FILE': 'NO',
            'SUPPORTED_PLATFORMS': 'iphoneos iphonesimulator',
        }
        
        for config_id, config_type in config_ids:
            print(f"=== {config_type} Configuration ===")
            
            pattern = rf'{re.escape(config_id)} /\* {re.escape(config_type)} \*/ = \{{[\s\S]*?buildSettings = \{{([\s\S]*?)\}};[\s\S]*?name = {re.escape(config_type)};'
            match = re.search(pattern, self.content)
            if not match:
                print(f"  ✗ Could not find {config_type} configuration section")
                continue
            
            settings = match.group(1)
            
            for setting, expected in expected_settings.items():
                expected_clean = expected.strip('"')
                setting_match = re.search(rf'{re.escape(setting)} = ([^;]+);', settings)
                if setting_match:
                    value = setting_match.group(1).strip().strip('"')
                    if value == expected_clean or (setting == 'SUPPORTED_PLATFORMS' and expected_clean in value):
                        print(f"  ✓ {setting}: {value}")
                    else:
                        print(f"  ✗ {setting}: {value} (expected: {expected_clean})")
                        self.issues.append({
                            'type': 'build_setting',
                            'severity': 'error',
                            'message': f'{config_type}: {setting} is incorrect',
                            'details': [f"Current: {value}, Expected: {expected_clean}"],
                            'count': 1
                        })
                else:
                    print(f"  ✗ {setting}: Not found (expected: {expected_clean})")
                    self.issues.append({
                        'type': 'build_setting',
                        'severity': 'error',
                        'message': f'{config_type}: {setting} is missing',
                        'details': [f"Expected: {expected_clean}"],
                        'count': 1
                    })
            
            # Check deployment target
            deployment_match = re.search(r'IPHONEOS_DEPLOYMENT_TARGET = ([^;]+);', settings)
            if deployment_match:
                print(f"  ✓ IPHONEOS_DEPLOYMENT_TARGET: {deployment_match.group(1).strip()}")
            else:
                print(f"  ⚠ IPHONEOS_DEPLOYMENT_TARGET: Not found")
            
            # Check Swift version
            swift_match = re.search(r'SWIFT_VERSION = ([^;]+);', settings)
            if swift_match:
                print(f"  ✓ SWIFT_VERSION: {swift_match.group(1).strip()}")
            else:
                print(f"  ⚠ SWIFT_VERSION: Not found")
            
            print()
    
    def check_project_integrity(self):
        """Check project file integrity"""
        print("=" * 70)
        print("5. PROJECT FILE INTEGRITY")
        print("=" * 70)
        print()
        
        # Check for balanced braces
        open_braces = self.content.count('{')
        close_braces = self.content.count('}')
        if open_braces != close_braces:
            self.issues.append({
                'type': 'integrity',
                'severity': 'error',
                'message': 'Mismatched braces in project file',
                'details': [f"Opening: {open_braces}, Closing: {close_braces}"],
                'count': 1
            })
            print(f"✗ Mismatched braces: {open_braces} opening, {close_braces} closing")
        else:
            print(f"✓ Braces are balanced: {open_braces} pairs")
        
        # Check for balanced parentheses
        open_parens = self.content.count('(')
        close_parens = self.content.count(')')
        if open_parens != close_parens:
            self.issues.append({
                'type': 'integrity',
                'severity': 'error',
                'message': 'Mismatched parentheses in project file',
                'details': [f"Opening: {open_parens}, Closing: {close_parens}"],
                'count': 1
            })
            print(f"✗ Mismatched parentheses: {open_parens} opening, {close_parens} closing")
        else:
            print(f"✓ Parentheses are balanced: {open_parens} pairs")
        
        # Check for common issues
        if 'MoreView.swift' in self.content or 'LiquidGlass.swift' in self.content:
            self.warnings.append("Project contains references to non-existent files (MoreView.swift, LiquidGlass.swift)")
            print("⚠ Project contains references to non-existent files")
        
        print()
    
    def print_summary(self):
        """Print summary of all issues"""
        print("=" * 70)
        print("SUMMARY")
        print("=" * 70)
        print()
        
        errors = [i for i in self.issues if i['severity'] == 'error']
        warnings_list = [i for i in self.issues if i['severity'] == 'warning'] + self.warnings
        
        if errors:
            print(f"✗ Found {len(errors)} error(s):")
            for issue in errors:
                print(f"  - {issue['message']}")
                if issue['details']:
                    for detail in issue['details'][:3]:
                        print(f"    • {detail}")
                    if len(issue['details']) > 3:
                        print(f"    ... and {len(issue['details']) - 3} more")
            print()
        
        if warnings_list:
            print(f"⚠ Found {len(warnings_list)} warning(s):")
            for warning in warnings_list[:10]:
                if isinstance(warning, dict):
                    print(f"  - {warning['message']}")
                else:
                    print(f"  - {warning}")
            if len(warnings_list) > 10:
                print(f"  ... and {len(warnings_list) - 10} more")
            print()
        
        if not errors and not warnings_list:
            print("✓ No issues found! Project structure is valid.")
            print()
        
        print(f"Total issues: {len(errors)} errors, {len(warnings_list)} warnings")
        print()
    
    def apply_fixes(self):
        """Apply automatic fixes (placeholder - would need implementation)"""
        print("=" * 70)
        print("AUTOMATIC FIXES")
        print("=" * 70)
        print()
        print("⚠ Automatic fixes are not implemented in this version.")
        print("Please use the individual fix scripts for specific issues.")
        print()
        return False

def main():
    parser = argparse.ArgumentParser(
        description='Xcode Project Validator - Check for file structure and build process errors'
    )
    parser.add_argument(
        '--fix',
        action='store_true',
        help='Attempt to automatically fix issues (not fully implemented)'
    )
    parser.add_argument(
        '--project',
        default='DisabilityAdvocacy.xcodeproj/project.pbxproj',
        help='Path to project.pbxproj file'
    )
    
    args = parser.parse_args()
    
    validator = ProjectValidator(project_path=args.project, fix=args.fix)
    success = validator.run()
    
    sys.exit(0 if success else 1)

if __name__ == '__main__':
    main()
