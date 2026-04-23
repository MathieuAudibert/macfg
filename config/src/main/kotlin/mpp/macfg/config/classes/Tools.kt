package mpp.macfg.config.classes

enum class Categories {
    LANGUAGES, DBMS, CLI, OTHER, PMS, CODE, FONTS, OPS
}

data class Tools (
    val toolName: String,
    val category: Categories,
    var version: String,
    var downloadUrl: String = "",
    var isSelected: Boolean = false
)