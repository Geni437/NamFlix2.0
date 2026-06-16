# NamFlix

NamFlix is a free live TV streaming platform that aggregates public IPTV streams from [iptv-org](https://github.com/iptv-org/iptv) and surfaces them through a fast, ad-free (for Pro members) web app and Android app. It is designed to run on a standard Namecheap shared hosting plan with no VPS required.

The platform is built as a monorepo with three independently deployable layers: a Laravel API backend that syncs and serves channel data, a Next.js static frontend, and a Flutter Android app. Authentication is handled by Supabase so the backend never needs to manage passwords or sessions directly.

```
┌─────────────────────────────────────────────────────────────────┐
│                        NamFlix Architecture                      │
└─────────────────────────────────────────────────────────────────┘

  [Browser / Smart TV]                    [Android App]
         │                                      │
         ▼                                      ▼
  [Next.js Static]                       [Flutter App]
  [Namecheap public_html]                      │
         │                                      │
         └──────────────┬───────────────────────┘
                        │
               ┌────────┴────────┐
               ▼                 ▼
       [Supabase Auth]    [Laravel API]
       [JWT tokens]       [Namecheap MySQL]
               │                 │
               └────────┬────────┘
                        │
              [Bearer JWT on every request]

  [iptv-org GitHub] ──→ [Laravel Cron Sync] ──→ [MySQL]
                         runs daily at 2 AM UTC
```

---

## Important: Content Hosting

**NamFlix hosts zero video content.**

All streams are publicly available M3U8 links maintained by the open-source [iptv-org](https://github.com/iptv-org/iptv) project. NamFlix is an aggregator and navigator — it fetches the stream index, stores metadata in MySQL, and presents it through a UI. The actual video delivery comes from the original broadcast providers.

NamFlix does not cache, re-stream, or store any video data. All blocked or NSFW content from iptv-org is filtered out by the sync service.

---

## Tech Stack

| Layer | Technology | Host |
|-------|------------|------|
| Frontend | Next.js 15 (static export) | Namecheap shared hosting |
| API | Laravel 11 (REST JSON API) | Namecheap shared hosting |
| Database | MySQL 8 | Namecheap (cPanel) |
| Auth | Supabase (JWT) | Supabase cloud (free tier) |
| Mobile | Flutter 3 (Android + iOS) | Google Play / App Store |
| CI/CD | GitHub Actions | GitHub |
| Stream data | iptv-org (public) | External CDN |

---

## Prerequisites

| Tool | Version | Install |
|------|---------|---------|
| Node.js | 20+ | https://nodejs.org |
| PHP | 8.2+ | Bundled with Namecheap |
| Composer | 2.x | https://getcomposer.org |
| Flutter | 3.19+ | https://flutter.dev/docs/get-started/install |
| Git | any | https://git-scm.com |
| Java | 17 (for Android) | https://adoptium.net |

---

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/namflix.git
cd namflix
```

### 2. Set up Supabase (auth layer)

Follow the step-by-step guide: **[SUPABASE-SETUP.md](SUPABASE-SETUP.md)**

You will need:
- A free Supabase account at https://supabase.com
- Google Cloud Console credentials (for Google OAuth)
- Three env values: `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SUPABASE_JWT_SECRET`

### 3. Deploy the Laravel API

Follow: **[namflix-api/README-deployment.md](namflix-api/README-deployment.md)**

Quick summary:
```bash
# On Namecheap server (cPanel → Terminal)
cd ~/namflix-api
composer install --no-dev --optimize-autoloader
cp .env.example .env
php artisan key:generate
# Edit .env with your values
php artisan migrate --force
php artisan config:cache && php artisan route:cache
php artisan namflix:sync-iptv  # First data sync (~2-5 min)
```

### 4. Deploy the Next.js frontend

Follow: **[namflix-frontend/README.md](namflix-frontend/README.md)**

Quick summary:
```bash
cd namflix-frontend
cp .env.example .env.local
# Edit .env.local
npm install
npm run build       # Produces out/ directory
# Upload out/ contents to Namecheap public_html/ via FTP
```

### 5. Build the Flutter app

Follow: **[namflix-flutter/README.md](namflix-flutter/README.md)**

Quick summary:
```bash
cd namflix-flutter
flutter pub get
flutter run \
  --dart-define=LARAVEL_API_URL=https://namflix.info/api/v1 \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

---

## Environment Variables

### Laravel API (`namflix-api/.env`)

| Variable | Description | Example |
|----------|-------------|---------|
| `APP_KEY` | Laravel encryption key (auto-generated) | `base64:...` |
| `APP_URL` | API base URL | `https://namflix.info/api` |
| `DB_DATABASE` | MySQL database name | `namflix_db` |
| `DB_USERNAME` | MySQL username | `namflix_user` |
| `DB_PASSWORD` | MySQL password | `...` |
| `SUPABASE_URL` | Supabase project URL | `https://xxx.supabase.co` |
| `SUPABASE_ANON_KEY` | Supabase public anon key | `eyJ...` |
| `SUPABASE_JWT_SECRET` | Supabase JWT secret (Settings → API → JWT) | `...` |
| `CRON_SECRET` | Shared secret for internal cron endpoints | `openssl rand -hex 32` |
| `FRONTEND_URL` | Frontend domain (for Stripe redirects) | `https://namflix.info` |
| `STRIPE_SECRET_KEY` | Stripe API secret key | `sk_live_...` |
| `STRIPE_WEBHOOK_SECRET` | Stripe webhook signing secret | `whsec_...` |
| `STRIPE_MONTHLY_PRICE_ID` | Stripe price ID for monthly plan | `price_...` |
| `STRIPE_ANNUAL_PRICE_ID` | Stripe price ID for annual plan | `price_...` |
| `GOOGLE_PLAY_PACKAGE_NAME` | Android app package name | `com.namflix.app` |
| `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` | Google service account JSON (single line) | `{...}` |
| `APPLE_SHARED_SECRET` | App Store shared secret for receipt validation | `...` |
| `CORS_ALLOWED_ORIGINS` | Allowed CORS origins | `https://namflix.info` |

### Next.js Frontend (`namflix-frontend/.env.local`)

| Variable | Description |
|----------|-------------|
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase project URL |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase public anon key |
| `NEXT_PUBLIC_API_URL` | Laravel API base URL |

### Flutter (dart-define at build time)

| Variable | Description |
|----------|-------------|
| `LARAVEL_API_URL` | Laravel API base URL |
| `SUPABASE_URL` | Supabase project URL |
| `SUPABASE_ANON_KEY` | Supabase public anon key |

### GitHub Secrets (for CI/CD)

| Secret | Used by | Description |
|--------|---------|-------------|
| `NAMECHEAP_HOST` | Laravel deploy | Server hostname or IP |
| `NAMECHEAP_USER` | Laravel deploy | cPanel username |
| `NAMECHEAP_PASSWORD` | Laravel deploy | cPanel password |
| `FTP_HOST` | Next.js deploy | FTP hostname (usually same as domain) |
| `FTP_USER` | Next.js deploy | FTP username (cPanel username) |
| `FTP_PASSWORD` | Next.js deploy | FTP password |
| `NEXT_PUBLIC_SUPABASE_URL` | Next.js deploy | Supabase URL (public) |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Next.js deploy | Supabase anon key (public) |
| `NEXT_PUBLIC_API_URL` | Next.js deploy | Laravel API URL (public) |
| `KEYSTORE_BASE64` | Android build | Base64-encoded keystore.jks |
| `KEY_ALIAS` | Android build | Keystore key alias |
| `KEY_PASSWORD` | Android build | Key password |
| `STORE_PASSWORD` | Android build | Keystore store password |
| `SUPABASE_URL` | Android build | Supabase URL |
| `SUPABASE_ANON_KEY` | Android build | Supabase anon key |
| `LARAVEL_API_URL` | Android build | Laravel API URL |

---

## Deployment

| Component | Method | Guide |
|-----------|--------|-------|
| Laravel API | SSH pull + artisan | [namflix-api/README-deployment.md](namflix-api/README-deployment.md) |
| Next.js frontend | Static FTP upload | [namflix-frontend/README.md](namflix-frontend/README.md) |
| Flutter Android | GitHub Actions APK release | [namflix-flutter/README.md](namflix-flutter/README.md) |
| Supabase | Dashboard config + CLI | [SUPABASE-SETUP.md](SUPABASE-SETUP.md) |

Automated CI/CD triggers on push to `main`:
- `namflix-api/**` changed → deploys Laravel via SSH
- `namflix-frontend/**` changed → builds Next.js and uploads via FTP
- `namflix-flutter/**` changed → builds APK and creates GitHub Release

---

## First Data Sync

After the Laravel API is deployed, run the initial data sync manually:

```bash
# SSH into your Namecheap server (cPanel → Terminal)
cd ~/namflix-api
php artisan namflix:sync-iptv
```

This fetches ~10,000+ channels from iptv-org and populates MySQL. It takes 2–5 minutes on first run. After that, the Laravel scheduler handles daily updates automatically.

To verify data loaded:
```bash
curl https://namflix.info/api/v1/channels | python3 -m json.tool | head -50
```

---

## License

MIT License — see [LICENSE](LICENSE) for details.

NamFlix uses publicly available stream data from [iptv-org/iptv](https://github.com/iptv-org/iptv) (Unlicense).
