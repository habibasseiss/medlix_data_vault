import 'package:flutter_test/flutter_test.dart';
import 'package:medlix_sso/medlix_sso.dart';
import 'package:medlix_sso/medlix_sso_method_channel.dart';
import 'package:medlix_sso/medlix_sso_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMedlixSsoPlatform
    with MockPlatformInterfaceMixin
    implements MedlixSsoPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> write({
    required String key,
    required String value,
    required Map<String, String> options,
  }) async {
    return Future.value();
  }

  @override
  Future<String?> read({
    required String key,
    required Map<String, String> options,
  }) async {
    return Future.value();
  }
}

void main() {
  final MedlixSsoPlatform initialPlatform = MedlixSsoPlatform.instance;

  test('$MethodChannelMedlixSso is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMedlixSso>());
  });

  test('getPlatformVersion', () async {
    MedlixSso medlixSsoPlugin = MedlixSso();
    MockMedlixSsoPlatform fakePlatform = MockMedlixSsoPlatform();
    MedlixSsoPlatform.instance = fakePlatform;

    expect(await medlixSsoPlugin.getPlatformVersion(), '42');
  });
}
