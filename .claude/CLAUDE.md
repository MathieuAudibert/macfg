# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.
Always update this file when updating the project, and always report the number of tokens used with its approximation in €.

---

## Project Overview

This is a Spring Boot multi-module Maven project written in Kotlin (version 2.2.21) using Java 21.

### Modules
- **config**: Configuration service module
- **core**: Core application module

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

---