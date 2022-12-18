package org.medlix.medlix_data_vault

import android.content.ContentResolver
import android.content.ContentValues
import android.net.Uri
import android.util.Log

class MedlixDataVaultContentResolver(
    private val contentResolver: ContentResolver,
    private val providerAuthorities: Array<String>,
) {

    fun getKey(key: String): String? {
        var value: String? = null

        for (providerAuthority in providerAuthorities) {
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

    fun insertKey(key: String, value: String) {
        for (providerAuthority in providerAuthorities) {
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

    fun deleteKey(key: String) {
        for (providerAuthority in providerAuthorities) {
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
}
