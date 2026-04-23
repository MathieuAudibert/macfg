package mpp.macfg.config.services

import org.springframework.stereotype.Service
import mpp.macfg.config.classes.Tools
import mpp.macfg.config.classes.Categories
import mpp.macfg.config.util.ReadIni
import mpp.macfg.config.util.FetchVersions

@Service
class ToolsService(
    private val readIni: ReadIni,
    private val fetchVersions: FetchVersions
) {

    private val toolsRegistry: MutableMap<String, Tools> = mutableMapOf()

    init {
        initializeTools()
    }

    private fun initializeTools() {
        val allVersions = readIni.getAllVersions()

        allVersions.forEach { (key, version) ->
            if (key.contains(".")) {
                val parts = key.split(".")
                if (parts.size >= 2) {
                    val categoryName = parts[0].uppercase()
                    val toolName = parts[1]

                    try {
                        val category = Categories.valueOf(categoryName)
                        val tool = Tools(
                            toolName = toolName,
                            category = category,
                            version = version
                        )
                        fetchVersions.updateToolDownloadUrl(tool)
                        toolsRegistry["$categoryName.$toolName"] = tool
                    } catch (e: IllegalArgumentException) {
                        // Category not found in enum, skip
                    }
                }
            }
        }
    }

    fun getAllTools(): List<Tools> {
        return toolsRegistry.values.toList()
    }

    fun getTool(category: String, toolName: String): Tools? {
        val key = "${category.uppercase()}.${toolName.lowercase()}"
        return toolsRegistry[key]
    }

    fun changeVersion(category: String, toolName: String, newVersion: String): Tools? {
        val tool = getTool(category, toolName) ?: return null

        tool.version = newVersion
        fetchVersions.updateToolDownloadUrl(tool)

        return tool
    }

    fun toggleSelection(category: String, toolName: String): Tools? {
        val tool = getTool(category, toolName) ?: return null
        tool.isSelected = !tool.isSelected
        return tool
    }

    fun setSelection(category: String, toolName: String, isSelected: Boolean): Tools? {
        val tool = getTool(category, toolName) ?: return null
        tool.isSelected = isSelected
        return tool
    }

    fun getSelectedTools(): List<Tools> {
        return toolsRegistry.values.filter { it.isSelected }
    }

    fun clearAllSelections() {
        toolsRegistry.values.forEach { it.isSelected = false }
    }
}
