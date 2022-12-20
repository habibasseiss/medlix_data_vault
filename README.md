# MedlixDataVault

This Flutter plugin allows developers to create apps that can securely share
data with other apps that are part of the same group or organization. The plugin
provides a secure way to store and retrieve data using the organization's
identifier, ensuring that only authorized apps can access the shared data. This
is useful for creating apps that need to share sensitive information, such as
API authentication tokens, within a specific group or organization.

## How it works

This plugin uses the [Keychain Sharing](https://developer.apple.com/documentation/security/keychain_services/keychain_items/sharing_access_to_keychain_items_among_a_collection_of_apps)
capability on iOS to share data between apps.

## Configuration

### iOS

On iOS, it's necessary to add a capability to the app's entitlements in Xcode.
To do this, open the Runner project in Xcode, select the Runner target, and then
select the "Signing & Capabilities" tab. Click the + button to add a new
capability, and then select the "Keychain Sharing" capability. Add the keychain
group that you want to use for the plugin, for example `org.medlix.SharedItems`.

The `Runner.entitlements` file should have the following entry:

```xml
<key>keychain-access-groups</key>
<array>
    <string>$(AppIdentifierPrefix)org.medlix.SharedItems</string>
</array>
```

It's important that the `ios/Runner.xcodeproj/project.pbxproj` file contains the
following line for each `buildSettings` entry:

```
CODE_SIGN_ENTITLEMENTS = Runner/Runner.entitlements;
```

### Android

On Android, the plugin uses the [`EncryptedSharedPreferences`](https://developer.android.com/reference/androidx/security/crypto/EncryptedSharedPreferences) class to securely
store data, which requires the minimum API level to be 23 (Android 6.0).
Therefore, the `minSdkVersion` in the `android/app/build.gradle` file must be
set to 23 or higher.

The plugin works by allowing each native Android app that uses it to define a
[`ContentProvider`](https://developer.android.com/guide/topics/providers/content-providers)
that can be used to share data stored via `EncryptedSharedPreferences`. The
plugin also implements a [`ContentResolver`](https://developer.android.com/reference/android/content/ContentResolver)
that can be used to access the shared data. Therefore, the plugin is both a
provider and a client of the shared data.

The overall process for sharing data between apps is as follows: when a key is
supposed to be stored, the plugin asks for all apps that are part of the same
group to store the key. The same happens for read and delete operations. In the
read operation, the plugin returns the first key found in the group.

For the plugin to work on Android, it's necessary to configure the native apps
in its `AndroidManifest.xml` file in a specific way. The following code must be
added to the `AndroidManifest.xml` file of each app that uses the plugin (e.g.,
`example1` and `example2` apps):

```xml
<queries>
    <provider
        android:authorities="org.medlix.example1.medlix_data_vault.provider"
        android:exported="false" />
    <provider
        android:authorities="org.medlix.example2.medlix_data_vault.provider"
        android:exported="false" />
</queries>
```

In this example, the `example1` and `example2` have the package names
`org.medlix.example1` and `org.medlix.example2`, respectively. The `queries`
element indicates that the current app can make queries to the providers defined
in the `provider` elements. The `android:authorities` attribute defines the
unique identifier for the provider in the plugin. It is required that the
`android:authorities` attribute has the format
`<package_name>.medlix_data_vault.provider` (i.e., the package name of the app
concatenated with `.medlix_data_vault.provider`). TODO: this could be improved
in the future.


### Flutter

Make sure that the `WidgetsFlutterBinding.ensureInitialized();` line is called
in the `main()` function before using the plugin. This is necessary to ensure
that the plugin is initialized correctly.

For the plugin to work on ioS, in addition to configuring the native app, it's
necessary to instantiate the plugin in Dart code using the `IosOptions` class.
The following code shows how to instantiate the plugin:

```dart
final sso = MedlixDataVault(
  iosOptions: const IosOptions(
    teamId: 'J3QC37L24N',              // Your Apple Developer Team ID
    groupId: 'org.medlix.SharedItems', // The keychain group ID
  ),
);
```

#### Examples

Three example apps are provided. The `example1` and `example2` apps use the
`org.medlix.SharedItems` keychain group, defined in the `Runner.entitlements`
file. The `example3` app uses no keychain group, to simulate a situation where
the app is not configured correctly. So, `example1` and `example2` apps can
share data with each other, but not with `example3`.
