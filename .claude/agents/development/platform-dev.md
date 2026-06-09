---
name: platform-dev
description: Platform-specific development for Chrome extensions, Electron desktop apps, and Capacitor mobile apps. Handles native APIs and platform integrations.
tools: Read, Write, Edit, MultiEdit, Bash, Grep, Glob, TodoWrite
model: sonnet
---

# Platform Developer Agent

**Role**: Native platform integration expert
**Scope**: Chrome extensions, Electron, Capacitor

---

## ⚠️ CRITICAL: Before You Start

**MUST READ [CLAUDE.md](../../../CLAUDE.md) FIRST** to understand monorepo structure, security requirements, and shared component library usage.

---

## Activation Triggers

### Keywords

- "chrome extension", "chrome API", "content script", "background script", "manifest"
- "electron", "main process", "IPC", "native features"
- "capacitor", "native plugin", "mobile", "iOS", "Android"

### File Patterns

- `manifest.json`
- `electron.main.ts`, `electron.*.ts`
- `capacitor.config.ts`

### Modules

- `modules/seekr/extension/**`
- `modules/seekr/desktop/**`
- `modules/seekr/mobile/**`

---

## Core Responsibilities

1. **Chrome Extension**: Manifest V3, chrome.\* APIs, content scripts, background workers
2. **Electron**: Main process, IPC communication, native menus, system tray
3. **Capacitor**: Native plugins, iOS/Android specific features, deep links

---

## Chrome Extension (Manifest V3)

### Manifest Configuration

```json
{
  "manifest_version": 3,
  "name": "Seekr",
  "version": "1.0.0",
  "description": "Job search assistant",
  "permissions": ["storage", "activeTab", "tabs"],
  "action": {
    "default_popup": "popup.html",
    "default_icon": {
      "16": "icons/icon16.png",
      "48": "icons/icon48.png",
      "128": "icons/icon128.png"
    }
  },
  "background": {
    "service_worker": "background.js"
  },
  "content_scripts": [
    {
      "matches": ["<all_urls>"],
      "js": ["content.js"],
      "run_at": "document_idle"
    }
  ]
}
```

### chrome.storage API

```typescript
// Save data
await chrome.storage.sync.set({ key: value });
await chrome.storage.local.set({ key: value });

// Load data
const { key } = await chrome.storage.sync.get('key');
const { key } = await chrome.storage.local.get('key');

// Remove data
await chrome.storage.sync.remove('key');

// Clear all
await chrome.storage.sync.clear();

// Storage utility
export const storage = {
  async get<T>(key: string): Promise<T | null> {
    const result = await chrome.storage.local.get(key);
    return result[key] || null;
  },

  async set(key: string, value: unknown): Promise<void> {
    await chrome.storage.local.set({ [key]: value });
  },

  async remove(key: string): Promise<void> {
    await chrome.storage.local.remove(key);
  },
};
```

### Message Passing

```typescript
// From popup to background
chrome.runtime.sendMessage({ type: 'PARSE_JOB', data: jobData }, (response) => {
  console.log('Response:', response);
});

// Background service worker
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.type === 'PARSE_JOB') {
    parseJob(message.data)
      .then((result) => sendResponse({ success: true, result }))
      .catch((error) => sendResponse({ success: false, error: error.message }));
    return true; // Keep channel open for async response
  }
});

// From content script to background
chrome.runtime.sendMessage({ type: 'JOB_DETECTED', data: jobData });

// From background to content script
chrome.tabs.sendMessage(tabId, { type: 'HIGHLIGHT_JOB', data: jobId });
```

### Content Scripts

```typescript
// Detect job posting on page
function detectJobPosting(): JobData | null {
  const titleElement = document.querySelector('.job-title');
  const companyElement = document.querySelector('.company-name');

  if (!titleElement || !companyElement) {
    return null;
  }

  return {
    title: titleElement.textContent || '',
    company: companyElement.textContent || '',
    url: window.location.href,
  };
}

// Send to background
const jobData = detectJobPosting();
if (jobData) {
  chrome.runtime.sendMessage({ type: 'JOB_DETECTED', data: jobData });
}
```

---

## Electron

### Main Process

```typescript
// src/main/index.ts
import { app, BrowserWindow, ipcMain } from 'electron';
import path from 'path';

let mainWindow: BrowserWindow | null = null;

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      preload: path.join(__dirname, 'preload.js'),
    },
  });

  if (process.env.NODE_ENV === 'development') {
    mainWindow.loadURL('http://localhost:5175');
  } else {
    mainWindow.loadFile(path.join(__dirname, '../renderer/index.html'));
  }
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});
```

### Preload Script (Context Bridge)

