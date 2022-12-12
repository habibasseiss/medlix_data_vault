import 'package:flutter/material.dart';
import 'package:medlix_data_vault/medlix_data_vault.dart';

const key = 'secure_key_test_134u1984';

final storage = MedlixDataVault(
  iosOptions: const IosOptions(
    teamId: 'J3QC37L24N',
    groupId: 'org.medlix.SharedItems',
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
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
    var value = await storage.read(key: key);

    if (value == null) {
      value = '0';
      await storage.write(key: key, value: value);
    }

    debugPrint(await storage.read(key: key));

    setState(() {
      _counter = value;
    });
  }

  void _incrementCounter() async {
    var value = await storage.read(key: key);
    value ??= '0';
    value = (int.parse(value) + 1).toString();
    await storage.write(key: key, value: value);
    debugPrint(await storage.read(key: key));

    value = await storage.read(key: key);

    setState(() {
      _counter = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              _counter ?? '0',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
