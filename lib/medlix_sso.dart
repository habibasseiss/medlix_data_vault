import 'medlix_sso_platform_interface.dart';

class MedlixSso {
  Future<String?> getPlatformVersion() {
    return MedlixSsoPlatform.instance.getPlatformVersion();
  }

  Future<void> write({required String key, required String value}) {
    print("writing");
    return MedlixSsoPlatform.instance.write(
      key: key,
      value: value,
      options: {
        'groupId': 'J3QC37L24N.com.example.SharedItems',
      },
    );
  }

  Future<String?> read({required String key}) {
    print("reading");
    return MedlixSsoPlatform.instance.read(
      key: key,
      options: {
        'groupId': 'J3QC37L24N.com.example.SharedItems',
      },
    );
  }
}
