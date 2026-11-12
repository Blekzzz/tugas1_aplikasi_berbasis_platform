import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/item.dart';

/// Satu-satunya kelas yang berbicara dengan SharedPreferences.
/// Seluruh daftar barang disimpan sebagai satu string JSON.
class ItemRepository {
  ItemRepository(this._prefs);

  final SharedPreferences _prefs;
  static const String _key = 'items_json';

  /// READ
  Future<List<Item>> getAll() async {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Item.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveAll(List<Item> items) async {
    final raw = jsonEncode(items.map((e) => e.toJson()).toList());
    await _prefs.setString(_key, raw);
  }

  /// CREATE
  Future<void> add(Item item) async {
    final items = await getAll();
    items.add(item);
    await _saveAll(items);
  }

  /// UPDATE
  Future<void> update(Item item) async {
    final items = await getAll();
    final index = items.indexWhere((e) => e.id == item.id);
    if (index == -1) return;
    items[index] = item;
    await _saveAll(items);
  }

  /// DELETE
  Future<void> delete(String id) async {
    final items = await getAll();
    items.removeWhere((e) => e.id == id);
    await _saveAll(items);
  }
}
