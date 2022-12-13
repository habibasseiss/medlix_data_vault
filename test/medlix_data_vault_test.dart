import 'package:flutter_test/flutter_test.dart';
import 'package:medlix_data_vault/medlix_data_vault.dart';
import 'package:medlix_data_vault/medlix_data_vault_method_channel.dart';
import 'package:medlix_data_vault/medlix_data_vault_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMedlixDataVaultPlatform
    with MockPlatformInterfaceMixin
    implements MedlixDataVaultPlatform {
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

  @override
  Future<void> delete({
    required String key,
    required Map<String, String> options,
  }) async {
    return Future.value();
  }
}

void main() {
  final MedlixDataVaultPlatform initialPlatform =
      MedlixDataVaultPlatform.instance;

  test('$MethodChannelMedlixDataVault is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMedlixDataVault>());
  });

  test('getPlatformVersion', () async {
    MedlixDataVault medlixDataVaultPlugin = MedlixDataVault();
    MockMedlixDataVaultPlatform fakePlatform = MockMedlixDataVaultPlatform();
    MedlixDataVaultPlatform.instance = fakePlatform;

    expect(await medlixDataVaultPlugin.getPlatformVersion(), '42');
  });
}
