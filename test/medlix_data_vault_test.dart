import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medlix_data_vault/medlix_data_vault_method_channel.dart';
import 'package:medlix_data_vault/medlix_data_vault_platform_interface.dart';

import 'medlix_data_vault_test_mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('medlix_data_vault_platform', () {
    test('$MethodChannelMedlixDataVault() is the default instance', () {
      expect(
        MedlixDataVaultPlatform.instance,
        isInstanceOf<MethodChannelMedlixDataVault>(),
      );
    });

    test('Cannot be implemented with `implements`', () {
      expect(
        () {
          MedlixDataVaultPlatform.instance =
              ImplementsMedlixDataVaultPlatform();
        },
        throwsA(isInstanceOf<AssertionError>()),
      );
    });

    test('Can be mocked with `implements`', () {
      final mock = MockMedlixDataVaultPlatform();
      MedlixDataVaultPlatform.instance = mock;
    });

    test('Can be extended', () {
      MedlixDataVaultPlatform.instance = ExtendsMedlixDataVaultPlatform();
    });
  });

  group('MethodChannelMedlixDataVault', () {
    const channel = MethodChannel('org.medlix.plugins/data_vault');

    final log = <MethodCall>[];

    // Used for Flutter 2.3 and later
    handler(MethodCall methodCall) async {
      log.add(methodCall);

      if (methodCall.method == 'containsKey') {
        return true;
      }

      return null;
    }

    TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, handler);

    //Remove this and replace with above when 2.3 goes stable
    // channel.setMockMethodCallHandler((call) async {
    //   log.add(call);

    //   if (call.method == 'containsKey') {
    //     return true;
    //   }

    //   // Return null explicitly instead of relying on the implicit null
    //   // returned by the method channel if no return statement is specified.

    //   return null;
    // });

    final storage = MethodChannelMedlixDataVault();
    const options = <String, String>{};
    const key = 'test_key';

    tearDown(() {
      log.clear();
    });

    test('read', () async {
      await storage.read(key: key, options: options);

      expect(
        log,
        <Matcher>[
          isMethodCall(
            'read',
            arguments: <String, Object>{
              'key': key,
              'options': options,
            },
          ),
        ],
      );
    });

    test('write', () async {
      await storage.write(key: key, value: 'test', options: options);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'write',
            arguments: <String, Object>{
              'key': key,
              'value': 'test',
              'options': options
            },
          ),
        ],
      );
    });

    // test('containsKey', () async {
    //   await storage.write(key: key, value: 'test', options: options);

    //   final result = await storage.containsKey(key: key, options: options);

    //   expect(result, true);
    // });

    test('delete', () async {
      await storage.write(key: key, value: 'test', options: options);
      await storage.delete(key: key, options: options);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'write',
            arguments: <String, Object>{
              'key': key,
              'value': 'test',
              'options': options
            },
          ),
          isMethodCall(
            'delete',
            arguments: <String, Object>{
              'key': key,
              'options': options,
            },
          ),
        ],
      );
    });

    // test('deleteAll', () async {
    //   await storage.deleteAll(options: options);
    //   expect(
    //     log,
    //     <Matcher>[
    //       isMethodCall(
    //         'deleteAll',
    //         arguments: <String, Object>{
    //           'options': options,
    //         },
    //       ),
    //     ],
    //   );
    // });

    // test('readAll', () async {
    //   await storage.write(key: key, value: 'test', options: options);

    //   await storage.readAll(options: options);

    //   expect(
    //     log,
    //     <Matcher>[
    //       isMethodCall(
    //         'write',
    //         arguments: <String, Object>{
    //           'key': key,
    //           'value': 'test',
    //           'options': options
    //         },
    //       ),
    //       isMethodCall(
    //         'readAll',
    //         arguments: <String, Object>{
    //           'options': options,
    //         },
    //       ),
    //     ],
    //   );
    // });
  });
}
