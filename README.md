# medlix_sso

A new Flutter plugin project.

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

In addition to configuring the native iOS app, it's necessary to instantiate the
plugin in Dart code using the `IosOptions` class. The following code shows how
to instantiate the plugin:

```dart
final sso = MedlixSso(
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
