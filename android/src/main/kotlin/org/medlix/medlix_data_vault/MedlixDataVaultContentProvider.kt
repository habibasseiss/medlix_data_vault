package org.medlix.medlix_data_vault

import android.content.ContentProvider
import android.content.ContentValues
import android.content.UriMatcher
import android.database.Cursor
import android.database.MatrixCursor
import android.net.Uri
import android.util.Log

class MedlixDataVaultContentProvider : ContentProvider() {

    private lateinit var sUriMatcher: UriMatcher

    private lateinit var flutterSecureStorage: FlutterSecureStorage
    private lateinit var authority: String
    private lateinit var contentUri: Uri
    private lateinit var keysContentUri: Uri

    override fun onCreate(): Boolean {
        context?.let {
            flutterSecureStorage = FlutterSecureStorage(it)

            // authority is based on the package name of the app
            authority = "${it.packageName}.medlix_data_vault.provider"
            contentUri = Uri.parse("content://${authority}")
            keysContentUri = Uri.parse("content://${authority}/${TABLE_NAME}")

            // initialize the URIs
            initializeUriMatching()

            Log.d(MedlixDataVaultPlugin.TAG, "Created ContentProvider: $contentUri")
        }

        return true
    }

    override fun delete(uri: Uri, selection: String?, selectionArgs: Array<String>?): Int {
        Log.d(MedlixDataVaultPlugin.TAG, "delete: $uri")

        return when (sUriMatcher.match(uri)) {
            URI_ITEM_ID -> {
                val key = uri.lastPathSegment

                if (flutterSecureStorage.delete(key)) 1
                else 0
            }
            URI_ITEM_LIST -> {
                flutterSecureStorage.deleteAll()
            }
            else -> {
                throw IllegalArgumentException("Unknown URI: $uri")
            }
        }
    }

    override fun getType(uri: Uri): String = when (sUriMatcher.match(uri)) {
        URI_ITEM_ID -> "vnd.android.cursor.item/vnd.$authority.$TABLE_NAME"
        URI_ITEM_LIST -> "vnd.android.cursor.dir/vnd.$authority.$TABLE_NAME"
        else -> throw IllegalArgumentException("Unsupported URI: $uri")
    }

    override fun insert(uri: Uri, values: ContentValues?): Uri? {
        Log.d(MedlixDataVaultPlugin.TAG, "insert: $uri")

        when (sUriMatcher.match(uri)) {
            URI_ITEM_ID -> {
                val key = uri.lastPathSegment
                val value = values?.getAsString("value")
                if (key != null && value != null) {
                    flutterSecureStorage.write(key, value)
                }
                return Uri.withAppendedPath(keysContentUri, key)
            }
            else -> throw IllegalArgumentException("Unsupported insert URI: $uri")
        }
    }

    override fun query(
        uri: Uri,
        projection: Array<String>?,
        selection: String?,
        selectionArgs: Array<String>?,
        sortOrder: String?
    ): Cursor {
        when (sUriMatcher.match(uri)) {
            URI_ITEM_ID -> {
                val key = uri.lastPathSegment
                val value = flutterSecureStorage.read(key)

                val cursor = MatrixCursor(projection)
                val builder = cursor.newRow()

                // for each column in projection
                projection?.forEach {
                    builder.add(it, value)
                }

                return cursor
            }
            URI_ITEM_LIST -> {
                val map = flutterSecureStorage.readAll()
                val cursor = MatrixCursor(projection)

                for ((key, value) in map) {
                    val builder = cursor.newRow()
                    projection?.forEach {
                        if (it == "key") builder.add(it, key)
                        if (it == "value") builder.add(it, value)
                    }
                }
//                Log.e(MedlixDataVaultPlugin.TAG, "projection: ${projection?.contentToString()}")
//                Log.d(MedlixDataVaultPlugin.TAG, "query: $uri, $projection, $map")

                return cursor
            }
            else -> throw IllegalArgumentException("Unsupported query URI: $uri")

        }
    }

    override fun update(
        uri: Uri, values: ContentValues?, selection: String?, selectionArgs: Array<String>?
    ): Int {
        throw  UnsupportedOperationException(
            "This ContentProvider does not support updates"
        )
    }

    // Add the URI's that can be matched on this content provider
    private fun initializeUriMatching() {
        sUriMatcher = UriMatcher(UriMatcher.NO_MATCH)
        sUriMatcher.addURI(authority, "${TABLE_NAME}/*", URI_ITEM_ID)
        sUriMatcher.addURI(authority, "${TABLE_NAME}/", URI_ITEM_LIST)
    }

    // The URI Codes
    companion object {
        private const val URI_ITEM_ID = 1
        private const val URI_ITEM_LIST = 2
        private const val TABLE_NAME = "keys"
    }
}