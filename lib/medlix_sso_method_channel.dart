import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'medlix_sso_platform_interface.dart';

/// An implementation of [MedlixSsoPlatform] that uses method channels.
class MethodChannelMedlixSso extends MedlixSsoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('nl.erasmusmc.medlix/sso');

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
