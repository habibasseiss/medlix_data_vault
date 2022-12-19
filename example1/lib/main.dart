import 'package:flutter/material.dart';
import 'package:medlix_data_vault/medlix_data_vault.dart';

import './secure_key_counter.dart';
import './settings_page.dart';

final storage = MedlixDataVault(
  iosOptions: const IosOptions(
    teamId: 'J3QC37L24N',
    groupId: 'org.medlix.SharedItems',
  ),
  androidOptions: const AndroidOptions(
    packageNames: [
      'org.medlix.example1',
      'org.medlix.example2',
    ],
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedlixDataVault Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SecureKeyCounter(
              storage: storage,
              storageKey: 'secure_key_test_134u1984',
            ),
        '/settings': (context) => SettingsPage(
              storage: storage,
            ),
      },
    );
  }
}
