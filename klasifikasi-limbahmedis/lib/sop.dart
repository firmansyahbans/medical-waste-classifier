import 'package:flutter/material.dart';

class SopScreen extends StatelessWidget {
  const SopScreen({super.key});

  // Widget khusus biar kita nggak ngetik ulang kode desain kartunya
  Widget _buildSopItem({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String wadah,
    required String penanganan,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Pil" Judul Kategori
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: iconColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: iconColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Teks Instruksi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("• Wadah: $wadah", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                const SizedBox(height: 4),
                Text("• Penanganan: $penanganan", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Panduan SOP",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              const Text(
                "Prosedur penanganan limbah medis",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 32),
              
              // List SOP (Infeksius, Farmasi, Sitotoksik, Domestik)
              Expanded(
                child: ListView(
                  children: [
                    _buildSopItem(
                      title: "Infeksius",
                      icon: Icons.warning_amber_rounded,
                      iconColor: Colors.orange.shade700,
                      bgColor: Colors.amber.shade100,
                      wadah: "Plastik Kuning",
                      penanganan: "Sterilisasi/Incinerator",
                    ),
                    _buildSopItem(
                      title: "Farmasi",
                      icon: Icons.medication,
                      iconColor: Colors.brown.shade700,
                      bgColor: Colors.brown.shade100,
                      wadah: "Plastik Coklat",
                      penanganan: "Pemisahan kimia/laboratorium",
                    ),
                    _buildSopItem(
                      title: "Sitotoksik",
                      icon: Icons.science,
                      iconColor: Colors.purple.shade700,
                      bgColor: Colors.purple.shade100,
                      wadah: "Plastik Ungu (Anti-bocor)",
                      penanganan: "Incinerator suhu tinggi",
                    ),
                    _buildSopItem(
                      title: "Domestik",
                      icon: Icons.check_circle,
                      iconColor: Colors.green.shade700,
                      bgColor: Colors.green.shade100,
                      wadah: "Plastik Hitam",
                      penanganan: "Buang ke TPA umum",
                    ),
                  ],
                ),
              ),

              // Tombol Bawah
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0, top: 12.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2B4C9B),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                    onPressed: () => Navigator.pop(context), // Kembali ke Dashboard
                    child: const Text(
                      "Kembali ke Dashboard",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}