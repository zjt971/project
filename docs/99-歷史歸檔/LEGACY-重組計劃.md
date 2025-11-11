# Documentation Reorganization Plan

## Objective
Ensure all documentation follows the @/docs/ principle where all produced documentation should be placed under the `docs/` directory.

## Current Status Analysis

### ✅ Compliant Files (No Action Needed)
- `docs/` - 38+ documentation files already properly organized
- `docs/architecture/` - 8 ADR files properly categorized
- `docs/uiux/` - UI/UX guidelines properly placed
- `requirement/` - **Explicitly excluded from reorganization per user request**

### ❌ Non-Compliant Files (Require Action)

#### Root Directory Files
1. **README.md** 
   - Current: Generic Gitee template content
   - Action: Move to `docs/project-readme-original.md` (preserve for reference)
   - Reason: Generic template, not project-specific documentation

2. **README.en.md**
   - Current: Comprehensive project documentation (335 lines)
   - Action: Move to `docs/README.md` (becomes main project documentation)
   - Reason: This is the actual project documentation that should be the main README

#### Code Directory Files
3. **code/ri-app/README.md**
   - Current: Application-specific development guide
   - Action: Move to `docs/development/ri-app-development-guide.md`
   - Reason: Development documentation should be centralized

4. **code/ri-app/README-VERCEL.md**
   - Current: Vercel deployment guide (275 lines)
   - Action: Move to `docs/deployment/vercel-deployment-guide.md`
   - Reason: Deployment documentation should be centralized

## Proposed Directory Structure

```
docs/
├── README.md                                    # Main project documentation (from README.en.md)
├── project-readme-original.md                  # Original Gitee template (from README.md)
├── development/
│   ├── ri-app-development-guide.md            # From code/ri-app/README.md
│   └── environment-setup-guide.md             # Existing
├── deployment/
│   ├── vercel-deployment-guide.md             # From code/ri-app/README-VERCEL.md
│   └── vercel-deployment.md                   # Existing
├── architecture/                               # Existing - no changes
├── uiux/                                      # Existing - no changes
└── [all other existing docs files]           # Existing - no changes
```

## Implementation Steps

### Phase 1: Create New Directory Structure
- Create `docs/development/` directory
- Create `docs/deployment/` directory

### Phase 2: Move Files
1. Move `README.md` → `docs/project-readme-original.md`
2. Move `README.en.md` → `docs/README.md`
3. Move `code/ri-app/README.md` → `docs/development/ri-app-development-guide.md`
4. Move `code/ri-app/README-VERCEL.md` → `docs/deployment/vercel-deployment-guide.md`

### Phase 3: Update References
- Update internal links in moved files
- Update any references to moved files in other documentation
- Ensure all relative paths are corrected

### Phase 4: Verification
- Verify all markdown files are under `docs/` (except `requirement/` per user request)
- Check all internal links work correctly
- Validate documentation structure is logical and accessible

## Benefits of This Reorganization

1. **Centralized Documentation**: All project documentation in one location
2. **Logical Categorization**: Development and deployment docs properly categorized
3. **Improved Discoverability**: Easier to find relevant documentation
4. **Consistent Structure**: Follows established @/docs/ principle
5. **Preserved Content**: No documentation is lost, only reorganized

## Files Explicitly Excluded

- `requirement/` directory - Per user request, these files remain unchanged
- Node modules and generated files - Not documentation files

## Post-Reorganization Maintenance

- New documentation should always be created under `docs/`
- Consider creating a documentation style guide
- Regular reviews to ensure compliance with @/docs/ principle