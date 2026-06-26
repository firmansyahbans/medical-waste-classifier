import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'wastemodel.dart';

class HistoryService {
  static const String _key = 'waste_history';

  // MENGAMBIL SEMUA DATA RIWAYAT
  static Future<List<WasteResult>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    
    // Ubah string JSON kembali menjadi objek WasteResult
    return raw.map((e) => WasteResult.fromJson(jsonDecode(e))).toList()
      ..sort((a, b) => b.time.compareTo(a.time)); // Urutkan dari yang paling baru
  }

  // MENAMBAH RIWAYAT BARU (DARI HASIL SCAN)
  static Future<void> add(WasteResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    
    // Ubah objek menjadi JSON lalu simpan di urutan paling atas (index 0)
    raw.insert(0, jsonEncode(result.toJson()));
    await prefs.setStringList(_key, raw);
  }

  // MENGHAPUS SEMUA RIWAYAT (Opsional untuk fitur reset)
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  // ---> INI FITUR BARU: MENGHAPUS SATU ITEM SPESIFIK <---
  static Future<void> deleteItem(WasteResult itemToDelete) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];

    // Hapus data yang waktunya sama persis dengan yang digeser user
    raw.removeWhere((e) {
      final decoded = WasteResult.fromJson(jsonDecode(e));
      return decoded.time.isAtSameMomentAs(itemToDelete.time);
    });

    await prefs.setStringList(_key, raw);
  }
}