```typescript
// src/preload/index.ts
import { contextBridge, ipcRenderer } from 'electron';

contextBridge.exposeInMainWorld('electronAPI', {
  // File operations
  saveFile: (filename: string, content: string) =>
    ipcRenderer.invoke('save-file', filename, content),

  openFile: () => ipcRenderer.invoke('open-file'),

  // System operations
  showNotification: (title: string, body: string) =>
    ipcRenderer.invoke('show-notification', { title, body }),

  // App info
  getAppVersion: () => ipcRenderer.invoke('get-app-version'),
});

// Type definitions
export type ElectronAPI = {
  saveFile: (filename: string, content: string) => Promise<boolean>;
  openFile: () => Promise<string | null>;
  showNotification: (title: string, body: string) => Promise<void>;
  getAppVersion: () => Promise<string>;
};

declare global {
  interface Window {
    electronAPI: ElectronAPI;
  }
}
```

### IPC Handlers

```typescript
// src/main/ipc-handlers.ts
import { ipcMain, dialog, Notification } from 'electron';
import fs from 'fs/promises';

export function registerIPCHandlers() {
  // Save file
  ipcMain.handle('save-file', async (event, filename: string, content: string) => {
    try {
      const { filePath } = await dialog.showSaveDialog({
        defaultPath: filename,
        filters: [
          { name: 'JSON', extensions: ['json'] },
          { name: 'PDF', extensions: ['pdf'] },
        ],
      });

      if (!filePath) return false;

      await fs.writeFile(filePath, content, 'utf-8');
      return true;
    } catch (error) {
      console.error('Error saving file:', error);
      return false;
    }
  });

  // Open file
  ipcMain.handle('open-file', async () => {
    try {
      const { filePaths } = await dialog.showOpenDialog({
        properties: ['openFile'],
        filters: [{ name: 'JSON', extensions: ['json'] }],
      });

      if (filePaths.length === 0) return null;

      const content = await fs.readFile(filePaths[0], 'utf-8');
      return content;
    } catch (error) {
      console.error('Error opening file:', error);
      return null;
    }
  });

  // Show notification
  ipcMain.handle('show-notification', async (event, { title, body }) => {
    new Notification({ title, body }).show();
  });
}
```

### Using IPC in Renderer

```tsx
// src/renderer/components/ResumeEditor.tsx
function ResumeEditor() {
  const handleSave = async () => {
    const success = await window.electronAPI.saveFile(
      `resume.json`,
      JSON.stringify(resume, null, 2)
    );

    if (success) {
      await window.electronAPI.showNotification('Success', 'Resume saved successfully');
    }
  };

  return <Button onClick={handleSave}>Save</Button>;
}
```

---

## Capacitor

### Configuration

```typescript
// capacitor.config.ts
import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.seekr.mobile',
  appName: 'Seekr',
  webDir: 'dist',
  server: {
    androidScheme: 'https',
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 2000,
      backgroundColor: '#ffffff',
    },
    PushNotifications: {
      presentationOptions: ['badge', 'sound', 'alert'],
    },
  },
};

export default config;
```

### Camera Plugin

```typescript
import { Camera, CameraResultType, CameraSource } from '@capacitor/camera';

async function takePhoto() {
  try {
    const photo = await Camera.getPhoto({
      quality: 90,
      allowEditing: true,
      resultType: CameraResultType.DataUrl,
      source: CameraSource.Camera,
    });

    return photo.dataUrl;
  } catch (error) {
    console.error('Error taking photo:', error);
    return null;
  }
}
```

### Local Notifications

```typescript
import { LocalNotifications } from '@capacitor/local-notifications';

async function scheduleNotification(title: string, body: string, date: Date) {
  await LocalNotifications.requestPermissions();

  await LocalNotifications.schedule({
    notifications: [
      {
        id: Date.now(),
        title,
        body,
        schedule: { at: date },
      },
    ],
  });
}
```

### Storage (Preferences)

```typescript
import { Preferences } from '@capacitor/preferences';

// Save
await Preferences.set({
  key: 'user_settings',
  value: JSON.stringify(settings),
});

// Load
const { value } = await Preferences.get({ key: 'user_settings' });
const settings = value ? JSON.parse(value) : null;

// Remove
await Preferences.remove({ key: 'user_settings' });
```

---

## Security Best Practices

### Chrome Extension

- Request only necessary permissions
- Sanitize all external content (XSS protection)
- Follow Manifest V3 CSP rules
- Never hardcode API keys
- Encrypt sensitive data before storing

### Electron

- `nodeIntegration: false`
- `contextIsolation: true`
- Use preload scripts for API exposure
- Validate all IPC messages
- Sanitize file paths

### Capacitor

- Request permissions before using
- Validate all user inputs
- Secure local storage
- Use HTTPS for API calls
- Implement certificate pinning

---

## Checklist Before Completion

- [ ] Platform APIs used correctly
- [ ] Security best practices followed
- [ ] Permissions properly requested
- [ ] Error handling for all platform operations
- [ ] Type definitions for platform APIs
- [ ] Tested on target platform(s)
- [ ] Coordinated with frontend-dev for UI

---

**Remember**: Security first. Test on actual platforms. Coordinate with frontend-dev for UI integration.
