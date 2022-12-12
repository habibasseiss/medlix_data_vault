import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medlix_data_vault/medlix_data_vault_method_channel.dart';

void main() {
  MethodChannelMedlixDataVault platform = MethodChannelMedlixDataVault();
  const MethodChannel channel = MethodChannel('medlix_data_vault');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
