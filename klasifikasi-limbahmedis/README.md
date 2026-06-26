### 1. Kebutuhan UI dan Desain
Menginstal *package* untuk menggunakan font kustom (Inter) tanpa perlu mengunduh file `.ttf` secara manual.
```bash
flutter pub add google_fonts
2. Kebutuhan Logika dan API
Menginstal package untuk menghubungkan aplikasi ke internet (memanggil API Gemini AI).

Bash
flutter pub add http
3. Kebutuhan Database Lokal
Menginstal package untuk menyimpan riwayat hasil scan langsung ke dalam memori perangkat agar data tidak hilang saat aplikasi ditutup.

Bash
flutter pub add shared_preferences
4. Kebutuhan Hardware (Kamera & Galeri)
Menginstal package untuk mengakses kamera bawaan HP, menyalakan flash, dan membuka galeri foto.

Bash
flutter pub add camera image_picker
5. Kebutuhan Cetak Dokumen (PDF)
Menginstal package untuk menggambar tata letak (layout) laporan dan mengekspornya menjadi file PDF atau langsung ke printer.

Bash
flutter pub add pdf printing
(💡 Tips: Kamu juga bisa menginstal seluruh kebutuhan hardware dan PDF sekaligus dengan perintah: flutter pub add camera image_picker pdf printing)

📂 Struktur Folder Utama (lib/)
main.dart : File utama penggerak aplikasi dan pengatur tema (Font Inter).

dashboard.dart : Halaman beranda yang berisi ringkasan harian dan daftar riwayat scan.

scan.dart : Halaman kamera utama dan pop-up hasil deteksi AI.

sop.dart : Halaman daftar lengkap panduan penanganan limbah berdasarkan warna wadah.

pdf.dart : Halaman preview tabel laporan sebelum diunduh/dicetak.

wastemodel.dart : Cetakan data (Model) untuk objek hasil limbah dan kumpulan data SOP.

APIgemini.dart : File service untuk mengirim gambar dan menerima hasil analisis dari Gemini API.

history.dart : File service pengelola database lokal (Simpan, Ambil, Hapus riwayat).

🚀 Cara Menjalankan Aplikasi
Pastikan perangkat Android fisik sudah tersambung dengan USB Debugging aktif (karena fitur kamera tidak bisa berjalan di Web/Browser).

Jalankan perintah berikut di terminal:

Bash
flutter run
--

flutter pub get 
-- install sebelum masuk ke hp srtelah flutter clean


---
untuk nyambung mesin ai
flutter pub add tflite_v2 image_picker

--
flutter pub add tensorflow_lite_flutter

---
untuk install font 
flutter pub add google_fonts

-
running
flutter run -d android

---
flutter run -d ec96e4a8 (hpku redmi note 10 pro max)

--
flutter clean membersihkan memory