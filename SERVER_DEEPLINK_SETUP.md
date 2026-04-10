# Deep Linking Server Configuration Setup

This guide explains how to set up the server-side files needed to enable seamless deep linking on both iOS and Android.

---

## 1. Android App Links - `.well-known/assetlinks.json`

### What It Does
This file tells Android that your app is the authorized handler for `https://myitihas.com` URLs. With this file, clicking a deep link on Android will **open the app directly without an app chooser**.

### Where to Place It
Place this file at: **`https://myitihas.com/.well-known/assetlinks.json`**

(Create a `.well-known` directory on your web server root if it doesn't exist)

### How to Generate It

You need:
1. **Package Name**: `com.myitihas.app` (or your actual package name)
2. **SHA-256 Signing Certificate Fingerprint**: Get this from your Android app

#### Get Your SHA-256 Fingerprint

**From your keystore file:**
```bash
keytool -list -v -keystore path/to/your/keystore.jks -alias your_alias
```

Look for: `SHA256: AB:CD:EF:...` (copy the hex values without colons)

**Or from Flutter (if using Play Store):**
```bash
# For release key
cd android
./gradlew signingReport
```

This will show something like:
```
Release: 
SHA256: 1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF
```

#### Create the assetlinks.json File

Replace `com.myitihas.app` and the SHA256 value with your actual values:

```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.myitihas.app",
      "sha256_cert_fingerprints": [
        "1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF"
      ]
    }
  }
]
```

### Upload to Server
1. Create the `.well-known` directory on your web server (usually in the `public` or `httpdocs` root)
2. Upload the `assetlinks.json` file
3. Verify it's accessible at: `https://myitihas.com/.well-known/assetlinks.json`
4. Should return a 200 status with valid JSON

### Troubleshooting
- **Multiple fingerprints?** If you have both debug and release keys, add both:
```json
"sha256_cert_fingerprints": [
  "DEBUG_SHA256_HERE",
  "RELEASE_SHA256_HERE"
]
```

---

## 2. iOS Universal Links - `.well-known/apple-app-site-association`

### What It Does
This file tells iOS that your app is the authorized handler for `https://myitihas.com` URLs. With this file, clicking a deep link on iOS will **open the app directly without an app chooser**.

### Where to Place It
Place this file at: **`https://myitihas.com/.well-known/apple-app-site-association`**

(Same `.well-known` directory as Android)

### How to Generate It

You need:
1. **Team ID**: Your Apple Developer Team ID (10-digit alphanumeric)
   - Find it at: https://developer.apple.com/account
   - Click "Membership" → Look for "Team ID"
   
2. **Bundle ID**: Your iOS app's bundle identifier (usually `com.myitihas.app` or similar)
   - Find it in: `ios/Runner/Info.plist` or Xcode project settings

#### Create the apple-app-site-association File

**IMPORTANT**: This file has **NO `.json` extension**. Name it exactly: `apple-app-site-association`

Replace `TEAM_ID` and `com.myitihas.app` with your actual values:

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAM_ID.com.myitihas.app",
        "paths": [
          "/post/*",
          "/story/*",
          "/video/*"
        ]
      }
    ]
  }
}
```

### Example with Real Values
If your Team ID is `ABC123XYZ9` and Bundle ID is `com.myitihas.app`:

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "ABC123XYZ9.com.myitihas.app",
        "paths": [
          "/post/*",
          "/story/*",
          "/video/*"
        ]
      }
    ]
  }
}
```

### Upload to Server
1. Upload the file (**without .json extension**) to `.well-known/apple-app-site-association`
2. Verify it's accessible at: `https://myitihas.com/.well-known/apple-app-site-association`
3. Should return a 200 status with valid JSON
4. **IMPORTANT**: Configure MIME type to `application/json` (see below)

### Configure MIME Type

iOS requires this file to be served with `application/json` MIME type.

**If using Apache (.htaccess)**:
```apache
<FilesMatch "apple-app-site-association">
  Header set Content-Type "application/json"
</FilesMatch>
```

**If using Nginx (nginx.conf)**:
```nginx
location /.well-known/apple-app-site-association {
  default_type application/json;
}
```

**If using Node.js/Express**:
```javascript
app.get('/.well-known/apple-app-site-association', (req, res) => {
  res.type('application/json');
  res.sendFile(path.join(__dirname, '.well-known/apple-app-site-association'));
});
```

---

## 3. Verify Setup

### Android Verification
Use the official Android tool to verify:
```bash
# Run this command to test
python3 -c "
import json
import urllib.request
url = 'https://myitihas.com/.well-known/assetlinks.json'
try:
    response = urllib.request.urlopen(url)
    data = json.loads(response.read())
    print('✓ assetlinks.json is valid and accessible')
    print('Content:', json.dumps(data, indent=2))
except Exception as e:
    print('✗ Error:', e)
"
```

