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
