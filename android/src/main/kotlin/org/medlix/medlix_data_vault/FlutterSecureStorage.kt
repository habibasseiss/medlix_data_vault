package org.medlix.medlix_data_vault

import android.content.Context
import android.content.SharedPreferences
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKeys
import java.io.IOException
import java.security.GeneralSecurityException

class FlutterSecureStorage(context: Context) {
    private lateinit var preferences: SharedPreferences

    init {
        try {
            val masterKeyAlias = MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC)

            preferences = EncryptedSharedPreferences.create(
                PREFERENCES_FILE_NAME,
                masterKeyAlias,
                context,
                EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
            )
        } catch (e: GeneralSecurityException) {
            // Handle error
            e.printStackTrace()
        } catch (e: IOException) {
            e.printStackTrace()
        }
    }

    fun read(key: String?): String? {
        return preferences.getString(key, null)
    }

    fun write(key: String?, value: String?): Boolean {
        val editor = preferences.edit()
        editor.putString(key, value)
        editor.apply()
        return preferences.contains(key)
    }

    fun delete(key: String?): Boolean {
        val editor = preferences.edit()
        return editor.remove(key).commit()
    }

    companion object {
        private const val PREFERENCES_FILE_NAME = "encrypted_preferences"
    }
}
