import 'package:flutter/material.dart';

import '../models/item.dart';
import '../utils/format.dart';
import '../viewmodels/item_viewmodel.dart';
import 'item_form_page.dart';

class ItemListPage extends StatelessWidget {
  const ItemListPage({super.key, required this.viewModel});

  final ItemViewModel viewModel;

  Future<void> _openForm(BuildContext context, {Item? item}) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ItemFormPage(viewModel: viewModel, item: item),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Item item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus barang?'),
        content: Text('"${item.nama}" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await viewModel.delete(item.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Barang berhasil dihapus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Inventaris')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          final items = viewModel.items;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  onChanged: viewModel.setQuery,
                  decoration: const InputDecoration(
                    hintText: 'Cari nama atau kategori',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        label: 'Jenis barang',
                        value: '${viewModel.totalJenis}',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryCard(
                        label: 'Total stok',
                        value: '${viewModel.totalStok}',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: items.isEmpty
                    ? const Center(
                        child: Text('Belum ada data. Tekan "Tambah".'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 88),
                        itemCount: items.length,
                        itemBuilder: (context, i) {
                          final item = items[i];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: ListTile(
                              title: Text(item.nama),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item.kategori} • ${item.jumlah} unit',
                                    ),
                                    Text(
                                      'Masuk: ${formatTanggal(item.tanggalMasuk)}',
                                    ),
                                    const SizedBox(height: 4),
                                    _StatusChip(status: item.status),
                                  ],
                                ),
                              ),
                              isThreeLine: true,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Ubah',
                                    icon: const Icon(Icons.edit_outlined),
                                    onPressed: () =>
                                        _openForm(context, item: item),
                                  ),
                                  IconButton(
                                    tooltip: 'Hapus',
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () =>
                                        _confirmDelete(context, item),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  Color get _color {
    switch (status) {
      case 'Tersedia':
        return Colors.green;
      case 'Dipinjam':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: _color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
