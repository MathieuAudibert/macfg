package fr.mpp.macfg;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.shell.core.command.annotation.Command;
import org.springframework.shell.core.command.annotation.Option;

@SpringBootApplication
public class MacfgApplication {

	public static void main(String[] args) {
		SpringApplication.run(MacfgApplication.class, args);
	}
}
