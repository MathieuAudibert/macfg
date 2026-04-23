package mpp.macfg.config.util

import org.springframework.core.io.ClassPathResource
import org.springframework.stereotype.Component
import java.io.BufferedReader
import java.io.InputStreamReader

@Component
class ReadIni {

    private val versionsMap: MutableMap<String, String> = mutableMapOf()

    init {
        loadVersionsFromIni()
    }

    private fun loadVersionsFromIni() {
        try {
            val resource = ClassPathResource("tools/tools.ini")
            BufferedReader(InputStreamReader(resource.inputStream)).use { reader ->
                var line: String?
                while (reader.readLine().also { line = it } != null) {
                    line?.let {
                        if (it.contains("=") && !it.trim().startsWith(";") && !it.trim().startsWith("[")) {
                            val parts = it.split("=", limit = 2)
                            if (parts.size == 2) {
                                val key = parts[0].trim()
                                val value = parts[1].trim()
                                versionsMap[key] = value
                            }
                        }
                    }
                }
            }
        } catch (e: Exception) {
            throw RuntimeException("Failed to load tools.ini", e)
        }
    }

    fun getVersion(category: String, toolName: String): String? {
        val key = "${category.lowercase()}.${toolName.lowercase()}"
        return versionsMap[key]
    }

    fun getAllVersions(): Map<String, String> = versionsMap.toMap()
}
