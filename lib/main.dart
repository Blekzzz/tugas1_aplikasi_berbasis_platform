import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'repositories/auth_repository.dart';
import 'repositories/item_repository.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/item_viewmodel.dart';
import 'views/home_page.dart';
import 'views/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final authVm = AuthViewModel(AuthRepository());
  final itemVm = ItemViewModel(ItemRepository(prefs));
  await itemVm.load();
  runApp(StokKuApp(authVm: authVm, itemVm: itemVm));
}

class StokKuApp extends StatelessWidget {
  const StokKuApp({super.key, required this.authVm, required this.itemVm});

  final AuthViewModel authVm;
  final ItemViewModel itemVm;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StokKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: ListenableBuilder(
        listenable: authVm,
        builder: (context, _) => authVm.isLoggedIn
            ? HomePage(authViewModel: authVm, itemViewModel: itemVm)
            : LoginPage(authViewModel: authVm),
      ),
    );
  }
}
