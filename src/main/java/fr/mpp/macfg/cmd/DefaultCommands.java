package fr.mpp.macfg.cmd;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.shell.core.command.annotation.Command;
import org.springframework.shell.core.command.annotation.Option;
import org.springframework.stereotype.Component;

@Component
public class DefaultCommands {
    
    public static final String group = "Default-Commands";

    @Value("${macfg.version}")
    public String macfgVersion;

    public String os = System.getProperty("os.name");

    public List<String> tools = Arrays.asList("vscode", "git", "bruno");

    @Command(name = "hello", group = group, description = "takes an argument -n/-name and returns Hello name.")
    public void sayHello(@Option(shortName = 'n', longName = "name", defaultValue = "World!") String name) {
        System.out.println("[*] Hello " + name);
    }

    @Command(name = "info", group = group, description = "shows detailled informations about the project")
    public void getVersion() {
        System.out.println("[*] Version: " + macfgVersion);
        System.out.println("[*] Lang: Java Springboot/Springshell");
        System.out.println("[*] Author: Mathieu A.");
        System.out.println("[*] Contact: mathieu.audibert@proton.me");
        System.out.println("[*] Description: A little cli tool to install all the tools I require");
        System.out.println("[*] OS: " + os);
    }

    // TODO: Make a cleaner list/separate json file, organize per "class"
    @Command(name = "list-tls", group = group, description = "list all available tools to install")
    public void getTools() {
        System.out.println("[*] Tools: " + tools);
    }
} 
