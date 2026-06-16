# NamFlix API — Namecheap Shared Hosting Deployment Guide

## Directory Structure on Server

```
~/                          ← home directory (outside public_html)
├── namflix-api/            ← Laravel lives here (NOT inside public_html)
│   ├── app/
│   ├── bootstrap/
│   ├── config/
│   ├── database/
│   ├── public/             ← THIS is what we expose
│   ├── routes/
│   ├── storage/
│   └── vendor/
└── public_html/
    └── api/                ← symlink OR .htaccess redirect → ~/namflix-api/public/
```

---

## Step 1 — Upload Laravel Files via cPanel File Manager

1. Log into cPanel → **File Manager**
2. Navigate to your **home directory** (one level above `public_html`)
3. Create a folder named `namflix-api`
4. Upload and extract your Laravel zip into `namflix-api/`
5. Ensure the folder structure shows `namflix-api/app/`, `namflix-api/public/`, etc.

---

## Step 2 — Create MySQL Database in cPanel

1. cPanel → **MySQL Databases**
2. Create database: `namflix_db`
3. Create user: `namflix_user` with a strong password
4. Add user to database with **ALL PRIVILEGES**
5. Note your credentials for `.env`

---

## Step 3 — Configure .env

SSH into your server (cPanel → Terminal) and run:

```bash
cd ~/namflix-api
cp .env.example .env
nano .env
```

Fill in:
```
APP_KEY=           # Will be generated in Step 4
APP_URL=https://namflix.info/api

DB_DATABASE=namflix_db
DB_USERNAME=namflix_user
DB_PASSWORD=your_password

SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_anon_key
SUPABASE_JWT_SECRET=your_jwt_secret    # From Supabase: Settings → API → JWT Secret

# Cron + internal endpoint security (generate with: openssl rand -hex 32)
CRON_SECRET=your_random_secret

# Frontend URL (used for Stripe redirect after checkout)
FRONTEND_URL=https://namflix.info

# Stripe (create at https://dashboard.stripe.com)
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...
STRIPE_MONTHLY_PRICE_ID=price_...
STRIPE_ANNUAL_PRICE_ID=price_...

# Google Play IAP verification (optional — only needed for mobile subscriptions)
GOOGLE_PLAY_PACKAGE_NAME=com.namflix.app
GOOGLE_PLAY_SERVICE_ACCOUNT_JSON=      # Single-line JSON from Google Cloud Console

# Apple IAP verification (optional — only needed for iOS subscriptions)
APPLE_SHARED_SECRET=                   # App Store Connect → In-App Purchases → Shared Secret

CORS_ALLOWED_ORIGINS=https://namflix.info,https://www.namflix.info
```

---

## Step 4 — Install Dependencies & Setup

Via cPanel Terminal (SSH):

```bash
cd ~/namflix-api

# Install PHP dependencies
composer install --no-dev --optimize-autoloader

# Generate application key
php artisan key:generate

# Run database migrations
php artisan migrate --force

# Cache config for production
php artisan config:cache
php artisan route:cache

# Set correct permissions
chmod -R 755 storage bootstrap/cache
```

---

## Step 5 — Point public_html/api to Laravel Public Folder

### Option A — Symlink (if your host supports it via SSH)
```bash
# From your home directory
ln -s ~/namflix-api/public ~/public_html/api
```

### Option B — .htaccess redirect (most reliable on shared hosting)

Create `~/public_html/api/.htaccess`:
```apache
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteRule ^(.*)$ /home/YOUR_CPANEL_USERNAME/namflix-api/public/$1 [L]
</IfModule>
```

### Option C — Copy public folder contents

In `~/namflix-api/public/index.php`, update the paths:
```php
// Change these lines to use absolute paths
require __DIR__.'/../../../namflix-api/vendor/autoload.php';
$app = require_once __DIR__.'/../../../namflix-api/bootstrap/app.php';
```

Then copy all files from `namflix-api/public/` to `public_html/api/`.

**Recommended for Namecheap: Option B or C**

---

## Step 6 — Configure Cron Job (Laravel Scheduler)

1. cPanel → **Cron Jobs**
2. Set frequency to **Every Minute** (`* * * * *`)
3. Command:
```
cd /home/YOUR_CPANEL_USERNAME/namflix-api && php artisan schedule:run >> /dev/null 2>&1
```

Replace `YOUR_CPANEL_USERNAME` with your actual cPanel username.

This single cron entry runs the Laravel scheduler, which then handles:
- `namflix:sync-iptv` — daily at 2 AM UTC
- `namflix:check-streams` — every 6 hours
- `namflix:sync-epg` — every 6 hours
- `namflix:snapshot-stats` — daily at midnight UTC

---

## Step 6b — Register Stripe Webhook

In the Stripe Dashboard (https://dashboard.stripe.com/webhooks):

1. Click **Add endpoint**
2. Endpoint URL: `https://namflix.info/api/v1/billing/webhook`
3. Select events to listen for:
   - `checkout.session.completed`
   - `customer.subscription.updated`
   - `customer.subscription.deleted`
   - `invoice.payment_failed`
4. Copy the **Signing Secret** → paste into `STRIPE_WEBHOOK_SECRET` in `.env`
5. Re-run: `php artisan config:cache`

---

## Step 7 — Run Initial Data Sync

After deployment, manually trigger the first sync:

```bash
cd ~/namflix-api
php artisan namflix:sync-iptv
```

This fetches all ~10,000+ channels from iptv-org. It may take 2–5 minutes.

---

## Step 8 — Verify API is Working

Test these URLs in your browser or Postman:

```
GET https://namflix.info/api/v1/channels
GET https://namflix.info/api/v1/categories
GET https://namflix.info/api/v1/countries
GET https://namflix.info/api/v1/search?q=bbc
GET https://namflix.info/api/v1/trending
```

All should return `{"success": true, "data": [...]}`.

---

## Updating the API (deploy a new version)

Run this on the server after every code push:

```bash
cd ~/namflix-api
git pull origin main
php ~/composer install --no-dev --optimize-autoloader
php artisan migrate --force
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

Or use GitHub Actions — any push to `main` that touches `namflix-api/**` triggers automatic deployment via `.github/workflows/deploy-laravel.yml`.

---

## Supabase Configuration

1. Go to your Supabase project → **Settings → API**
2. Copy the **JWT Secret** (NOT the anon key) → paste into `SUPABASE_JWT_SECRET` in `.env`
3. In Supabase Auth settings, add your domain to the **Site URL** and **Redirect URLs**
4. Enable Google OAuth if needed: Authentication → Providers → Google

---

## Environment Requirements

| Requirement | Value |
|-------------|-------|
| PHP | 8.2+ |
| MySQL | 5.7+ or 8.0+ |
| Composer | 2.x |
| PHP Extensions | pdo_mysql, json, mbstring, openssl, tokenizer, xml, ctype, fileinfo, curl |

---

## Troubleshooting

**500 errors on API calls:**
```bash
tail -f ~/namflix-api/storage/logs/laravel.log
```

**Permissions issue:**
```bash
chmod -R 755 ~/namflix-api/storage
chmod -R 755 ~/namflix-api/bootstrap/cache
```

**Config not updating:**
```bash
php artisan config:clear
php artisan config:cache
```

**Migrations failing:**
```bash
php artisan migrate:status
php artisan migrate --force
```

**JWT auth not working:**
- Confirm `SUPABASE_JWT_SECRET` is the JWT Secret (not the anon key)
- The JWT Secret is under Supabase: Settings → API → JWT Settings → JWT Secret
