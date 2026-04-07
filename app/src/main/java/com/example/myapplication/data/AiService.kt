package com.example.myapplication.data

import android.util.Log
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import java.net.HttpURLConnection
import java.net.URL
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

@Serializable
data class ChatMessage(
    val role: String,
    val content: String
)

@Serializable
data class ChatRequest(
    val messages: List<ChatMessage>,
    val model: String = "gpt-4o",
    val temperature: Double = 1.0,
    val top_p: Double = 1.0,
    val max_tokens: Int = 1000
)

@Serializable
data class ChatResponse(
    val choices: List<Choice>
)

@Serializable
data class Choice(
    val message: ChatMessage
)

class AiService(private val getApiKey: suspend () -> String?) {

    private val json = Json { 
        ignoreUnknownKeys = true 
        encodeDefaults = true
    }
    private val endpoint = "https://models.inference.ai.azure.com/chat/completions"

    suspend fun getCompletion(messages: List<ChatMessage>): Result<String> = withContext(Dispatchers.IO) {
        try {
            val apiKey = getApiKey()
            if (apiKey.isNullOrBlank()) {
                return@withContext Result.failure(Exception("API Key is missing. Please set your GitHub Token in settings."))
            }
            
            val url = URL(endpoint)
            val connection = url.openConnection() as HttpURLConnection
            connection.requestMethod = "POST"
            connection.setRequestProperty("Content-Type", "application/json")
            connection.setRequestProperty("Authorization", "Bearer $apiKey")
            connection.setRequestProperty("User-Agent", "MediPlus-Android-App")
            connection.doOutput = true
            connection.connectTimeout = 15000
            connection.readTimeout = 15000

            val requestBody = json.encodeToString(ChatRequest(messages = messages))

            connection.outputStream.use { 
                it.write(requestBody.toByteArray(Charsets.UTF_8)) 
            }

            val responseCode = connection.responseCode
            if (responseCode == 200) {
                val responseText = connection.inputStream.bufferedReader().readText()
                val response = json.decodeFromString<ChatResponse>(responseText)
                val content = response.choices.firstOrNull()?.message?.content ?: "No response from AI"
                Result.success(content)
            } else {
                val errorText = connection.errorStream?.bufferedReader()?.readText() ?: "No error details"
                Log.e("AiService", "API Error $responseCode: $errorText")
                Result.failure(Exception("AI Error ($responseCode): $errorText"))
            }
        } catch (e: Exception) {
            Log.e("AiService", "Exception: ${e.message}", e)
            Result.failure(e)
        }
    }
}
