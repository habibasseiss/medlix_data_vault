import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'medlix_data_vault_method_channel.dart';

abstract class MedlixDataVaultPlatform extends PlatformInterface {
  /// Constructs a MedlixDataVaultPlatform.
  MedlixDataVaultPlatform() : super(token: _token);

  static final Object _token = Object();

  static MedlixDataVaultPlatform _instance = MethodChannelMedlixDataVault();

  /// The default instance of [MedlixDataVaultPlatform] to use.
  ///
  /// Defaults to [MethodChannelMedlixDataVault].
  static MedlixDataVaultPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MedlixDataVaultPlatform] when
  /// they register themselves.
  static set instance(MedlixDataVaultPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> write({
    required String key,
    required String value,
    required Map<String, String> options,
  }) {
    throw UnimplementedError('write() has not been implemented.');
  }

  Future<String?> read({
    required String key,
    required Map<String, String> options,
  }) {
    throw UnimplementedError('read() has not been implemented.');
  }
}
