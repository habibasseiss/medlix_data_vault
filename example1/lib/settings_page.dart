import 'package:flutter/material.dart';
import 'package:medlix_data_vault/medlix_data_vault.dart';

class SettingsPage extends StatefulWidget {
  final MedlixDataVault storage;

  const SettingsPage({
    super.key,
    required this.storage,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final keyTextController = TextEditingController();
  final valueTextController = TextEditingController();
  bool isLoading = true;
  Map<String, String> data = {};

  void _removeAllKeys() async {
    setState(() {
      isLoading = true;
    });

    await widget.storage.deleteAll();

    _reloadKeys();
  }

  void _addKey() async {
    // display a dialog to get the key and value
    // await storage.write(key: key, value: value);

    final wasSaved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Key'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: keyTextController,
                decoration: const InputDecoration(
                  labelText: 'Key',
                ),
              ),
              TextField(
                controller: valueTextController,
                decoration: const InputDecoration(
                  labelText: 'Value',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final navigator = Navigator.of(context);

                if (keyTextController.text.isNotEmpty &&
                    valueTextController.text.isNotEmpty) {
                  await widget.storage.write(
                    key: keyTextController.text,
                    value: valueTextController.text,
                  );
                }

                navigator.pop(true);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (wasSaved == true) {
      _reloadKeys();
    }

    keyTextController.clear();
    valueTextController.clear();
  }

  void _reloadKeys() async {
    setState(() {
      isLoading = true;
    });

    await widget.storage.readAll().then((data) {
      setState(() {
        this.data = data;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _reloadKeys();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    keyTextController.dispose();
    valueTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addKey,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                for (var entry in data.entries)
                  ListTile(
                    title: Text(entry.key),
                    subtitle: Text(entry.value),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await widget.storage.delete(key: entry.key);

                        setState(() {
                          isLoading = true;
                        });

                        await widget.storage.readAll().then((data) {
                          setState(() {
                            this.data = data;
                            isLoading = false;
                          });
                        });
                      },
                    ),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'deleteAllKeys',
        onPressed: _removeAllKeys,
        tooltip: 'Delete All Keys',
        label: const Text('Delete All Keys'),
        icon: const Icon(Icons.delete),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
      ),
    );
  }
}
