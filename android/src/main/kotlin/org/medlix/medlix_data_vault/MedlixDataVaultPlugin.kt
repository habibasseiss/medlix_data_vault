package org.medlix.medlix_data_vault

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
        contentResolver = MedlixDataVaultContentResolver(
            flutterPluginBinding.applicationContext.contentResolver,
        )
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "read" -> {
                val key = call.argument<String>("key")
                var value: String? = null
                val options = call.argument<Map<String, Any>>("options")
                val packageNames = packageNamesToAuthorities(options?.get("packageNames") as String?)

                if (key != null) {
                    value = contentResolver.getKey(key, packageNames)
                }

                result.success(value)
            }
            "write" -> {
                val key = call.argument<String>("key")
                val value = call.argument<String>("value")
                val options = call.argument<Map<String, Any>>("options")
                val packageNames = packageNamesToAuthorities(options?.get("packageNames") as String?)

                if (key != null && value != null) {
                    contentResolver.insertKey(key, value, packageNames)
                }

                result.success(null)
            }
            "delete" -> {
                val key = call.argument<String>("key")
                val options = call.argument<Map<String, Any>>("options")
                val packageNames = packageNamesToAuthorities(options?.get("packageNames") as String?)

                if (key != null) {
                    contentResolver.deleteKey(key, packageNames)
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

    private fun packageNamesToAuthorities(packageNames: String?): Array<String>? {
        return packageNames
            ?.split(",")
            ?.map { "$it.medlix_data_vault.provider" }
            ?.toTypedArray()
    }

    companion object {
        const val TAG = "MedlixDataVaultPlugin"
    }
}
