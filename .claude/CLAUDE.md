# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.
Always update this file when updating the project, and always report the number of tokens used with its approximation in €.

---

## Project Overview

This is a Spring Boot multi-module Maven project written in Kotlin (version 2.2.21) using Java 21.

### Modules
- **config**: Configuration service module (Port 7777)
  - Tools configuration and version management
  - REST API for tool operations
  - INI file parser for default versions
  - Download URL generation
- **core**: Core application module (Port 7778)
  - Interactive CLI for tool selection
  - Client service for config module

### Security & Certificates

The project includes a complete PKI setup for SSL/TLS:
- Self-signed CA for development
- Server certificates with SAN (localhost, *.localhost, 127.0.0.1)
- Client certificates for mutual TLS
- Java keystores (JKS and PKCS12 formats)
- Truststore for CA certificates

#### Certificate Management
- Generation script: `generate-certs.sh` 
- Location: `config/src/main/resources/certs/`
- Documentation: `README-CERTIFICATES.md`
- SSL configuration profile: `application-ssl.properties`

#### Running with SSL
```bash
mvn spring-boot:run -Dspring-boot.run.profiles=ssl
```

### Tools Configuration System

The project includes a tools configuration system that manages software tools, versions, and selections.

#### Key Features
- Reads default versions from `tools.ini`
- Version management (users can change tool versions)
- Selection tracking (tools can be marked as selected)
- Automatic download URL generation based on version
- REST API for all operations
- Interactive CLI for easy management

#### Configuration File
- Location: `config/src/main/resources/tools/tools.ini`
- Format: INI with categories and version mappings
- Documentation: `README-TOOLS.md`

#### Running the System
```bash
# Start config service
cd config && mvn spring-boot:run

# Start core service with interactive CLI
cd core && mvn spring-boot:run -Dspring-boot.run.arguments=--interactive
```

#### API Endpoints
- `GET /api/tools` - List all tools
- `PUT /api/tools/{category}/{tool}/version` - Change version
- `PUT /api/tools/{category}/{tool}/select/{true|false}` - Set selection
- `GET /api/tools/selected` - Get selected tools

Swagger UI: http://localhost:7777/swagger-ui.html

---