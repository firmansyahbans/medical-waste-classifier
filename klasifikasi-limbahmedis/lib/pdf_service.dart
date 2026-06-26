import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'wastemodel.dart';

class PdfService {
  // BUAT FILE PDF DAN LANGSUNG BUKA DIALOG PRINT/SAVE/SHARE
  static Future<void> cetakLaporan(List<WasteResult> data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Header
          pw.Text(
            'Laporan Limbah Medis',
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            '${DateFormat('dd MMMM yyyy').format(DateTime.now())} | Firmansyah B.S.',
            style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 12),
          ),
          pw.SizedBox(height: 24),

          // Tabel Riwayat
          pw.TableHelper.fromTextArray(
            headers: ['WAKTU', 'LIMBAH', 'KATEGORI', 'AKURASI'],
            data: data
                .map((r) => [
                      DateFormat('HH:mm').format(r.time),
                      r.name,
                      r.category,
                      '${r.accuracy.toInt()}%',
                    ])
                .toList(),
            headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, fontSize: 11),
            cellStyle: const pw.TextStyle(fontSize: 10),
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          ),
          pw.SizedBox(height: 32),

          // Tabel SOP
          pw.Text(
            'Panduan Penanganan (SOP)',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: ['KATEGORI', 'METODE', 'WARNA'],
            data: const [
              ['Infeksius', 'Incinerator', 'Kuning'],
              ['Farmasi', 'Kimia/Lab', 'Coklat'],
              ['Sitotoksik', 'Incinerator Suhu Tinggi', 'Ungu'],
              ['Domestik', 'Buang ke TPA', 'Hitam'],
            ],
            headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, fontSize: 11),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.amber100),
            cellStyle: const pw.TextStyle(fontSize: 10),
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          ),
        ],
      ),
    );

    // Ini akan munculkan dialog Print/Save/Share PDF (hardcopy lewat printer, atau simpan jadi file)
    await Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
      name: 'laporan-limbah-${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
    );
  }
}
