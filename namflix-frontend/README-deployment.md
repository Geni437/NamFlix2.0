# NamFlix Frontend — Deployment Guide (Namecheap Shared Hosting)

## Overview

The frontend is a Next.js 15 static export. `next build` outputs plain HTML/CSS/JS
files into `out/` with no Node.js runtime required. Upload the contents of `out/`
(not the folder itself) to `public_html/` on your Namecheap cPanel server.

---

## 1. Local Setup

```bash
cd namflix-frontend
npm install
```

Copy `.env.example` to `.env.local` and fill in your values:

```bash
cp .env.example .env.local
```

```
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhb...
NEXT_PUBLIC_API_URL=https://namflix.info/api/v1
```

> `NEXT_PUBLIC_API_URL` must point to your Laravel API's public URL. On Namecheap the
> API lives at `~/namflix-api/` with a symlink or subdomain routing it to the web.

---

## 2. Build

```bash
npm run build
```

This runs `next build` with `output: 'export'` and produces `out/` containing:

```
out/
  index.html
  live/
    index.html
  channel/
    placeholder/
      index.html        ← shell for all /channel/{id}/ routes
  country/
    us/
      index.html        ← shell for all /country/{code}/ routes
  category/
    news/
      index.html        ← shell for all /category/{id}/ routes
  search/
    index.html
  favorites/
    index.html
  history/
    index.html
  _next/
    static/             ← JS/CSS bundles (long-cached)
```

---

## 3. Upload to Namecheap

### Option A — File Manager (cPanel)

1. Log into cPanel → **File Manager**
2. Navigate to `public_html/`
3. Delete or back up any existing files
4. Click **Upload**, select all files/folders from your local `out/` directory
5. After upload, also upload `.htaccess` from this project root into `public_html/`
   (the `out/` directory does not contain `.htaccess`)

### Option B — FTP/SFTP (FileZilla recommended)

```
Host:     ftp.namflix.info (or IP from cPanel)
Username: your cPanel username
Password: your cPanel password
Port:     21 (FTP) or 22 (SFTP)
```

1. On the remote side, navigate to `public_html/`
2. Upload all contents of `out/` into `public_html/`
3. Upload `.htaccess` from this project root into `public_html/`

### Option C — rsync (if SSH enabled)

```bash
# From namflix-frontend/ after npm run build
rsync -avz --delete out/ user@namflix.info:public_html/
scp .htaccess user@namflix.info:public_html/
```

---

## 4. .htaccess

The `.htaccess` file (in this project root, not in `out/`) must be uploaded to
`public_html/`. It handles:

- **HTTPS redirect** — forces all HTTP traffic to HTTPS
- **Dynamic route shells** — serves `channel/placeholder/index.html` for all
  `/channel/{any-id}/` requests; the Next.js client router then reads the real
  ID from `window.location` and fetches the correct channel
- **Clean URLs** — rewrites `/live/` to `/live/index.html` etc.
- **GZIP compression** — reduces transfer size
- **Cache headers** — JS/CSS assets cached 1 year; HTML never cached

If cPanel blocks `.htaccess` uploads via File Manager, enable "Show Hidden Files"
in the File Manager settings.

---

## 5. Supabase Configuration

In your Supabase project dashboard:

1. **Auth → URL Configuration**
   - Site URL: `https://namflix.info`
   - Redirect URLs: `https://namflix.info/**`

2. **Auth → Providers**
   - Enable Google OAuth (add Client ID + Secret from Google Cloud Console)
   - Google: set Authorised redirect URI to `https://your-project.supabase.co/auth/v1/callback`

---

## 6. Laravel API CORS

The Laravel API must allow requests from your frontend domain. In `namflix-api/config/cors.php`:

```php
'allowed_origins' => ['https://namflix.info'],
```

Or during development:

```php
'allowed_origins' => ['*'],
```

---

## 7. Verify Deployment

After upload, test these URLs:

| URL | Expected |
|-----|----------|
| `https://namflix.info/` | Home page with trending channels |
| `https://namflix.info/live/` | Browse all channels grid |
| `https://namflix.info/channel/bbc-news-uk/` | Channel player page |
| `https://namflix.info/search/` | Search page, autofocus input |
| `https://namflix.info/country/gb/` | UK channels |
| `https://namflix.info/category/news/` | News channels |

Open DevTools → Network tab and confirm:
- API calls go to `NEXT_PUBLIC_API_URL` (your Laravel backend)
- No 404 errors on JS/CSS assets
- HLS streams load in the player on `/channel/{id}/`

---

## 8. Re-deploying Updates

```bash
# Rebuild locally
npm run build

# Re-upload only changed files via rsync
rsync -avz --delete out/ user@namflix.info:public_html/
```

Because JS/CSS bundles have content-hash filenames, browsers auto-pick up new
assets. HTML files have `no-cache` headers so users always get the latest shell.

---

## 9. Troubleshooting

| Issue | Fix |
|-------|-----|
| `/channel/bbc-news/` shows 404 | `.htaccess` not uploaded or mod_rewrite not enabled |
| Blank page on channel route | Open DevTools console — likely a JS error or missing env var |
| CORS error in console | Add frontend domain to Laravel `cors.php` allowed_origins |
| Video won't play | Check browser console for HLS errors; stream may be geo-blocked |
| Auth doesn't redirect back | Add `https://namflix.info/**` to Supabase redirect URLs |
| Old version still showing | Clear browser cache; check Cache-Control headers via DevTools |

---

## 10. Environment Variables Cheat Sheet

| Variable | Where | Example |
|----------|-------|---------|
| `NEXT_PUBLIC_API_URL` | `.env.local` | `https://namflix.info/api/v1` |
| `NEXT_PUBLIC_SUPABASE_URL` | `.env.local` | `https://abc.supabase.co` |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | `.env.local` | `eyJhbGci...` |

All three must be set before running `npm run build`. They are baked into the
static bundle at build time — changing them requires a rebuild and re-upload.
