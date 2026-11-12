import 'package:flutter/material.dart';

import '../models/item.dart';
import '../utils/format.dart';
import '../viewmodels/item_viewmodel.dart';

/// Form tambah (item == null) atau ubah (item != null).
class ItemFormPage extends StatefulWidget {
  const ItemFormPage({super.key, required this.viewModel, this.item});

  final ItemViewModel viewModel;
  final Item? item;

  @override
  State<ItemFormPage> createState() => _ItemFormPageState();
}

class _ItemFormPageState extends State<ItemFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaC;
  late final TextEditingController _jumlahC;
  late final TextEditingController _tanggalC;
  late String _kategori;
  late String _status;
  DateTime? _tanggal;

  bool get _isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _namaC = TextEditingController(text: item?.nama ?? '');
    _jumlahC = TextEditingController(text: item?.jumlah.toString() ?? '');
    _tanggal = item?.tanggalMasuk;
    _tanggalC = TextEditingController(
      text: item == null ? '' : formatTanggal(item.tanggalMasuk),
    );
    _kategori = item?.kategori ?? Item.kategoriList.first;
    _status = item?.status ?? Item.statusList.first;
  }

  @override
  void dispose() {
    _namaC.dispose();
    _jumlahC.dispose();
    _tanggalC.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 1),
    );
    if (picked == null) return;
    setState(() {
      _tanggal = picked;
      _tanggalC.text = formatTanggal(picked);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final item = Item(
      id: widget.item?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      nama: _namaC.text.trim(),
      kategori: _kategori,
      jumlah: int.parse(_jumlahC.text.trim()),
      tanggalMasuk: _tanggal!,
      status: _status,
    );
    if (_isEdit) {
      await widget.viewModel.update(item);
    } else {
      await widget.viewModel.add(item);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEdit ? 'Barang berhasil diubah' : 'Barang berhasil ditambahkan',
        ),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Ubah Barang' : 'Tambah Barang')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _namaC,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(labelText: 'Nama barang'),
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return 'Nama barang wajib diisi';
                    if (v.length < 3) return 'Nama minimal 3 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _kategori,
                  decoration: const InputDecoration(labelText: 'Kategori'),
                  items: Item.kategoriList
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _kategori = v!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _jumlahC,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Jumlah'),
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return 'Jumlah wajib diisi';
                    final n = int.tryParse(v);
                    if (n == null) return 'Jumlah harus berupa angka bulat';
                    if (n < 0) return 'Jumlah tidak boleh negatif';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tanggalC,
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal masuk',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: (_) =>
                      _tanggal == null ? 'Tanggal masuk wajib dipilih' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: Item.statusList
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _status = v!),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _save,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(_isEdit ? 'Simpan Perubahan' : 'Simpan'),
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
