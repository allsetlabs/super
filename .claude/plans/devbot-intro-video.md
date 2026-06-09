# DevBot Intro Video - Implementation Plan

## Overview

Create a ~15-second intro video for the DevBot module using Remotion (React-based video framework). The video will showcase DevBot's core value proposition: mobile access to Claude Code from anywhere.

## Video Specs

- **Dimensions:** 1920x1080 (16:9 landscape)
- **FPS:** 30
- **Duration:** ~15 seconds (450 frames)
- **Style:** Dark theme with orange accent (matches DevBot's actual UI theme)
- **Font:** Inter (Google Fonts via @remotion/google-fonts)

## Video Storyboard (5 scenes with transitions)

### Scene 1: Logo Reveal (0-3s, 90 frames)

- Dark background (#1a1a2e)
- "DevBot" text scales in with spring animation
- Orange glow pulse behind the text
- Subtitle fades in: "Your AI Dev Assistant, Anywhere"

### Scene 2: Three Pillars (3-7s, 120 frames)

- Three cards slide in sequentially from bottom with staggered delays
- Each card has an icon area + label:
  1. **Chat** icon + "Interactive Chat" - ChatGPT-like AI conversations
  2. **Terminal** icon + "CLI Sessions" - Full terminal access
  3. **Clock** icon + "Scheduler" - Automated recurring tasks
- Cards have subtle orange border glow

### Scene 3: Architecture Flow (7-10s, 90 frames)

- Animated connection diagram:
  - Phone icon (left) → arrow animates → Server icon (center) → arrow animates → Claude Code icon (right)
- Labels fade in below each: "Mobile App" → "Your Server" → "Claude Code"
- Shows the key architecture concept

### Scene 4: Feature Highlights (10-13s, 90 frames)

- Quick text reveals (typewriter or slide-in):
  - "Real-time streaming responses"
  - "Multi-file upload support"
  - "Persistent terminal sessions"
  - "Scheduled automation"
- Each line appears with slight delay, orange bullet points

### Scene 5: Closing (13-15s, 60 frames)

- "DevBot" text with orange gradient
- Tagline: "Code from your pocket"
- Fade to black

### Transitions

- Fade transitions between scenes using `@remotion/transitions`
- 15-frame (0.5s) fades between each scene

## Project Location

`modules/devbot/intro-video/`

## File Structure

```
modules/devbot/intro-video/
├── package.json
├── tsconfig.json
├── remotion.config.ts
├── src/
│   ├── Root.tsx                    # Composition registration
│   ├── DevBotIntro.tsx             # Main composition (orchestrates scenes)
│   ├── scenes/
│   │   ├── LogoReveal.tsx          # Scene 1
│   │   ├── ThreePillars.tsx        # Scene 2
│   │   ├── ArchitectureFlow.tsx    # Scene 3
│   │   ├── FeatureHighlights.tsx   # Scene 4
│   │   └── Closing.tsx             # Scene 5
│   ├── components/
│   │   ├── AnimatedText.tsx        # Reusable text animation
│   │   ├── Card.tsx                # Feature card component
│   │   ├── GlowEffect.tsx         # Orange glow effect
│   │   └── Icon.tsx                # SVG icon components (no external deps)
│   └── lib/
│       └── constants.ts            # Colors, timing, shared values
```

## Key Implementation Details

### Colors (from DevBot's actual theme)

```ts
const COLORS = {
  background: '#0f0f1a', // Dark blue-black
  surface: '#1a1a2e', // Slightly lighter
  primary: '#e8913a', // DevBot orange (OKLCH 0.6716 0.1368 48.513 approximation)
  primaryGlow: '#e8913a40', // Orange with alpha for glow
  text: '#f0f0f0', // Light text
  textMuted: '#a0a0b0', // Muted text
};
```

### Animation Approach

- All animations via `useCurrentFrame()` + `interpolate()` / `spring()` (NO CSS transitions)
- Spring configs: `{ damping: 200 }` for smooth reveals, `{ damping: 15, stiffness: 200 }` for snappy entrances
- `<Sequence>` for scene timing, `<TransitionSeries>` for fade transitions between scenes

### Icons

- Hand-drawn SVG paths inline (Terminal, MessageCircle, Clock, Phone, Server, Bot icons)
- No external icon library dependency (keeps project lightweight)

### Dependencies (exact versions, no ^)

- `remotion` - Core framework
- `@remotion/cli` - Dev server + rendering
- `@remotion/transitions` - Scene transitions (fade)
- `@remotion/google-fonts` - Inter font
- `react`, `react-dom` - Required by Remotion
- `typescript` - Type safety

## Execution Steps

1. **Scaffold project** - `npx create-video@latest` in `modules/devbot/`, select blank template
2. **Install extra packages** - `@remotion/transitions`, `@remotion/google-fonts`
3. **Create constants** - Colors, timing, shared config
4. **Build scenes** - Each scene as an independent component (Scene 1-5)
5. **Build shared components** - AnimatedText, Card, GlowEffect, Icon
6. **Wire up composition** - Root.tsx with DevBotIntro orchestrating scenes via TransitionSeries
7. **Preview & iterate** - `npm run dev` to preview
8. **Render** - `npx remotion render DevBotIntro out/devbot-intro.mp4`

## Rendering

```bash
cd modules/devbot/intro-video
npx remotion render DevBotIntro out/devbot-intro.mp4
```
