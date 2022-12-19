import 'package:flutter/material.dart';
import 'package:medlix_data_vault/medlix_data_vault.dart';

class SettingsPage extends StatelessWidget {
  final MedlixDataVault storage;

  const SettingsPage({
    super.key,
    required this.storage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: FutureBuilder(
          future: storage.readAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.data.toString()),
                  ],
                ),
              );
            }
            return const SizedBox();
          }),
    );
  }
}
