# Extension Refactor (Minimal Hello World)

**Module:** `modules/seekr/extension`
**Status:** Approved
**Created:** 2025-12-06

## Overview

Complete refactor of the Seekr Chrome extension to a minimal "Hello World" implementation with two independent React apps:

1. **Popup App** - Simple "Hello World" when clicking extension icon
2. **Page App** - Floating "S" button on every page that opens a sidebar with "Hello World"

## Architecture

### Key Decisions

- **No shared code** between popup and page apps
- **Shadow DOM** for page app CSS isolation (prevents style conflicts with host pages)
- **Self-contained apps** - each handles its own initialization and styling

### CSS Isolation Strategy

```
Host Page
└── #seekr-root (Shadow Host)
    └── Shadow DOM
        ├── <link href="page.css">  ← Tailwind + theme vars
        └── <div id="page-root">
            └── Page App renders here
```

## File Structure

```
modules/seekr/extension/src/
├── chrome/
│   ├── manifest.json
│   └── content.ts
├── popup/
│   ├── App.tsx
│   └── App.css
├── page/
│   ├── App.tsx
│   ├── FloatingButton.tsx
│   ├── Sidebar.tsx
│   └── App.css
└── popup.html
```

## Implementation Checklist

### Phase 1: Create New Files

- [ ] `src/popup/App.tsx`
  - Self-contained entry point
  - Import React, ReactDOM, component library styles
  - Set up ThemeProvider
  - Render "Hello World"
  - Mount to DOM

- [ ] `src/page/App.tsx`
  - Root component for page injection
  - Manage sidebar open/closed state
  - Render FloatingButton and Sidebar

- [ ] `src/page/FloatingButton.tsx`
  - Fixed position round button
  - Display "S" (or "✕" when open)
  - onClick prop to toggle sidebar
  - Inline styles for isolation

- [ ] `src/page/Sidebar.tsx`
  - Slide-in panel from right
  - Display "Hello World"
  - Animation for open/close

- [ ] `src/page/App.css`
  - Tailwind directives
  - CSS variables for theme
  - Animation keyframes

### Phase 2: Modify Existing Files

- [ ] Move `src/popup.css` → `src/popup/App.css`

- [ ] `src/chrome/manifest.json`
  - Remove unused permissions (identity, oauth2)
  - Update content script path
  - Simplify to basic permissions

- [ ] `src/chrome/content.tsx` → `src/chrome/content.ts`
  - Create Shadow DOM container
  - Inject App.css into Shadow DOM
  - Mount page/App.tsx inside Shadow DOM

- [ ] `src/popup.html`
  - Update script src to `popup/App.tsx`

- [ ] `vite.config.ts`
  - Update rollup input for popup
  - Ensure content script CSS is handled

### Phase 3: Delete Old Files

- [ ] `src/popup.tsx`
- [ ] `src/App.tsx`
- [ ] `src/ExtensionInit.tsx`
- [ ] `src/components/SeekerExtension.tsx`
- [ ] `src/hooks/useAuth.ts`
- [ ] `src/hooks/useResumes.ts`
- [ ] `src/popup/LoginScreen.tsx`
- [ ] `src/popup/ResumeList.tsx`
- [ ] `src/stubs/react-oauth-google.ts`
- [ ] `src/types/index.ts`
- [ ] `src/utils/api.ts`
- [ ] `src/utils/storage.ts`

### Phase 4: Validation

- [ ] Run `npm run build` - verify no errors
- [ ] Load extension in Chrome
- [ ] Test popup shows "Hello World"
- [ ] Test page injection shows floating "S" button
- [ ] Test clicking "S" opens sidebar with "Hello World"
- [ ] Verify styles don't leak to/from host page

## Component Specifications

### popup/App.tsx

```
Purpose: Self-contained popup entry point
Dependencies: React, ReactDOM, @subbiah/reusable (styles, ThemeProvider)
Renders: "Hello World" centered in popup
Size: 320x400px (set in container)
```

### page/App.tsx

```
Purpose: Root component for page injection
State: isOpen (boolean) - sidebar visibility
Children: FloatingButton, Sidebar (conditional)
```

### page/FloatingButton.tsx

```
Purpose: Floating action button
Props: isOpen, onClick
Position: Fixed, top-right
Size: 56x56px, round
Z-index: 2147483647 (max)
Visual: Blue background, white "S" text
Hover: Scale + shadow effect
```

### page/Sidebar.tsx

```
Purpose: Slide-in sidebar panel
Props: onClose
Position: Fixed, right side, full height
Width: 400px
Animation: Slide in from right
Content: "Hello World"
```

## Dependencies

No new dependencies required. Using existing:

- `react`, `react-dom`
- `@subbiah/reusable`
- `@crxjs/vite-plugin`
- `tailwindcss`

## Notes

- Component library provides ThemeProvider for dark/light mode
- Shadow DOM ensures complete style isolation for page app
- Popup uses standard DOM (extension pages are isolated by Chrome)
