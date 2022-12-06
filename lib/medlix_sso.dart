import 'medlix_sso_platform_interface.dart';

class MedlixSso {
  final String? iosTeamId;
  final String? iosGroupId;

  MedlixSso({
    this.iosTeamId,
    this.iosGroupId,
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
    final options = <String, String>{};
    if (prefixedGroupId != null) {
      options['groupId'] = prefixedGroupId!;
    }
    return options;
  }

  String? get prefixedGroupId {
    // concatenate the teamId and groupId
    if (iosTeamId != null && iosGroupId != null) {
      return '$iosTeamId.$iosGroupId';
    }
    return null;
  }
}
