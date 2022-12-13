package org.medlix.medlix_data_vault;

import org.medlix.medlix_data_vault.FlutterSecureStorage;

import androidx.annotation.NonNull;
import androidx.security.crypto.EncryptedSharedPreferences;
import androidx.security.crypto.MasterKeys;

import java.io.IOException;
import java.security.GeneralSecurityException;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/** MedlixDataVaultPlugin */
public class MedlixDataVaultPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private FlutterSecureStorage flutterSecureStorage;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "org.medlix.plugins/data_vault");
        channel.setMethodCallHandler(this);

        flutterSecureStorage = new FlutterSecureStorage(flutterPluginBinding.getApplicationContext());
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("read")) {
            String key = call.argument("key");
            String value = flutterSecureStorage.read(key);
            result.success(value);
        } else if (call.method.equals("write")) {
            String key = call.argument("key");
            String value = call.argument("value");
            flutterSecureStorage.write(key, value);
            result.success(null);
        }
        else if (call.method.equals("delete")) {
            String key = call.argument("key");
            flutterSecureStorage.delete(key);
            result.success(null);
        }
        else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
