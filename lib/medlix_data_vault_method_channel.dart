import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'medlix_data_vault_platform_interface.dart';

/// An implementation of [MedlixDataVaultPlatform] that uses method channels.
class MethodChannelMedlixDataVault extends MedlixDataVaultPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('nl.erasmusmc.medlix/data_vault');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

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
    return await methodChannel.invokeMethod<String?>(
      'read',
      {
        'key': key,
        'options': options,
      },
    );
  }
}