package mpp.macfg.core.services

import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import org.springframework.web.client.RestTemplate
import org.springframework.http.HttpEntity
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpMethod
import org.springframework.http.MediaType

@Service
class ToolSelectionService {

    @Value("\${config.service.url:http://localhost:7777}")
    private lateinit var configServiceUrl: String

    private val restTemplate = RestTemplate()

    fun selectTool(category: String, toolName: String): Boolean {
        return try {
            val url = "$configServiceUrl/api/tools/$category/$toolName/select/true"
            restTemplate.exchange(url, HttpMethod.PUT, null, String::class.java)
            true
        } catch (e: Exception) {
            println("Failed to select tool: ${e.message}")
            false
        }
    }

    fun deselectTool(category: String, toolName: String): Boolean {
        return try {
            val url = "$configServiceUrl/api/tools/$category/$toolName/select/false"
            restTemplate.exchange(url, HttpMethod.PUT, null, String::class.java)
            true
        } catch (e: Exception) {
            println("Failed to deselect tool: ${e.message}")
            false
        }
    }

    fun toggleToolSelection(category: String, toolName: String): Boolean {
        return try {
            val url = "$configServiceUrl/api/tools/$category/$toolName/select"
            restTemplate.exchange(url, HttpMethod.PUT, null, String::class.java)
            true
        } catch (e: Exception) {
            println("Failed to toggle tool selection: ${e.message}")
            false
        }
    }

    fun getSelectedTools(): List<Map<String, Any>>? {
        return try {
            val url = "$configServiceUrl/api/tools/selected"
            val response = restTemplate.getForObject(url, List::class.java)
            @Suppress("UNCHECKED_CAST")
            response as? List<Map<String, Any>>
        } catch (e: Exception) {
            println("Failed to get selected tools: ${e.message}")
            null
        }
    }

    fun changeToolVersion(category: String, toolName: String, newVersion: String): Boolean {
        return try {
            val url = "$configServiceUrl/api/tools/$category/$toolName/version"
            val headers = HttpHeaders().apply {
                contentType = MediaType.APPLICATION_JSON
            }
            val body = mapOf("version" to newVersion)
            val request = HttpEntity(body, headers)
            restTemplate.exchange(url, HttpMethod.PUT, request, String::class.java)
            true
        } catch (e: Exception) {
            println("Failed to change tool version: ${e.message}")
            false
        }
    }
}
