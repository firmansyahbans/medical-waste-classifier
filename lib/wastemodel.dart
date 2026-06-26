class WasteResult {
  final String name;
  final String category;
  final double accuracy;
  final String sop;
  final String wadah;
  final String penanganan;
  final DateTime time;

  WasteResult({
    required this.name,
    required this.category,
    required this.accuracy,
    required this.sop,
    required this.wadah,
    required this.penanganan,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'category': category,
        'accuracy': accuracy,
        'sop': sop,
        'wadah': wadah,
        'penanganan': penanganan,
        'time': time.toIso8601String(),
      };

  factory WasteResult.fromJson(Map<String, dynamic> j) => WasteResult(
        name: j['name'],
        category: j['category'],
        accuracy: (j['accuracy'] as num).toDouble(),
        sop: j['sop'],
        wadah: j['wadah'],
        penanganan: j['penanganan'],
        time: DateTime.parse(j['time']),
      );
}

// SOP data per kategori
class SopData {
  static const Map<String, Map<String, String>> data = {
    'Infeksius': {
      'wadah': 'Plastik Kuning',
      'penanganan': 'Sterilisasi/Incinerator',
      'warna': 'Kuning',
    },
    'Farmasi': {
      'wadah': 'Plastik Coklat',
      'penanganan': 'Pemisahan kimia/laboratorium',
      'warna': 'Coklat',
    },
    'Sitotoksik': {
      'wadah': 'Plastik Ungu (Anti-bocor)',
      'penanganan': 'Incinerator suhu tinggi',
      'warna': 'Ungu',
    },
    'Domestik': {
      'wadah': 'Plastik Hitam',
      'penanganan': 'Buang ke TPA umum',
      'warna': 'Hitam',
    },
  };
}