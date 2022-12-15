package org.medlix.medlix_data_vault

import android.content.ContentResolver
import android.net.Uri
import android.os.Build
import android.util.Log
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
    private lateinit var contentResolver: ContentResolver

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPluginBinding) {
        channel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "org.medlix.plugins/data_vault")
        channel.setMethodCallHandler(this)

        flutterSecureStorage = FlutterSecureStorage(flutterPluginBinding.applicationContext)
        contentProvider = MedlixDataVaultContentProvider()
        contentResolver = flutterPluginBinding.applicationContext.contentResolver
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
                    value = getKey(key)
                }

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

    private fun getKey(key: String): String? {
        var value: String? = null

        for (providerAuthority in providerAthorities) {
            try {
                val providerUri = "content://$providerAuthority/keys/$key"
                val cursor = contentResolver.query(
                    Uri.parse(providerUri), // The provider Uri
                    arrayOf("value"), // Return the "value" column
                    null, // Return all rows
                    null, // No selection arguments
                    null // Default sort order
                )

                cursor?.let {
                    while (it.moveToNext()) {
                        value = it.getString(0)
                        Log.d(TAG, "key: $key, value: $value")
                    }
                }

                cursor?.close()

                return value
            } catch (e: Exception) {
                Log.e(TAG, "Cannot get key from provider: $providerAuthority", e)
            }
        }

        return null
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    companion object {
        const val TAG = "MedlixDataVaultPlugin"

        // TODO: make this configurable
        private val providerAthorities = arrayOf(
            "org.medlix.example1.medlix_data_vault.provider",
            "org.medlix.example2.medlix_data_vault.provider",
            "org.medlix.example3.medlix_data_vault.provider",
        )
    }
}
