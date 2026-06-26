import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'scan.dart';
import 'pdf.dart';
import 'history.dart';
import 'wastemodel.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<WasteResult> _riwayat = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _muatRiwayat();
  }

  // AMBIL DATA ASLI DARI HISTORY SERVICE
  Future<void> _muatRiwayat() async {
    final data = await HistoryService.getAll();
    if (mounted) {
      setState(() {
        _riwayat = data;
        _loading = false;
      });
    }
  }

  // HITUNG BERAPA SCAN HARI INI
  int get _jumlahHariIni {
    final now = DateTime.now();
    return _riwayat
        .where((r) =>
            r.time.year == now.year &&
            r.time.month == now.month &&
            r.time.day == now.day)
        .length;
  }

  Color _warnaKategori(String kategori) {
    switch (kategori) {
      case 'Infeksius':
        return Colors.amber;
      case 'Farmasi':
        return Colors.brown;
      case 'Sitotoksik':
        return Colors.purple;
      case 'Domestik':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _muatRiwayat,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- HEADER (UDAH DITAMBAH LOGO K3RS DI KANAN) ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Bagian Kiri (Foto Profil & Sapaan)
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.grey.shade300,
                                child: const Icon(Icons.person, color: Colors.grey),
                              ),
                              const SizedBox(width: 12),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Halo, Petugas",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    "Petugas K3RS - Shift Malam",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          
                          // Bagian Kanan (Logo K3RS)
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Image.asset(
                                  'assets/logo_k3rs.png', // Pastiin nama file sama
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // --- END HEADER ---

                      const SizedBox(height: 24),

                      // Ringkasan pembuangan hari ini
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B4C9B),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Ringkasan Pembuangan Hari ini",
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "$_jumlahHariIni",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Objek limbah berhasil dipindai",
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Riwayat Terakhir
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Riwayat Terakhir",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            onPressed: _riwayat.isEmpty
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PdfScreen(data: _riwayat)),
                                    );
                                  },
                            child: const Text(
                              "Cetak PDF",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // List riwayat 
                      if (_riwayat.isEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          alignment: Alignment.center,
                          child: const Text(
                            "Belum ada riwayat scan",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      else
                        ..._riwayat.take(10).map((r) => Dismissible(
                              // Key wajib ada biar sistem tau item mana yang digeser
                              key: ValueKey(r.time.toString()), 
                              // Cuma bisa digeser dari kanan ke kiri
                              direction: DismissDirection.endToStart,
                              // Background merah pas digeser
                              background: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade400,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.centerRight,
                                child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
                              ),
                              // Aksi pas itemnya selesai digeser
                              onDismissed: (direction) async {
                                // 1. Hapus dari database memori
                                await HistoryService.deleteItem(r);
                                // 2. Tampilkan notifikasi kecil di bawah
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("${r.name} berhasil dihapus"),
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                                // 3. Refresh layar biar itemnya hilang
                                _muatRiwayat();
                              },
                              // Ini desain UI item lu yang lama, cuma ditambah warna putih doang
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white, // Wajib dikasih warna biar background merahnya nggak nembus
                                  border: Border.all(color: Colors.grey.shade200),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                        radius: 8,
                                        backgroundColor:
                                            _warnaKategori(r.category)),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            r.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            "Limbah ${r.category}",
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      DateFormat('HH:mm').format(r.time),
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),

                      // TOMBOL BAWAH MASUK KAMERA
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2B4C9B),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28)),
                          ),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ScanScreen()),
                            );
                            _muatRiwayat(); // refresh setelah balik dari scan
                          },
                          child: const Text(
                            "SCAN LIMBAH SEKARANG",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}