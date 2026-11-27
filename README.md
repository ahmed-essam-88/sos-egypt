# SOS EGYPT

Emergency assistance and personal safety app for Egypt (Flutter, Android, Arabic RTL + English).

## What it does
- **SOS**: press-and-hold button, 5 second cancel countdown, GPS location, customisable message, optional emergency profile (only with consent), per-contact SMS/WhatsApp hand-off, history. The app prepares the message; it never claims delivery and never claims emergency services were contacted.
- **Contacts**: add/edit/delete, primary contact, multi-select, message templates, test mode (no real alert).
- **Safety Assistant**: offline, rule-based (not generative AI). Understands Egyptian Arabic and English, flags immediate danger, returns curated first steps.
- **8 emergency categories** with steps, precautions, when to call, official numbers.
- **Directory** of verified Egyptian numbers (123, 122, 180, 126, 128, 129, 16000) that open the dialer.
- **Map**: OpenStreetMap + Overpass nearby hospitals/police/fire stations with distance, search, navigation hand-off. Marked "not officially verified".
- **Extras**: operator call script, preparedness checklist, safety education, accessibility (semantics, large touch targets, text scaling), offline content.

## Data and security
Contacts, profile and history are stored with Android Keystore-backed secure storage on the device. No server, no account, no tracking. No secrets in the code.

## Run
```
flutter pub get
flutter test
flutter run
flutter build apk --release
```
CI builds the APK on every `v*` tag (`.github/workflows/build.yml`) and attaches it to the GitHub Release.

## Sources for emergency numbers
- https://kfs.gov.eg/directory
- https://www.giza.gov.eg/Services/Emergency%20services.aspx
- https://cpa.gov.eg/ar-eg/%D8%A3%D8%B1%D9%82%D8%A7%D9%85-%D8%AA%D9%87%D9%85%D9%83

## Known limits
- No device/emulator test of the APK yet. Web build used for visual checks.
- No cloud backend or push notifications in v1.0 (everything is on-device by design so SOS works offline).
- Optional online AI assistant is not included; it would need a free API key behind a proxy, never in the app.
