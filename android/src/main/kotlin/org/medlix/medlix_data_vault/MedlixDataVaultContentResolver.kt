package org.medlix.medlix_data_vault

import android.content.ContentResolver
import android.content.ContentValues
import android.net.Uri
import android.util.Log

class MedlixDataVaultContentResolver(private val contentResolver: ContentResolver) {

    fun getKey(key: String, packageNames: Array<String>?): String? {
        var value: String? = null

        for (providerAuthority in packageNames ?: arrayOf()) {
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
                        Log.d(
                            MedlixDataVaultPlugin.TAG,
                            "Got key `$key` with value `$value` from provider: $providerAuthority"
                        )
                    }
                }

                cursor?.close()

                return value
            } catch (e: Exception) {
                Log.w(MedlixDataVaultPlugin.TAG, "Cannot get key from provider: $providerAuthority")
            }
        }

        return null
    }

    fun insertKey(key: String, value: String, packageNames: Array<String>?) {
        for (providerAuthority in packageNames ?: arrayOf()) {
            try {
                val providerUri = "content://$providerAuthority/keys/$key"
                val values = ContentValues()
                values.put("value", value)
                contentResolver.insert(Uri.parse(providerUri), values)

                Log.d(
                    MedlixDataVaultPlugin.TAG,
                    "Inserted key `$key` with value `$value` to provider: $providerAuthority"
                )
            } catch (e: Exception) {
                Log.w(
                    MedlixDataVaultPlugin.TAG, "Cannot insert key to provider: $providerAuthority"
                )
            }
        }
    }

    fun deleteKey(key: String, packageNames: Array<String>?) {
        for (providerAuthority in packageNames ?: arrayOf()) {
            try {
                val providerUri = "content://$providerAuthority/keys/$key"
                val count = contentResolver.delete(
                    Uri.parse(providerUri), // The provider Uri
                    null, // Return all rows
                    null // No selection arguments
                )

                Log.d(
                    MedlixDataVaultPlugin.TAG,
                    "Deleted $count row(s) from provider: $providerAuthority"
                )
            } catch (e: Exception) {
                Log.w(
                    MedlixDataVaultPlugin.TAG, "Cannot delete key from provider: $providerAuthority"
                )
            }
        }
    }

    fun getAllKeys(packageNames: Array<String>?): Map<String, String> {
        val map = mutableMapOf<String, String>()

        for (providerAuthority in packageNames ?: arrayOf()) {
            try {
                val providerUri = "content://$providerAuthority/keys"
                val cursor = contentResolver.query(
                    Uri.parse(providerUri), // The provider Uri
                    arrayOf("key", "value"), // Return the "key" and "value" columns
                    null, // Return all rows
                    null, // No selection arguments
                    null // Default sort order
                )

                Log.d(
                    MedlixDataVaultPlugin.TAG,
                    "Getting all keys from provider: $providerAuthority"
                )
                cursor?.let {
                    while (it.moveToNext()) {
                        val key = it.getString(0)
                        val value = it.getString(1)
                        map[key] = value

                        Log.d(MedlixDataVaultPlugin.TAG, "`$key` = `$value`")
                    }
                }

                cursor?.close()
            } catch (e: Exception) {
                Log.w(MedlixDataVaultPlugin.TAG, "Cannot get all keys from provider: $providerAuthority")
            }
        }
        return map
    }

    fun containsKey(key: String, packageNames: Array<String>?): Boolean {
        return getKey(key, packageNames) != null
    }
}
