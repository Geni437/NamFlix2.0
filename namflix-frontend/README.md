# NamFlix Frontend

Next.js 15 static frontend for the NamFlix live TV platform.

Built with: Next.js 15 (App Router, static export) · Tailwind CSS · Supabase Auth · SWR

---

## How it works

`next.config.js` has `output: 'export'` — every page is pre-rendered to static HTML at build time. There is no Next.js server at runtime. The exported files are uploaded to Namecheap's `public_html/` and served as a regular static site.

All data fetching happens client-side against the Laravel API (`NEXT_PUBLIC_API_URL`).

---

## Local development

### 1. Install dependencies

```bash
cd namflix-frontend
npm install
```

### 2. Create environment file

```bash
cp .env.example .env.local
```

Edit `.env.local`:
```env
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
NEXT_PUBLIC_API_URL=https://namflix.info/api/v1
```

For local API development (if running Laravel locally on port 8000):
```env
NEXT_PUBLIC_API_URL=http://localhost:8000/api/v1
```

### 3. Start dev server

```bash
npm run dev
```

Visit http://localhost:3000

---

## Building for production

```bash
npm run build
```

This runs `next build` and, because `output: 'export'` is set, writes the entire site to the `out/` directory as static HTML/CSS/JS.

Verify the output:
```bash
ls out/
# Should show: index.html  live/  channel/  search/  pro/  _next/  ...
```

---

## Deploying to Namecheap

### Method A — FTP (recommended for large deploys)

Use FileZilla or any FTP client:

| Setting | Value |
|---------|-------|
| Host | namflix.info |
| Username | your cPanel username |
| Password | your cPanel password |
| Port | 21 |

1. Connect to your server
2. Navigate to `/public_html/` on the server
3. Delete existing files (keep `.htaccess` if present)
4. Upload everything from your local `out/` directory to `/public_html/`

### Method B — cPanel File Manager

1. Zip the contents of `out/` locally:
   ```bash
   cd out
   zip -r ../namflix-frontend.zip .
   cd ..
   ```
2. Open cPanel → File Manager → `public_html/`
3. Delete existing files
4. Upload `namflix-frontend.zip` → Extract here
5. Delete the zip after extracting

### After uploading — verify .htaccess

Make sure `public_html/.htaccess` contains the SPA routing rules (the `.htaccess` file from this repo should be uploaded too):

```apache
Options -MultiViews
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ /index.html [QSA,L]
```

This ensures deep links like `/channel/BBC1.uk` work directly without 404s.

### Test deployment

```bash
curl https://namflix.info/                         # Home page
curl https://namflix.info/live/                    # Live TV page
curl https://namflix.info/channel/CNN.us/          # Channel page
curl https://namflix.info/pro/                     # Pro upgrade page
```

All should return HTML (not 404).

---

## Automated deployment (GitHub Actions)

Every push to `main` that changes files in `namflix-frontend/**` triggers `.github/workflows/deploy-nextjs.yml`:

1. Checks out code
2. Installs Node 20
3. Runs `npm ci`
4. Runs `npm run build` with secrets injected as env vars
5. FTP-uploads `out/` to Namecheap `public_html/`

Required GitHub Secrets:
```
FTP_HOST                    → your domain
FTP_USER                    → cPanel username
FTP_PASSWORD                → cPanel password
NEXT_PUBLIC_SUPABASE_URL    → Supabase project URL
NEXT_PUBLIC_SUPABASE_ANON_KEY → Supabase anon key
NEXT_PUBLIC_API_URL         → https://namflix.info/api/v1
```

---

## Project structure

```
namflix-frontend/
├── app/                    # Next.js App Router pages
│   ├── layout.jsx          # Root layout (GlobalNav, AuthProvider)
│   ├── page.jsx            # Home — personalized channel feed
│   ├── live/page.jsx       # All live channels
│   ├── channel/[id]/       # Channel detail + stream player
│   ├── search/page.jsx     # Search
│   ├── favorites/page.jsx  # Saved channels (requires auth)
│   ├── history/page.jsx    # Watch history (requires auth)
│   ├── pro/page.jsx        # Pro upgrade page
│   └── pro/success/        # Post-payment success
├── components/             # Reusable UI components
│   ├── GlobalNav.jsx       # Top navigation
│   ├── AuthModal.jsx       # Login/signup modal
│   ├── ChannelCard.jsx     # Channel grid card
│   ├── StreamPlayer.jsx    # HLS video player
│   ├── ProBadge.jsx        # Gold PRO badge
│   └── ProUpgradeModal.jsx # Upgrade prompt overlay
├── context/
│   └── AuthContext.jsx     # Supabase auth state
├── lib/
│   ├── api.js              # Laravel API client (apiFetch)
│   └── supabase.js         # Supabase client init
├── public/locales/         # i18n translation files (12 languages)
├── .env.example            # Environment variable template
├── .htaccess               # Apache SPA routing rules
├── next.config.js          # output: 'export', trailingSlash: true
└── tailwind.config.js
```

---

## Troubleshooting

**Build fails with "useRouter called in RSC"**
Add `'use client'` at the top of the file using `useRouter`.

**Images not loading**
`next.config.js` has `images: { unoptimized: true }` — use regular `<img>` tags for logos, or `next/image` will work but without optimization.

**Deep links return 404 on Namecheap**
Ensure `.htaccess` is uploaded and Apache `mod_rewrite` is enabled (it is on Namecheap by default).

**Auth not working**
Verify `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` are set. Check Supabase dashboard for the correct Site URL and Redirect URLs.
