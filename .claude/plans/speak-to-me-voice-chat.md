# Speak To Me Voice Chat

## Overview

**Feature:** Voice-first conversational interface for Seekr web app
**Module:** `modules/seekr/web`
**Status:** Approved

### Summary

A voice chat bot accessible at `/speak_to_me` route with:

- Infinity animation that responds to user speaking/AI responding
- Auto-send after 5 seconds of silence
- TTS playback of AI responses
- No message persistence (fresh start on reload)
- Conversational system prompt (replies like a human, no code blocks)

## Architecture

### Data Flow

```
User speaks → useSTT records → useSilenceDetection detects 5s pause
    ↓
Stop recording → Get transcript → useVoiceChat.sendMessage()
    ↓
Backend responds (conversational text) → useTTS.synthesize()
    ↓
Animation active during speaking/listening → Ready for next input
```

### State Machine

```
┌─────────┐     User taps      ┌───────────┐
│  IDLE   │ ────────────────→  │ LISTENING │
└─────────┘                    └───────────┘
     ↑                              │
     │                        5s silence
     │                              ↓
     │                       ┌────────────┐
     │    TTS ends           │ PROCESSING │
     │ ←──────────────────── └────────────┘
     │                              │
     │                        Response received
     │                              ↓
     │                       ┌──────────┐
     └─────────────────────  │ SPEAKING │
           TTS ends          └──────────┘
```

## File Structure

```
modules/seekr/web/src/
├── pages/
│   └── SpeakToMe/
│       ├── index.tsx              (NEW)
│       ├── InfinityAnimation.tsx  (NEW)
│       └── types.ts               (NEW)
├── hooks/
│   ├── useVoiceChat.ts           (NEW)
│   └── useSilenceDetection.ts    (NEW)
└── App.tsx                        (MODIFY)
```

## Implementation Checklist

### Phase 1: Types & Hooks

- [ ] Create `src/pages/SpeakToMe/types.ts`
  - VoiceChatMessage type
  - Phase type: 'idle' | 'listening' | 'processing' | 'speaking'
  - VoiceChatRequest/Response types

- [ ] Create `src/hooks/useSilenceDetection.ts`
  - Monitor audio input levels during recording
  - Detect when user stops speaking for 5 seconds
  - Return `onSilenceDetected` callback trigger

- [ ] Create `src/hooks/useVoiceChat.ts`
  - POST to `/api/voice-chat` endpoint
  - Handle messages array (no persistence)
  - Return `sendMessage`, `isLoading`, `response`, `error`

### Phase 2: Components

- [ ] Create `src/pages/SpeakToMe/InfinityAnimation.tsx`
  - SVG infinity symbol (∞)
  - Animate based on `isActive` prop
  - Pulse/glow effect when listening or speaking
  - Idle state: subtle floating animation

- [ ] Create `src/pages/SpeakToMe/index.tsx`
  - Orchestrate STT → Chat → TTS flow
  - Manage conversation phase state
  - Handle tap to start listening
  - Auto-stop on 5s silence
  - Display current transcript/response (optional)

### Phase 3: Integration

- [ ] Modify `src/App.tsx`
  - Add route: `<Route path="/speak_to_me" element={<SpeakToMe />} />`

### Phase 4: Backend

- [ ] Create `/api/voice-chat` endpoint
  - Same structure as `/api/chat`
  - Different system prompt: conversational, no code blocks
  - System prompt: "You are an interactive voice assistant. Respond conversationally like a human speaking. Never include code blocks, markdown formatting, or technical syntax in your responses. Keep responses concise and natural for spoken conversation."

## Reusing Existing Code

| Import          | From                       | Usage                |
| --------------- | -------------------------- | -------------------- |
| `useSTT`        | `hooks/useSTT.ts`          | Voice recording      |
| `useTTS`        | `hooks/useTTS.ts`          | Response playback    |
| `VoiceProvider` | `context/VoiceContext.tsx` | Already wrapping App |

## API Contract

### Request

```
POST /api/voice-chat
{
  "messages": [
    { "role": "user", "content": "Hello, how are you?" },
    { "role": "assistant", "content": "I'm doing great, thanks for asking!" }
  ]
}
```

### Response

```
{
  "response": "That's wonderful to hear! What would you like to talk about today?"
}
```

## Notes

- No localStorage persistence - messages cleared on page exit/reload
- Animation should be visually engaging but not distracting
- Keep responses concise for natural TTS playback
- 5-second silence threshold is configurable if needed
