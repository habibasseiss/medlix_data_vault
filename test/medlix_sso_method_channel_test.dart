import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medlix_sso/medlix_sso_method_channel.dart';

void main() {
  MethodChannelMedlixSso platform = MethodChannelMedlixSso();
  const MethodChannel channel = MethodChannel('medlix_sso');

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
