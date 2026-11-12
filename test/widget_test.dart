import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stokku/main.dart';
import 'package:stokku/repositories/auth_repository.dart';
import 'package:stokku/repositories/item_repository.dart';
import 'package:stokku/viewmodels/auth_viewmodel.dart';
import 'package:stokku/viewmodels/item_viewmodel.dart';

void main() {
  testWidgets('menampilkan halaman login saat aplikasi dibuka', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      StokKuApp(
        authVm: AuthViewModel(AuthRepository()),
        itemVm: ItemViewModel(ItemRepository(prefs)),
      ),
    );

    expect(find.text('Masuk'), findsOneWidget);
  });
}
