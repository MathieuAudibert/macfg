package mpp.macfg.core

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import io.github.oshai.kotlinlogging.KotlinLogging

@SpringBootApplication
class CoreApplication

fun main(args: Array<String>) {
	val logger = KotlinLogging.logger {}

	logger.trace { "Starting Kotlin Springboot application - Core" }
	runApplication<CoreApplication>(*args)
}
