import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'wastemodel.dart';
import 'pdf_service.dart';

class PdfScreen extends StatelessWidget {
  final List<WasteResult> data;
  const PdfScreen({super.key, required this.data});

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
        title: const Text("Kembali",
            style: TextStyle(color: Colors.black, fontSize: 16)),
        titleSpacing: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  minimumSize: const Size(80, 32),
                ),
                onPressed: () async {
                  // Membuka dialog Print/Save/Share PDF asli
                  await PdfService.cetakLaporan(data);
                },
                child: const Text("Unduh",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Laporan Limbah Medis",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(
              "${DateFormat('dd MMMM yyyy').format(DateTime.now())} | Firmansyah B.S.",
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 32),

            // Tabel Riwayat — DATA ASLI dari parameter `data`
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1.5),
                1: FlexColumnWidth(2.5),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(1.5),
              },
              children: [
                const TableRow(
                  children: [
                    Text("WAKTU", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    Text("LIMBAH", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    Text("KATEGORI", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    Text("AKURASI", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                  ],
                ),
                ...data.map((r) => TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(DateFormat('HH:mm').format(r.time),
                              style: const TextStyle(fontSize: 12, color: Colors.black87)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(r.name,
                              style: const TextStyle(fontSize: 12, color: Colors.black87)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(r.category,
                              style: const TextStyle(fontSize: 12, color: Colors.black87)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text("${r.accuracy.toInt()}%",
                              style: const TextStyle(fontSize: 12, color: Colors.black87)),
                        ),
                      ],
                    )),
              ],
            ),
            const SizedBox(height: 48),

            // Tabel SOP Bawah
            const Text("Panduan Penanganan (SOP)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8)),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(3),
                  2: FlexColumnWidth(2),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8))),
                    children: const [
                      Padding(padding: EdgeInsets.all(12), child: Text("KATEGORI", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                      Padding(padding: EdgeInsets.all(12), child: Text("METODE", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                      Padding(padding: EdgeInsets.all(12), child: Text("WARNA", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                    ],
                  ),
                  const TableRow(
                    children: [
                      Padding(padding: EdgeInsets.all(12), child: Text("Infeksius", style: TextStyle(fontSize: 12))),
                      Padding(padding: EdgeInsets.all(12), child: Text("Incinerator", style: TextStyle(fontSize: 12))),
                      Padding(padding: EdgeInsets.all(12), child: Text("Kuning", style: TextStyle(fontSize: 12))),
                    ],
                  ),
                  const TableRow(
                    children: [
                      Padding(padding: EdgeInsets.all(12), child: Text("Farmasi", style: TextStyle(fontSize: 12))),
                      Padding(padding: EdgeInsets.all(12), child: Text("Kimia/Lab", style: TextStyle(fontSize: 12))),
                      Padding(padding: EdgeInsets.all(12), child: Text("Coklat", style: TextStyle(fontSize: 12))),
                    ],
                  ),
                  const TableRow(
                    children: [
                      Padding(padding: EdgeInsets.all(12), child: Text("Sitotoksik", style: TextStyle(fontSize: 12))),
                      Padding(padding: EdgeInsets.all(12), child: Text("Incinerator Suhu Tinggi", style: TextStyle(fontSize: 12))),
                      Padding(padding: EdgeInsets.all(12), child: Text("Ungu", style: TextStyle(fontSize: 12))),
                    ],
                  ),
                  const TableRow(
                    children: [
                      Padding(padding: EdgeInsets.all(12), child: Text("Domestik", style: TextStyle(fontSize: 12))),
                      Padding(padding: EdgeInsets.all(12), child: Text("Buang ke TPA", style: TextStyle(fontSize: 12))),
                      Padding(padding: EdgeInsets.all(12), child: Text("Hitam", style: TextStyle(fontSize: 12))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
