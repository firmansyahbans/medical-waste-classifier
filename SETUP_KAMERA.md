# SETUP IZIN KAMERA — WAJIB DIBACA SEBELUM RUN

Package `camera` butuh izin native di Android & iOS. Tanpa ini, app akan crash pas buka kamera.

## Android
Edit `android/app/src/main/AndroidManifest.xml`, tambahkan di dalam tag `<manifest>` (sebelum `<application>`):

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" android:required="false" />
```

Cek juga `android/app/build.gradle`, pastikan:
```
minSdkVersion 21
```
(camera package butuh minimal SDK 21)

## iOS
Edit `ios/Runner/Info.plist`, tambahkan sebelum `</dict>` terakhir:

```xml
<key>NSCameraUsageDescription</key>
<string>Aplikasi butuh akses kamera untuk scan limbah medis</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Aplikasi butuh akses galeri untuk memilih foto limbah</string>
```

## Setelah edit
```bash
flutter clean
flutter pub get
flutter run
```

## Catatan
- Live camera preview (package `camera`) TIDAK jalan di Chrome/web dengan baik untuk semua device — paling stabil di emulator Android atau HP fisik.
- Kalau testing di Chrome dan kamera nggak muncul, itu normal — coba di Android emulator atau HP asli.
