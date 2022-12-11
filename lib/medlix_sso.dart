library medlix_sso;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:medlix_sso/medlix_sso_platform_interface.dart';

part 'options/ios_options.dart';
part 'options/options.dart';

class MedlixSso {
  final IosOptions iosOptions;

  MedlixSso({
    this.iosOptions = IosOptions.defaultOptions,
  });

  Future<String?> getPlatformVersion() {
    return MedlixSsoPlatform.instance.getPlatformVersion();
  }

  Future<void> write({required String key, required String value}) {
    return MedlixSsoPlatform.instance.write(
      key: key,
      value: value,
      options: _buildOptions,
    );
  }

  Future<String?> read({required String key}) {
    return MedlixSsoPlatform.instance.read(
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
