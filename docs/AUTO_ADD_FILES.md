# Auto-Add Files to Xcode Project

## Overview

The project structure monitoring workflow can automatically add missing Swift files to your Xcode project. This feature helps maintain project consistency and reduces manual work.

## How It Works

### Automatic Detection

The workflow automatically detects when Swift files exist in the filesystem but are not referenced in `project.pbxproj`. This can happen when:

- Files are created outside of Xcode
- Files are added via git but not through Xcode's "Add Files" dialog
- Project file gets out of sync with the filesystem

### Auto-Fix Options

#### Option 1: PR Label (Recommended)

Add the `auto-fix-project` label to your pull request. The workflow will:

1. Detect missing files
2. Automatically add them to the project
3. Commit the changes to your PR branch
4. Comment on the PR with results

**Usage:**
1. Create or update a PR
2. Add the `auto-fix-project` label
3. The workflow will run on the next push/update

#### Option 2: Manual Script

Run the script locally to add files:

```bash
# Dry run (see what would be added)
python3 scripts/auto-add-files-to-project.py --dry-run

# Add all missing files (with confirmation)
python3 scripts/auto-add-files-to-project.py

# Add all missing files automatically (no confirmation)
python3 scripts/auto-add-files-to-project.py --auto

# Add a specific file
python3 scripts/auto-add-files-to-project.py --file Shared/Utilities/NewFile.swift
```

## What Gets Added

The script automatically:

1. **Creates PBXFileReference** - Adds file reference to the project
2. **Creates PBXBuildFile** - Links file to build system
3. **Adds to Group** - Places file in appropriate group based on path:
   - `Shared/` files → Shared group
   - `iOS/` files → iOS group
   - `macOS/` files → macOS group
   - `Tests/` files → Tests group
4. **Adds to Targets** - Automatically determines target membership:
   - Shared files → Both iOS and macOS targets
   - iOS files → iOS target only
   - macOS files → macOS target only
   - Test files → Appropriate test target

## Safety Features

- **Dry Run Mode**: Test changes before applying
- **Confirmation Prompt**: Asks for confirmation before making changes (unless `--auto` is used)
- **Validation**: Checks if file already exists before adding
- **Group Detection**: Automatically finds appropriate group based on file path

## Current Status

⚠️ **Note:** The auto-add feature is currently in development. The group detection logic needs refinement to handle complex nested group structures. For now, the script will:

1. ✅ Detect missing files accurately
2. ⚠️ Attempt to find appropriate groups (may use root groups as fallback)
3. ✅ Generate proper UUIDs and project file entries
4. ⚠️ Add files to appropriate targets based on path

**Recommended Workflow:**
1. Use the script to identify missing files
2. Manually add files through Xcode for precise group placement
3. Or use the script with `--dry-run` to see what would be added, then adjust manually

## Limitations

- Only adds Swift files (`.swift` extension)
- Group detection is based on path matching (may need manual adjustment for complex structures)
- Nested group traversal needs improvement for deeply nested structures
- Build phase assignment is heuristic-based (may need verification)
- Does not remove orphaned references (use Xcode for that)

## Best Practices

1. **Review Before Committing**: Always review auto-added files in Xcode before merging
2. **Test Builds**: Run a build after auto-adding to ensure everything compiles
3. **Verify Target Membership**: Check that files are added to correct targets
4. **Use Dry Run First**: Test with `--dry-run` to see what would change

## Troubleshooting

### Files Not Added

- Check that the file path matches expected structure (`Shared/`, `iOS/`, `macOS/`)
- Verify the file exists in the filesystem
- Check workflow logs for error messages

### Wrong Target Assignment

- Manually adjust target membership in Xcode after auto-adding
- Or modify the script's `determine_targets()` function

### Group Not Found

- The script tries to match groups by path
- If a group isn't found, you may need to add the file manually in Xcode
- Or update the script's `find_group_id_for_path()` function

## Integration with CI/CD

The auto-fix feature is integrated into the GitHub Actions workflow:

- Runs automatically on PRs with the `auto-fix-project` label
- Commits changes back to the PR branch
- Posts a comment with results
- Does not require manual intervention

## Example Workflow

1. Developer creates a new Swift file: `Shared/Utilities/NewUtility.swift`
2. Developer commits and pushes to PR branch
3. CI workflow detects missing file
4. Developer adds `auto-fix-project` label to PR
5. Workflow automatically adds file to project
6. Developer reviews changes and merges PR

This eliminates the need to manually add files through Xcode!
