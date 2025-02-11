package com.restapi.restapispring;

import org.springframework.stereotype.Service;
import java.util.*;
import java.util.concurrent.atomic.AtomicLong;

@Service
public class TodoService {
    private final Map<Long, Todo> todos = new LinkedHashMap<>();
    private final AtomicLong counter = new AtomicLong();

    public List<Todo> getAllTodos() {
        return new ArrayList<>(todos.values());
    }

    public Todo addTodo(Todo todo) {
        Long id = counter.incrementAndGet();
        todo.setId(id);
        todos.put(id, todo);
        return todo;
    }

    public Todo updateTodo(Long id, Todo todo) {
        if (todos.containsKey(id)) {
            todo.setId(id);
            todos.put(id, todo);
            return todo;
        }
        return null;
    }

    public boolean deleteTodo(Long id) {
        return todos.remove(id) != null;
    }
}