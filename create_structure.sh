#!/bin/bash
# create_structure.sh
# ===============================================
# This script creates the directory structure and sample files
# for the "restapispring" project with the base package:
# com.restapi.restapispring
# ===============================================

# Create directories
mkdir -p restapispring/src/main/java/com/restapi/restapispring/config
mkdir -p restapispring/src/main/java/com/restapi/restapispring/controller
mkdir -p restapispring/src/main/java/com/restapi/restapispring/dto
mkdir -p restapispring/src/main/java/com/restapi/restapispring/exception
mkdir -p restapispring/src/main/java/com/restapi/restapispring/model
mkdir -p restapispring/src/main/java/com/restapi/restapispring/repository
mkdir -p restapispring/src/main/java/com/restapi/restapispring/service
mkdir -p restapispring/src/main/resources
mkdir -p restapispring/src/test/java/com/restapi/restapispring

# Create RestapispringApplication.java
cat <<'EOF' > restapispring/src/main/java/com/restapi/restapispring/RestapispringApplication.java
package com.restapi.restapispring;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class RestapispringApplication {
    public static void main(String[] args) {
        SpringApplication.run(RestapispringApplication.class, args);
    }
}
EOF

# Create SecurityConfig.java
cat <<'EOF' > restapispring/src/main/java/com/restapi/restapispring/config/SecurityConfig.java
package com.restapi.restapispring.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http.csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(authz -> authz.anyRequest().authenticated())
            .httpBasic(Customizer.withDefaults());
        return http.build();
    }

    @Bean
    public InMemoryUserDetailsManager userDetailsService(PasswordEncoder passwordEncoder) {
        UserDetails user = User.withUsername("user")
                               .password(passwordEncoder.encode("password"))
                               .roles("USER")
                               .build();
        return new InMemoryUserDetailsManager(user);
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
EOF

# Create Todo.java (Model)
cat <<'EOF' > restapispring/src/main/java/com/restapi/restapispring/model/Todo.java
package com.restapi.restapispring.model;

public class Todo {
    private Long id;
    private String title;
    private boolean completed;

    public Todo() {}

    public Todo(Long id, String title, boolean completed) {
        this.id = id;
        this.title = title;
        this.completed = completed;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public boolean isCompleted() { return completed; }
    public void setCompleted(boolean completed) { this.completed = completed; }
}
EOF

# Create TodoRepository.java (In-Memory)
cat <<'EOF' > restapispring/src/main/java/com/restapi/restapispring/repository/TodoRepository.java
package com.restapi.restapispring.repository;

import com.restapi.restapispring.model.Todo;
import org.springframework.stereotype.Repository;

import java.util.*;
import java.util.concurrent.atomic.AtomicLong;

@Repository
public class TodoRepository {

    private final Map<Long, Todo> todos = new LinkedHashMap<>();
    private final AtomicLong counter = new AtomicLong();

    public List<Todo> findAll() {
        return new ArrayList<>(todos.values());
    }

    public Todo save(Todo todo) {
        if (todo.getId() == null) {
            Long id = counter.incrementAndGet();
            todo.setId(id);
        }
        todos.put(todo.getId(), todo);
        return todo;
    }

    public boolean exists(Long id) {
        return todos.containsKey(id);
    }

    public boolean delete(Long id) {
        return todos.remove(id) != null;
    }
}
EOF

# Create TodoService.java
cat <<'EOF' > restapispring/src/main/java/com/restapi/restapispring/service/TodoService.java
package com.restapi.restapispring.service;

import com.restapi.restapispring.model.Todo;
import com.restapi.restapispring.repository.TodoRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TodoService {

    private final TodoRepository todoRepository;

    public TodoService(TodoRepository todoRepository) {
        this.todoRepository = todoRepository;
    }

    public List<Todo> getAllTodos() {
        return todoRepository.findAll();
    }

    public Todo addTodo(Todo todo) {
        return todoRepository.save(todo);
    }

    public Todo updateTodo(Long id, Todo todo) {
        if (todoRepository.exists(id)) {
            todo.setId(id);
            return todoRepository.save(todo);
        }
        return null;
    }

    public boolean deleteTodo(Long id) {
        return todoRepository.delete(id);
    }
}
EOF

# Create TodoController.java
cat <<'EOF' > restapispring/src/main/java/com/restapi/restapispring/controller/TodoController.java
package com.restapi.restapispring.controller;

import com.restapi.restapispring.model.Todo;
import com.restapi.restapispring.service.TodoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/todos")
public class TodoController {

    @Autowired
    private TodoService todoService;

    @GetMapping
    public List<Todo> getTodos() {
        return todoService.getAllTodos();
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Todo createTodo(@RequestBody Todo todo) {
        return todoService.addTodo(todo);
    }

    @PutMapping("/{id}")
    public Todo updateTodo(@PathVariable Long id, @RequestBody Todo todo) {
        return todoService.updateTodo(id, todo);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteTodo(@PathVariable Long id) {
        todoService.deleteTodo(id);
    }
}
EOF

# Create GlobalExceptionHandler.java (Optional)
cat <<'EOF' > restapispring/src/main/java/com/restapi/restapispring/exception/GlobalExceptionHandler.java
package com.restapi.restapispring.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(Exception.class)
    public ResponseEntity<String> handleAllExceptions(Exception ex) {
        return new ResponseEntity<>("An error occurred: " + ex.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
EOF

# Create a basic test file RestapispringApplicationTests.java
cat <<'EOF' > restapispring/src/test/java/com/restapi/restapispring/RestapispringApplicationTests.java
package com.restapi.restapispring;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class RestapispringApplicationTests {

    @Test
    void contextLoads() {
    }
}
EOF

echo "Project structure for com.restapi.restapispring created successfully."