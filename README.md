## Powered Medical Waste Classification (K3RS)
An Offline-First Mobile Solution for Smart Healthcare Waste Management.

##  Background & Problem
Pengelolaan limbah medis (K3RS) adalah prosedur krusial, tapi dalam praktiknya sering menjadi beban tambahan bagi tenaga kesehatan. Dengan alur kerja yang padat, keharusan untuk selalu mengingat detail SOP klasifikasi pembuangan cukup rentan memicu *human error*. Padahal, kesalahan pemilahan bisa berakibat fatal bagi keselamatan pekerja dan lingkungan. Di sisi lain, mengandalkan pemrosesan AI berbasis *cloud* (server internet) untuk aplikasi semacam ini bukanlah solusi ideal. Tenaga kesehatan membutuhkan sistem yang sangat responsif di lapangan, sementara pengiriman visual ke server sering kali terkendala *latency* (delay/loading). Selain itu, rumah sakit umumnya memiliki protokol privasi data yang ketat dan perlu menekan biaya pemeliharaan infrastruktur IT. Oleh karena itu, aplikasi ini dibangun dengan pendekatan **100% offline (on-device processing)**. Model AI memproses klasifikasi langsung di dalam *smartphone* pengguna. Hasilnya bisa didapatkan secara instan, keamanan operasional rumah sakit lebih terjamin, dan efisiensi biaya server bisa dicapai secara maksimal.

##  The Solution
Aplikasi klasifikasi limbah medis berbasis AI yang bekerja secara 100% offline (on-device processing). Dirancang dengan prinsip **Zero-Friction UI** untuk mempermudah nakes dalam memilah sampah secara presisi tanpa hambatan administrasi manual.

## Tech Stack
- **Deep Learning:** MobileNetV2 (TensorFlow/Keras)
- **Mobile Development:** Flutter
- **Deployment:** TensorFlow Lite (.tflite) for edge computing
- **Design:** Figma (Interactive Prototyping)

## AI Methodology
- **Dataset:** 37 Kelas limbah medis & non-medis spesifik
- **Source:** Hybrid (Kaggle Repositories & Scraped Google Images)
- **Validation:** 80:20 Training & Testing Split
- **Pre-processing:** Data Augmentation (Rotation, Zoom, Flip) untuk ketangguhan model

## Application Workflow
1. **Interactive Dashboard:** Ringkasan data harian & akses cepat pemindaian.
2. **Real-time Scanning:** Input visual tanpa konfigurasi manual (Frictionless).
3. **On-Device Inference:** Ekstraksi fitur menggunakan MobileNetV2 secara offline.
4. **Actionable Output:** Instruksi warna wadah pembuangan sesuai SOP K3RS.
5. **Auto-Reporting:** Ekspor riwayat klasifikasi ke format PDF.

## Preview

**Skenario 1: Deteksi Objek Non-Medis**
<img width="1920" height="1080" alt="PITCH DECK - K3RS" src="https://github.com/user-attachments/assets/8c2738e9-e599-41ea-8190-9654dea4b44c" />

**Skenario 2: Deteksi Objek Limbah Medis**
<img width="1920" height="1080" alt="PITCH DECK - K3RS-MEDIS" src="https://github.com/user-attachments/assets/dd34e649-5472-4731-b6fb-36842f836fa5" />

