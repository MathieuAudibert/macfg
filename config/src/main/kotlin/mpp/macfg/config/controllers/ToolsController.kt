package mpp.macfg.config.controllers

import mpp.macfg.config.classes.Tools
import mpp.macfg.config.services.ToolsService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/tools")
class ToolsController(private val toolsService: ToolsService) {

    @GetMapping
    fun getAllTools(): ResponseEntity<List<Tools>> {
        return ResponseEntity.ok(toolsService.getAllTools())
    }

    @GetMapping("/{category}/{toolName}")
    fun getTool(
        @PathVariable category: String,
        @PathVariable toolName: String
    ): ResponseEntity<Tools> {
        val tool = toolsService.getTool(category, toolName)
        return if (tool != null) {
            ResponseEntity.ok(tool)
        } else {
            ResponseEntity.notFound().build()
        }
    }

    @PutMapping("/{category}/{toolName}/version")
    fun changeVersion(
        @PathVariable category: String,
        @PathVariable toolName: String,
        @RequestBody request: VersionChangeRequest
    ): ResponseEntity<Tools> {
        val tool = toolsService.changeVersion(category, toolName, request.version)
        return if (tool != null) {
            ResponseEntity.ok(tool)
        } else {
            ResponseEntity.notFound().build()
        }
    }

    @PutMapping("/{category}/{toolName}/select")
    fun toggleSelection(
        @PathVariable category: String,
        @PathVariable toolName: String
    ): ResponseEntity<Tools> {
        val tool = toolsService.toggleSelection(category, toolName)
        return if (tool != null) {
            ResponseEntity.ok(tool)
        } else {
            ResponseEntity.notFound().build()
        }
    }

    @PutMapping("/{category}/{toolName}/select/{isSelected}")
    fun setSelection(
        @PathVariable category: String,
        @PathVariable toolName: String,
        @PathVariable isSelected: Boolean
    ): ResponseEntity<Tools> {
        val tool = toolsService.setSelection(category, toolName, isSelected)
        return if (tool != null) {
            ResponseEntity.ok(tool)
        } else {
            ResponseEntity.notFound().build()
        }
    }

    @GetMapping("/selected")
    fun getSelectedTools(): ResponseEntity<List<Tools>> {
        return ResponseEntity.ok(toolsService.getSelectedTools())
    }

    @DeleteMapping("/selected")
    fun clearAllSelections(): ResponseEntity<Void> {
        toolsService.clearAllSelections()
        return ResponseEntity.noContent().build()
    }
}

data class VersionChangeRequest(val version: String)
