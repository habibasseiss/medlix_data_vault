import 'package:flutter/material.dart';
import 'package:medlix_data_vault/medlix_data_vault.dart';

class SecureKeyCounter extends StatefulWidget {
  const SecureKeyCounter({
    super.key,
    required this.storage,
    required this.storageKey,
  });

  final MedlixDataVault storage;
  final String storageKey;

  @override
  State<SecureKeyCounter> createState() => _SecureKeyCounterState();
}

class _SecureKeyCounterState extends State<SecureKeyCounter>
    with WidgetsBindingObserver {
  String? _counter;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _startCounter();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _startCounter();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _startCounter() async {
    var value = await widget.storage.read(key: widget.storageKey);

    if (value == null) {
      value = '0';
      await widget.storage.write(key: widget.storageKey, value: value);
    }

    debugPrint(await widget.storage.read(key: widget.storageKey));

    setState(() {
      _counter = value;
    });
  }

  void _incrementCounter() async {
    var value = await widget.storage.read(key: widget.storageKey);
    value ??= '0';
    value = (int.parse(value) + 1).toString();
    await widget.storage.write(key: widget.storageKey, value: value);
    debugPrint(await widget.storage.read(key: widget.storageKey));

    value = await widget.storage.read(key: widget.storageKey);

    setState(() {
      _counter = value;
    });
  }

  void _deleteKey() async {
    await widget.storage.delete(key: widget.storageKey);

    debugPrint('key $widget.storageKey deleted');

    setState(() {
      _counter = '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Key Counter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed('/settings');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Key: '),
                  TextSpan(
                    text: widget.storageKey,
                    style: const TextStyle(
                        fontFamily: 'Courier',
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'The following value is stored in the "data vault" and shared among apps in the same group:',
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              _counter ?? '0',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'incrementCounter',
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            icon: const Icon(Icons.add),
            label: const Text('Increment'),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'deleteKey',
            onPressed: _deleteKey,
            tooltip: 'Delete Key',
            label: const Text('Delete Key'),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
