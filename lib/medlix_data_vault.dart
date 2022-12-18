library medlix_data_vault;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:medlix_data_vault/medlix_data_vault_platform_interface.dart';

part 'options/native_options.dart';
part 'options/options.dart';

class MedlixDataVault {
  final IosOptions iosOptions;
  final AndroidOptions androidOptions;

  MedlixDataVault({
    this.iosOptions = IosOptions.defaultOptions,
    this.androidOptions = AndroidOptions.defaultOptions,
  });

  MedlixDataVaultPlatform get _platform => MedlixDataVaultPlatform.instance;

  Future<String?> getPlatformVersion() {
    return _platform.getPlatformVersion();
  }

  Future<void> write({required String key, required String value}) {
    return _platform.write(
      key: key,
      value: value,
      options: _buildOptions,
    );
  }

  Future<String?> read({required String key}) {
    return _platform.read(
      key: key,
      options: _buildOptions,
    );
  }

  Future<void> delete({required String key}) {
    return _platform.delete(
      key: key,
      options: _buildOptions,
    );
  }

  Map<String, String> get _buildOptions {
    if (Platform.isIOS) {
      return iosOptions.params;
    } else if (Platform.isAndroid) {
      return androidOptions.params;
    } else {
      return {};
    }
  }
}
