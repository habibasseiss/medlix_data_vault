library medlix_data_vault;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:medlix_data_vault/medlix_data_vault_platform_interface.dart';

part 'options/ios_options.dart';
part 'options/options.dart';

class MedlixDataVault {
  final IosOptions iosOptions;

  MedlixDataVault({
    this.iosOptions = IosOptions.defaultOptions,
  });

  Future<String?> getPlatformVersion() {
    return MedlixDataVaultPlatform.instance.getPlatformVersion();
  }

  Future<void> write({required String key, required String value}) {
    return MedlixDataVaultPlatform.instance.write(
      key: key,
      value: value,
      options: _buildOptions,
    );
  }

  Future<String?> read({required String key}) {
    return MedlixDataVaultPlatform.instance.read(
      key: key,
      options: _buildOptions,
    );
  }

  Map<String, String> get _buildOptions {
    if (Platform.isIOS) {
      return iosOptions.params;
    } else if (Platform.isAndroid) {
      return {};
    } else {
      return {};
    }
  }
}
