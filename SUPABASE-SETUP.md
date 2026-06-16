# Supabase Setup — NamFlix

Supabase handles **auth only** in NamFlix. MySQL on Namecheap is the app database.
Supabase is NOT used for tables, storage, or realtime in production.

---

## 1. Create the Project

1. Go to https://supabase.com/dashboard → **New project**
2. Name: `namflix` (or `namflix-prod`)
3. Password: generate a strong one and save it (you won't need it regularly)
4. Region: pick closest to your Namecheap server (e.g. Frankfurt for EU, Singapore for Asia)
5. Plan: Free tier is fine for auth-only usage

Save these from **Settings → API**:
- `Project URL` → `SUPABASE_URL` in `.env`
- `anon public` key → `SUPABASE_ANON_KEY` in `.env`
- `service_role` key → keep secret, needed if you ever use server-side Supabase admin calls
- **JWT Secret** (Settings → API → JWT Settings) → `SUPABASE_JWT_SECRET` in `.env`

---

## 2. Auth Settings

Go to **Authentication → URL Configuration**:

| Field | Value |
|-------|-------|
| Site URL | `https://namflix.info` |
| Redirect URLs | `https://namflix.info` |
| | `https://namflix.info/auth/callback` |
| | `namflix://auth/callback` |

Go to **Authentication → Settings**:

| Setting | Value |
|---------|-------|
| Enable email signup | ON |
| Confirm email | OFF (faster onboarding; enable later if needed) |
| Secure email change | ON |
| Enable phone signup | OFF |
| JWT expiry | `3600` (1 hour) |
| Refresh token expiry | `2592000` (30 days) |
| Enable refresh token rotation | ON |
| Reuse interval | `10` seconds |

---

## 3. Google OAuth

### Step A — Google Cloud Console

1. Go to https://console.cloud.google.com → **APIs & Services → Credentials**
2. Create **OAuth 2.0 Client ID** (type: Web application)
3. Authorized redirect URIs — add **exactly**:
   ```
   https://your-project-ref.supabase.co/auth/v1/callback
   ```
   (Replace `your-project-ref` with your actual Supabase project ref, visible in Settings → General)
4. Save **Client ID** and **Client Secret**

### Step B — Supabase Dashboard

1. **Authentication → Providers → Google**
2. Toggle: **Enable Google provider** ON
3. Paste Client ID and Client Secret
4. Save

### Step C — Next.js / Flutter

The clients use `supabase.auth.signInWithOAuth({ provider: 'google' })` — no additional config needed on the client side beyond `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY`.

---

## 4. Edge Functions — Deploy

Install the Supabase CLI:
```bash
npm install -g supabase
# or
brew install supabase/tap/supabase
```

Login and link:
```bash
supabase login
supabase link --project-ref your-project-ref
```

Set Edge Function secrets (these are env vars available inside Deno functions):
```bash
supabase secrets set LARAVEL_API_URL=https://namflix.info/api/v1
supabase secrets set CRON_SECRET=your-cron-secret-here
```

Deploy both functions:
```bash
supabase functions deploy sync-iptv-data --no-verify-jwt
supabase functions deploy get-user-country --no-verify-jwt
```

Verify deployment:
```bash
supabase functions list
```

---

## 5. Schedule the Sync Function (Supabase Cron)

Supabase uses pg_cron for scheduled jobs (available on Pro plan).
On the Free plan, use an external cron service (e.g. cron-job.org) to POST to the function URL.

**Function URL:**
```
https://your-project-ref.supabase.co/functions/v1/sync-iptv-data
```

**If using pg_cron (Pro plan):**

In Supabase SQL editor:
```sql
select
  cron.schedule(
    'sync-iptv-nightly',
    '0 2 * * *',  -- 2 AM daily
    $$
    select
      net.http_post(
        url := 'https://your-project-ref.supabase.co/functions/v1/sync-iptv-data',
        headers := '{"Content-Type": "application/json", "X-Cron-Secret": "your-cron-secret"}'::jsonb,
        body := '{}'::jsonb
      )
    $$
  );
```

**If using cron-job.org (Free plan):**
1. Create account at https://cron-job.org
2. Add job:
   - URL: `https://your-project-ref.supabase.co/functions/v1/sync-iptv-data`
   - Method: POST
   - Header: `X-Cron-Secret: your-cron-secret`
   - Schedule: daily at 2 AM

---

## 6. Laravel — Environment Variables

Add to your Namecheap server's `.env`:
```env
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=eyJ...
SUPABASE_JWT_SECRET=your-jwt-secret-from-supabase-dashboard

# Generate with: openssl rand -hex 32
CRON_SECRET=your-shared-cron-secret
```

The `SUPABASE_JWT_SECRET` is found in:
**Supabase Dashboard → Settings → API → JWT Settings → JWT Secret**

---

## 7. Test the Auth Flow

Test JWT verification locally:
```bash
# 1. Get a token by signing in via Supabase (use the JS client or curl)
curl -X POST 'https://your-project-ref.supabase.co/auth/v1/token?grant_type=password' \
  -H "apikey: YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"testpass"}'

# 2. Use the access_token from the response to call your Laravel API
curl -X GET 'https://namflix.info/api/v1/me' \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

Test the internal cron endpoint:
```bash
curl -X POST 'https://namflix.info/api/v1/internal/sync-iptv' \
  -H "X-Cron-Secret: your-cron-secret" \
  -H "Content-Type: application/json"
```

Test the Edge Function:
```bash
curl -X POST 'https://your-project-ref.supabase.co/functions/v1/sync-iptv-data' \
  -H "X-Cron-Secret: your-cron-secret"
```

Test country detection:
```bash
curl 'https://your-project-ref.supabase.co/functions/v1/get-user-country'
# Returns: {"country_code":"NA","country_name":"Namibia","source":"fallback"}
```

---

## 8. What Supabase Does NOT Handle

- App data (channels, streams, categories) — MySQL on Namecheap
- File storage — not configured
- Realtime subscriptions — not used (pull-based refresh instead)
- Row-level security — no app tables in Supabase
- Database migrations — Laravel handles all schema migrations

---

## Architecture Summary

```
User → Supabase Auth → JWT token
JWT token → Next.js / Flutter client
Client → Laravel API (Bearer JWT)
Laravel → VerifySupabaseToken middleware → decodes JWT → loads/creates User
Laravel MySQL → all app data queries

Supabase Edge Function (scheduled) → POST /api/v1/internal/sync-iptv
Laravel cron (primary) → same sync logic
```
