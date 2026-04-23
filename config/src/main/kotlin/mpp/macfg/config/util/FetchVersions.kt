package mpp.macfg.config.util

import mpp.macfg.config.classes.Tools
import org.springframework.stereotype.Component

@Component
class FetchVersions {

    fun fetchDownloadUrl(tool: Tools): String {
        return when (tool.category.name.lowercase()) {
            "languages" -> fetchLanguageUrl(tool)
            "dbms" -> fetchDbmsUrl(tool)
            "cli" -> fetchCliUrl(tool)
            "other" -> fetchOtherUrl(tool)
            "pms" -> fetchPmsUrl(tool)
            "code" -> fetchCodeUrl(tool)
            "fonts" -> fetchFontUrl(tool)
            "ops" -> fetchOpsUrl(tool)
            else -> ""
        }
    }

    private fun fetchLanguageUrl(tool: Tools): String {
        return when (tool.toolName.lowercase()) {
            "java" -> "https://download.oracle.com/java/${tool.version}/latest/jdk-${tool.version}_windows-x64_bin.exe"
            "python" -> "https://www.python.org/ftp/python/${tool.version}/python-${tool.version}-amd64.exe"
            "rust" -> "https://static.rust-lang.org/dist/rust-${tool.version}-x86_64-pc-windows-msvc.msi"
            "javascript" -> "" // JavaScript is bundled with browsers/Node.js
            else -> ""
        }
    }

    private fun fetchDbmsUrl(tool: Tools): String {
        return when (tool.toolName.lowercase()) {
            "mongodb" -> "https://fastdl.mongodb.org/windows/mongodb-windows-x86_64-${tool.version}-signed.msi"
            "mysql" -> "https://dev.mysql.com/get/Downloads/MySQLInstaller/mysql-installer-community-${tool.version}.0-windows-x64.msi"
            "postgresql" -> "https://sbp.enterprisedb.com/getfile.jsp?fileid=1259039" // PostgreSQL requires specific version mapping
            else -> ""
        }
    }

    private fun fetchCliUrl(tool: Tools): String {
        return when (tool.toolName.lowercase()) {
            "make" -> "https://github.com/mbuilov/gnumake-windows/releases/latest"
            "wsl" -> "https://aka.ms/wslinstall"
            "gitbash" -> "https://github.com/git-for-windows/git/releases/latest"
            "termius" -> "https://termius.com/windows"
            else -> ""
        }
    }

    private fun fetchOtherUrl(tool: Tools): String {
        return when (tool.toolName.lowercase()) {
            "bruno" -> "https://github.com/usebruno/bruno/releases/download/v${tool.version}/bruno_${tool.version}_x64_win.exe"
            "compass" -> "https://downloads.mongodb.com/compass/mongodb-compass-${tool.version}-win32-x64.exe"
            "pgadmin" -> "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${tool.version}/windows/pgadmin4-${tool.version}-x64.exe"
            "mysql_wb" -> "https://dev.mysql.com/downloads/workbench/"
            "nodejs" -> "https://nodejs.org/dist/${tool.version}/node-${tool.version}-x64.msi"
            else -> ""
        }
    }

    private fun fetchPmsUrl(tool: Tools): String {
        return when (tool.toolName.lowercase()) {
            "mvn" -> "https://dlcdn.apache.org/maven/maven-3/${tool.version}/binaries/apache-maven-${tool.version}-bin.zip"
            "uv" -> "https://github.com/astral-sh/uv/releases/latest"
            "bun" -> "https://github.com/oven-sh/bun/releases/latest"
            else -> ""
        }
    }

    private fun fetchCodeUrl(tool: Tools): String {
        return when (tool.toolName.lowercase()) {
            "vscode" -> "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
            else -> ""
        }
    }

    private fun fetchFontUrl(tool: Tools): String {
        return when (tool.toolName.lowercase()) {
            "jetbrains_mono" -> "https://github.com/JetBrains/JetBrainsMono/releases/latest"
            "cascadia_mono" -> "https://github.com/microsoft/cascadia-code/releases/latest"
            "fira_code" -> "https://github.com/tonsky/FiraCode/releases/latest"
            else -> ""
        }
    }

    private fun fetchOpsUrl(tool: Tools): String {
        return when (tool.toolName.lowercase()) {
            "git" -> "https://github.com/git-for-windows/git/releases/latest"
            "docker" -> "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe"
            else -> ""
        }
    }

    fun updateToolDownloadUrl(tool: Tools) {
        tool.downloadUrl = fetchDownloadUrl(tool)
    }
}
