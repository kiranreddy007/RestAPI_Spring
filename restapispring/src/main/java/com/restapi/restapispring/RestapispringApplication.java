package com.restapi.restapispring;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
@RequestMapping("/")
public class RestapispringApplication {

	public static void main(String[] args) {
        SpringApplication.run(RestapispringApplication.class, args);
    }

	//return simply a string at base URL
	@GetMapping("/")
	public String home() {
		return "Welcome to the home page!";
	}

    @GetMapping("/hello")
    public String hello() {
        return "Hello, Spring Boot!";
    }

}




