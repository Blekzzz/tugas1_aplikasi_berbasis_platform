import 'package:flutter/material.dart';

import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/item_viewmodel.dart';
import 'item_list_page.dart';
import 'profile_page.dart';

/// Menu utama dengan 2 tujuan: Data | Profil.
class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.authViewModel,
    required this.itemViewModel,
  });

  final AuthViewModel authViewModel;
  final ItemViewModel itemViewModel;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          ItemListPage(viewModel: widget.itemViewModel),
          ProfilePage(
            authViewModel: widget.authViewModel,
            itemViewModel: widget.itemViewModel,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Data',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
