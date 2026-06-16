# Google OAuth Authentication

Add Google OAuth authentication to any app using the shared component library pattern.

## Architecture

```
Frontend                          Backend API                    Database
   |                                   |                            |
   | 1. Google Sign-In button          |                            |
   | 2. Get credential (ID token)      |                            |
   |-----> POST /api/auth/google-login |                            |
   |       3. Verify with Supabase Auth|                            |
   |       4. Upsert user -------------|--------------------------->|
   |       5. Return AuthTokenResponse |                            |
   |<----- { access_token, user }      |                            |
   | 6. Store in localStorage          |                            |
   | 7. useAuth() available app-wide   |                            |
```

## Prerequisites

1. **Google Cloud Console**: Create OAuth 2.0 credentials at https://console.cloud.google.com/apis/credentials
2. **Supabase**: Enable Google provider in Authentication > Providers > Google
3. **Component Library**: Must use `@allsetlabs/forge` with `InitializeForgeChunks`

## Required Environment Variables

```bash
# Client-side (exposed to browser)
NEXT_PUBLIC_GOOGLE_CLIENT_ID=your-client-id.apps.googleusercontent.com

# Server-side (Supabase config)
GOOGLE_CLIENT_SECRET=your-client-secret

# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

## Implementation Steps

### 1. Database: Create Users Table

```sql
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  google_id TEXT UNIQUE,
  email TEXT NOT NULL UNIQUE,
  name TEXT,
  profile_picture TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_users_google_id ON users(google_id);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
```

### 2. Supabase Config: Enable Google Provider

Add to `supabase/config.toml`:

```toml
[auth.external.google]
enabled = true
client_id = "env(NEXT_PUBLIC_GOOGLE_CLIENT_ID)"
secret = "env(GOOGLE_CLIENT_SECRET)"
skip_nonce_check = true
```

### 3. API Route: `/api/auth/google-login/route.ts`

```typescript
import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@supabase/supabase-js';
import type { AuthTokenResponse } from '@allsetlabs/forge/types/auth';

const supabase = createClient(process.env.SUPABASE_URL!, process.env.SUPABASE_ANON_KEY!);

export async function POST(request: NextRequest) {
  try {
    const { credential } = await request.json();

    if (!credential) {
      return NextResponse.json({ error: 'Missing credential' }, { status: 400 });
    }

    // Verify Google credential with Supabase Auth
    const { data, error } = await supabase.auth.signInWithIdToken({
      provider: 'google',
      token: credential,
    });

    if (error || !data.session || !data.user) {
      return NextResponse.json(
        { error: error?.message || 'Authentication failed' },
        { status: 401 }
      );
    }

    const googleId = data.user.user_metadata?.sub ?? data.user.id;
    const email = data.user.email ?? '';
    const name = data.user.user_metadata?.full_name ?? data.user.user_metadata?.name ?? '';
    const profilePicture =
      data.user.user_metadata?.avatar_url ?? data.user.user_metadata?.picture ?? null;

    // Upsert user in database
    const { data: dbUser, error: dbError } = await supabase
      .from('users')
      .upsert(
        { google_id: googleId, email, name, profile_picture: profilePicture },
        { onConflict: 'google_id' }
      )
      .select()
      .single();

    if (dbError) {
      console.error('Database error:', dbError);
    }

    const response: AuthTokenResponse = {
      access_token: data.session.access_token,
      token_type: 'bearer',
      user: {
        id: dbUser?.id?.toString() ?? data.user.id,
        email,
        name,
        picture: profilePicture,
      },
    };

    return NextResponse.json(response);
  } catch (error) {
    console.error('Google login error:', error);
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 });
  }
}
```

### 4. Provider Setup: `providers.tsx`

**Option A: With AuthGuard (protected app)**

```typescript
<InitializeForgeChunks
  applyToBody
  auth={{
    googleClientId: GOOGLE_CLIENT_ID,
    onSuccess: googleLogin,
    loginTitle: 'App Name',
    loginDescription: 'Sign in to continue',
  }}
>
  {children}
</InitializeForgeChunks>
```

**Option B: Without AuthGuard (public app with optional login)**

```typescript
<InitializeForgeChunks applyToBody auth={{ googleClientId: GOOGLE_CLIENT_ID }}>
  {children}
</InitializeForgeChunks>
```

### 5. Login Page: `/login/page.tsx` (for Option B)

```typescript
'use client';

import { useRouter } from 'next/navigation';
import { AuthLogin } from '@allsetlabs/forge/components/auth-login';
import { useAuth } from '@allsetlabs/forge/statefulComponents/auth/context';
import type { AuthTokenResponse } from '@allsetlabs/forge/types/auth';

async function googleLogin(credential: string): Promise<AuthTokenResponse> {
  const response = await fetch('/api/auth/google-login', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ credential }),
  });

  if (!response.ok) {
    const error = await response.json();
    throw new Error(error.error || 'Login failed');
  }

  return response.json();
}

export default function LoginPage() {
  const router = useRouter();
  const { login } = useAuth();

  const handleSuccess = async (credential: string) => {
    const tokenResponse = await googleLogin(credential);
    login(tokenResponse);
    router.push('/');
  };

  return (
    <AuthLogin
      title="App Name"
      description="Sign in to continue"
      onSuccessLogin={handleSuccess}
    />
  );
}
```

### 6. Using Auth State: `useAuth()`

```typescript
import { useAuth } from '@allsetlabs/forge/statefulComponents/auth/context';

function Component() {
  const { isAuthenticated, user, login, logout } = useAuth();

  return (
    <div>
      {isAuthenticated ? (
        <span>Welcome, {user?.name}</span>
      ) : (
        <Button onClick={() => router.push('/login')}>Login</Button>
      )}
    </div>
  );
}
```

## Auth Config Options

| Option                  | Type     | Required | Description                    |
| ----------------------- | -------- | -------- | ------------------------------ |
| `googleClientId`        | string   | Yes      | Google OAuth Client ID         |
| `onSuccess`             | function | No       | If provided, enables AuthGuard |
| `loginTitle`            | string   | No       | Login page title               |
| `loginDescription`      | string   | No       | Login page description         |
| `enableExtensionBridge` | boolean  | No       | Enable Chrome extension sync   |

## Key Differences from Seekr Web

| Aspect             | Seekr Web         | This Pattern               |
| ------------------ | ----------------- | -------------------------- |
| Backend            | Python FastAPI    | Next.js API Routes         |
| Token verification | Manual JWT decode | Supabase Auth              |
| Secret needed      | No                | Yes (GOOGLE_CLIENT_SECRET) |
| Token storage      | localStorage      | localStorage               |

## Troubleshooting

### "Provider is not enabled" Error

- Enable Google provider in `supabase/config.toml`
- Add `GOOGLE_CLIENT_SECRET` to environment
- Restart Supabase: `npm run db:stop && npm run db:start`

### "Invalid token audience" Error

- Verify `NEXT_PUBLIC_GOOGLE_CLIENT_ID` matches Google Console
- Check authorized JavaScript origins in Google Console

## Reference Implementation

See `forge-modules/meme-vault` for complete working example.
