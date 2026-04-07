package com.example.myapplication.data

import android.content.Context
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import org.json.JSONObject

private val Context.dataStore by preferencesDataStore(name = "settings")

class SettingsRepository(private val context: Context) {

    private val GITHUB_TOKEN_KEY = stringPreferencesKey("github_token")

    val githubToken: Flow<String?> = context.dataStore.data
        .map { preferences ->
            preferences[GITHUB_TOKEN_KEY]
        }

    suspend fun saveGithubToken(token: String) {
        context.dataStore.edit { preferences ->
            preferences[GITHUB_TOKEN_KEY] = token
        }
    }

    fun getFallbackToken(): String? {
        return try {
            val jsonString = context.assets.open("secrets.json").bufferedReader().use { it.readText() }
            JSONObject(jsonString).getString("github_token")
        } catch (e: Exception) {
            null
        }
    }
}
