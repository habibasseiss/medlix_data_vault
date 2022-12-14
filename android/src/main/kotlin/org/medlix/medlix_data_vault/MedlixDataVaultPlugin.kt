package org.medlix.medlix_data_vault

import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/** MedlixDataVaultPlugin  */
class MedlixDataVaultPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var flutterSecureStorage: FlutterSecureStorage
    private lateinit var contentProvider: MedlixDataVaultContentProvider

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPluginBinding) {
        channel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "org.medlix.plugins/data_vault")
        channel.setMethodCallHandler(this)
        flutterSecureStorage = FlutterSecureStorage(flutterPluginBinding.applicationContext)
        contentProvider = MedlixDataVaultContentProvider()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android " + Build.VERSION.RELEASE)
            }
            "read" -> {
                val key = call.argument<String>("key")
                val value = flutterSecureStorage.read(key)
                result.success(value)
            }
            "write" -> {
                val key = call.argument<String>("key")
                val value = call.argument<String>("value")
                flutterSecureStorage.write(key, value)
                result.success(null)
            }
            "delete" -> {
                val key = call.argument<String>("key")
                flutterSecureStorage.delete(key)
                result.success(null)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
