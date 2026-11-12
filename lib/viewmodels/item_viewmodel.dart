import 'package:flutter/foundation.dart';

import '../models/item.dart';
import '../repositories/item_repository.dart';

class ItemViewModel extends ChangeNotifier {
  ItemViewModel(this._repo);

  final ItemRepository _repo;
  List<Item> _items = [];
  String _query = '';

  /// Daftar barang yang sudah difilter pencarian & diurutkan berdasarkan nama.
  List<Item> get items {
    final q = _query.toLowerCase();
    final result = _items
        .where((e) =>
            e.nama.toLowerCase().contains(q) ||
            e.kategori.toLowerCase().contains(q))
        .toList()
      ..sort((a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()));
    return result;
  }

  int get totalJenis => _items.length;
  int get totalStok => _items.fold(0, (sum, e) => sum + e.jumlah);

  Future<void> load() async {
    _items = await _repo.getAll();
    notifyListeners();
  }

  Future<void> add(Item item) async {
    await _repo.add(item);
    await load();
  }

  Future<void> update(Item item) async {
    await _repo.update(item);
    await load();
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    await load();
  }

  void setQuery(String value) {
    _query = value.trim();
    notifyListeners();
  }
}
