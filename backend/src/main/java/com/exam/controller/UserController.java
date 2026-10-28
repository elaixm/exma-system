package com.exam.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.exam.common.Result;
import com.exam.entity.User;
import com.exam.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/users")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/list")
    public Result<Page<User>> getUserList(@RequestParam(defaultValue = "1") Integer page,
                                         @RequestParam(defaultValue = "10") Integer size,
                                         @RequestParam(required = false) String role,
                                         @RequestParam(required = false) String keyword) {
        Page<User> userPage = userService.getUserList(page, size, role, keyword);
        return Result.success(userPage);
    }

    @GetMapping("/{id}")
    public Result<User> getUserById(@PathVariable Long id) {
        User user = userService.getUserById(id);
        return Result.success(user);
    }

    @GetMapping("/current")
    public Result<User> getCurrentUser(Authentication authentication) {
        String username = authentication.getName();
        User user = userService.getCurrentUser(username);
        return Result.success(user);
    }

    @PostMapping
    public Result<Void> createUser(@RequestBody User user) {
        try {
            com.exam.dto.RegisterRequest request = new com.exam.dto.RegisterRequest();
            request.setUsername(user.getUsername());
            request.setPassword(user.getPassword());
            request.setRealName(user.getRealName());
            request.setRole(user.getRole());
            request.setEmail(user.getEmail());
            request.setPhone(user.getPhone());
            userService.register(request);
            return Result.success("创建成功", null);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public Result<Void> updateUser(@PathVariable Long id, @RequestBody User user) {
        try {
            user.setId(id);
            userService.updateUser(user);
            return Result.success("更新成功", null);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public Result<Void> deleteUser(@PathVariable Long id) {
        try {
            userService.deleteUser(id);
            return Result.success("删除成功", null);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
}

