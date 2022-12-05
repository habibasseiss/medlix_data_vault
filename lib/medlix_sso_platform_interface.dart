import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'medlix_sso_method_channel.dart';

abstract class MedlixSsoPlatform extends PlatformInterface {
  /// Constructs a MedlixSsoPlatform.
  MedlixSsoPlatform() : super(token: _token);

  static final Object _token = Object();

  static MedlixSsoPlatform _instance = MethodChannelMedlixSso();

  /// The default instance of [MedlixSsoPlatform] to use.
  ///
  /// Defaults to [MethodChannelMedlixSso].
  static MedlixSsoPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MedlixSsoPlatform] when
  /// they register themselves.
  static set instance(MedlixSsoPlatform instance) {
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
