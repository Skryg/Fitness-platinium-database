package com.tcs.project;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.SecurityProperties;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;

import static org.springframework.transaction.TransactionDefinition.withDefaults;

@SpringBootApplication(exclude = SecurityAutoConfiguration.class)

public class ProjectApplication {

	// Equpitment nie dziala jeszcze
	public static void main(String[] args) {
		SpringApplication.run(ProjectApplication.class, args);
	}

}
