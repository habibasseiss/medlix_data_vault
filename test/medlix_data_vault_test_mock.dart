import 'package:flutter/services.dart';
import 'package:medlix_data_vault/medlix_data_vault_platform_interface.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMethodChannel extends Mock implements MethodChannel {}

class MockMedlixDataVaultPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements MedlixDataVaultPlatform {}

class ImplementsMedlixDataVaultPlatform extends Mock
    implements MedlixDataVaultPlatform {}

class ExtendsMedlixDataVaultPlatform extends MedlixDataVaultPlatform {
  // @override
  // Future<bool> containsKey({
  //   required String key,
  //   required Map<String, String> options,
  // }) =>
  //     Future.value(true);

  @override
  Future<void> delete({
    required String key,
    required Map<String, String> options,
  }) =>
      Future<void>.value();

  // @override
  // Future<void> deleteAll({required Map<String, String> options}) =>
  //     Future<void>.value();

  @override
  Future<String?> read({
    required String key,
    required Map<String, String> options,
  }) =>
      Future<String?>.value();

  // @override
  // Future<Map<String, String>> readAll({required Map<String, String> options}) =>
  //     Future.value(<String, String>{});

  @override
  Future<void> write({
    required String key,
    required String value,
    required Map<String, String> options,
  }) =>
      Future<void>.value();
}
