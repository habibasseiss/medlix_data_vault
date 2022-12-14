package org.medlix.medlix_data_vault

import android.content.ContentProvider
import android.content.ContentValues
import android.content.UriMatcher
import android.database.Cursor
import android.net.Uri
import android.util.Log

class MedlixDataVaultContentProvider : ContentProvider() {

    private lateinit var sUriMatcher : UriMatcher

    private lateinit var flutterSecureStorage: FlutterSecureStorage
    private lateinit var authority: String
    private lateinit var contentUri: Uri

    override fun onCreate(): Boolean {
        context?.let {
            flutterSecureStorage = FlutterSecureStorage(it)
            authority = "${it.packageName}.medlix_data_vault.provider"
            contentUri = Uri.parse("content://${authority}")

            // intialize the URIs
            initializeUriMatching()

            Log.d(TAG, "onCreate: $contentUri")
        }

        return true
    }

    override fun delete(uri: Uri, selection: String?, selectionArgs: Array<String>?): Int {
//        TODO("Implement this to handle requests to delete one or more rows")

//        flutterSecureStorage.delete(selection)
        return 0
    }

    override fun getType(uri: Uri) : String = when(sUriMatcher.match(uri)) {
        URI_ITEM_ID -> "vnd.android.cursor.item/vnd.$authority.$TABLE_NAME"
        else -> throw IllegalArgumentException("Unsupported URI: $uri")
    }


    override fun insert(uri: Uri, values: ContentValues?): Uri? {
//        TODO("Implement this to handle requests to insert a new row.")
        return Uri.EMPTY
    }



    override fun query(
        uri: Uri, projection: Array<String>?, selection: String?,
        selectionArgs: Array<String>?, sortOrder: String?
    ): Cursor? {
//        TODO("Implement this to handle query requests from clients.")
        return null
    }

    override fun update(
        uri: Uri, values: ContentValues?, selection: String?,
        selectionArgs: Array<String>?
    ): Int {
//        TODO("Implement this to handle requests to update one or more rows.")
        return 0
    }

    // Add the URI's that can be matched on this content provider
    private fun initializeUriMatching() {
        sUriMatcher = UriMatcher(UriMatcher.NO_MATCH)
        sUriMatcher.addURI(authority, "${TABLE_NAME}/#", URI_ITEM_ID)
    }

    // The URI Codes
    companion object {
        private const val TAG = "MedlixDataVaultPlugin"
        private const val URI_ITEM_ID = 1
        private const val TABLE_NAME = "keys"
    }
}