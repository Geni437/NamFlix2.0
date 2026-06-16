# NamFlix Flutter App

Flutter 3 Android app for the NamFlix live TV platform.

Built with: Flutter 3 · Dart 3 · BLoC · go_router · Supabase Auth · HLS Player · In-App Purchase

Minimum Android version: 5.0 (API 21)

---

## Prerequisites

| Tool | Version | Install |
|------|---------|---------|
| Flutter | 3.19+ | https://flutter.dev/docs/get-started/install |
| Dart | 3.3+ | Bundled with Flutter |
| Android Studio | Latest | https://developer.android.com/studio |
| Java | 17 | https://adoptium.net (for Android builds) |

Verify your setup:
```bash
flutter doctor
# All items should show ✅ or ⚠️ (warnings are ok, errors are not)
```

---

## Local development

### 1. Get dependencies

```bash
cd namflix-flutter
flutter pub get
```

### 2. Run on a device or emulator

```bash
flutter run \
  --dart-define=LARAVEL_API_URL=https://namflix.info/api/v1 \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJ...
```

For local API development (Laravel on port 8000):
```bash
flutter run \
  --dart-define=LARAVEL_API_URL=http://10.0.2.2:8000/api/v1 \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJ...
```

> Note: `10.0.2.2` is the Android emulator's alias for `localhost` on the host machine.

### 3. Run tests and analysis

```bash
flutter analyze
flutter test
```

---

## Android signing setup (one-time)

Before building a release APK you need a signing keystore. Do this once and keep the keystore file safe.

### Step 1 — Generate keystore

```bash
keytool -genkey -v \
  -keystore ~/namflix-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias namflix
```

You will be prompted for:
- Store password (save this)
- Key password (save this — can be same as store password)
- Your name, organization, city, country

### Step 2 — Create key.properties

```bash
cat > android/key.properties <<EOF
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=namflix
storeFile=/absolute/path/to/namflix-keystore.jks
EOF
```

> **Never commit `android/key.properties` or `*.jks` to git** — they are in `.gitignore`.

### Step 3 — Configure android/app/build.gradle

In `android/app/build.gradle`, add before the `android {}` block:

```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
```

Inside `android {}` → `signingConfigs`:

```groovy
signingConfigs {
    release {
        keyAlias     keystoreProperties['keyAlias']
        keyPassword  keystoreProperties['keyPassword']
        storeFile    keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}
```

Inside `buildTypes {}` → `release`:

```groovy
release {
    signingConfig signingConfigs.release
    minifyEnabled true
    shrinkResources true
}
```

---

## Building for production

### Release APK (sideload / direct install)

```bash
flutter build apk --release \
  --dart-define=LARAVEL_API_URL=https://namflix.info/api/v1 \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJ... \
  --obfuscate \
  --split-debug-info=build/debug-info
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### App Bundle (Google Play Store)

```bash
flutter build appbundle --release \
  --dart-define=LARAVEL_API_URL=https://namflix.info/api/v1 \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJ... \
  --obfuscate \
  --split-debug-info=build/debug-info
```

Output: `build/app/outputs/bundle/release/app-release.aab`

---

## Automated builds (GitHub Actions)

Every push to `main` that changes `namflix-flutter/**` triggers `.github/workflows/build-android.yml`:

1. Sets up Java 17 + Flutter 3.19
2. Runs `flutter pub get`, `flutter analyze`, `flutter test`
3. Decodes the keystore from `KEYSTORE_BASE64` secret
4. Builds APK and AAB
5. Creates a GitHub Release with both files

### Setting up CI/CD secrets

Required GitHub Secrets (Settings → Secrets and variables → Actions):

| Secret | How to get it |
|--------|---------------|
| `KEYSTORE_BASE64` | `base64 -i namflix-keystore.jks` — paste the output |
| `KEY_ALIAS` | The alias used when creating the keystore (`namflix`) |
| `KEY_PASSWORD` | Key password from keystore generation |
| `STORE_PASSWORD` | Store password from keystore generation |
| `SUPABASE_URL` | From Supabase dashboard → Settings → API |
| `SUPABASE_ANON_KEY` | From Supabase dashboard → Settings → API |
| `LARAVEL_API_URL` | `https://namflix.info/api/v1` |

### Encode keystore to base64

```bash
# macOS / Linux
base64 -i ~/namflix-keystore.jks | pbcopy   # copies to clipboard (macOS)
base64 -i ~/namflix-keystore.jks            # print to terminal (Linux)

# Windows (PowerShell)
[Convert]::ToBase64String([IO.File]::ReadAllBytes("$HOME\namflix-keystore.jks"))
```

Paste the output as the `KEYSTORE_BASE64` secret.

---

## Versioning

Version is set in `pubspec.yaml`:
```yaml
version: 1.0.0+1
#         │    └── build number (versionCode in Android)
#         └── version name (versionName in Android)
```

To bump before a release:
```yaml
version: 1.1.0+2
```

The GitHub Actions workflow reads this automatically and tags the release as `v1.1.0+2`.

---

## Google Play setup for In-App Purchases

1. Create a Google Play app at https://play.google.com/console
2. Go to **Monetize → Products → Subscriptions**
3. Create two subscriptions:
   - Product ID: `namflix_pro_monthly` — Price: $2.99/month
   - Product ID: `namflix_pro_annual` — Price: $19.99/year
4. Activate both products
5. Add a Google Play service account for purchase verification:
   - Google Cloud Console → IAM → Service Accounts → Create
   - Grant role: **Android Publisher API Editor** (or use the Play Console's linked service account)
   - Download JSON key → paste contents (single line) into `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` env var on server

---

## Project structure

```
namflix-flutter/
├── lib/
│   ├── main.dart                         # App entry point
│   ├── app.dart                          # Router + theme setup
│   ├── core/
│   │   ├── constants/app_constants.dart  # dart-define values + Hive keys
│   │   ├── network/dio_client.dart       # HTTP client with JWT interceptor
│   │   ├── supabase/supabase_client.dart # Supabase init
│   │   └── theme/app_theme.dart         # Colors + text styles
│   ├── domain/
│   │   ├── entities/                     # Pure data models
│   │   └── repositories/                # Abstract interfaces
│   ├── data/
│   │   ├── models/                       # JSON-serializable models
│   │   ├── repositories/                # Implementations
│   │   └── datasources/                 # Remote + local data sources
│   └── presentation/
│       ├── blocs/                        # BLoC state management
│       ├── screens/                      # Full-page screens
│       └── widgets/                      # Reusable UI components
├── android/
│   ├── app/build.gradle                 # Signing config goes here
│   └── key.properties                   # (gitignored) keystore credentials
├── pubspec.yaml                          # Dependencies + version
└── l10n.yaml                            # Localization config
```

---

## Troubleshooting

**`flutter: error: The name 'InAppPurchase' isn't defined`**
Run `flutter pub get` — the `in_app_purchase` package must be fetched.

**Google Play billing error on emulator**
IAP only works on physical devices with Google Play Services installed. Use a real device for IAP testing.

**HLS stream not playing**
Some streams require specific HLS headers. Try a different stream for the same channel. Use `better_player` debug logs: set `betterPlayerConfiguration.eventListener` to print events.

**Supabase deep link auth not working**
Verify `namflix://auth/callback` is in Supabase's Redirect URLs (Authentication → URL Configuration) and in the Android `AndroidManifest.xml` intent filter.

**Release APK crashes**
Check ProGuard rules — some libraries need `keep` rules. Run with `--no-obfuscate` first to verify the crash isn't obfuscation-related.
