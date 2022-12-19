import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'medlix_data_vault_platform_interface.dart';

/// An implementation of [MedlixDataVaultPlatform] that uses method channels.
class MethodChannelMedlixDataVault extends MedlixDataVaultPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('org.medlix.plugins/data_vault');

  @override
  Future<void> write({
    required String key,
    required String value,
    required Map<String, String> options,
  }) async {
    await methodChannel.invokeMethod<void>('write', {
      'key': key,
      'value': value,
      'options': options,
    });
  }

  @override
  Future<String?> read({
    required String key,
    required Map<String, String> options,
  }) async {
    return await methodChannel.invokeMethod<String?>('read', {
      'key': key,
      'options': options,
    });
  }

  @override
  Future<void> delete({
    required String key,
    required Map<String, String> options,
  }) async {
    await methodChannel.invokeMethod<void>('delete', {
      'key': key,
      'options': options,
    });
  }

  @override
  Future<Map<String, String>> readAll({
    required Map<String, String> options,
  }) async {
    final results = await methodChannel.invokeMethod<Map>(
      'readAll',
      {
        'options': options,
      },
    );

    return results?.cast<String, String>() ?? <String, String>{};
  }
}