Or use online tool: https://digitalassetlinks.googleapis.com/v1/assetLinkCheck?namespace=android_app&package_name=com.myitihas.app&relation=delegate_permission/common.handle_all_urls

### iOS Verification
Use the official Apple tool:
```bash
python3 -c "
import json
import urllib.request
url = 'https://myitihas.com/.well-known/apple-app-site-association'
try:
    response = urllib.request.urlopen(url)
    print(f'Status: {response.status}')
    print(f'Content-Type: {response.headers.get(\"Content-Type\")}')
    data = json.loads(response.read())
    print('✓ apple-app-site-association is valid and accessible')
    print('Content:', json.dumps(data, indent=2))
except Exception as e:
    print('✗ Error:', e)
"
```

Or use online tool: https://branch.io/resources/universal-links/

---

## 4. File Structure on Server

Your server's root should look like:

```
/var/www/myitihas.com/
├── public/
│   ├── .well-known/
│   │   ├── assetlinks.json          ← Android App Links
│   │   └── apple-app-site-association     ← iOS Universal Links (NO .json extension)
│   ├── index.html
│   ├── post/
│   ├── story/
│   ├── video/
│   └── ...other files
```

---

## 5. Testing Deep Links

### Android Testing

**Cold Start** (app not running):
```bash
adb shell am start -a android.intent.action.VIEW \
  -d "https://myitihas.com/post/ABC-123-UUID"
```

**Warm Start** (app in background):
```bash
adb shell am start -W -a android.intent.action.VIEW \
  -d "https://myitihas.com/story/XYZ-789-UUID"
```

### iOS Testing

**Via Simulator**:
- Open Safari on simulator
- Type: `https://myitihas.com/post/ABC-123-UUID`
- Tap the link → should open app (may take 5-10 seconds on first test)

**Via Real Device**:
- Send yourself a test iMessage with the link
- Tap the link → should open app automatically

---

## 6. What Works After Setup

✅ **Android** - Click `https://myitihas.com/post/{uuid}` → Opens app directly to post (no chooser)

✅ **iOS** - Click `https://myitihas.com/story/{uuid}` → Opens app directly to story (no chooser)

✅ **Cold Start** - App not running → Tapping link launches app to that content

✅ **Warm Start** - App in background → Tapping link brings app to foreground at that content

✅ **All Content Types** - Posts, stories, videos all work

✅ **Image + Text Shares** - Shared links preserve functionality

✅ **Share Functions** - All share/copy functions include working links

---

## 7. Troubleshooting

### "App not opening, going to website instead"
- assetlinks.json or apple-app-site-association not deployed
- Check files are accessible via browser (200 status, valid JSON)
- Verify MIME type is `application/json` for apple-app-site-association
- For Apple, wait 5-10 seconds after linking device (cache refresh time)

### "App opens but doesn't navigate to content"
- Deep link routing code issue (not this setup)
- Check auth_service logs in Flutter for route parsing errors

### "assetlinks.json validates but Android still shows chooser"
- Using debug SHA256? Need to add debug key fingerprint to assetlinks.json
- Reinstall app after updating assetlinks.json
- Try: `adb clear-package-data com.myitihas.app && adb install app.apk`

### "apple-app-site-association works but iOS still shows Safari"
- MIME type not set correctly
- Universal Links cache: Go to Settings → Developer → Delete Universal Links cache (device)
- Reinstall app and wait 5-10 seconds before testing
- Verify Team ID format is correct (TEAM_ID.bundle.id)

---

## 8. Checklist Before Going Live

- [ ] Android assetlinks.json deployed at `.well-known/assetlinks.json`
- [ ] assetlinks.json returns 200 status and valid JSON
- [ ] Android SHA256 fingerprint matches (both debug and release if needed)
- [ ] iOS apple-app-site-association deployed at `.well-known/apple-app-site-association`
- [ ] apple-app-site-association has **NO .json extension**
- [ ] apple-app-site-association returns 200 status and valid JSON
- [ ] MIME type for apple-app-site-association is `application/json`
- [ ] iOS Team ID and Bundle ID are correct
- [ ] Tested cold start on both platforms
- [ ] Tested warm start on both platforms
- [ ] Shared a post/story/video and clicked the link on both platforms
- [ ] All routes (`/post/*`, `/story/*`, `/video/*`) work correctly

---

## Questions?

If deep linking still doesn't work after setup:
1. Verify both files are uploaded and accessible via browser
2. Check Flutter console logs for deep link parsing errors
3. Verify app signing certificates match the ones in assetlinks.json
4. For iOS, restart device and wait 10 seconds before testing again
