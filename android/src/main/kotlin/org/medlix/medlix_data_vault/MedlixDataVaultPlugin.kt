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
    private lateinit var contentResolver: MedlixDataVaultContentResolver

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPluginBinding) {
        channel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "org.medlix.plugins/data_vault")
        channel.setMethodCallHandler(this)

        flutterSecureStorage = FlutterSecureStorage(flutterPluginBinding.applicationContext)
        contentProvider = MedlixDataVaultContentProvider()
        contentResolver = MedlixDataVaultContentResolver(flutterPluginBinding.applicationContext.contentResolver)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android " + Build.VERSION.RELEASE)
            }
            "read" -> {
                val key = call.argument<String>("key")
                var value: String? = null

                if (key != null) {
                    value = contentResolver.getKey(key)
                }

                result.success(value)
            }
            "write" -> {
                val key = call.argument<String>("key")
                val value = call.argument<String>("value")

                if (key != null && value != null) {
                    contentResolver.insertKey(key, value)
                }

                result.success(null)
            }
            "delete" -> {
                val key = call.argument<String>("key")

                if (key != null) {
                    contentResolver.deleteKey(key)
                }

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

    companion object {
        const val TAG = "MedlixDataVaultPlugin"
    }
}
