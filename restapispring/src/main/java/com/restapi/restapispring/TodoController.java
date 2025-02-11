package com.restapi.restapispring;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/todos")
public class TodoController {

    @Autowired
    private TodoService todoService;

    // Get all todos
    @GetMapping
    public List<Todo> getTodos() {
        return todoService.getAllTodos();
    }

    // Create a new todo
    @PostMapping
    public Todo createTodo(@RequestBody Todo todo) {
        return todoService.addTodo(todo);
    }

    // Update an existing todo
    @PutMapping("/{id}")
    public Todo updateTodo(@PathVariable Long id, @RequestBody Todo todo) {
        return todoService.updateTodo(id, todo);
    }

    // Delete a todo
    @DeleteMapping("/{id}")
    public void deleteTodo(@PathVariable Long id) {
        todoService.deleteTodo(id);
    }
}