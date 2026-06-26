import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

import 'sop.dart';
import 'history.dart';
import 'wastemodel.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraReady = false;
  bool _isAiReady = false; 
  bool _isLoading = false;
  bool _flashOn = false;
  File? _previewImage;
  String? _errorMsg;
  Map<dynamic, dynamic>? _hasilScan; 

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _setupKamera();
    _loadTFLiteModel(); 
  }
  
  void _tampilkanError(String pesan) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(pesan), backgroundColor: Colors.red),
      );
    }
  }

  // 1. MEMUAT OTAK AI
  Future<void> _loadTFLiteModel() async {
    try {
      String? res = await Tflite.loadModel(
        model: "assets/model_k3rs.tflite",
        labels: "assets/labels_k3rs.txt",
        isAsset: true,
        numThreads: 1, 
        useGpuDelegate: false, 
      );

      if (res == "success") {
        if (mounted) setState(() => _isAiReady = true);
      } else {
        if (mounted) setState(() => _errorMsg = "AI gagal masuk: Cek folder/pubspec!");
      }
    } catch (e) {
      if (mounted) setState(() => _errorMsg = "AI Error: $e");
    }
  }

  // 2. INISIALISASI KAMERA LIVE PREVIEW
  Future<void> _setupKamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() => _errorMsg = "Kamera tidak ditemukan");
        return;
      }
      final kameraBelakang = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );
      _controller = CameraController(
        kameraBelakang,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _controller!.initialize();
      if (mounted) {
        setState(() => _isCameraReady = true);
      }
    } catch (e) {
      setState(() => _errorMsg = "Gagal mengakses kamera: $e");
    }
  }

  // 3. TOGGLE FLASH ON/OFF
  Future<void> _toggleFlash() async {
    if (_controller == null || !_isCameraReady) return;
    try {
      final modeBaru = _flashOn ? FlashMode.off : FlashMode.torch;
      await _controller!.setFlashMode(modeBaru);
      setState(() => _flashOn = !_flashOn);
    } catch (e) {
      _tampilkanError('Flash tidak didukung di perangkat ini');
    }
  }

  // 4. AMBIL FOTO DARI KAMERA
  Future<void> _ambilFotoDariKamera() async {
    if (_controller == null || !_isCameraReady || _isLoading || !_isAiReady) return;
    try {
      final XFile foto = await _controller!.takePicture();
      final File file = File(foto.path);
      setState(() => _previewImage = file);
      
      await _prosesGambarDenganTFLite(file); 
    } catch (e) {
      _tampilkanError('Gagal mengambil foto: $e');
    }
  }

  // 5. AMBIL FOTO DARI GALERI
  Future<void> _ambilFotoDariGaleri() async {
    if (_isLoading || !_isAiReady) return;
    try {
      final XFile? foto = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080, 
        maxHeight: 1080, 
        imageQuality: 85, 
      );
      
      if (foto != null) {
        final file = File(foto.path);
        setState(() => _previewImage = file);
        await _prosesGambarDenganTFLite(file); 
      }
    } catch (e) {
      _tampilkanError('Gagal mengambil dari galeri: $e');
    }
  }

  // 6. PROSES GAMBAR DENGAN TFLITE (BAGIAN YANG DIPERBAIKI)
  Future<void> _prosesGambarDenganTFLite(File file) async {
    setState(() => _isLoading = true);
    try {
      var recognitions = await Tflite.runModelOnImage(
        path: file.path,
        numResults: 3,
        threshold: 0.1,
        imageMean: 0.0,
        imageStd: 255.0,
      );

      if (recognitions != null && recognitions.isNotEmpty) {
        var bestMatch = recognitions[0];
        
        // Cek fallback jika nama mengandung 'syringe'
        for (var rec in recognitions) {
          if (rec['label'].toString().toLowerCase().contains('syringe')) {
            bestMatch = rec;
            break;
          }
        }

        // PERBAIKAN: Parsing accuracy diubah ke num biar gak crash kalau dapet int
        double confidence = (bestMatch['confidence'] as num).toDouble();
        String labelAwal = bestMatch['label'].toString();
        
        // Membersihkan angka di depan label (misal: "0 infus" -> "infus")
        String namaLabelBersih = labelAwal.replaceAll(RegExp(r'^[0-9]+\s*'), '');

        WasteResult hasil = WasteResult(
          name: namaLabelBersih,
          category: namaLabelBersih == 'bukan_limbahmedis' ? "Non-Medis" : "Infeksius", 
          accuracy: confidence * 100,
          time: DateTime.now(),
          sop: namaLabelBersih == 'bukan_limbahmedis' 
              ? "Buang di tempat sampah domestik/umum." 
              : "Masukkan ke kantong kuning.",
          wadah: namaLabelBersih == 'bukan_limbahmedis' ? "Plastik Hitam" : "Plastik Kuning",
          penanganan: namaLabelBersih == 'bukan_limbahmedis' ? "TPA" : "Incinerator",
        );

        setState(() {
          _hasilScan = bestMatch;
          _isLoading = false;
        });

        if (mounted) _tampilkanHasilDeteksi(context, hasil);
        
      } else {
        setState(() => _isLoading = false);
        _tampilkanError("AI tidak mendeteksi objek apa pun (Akurasi di bawah 10%)");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _tampilkanError("Crash saat membaca AI: $e"); // Biar errornya muncul di layar HP
    }
  }

  // 7. BOTTOM SHEET HASIL DETEKSI
  void _tampilkanHasilDeteksi(BuildContext context, WasteResult hasil) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _previewImage != null
                        ? Image.file(_previewImage!,
                            width: 64, height: 64, fit: BoxFit.cover)
                        : Container(
                            width: 64, height: 64, color: Colors.grey.shade300,
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(hasil.name.toUpperCase(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text("Tingkat Kecocokan: ${hasil.accuracy.toStringAsFixed(1)}%",
                            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                              color: hasil.category == "Non-Medis" ? Colors.green.shade100 : Colors.amber.shade100, 
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                              hasil.category == "Non-Medis" ? "✅ Limbah ${hasil.category}" : "⚠️ Limbah ${hasil.category}",
                              style: TextStyle(
                                  color: hasil.category == "Non-Medis" ? Colors.green : Colors.orange, 
                                  fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.amber.shade50, border: Border.all(color: Colors.amber), borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("SOP Pembuangan K3RS:", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.brown)),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SopScreen())),
                          child: const Text("Lihat Detail →", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF2B4C9B))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(hasil.sop, style: const TextStyle(fontSize: 13, color: Colors.brown, fontWeight: FontWeight.w400)),
                    const SizedBox(height: 8),
                    Text("Wadah: ${hasil.wadah}\nPenanganan: ${hasil.penanganan}",
                        style: const TextStyle(fontSize: 12, color: Colors.brown, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B4C9B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  onPressed: () async {
                    await HistoryService.add(hasil);
                    if (context.mounted) Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text("Selesai & Catat ke Riwayat", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Scan Ulang", style: TextStyle(color: Color(0xFF2B4C9B), fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    Tflite.close(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B4C9B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text("Kembali", style: TextStyle(color: Colors.white, fontSize: 16)),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          // 8. AREA KAMERA LIVE PREVIEW
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300, maxHeight: 400),
                    child: AspectRatio(
                      aspectRatio: (_isCameraReady && _controller?.value.previewSize != null)
                          ? _controller!.value.previewSize!.height / _controller!.value.previewSize!.width
                          : 3 / 4,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          border: Border.all(color: Colors.white54, width: 2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: _buildKontenPreview(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    _isAiReady ? "AI Siap! Arahkan objek ke dalam kotak" : "Menunggu AI...",
                    style: TextStyle(color: _isAiReady ? Colors.greenAccent : Colors.amber, fontSize: 14, fontWeight: FontWeight.bold)
                  ),
                ],
              ),
            ),
          ),

          // 9. AREA KONTROL BAWAH
          Container(
            padding: const EdgeInsets.only(top: 24, bottom: 40),
            decoration: const BoxDecoration(color: Color(0xFF1A2A5E)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: (_isLoading || !_isAiReady) ? null : _ambilFotoDariGaleri,
                  icon: Icon(Icons.photo_library, color: _isAiReady ? Colors.white : Colors.grey, size: 28),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: const Color(0xFF2B4C9B),
                    child: IconButton(
                      onPressed: (_isLoading || !_isCameraReady || !_isAiReady) ? null : _ambilFotoDariKamera,
                      icon: Icon(Icons.camera_alt, color: _isAiReady ? Colors.white : Colors.grey, size: 28),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: (_isLoading || !_isCameraReady) ? null : _toggleFlash,
                  icon: Icon(_flashOn ? Icons.flash_on : Icons.flash_off, color: _flashOn ? Colors.amber : Colors.white, size: 28),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKontenPreview() {
    if (_isLoading) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text("Memproses AI...", style: TextStyle(color: Colors.white70)),
        ],
      );
    }
    if (_previewImage != null) return Image.file(_previewImage!, fit: BoxFit.cover);
    if (_errorMsg != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(_errorMsg!, style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
        ),
      );
    }
    if (_isCameraReady && _controller != null) {
      final previewSize = _controller!.value.previewSize;
      if (previewSize == null) return CameraPreview(_controller!);
      return ClipRect(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: previewSize.height,
            height: previewSize.width,
            child: CameraPreview(_controller!),
          ),
        ),
      );
    }
    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }
}