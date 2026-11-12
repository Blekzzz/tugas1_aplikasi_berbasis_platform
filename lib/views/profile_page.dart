import 'package:flutter/material.dart';

import '../repositories/auth_repository.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/item_viewmodel.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.authViewModel,
    required this.itemViewModel,
  });

  final AuthViewModel authViewModel;
  final ItemViewModel itemViewModel;

    Future<void> _confirmLogout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Anda perlu login lagi untuk membuka aplikasi.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (ok == true) {
      authViewModel.logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          const CircleAvatar(
            radius: 40,
            child: Icon(Icons.person, size: 40),
          ),
          const SizedBox(height: 12),
          Text(
            'Nathanza Gaurangga',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Text(
            'NIM 240040060',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.email_outlined),
                  title: Text('Akun'),
                  subtitle: Text(AuthRepository.demoEmail),
                ),
                ListenableBuilder(
                  listenable: itemViewModel,
                  builder: (context, _) => ListTile(
                    leading: const Icon(Icons.inventory_2_outlined),
                    title: const Text('Ringkasan inventaris'),
                    subtitle: Text(
                      '${itemViewModel.totalJenis} jenis barang, '
                      '${itemViewModel.totalStok} unit',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => _confirmLogout(context),
            icon: const Icon(Icons.logout),
            label: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
