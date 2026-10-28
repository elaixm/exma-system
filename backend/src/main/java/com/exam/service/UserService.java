package com.exam.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.exam.common.Constants;
import com.exam.dto.LoginRequest;
import com.exam.dto.LoginResponse;
import com.exam.dto.RegisterRequest;
import com.exam.entity.User;
import com.exam.mapper.UserMapper;
import com.exam.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.concurrent.TimeUnit;

@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    public LoginResponse login(LoginRequest request) {
        QueryWrapper<User> wrapper = new QueryWrapper<>();
        wrapper.eq("username", request.getUsername());
        User user = userMapper.selectOne(wrapper);

        if (user == null || !user.getPassword().equals(request.getPassword())) {
            throw new RuntimeException("用户名或密码错误");
        }

        String token = jwtUtil.generateToken(user.getUsername(), user.getRole());
        redisTemplate.opsForValue().set(Constants.REDIS_TOKEN_PREFIX + user.getUsername(), token, 24, TimeUnit.HOURS);

        LoginResponse response = new LoginResponse();
        response.setToken(token);
        response.setUsername(user.getUsername());
        response.setRole(user.getRole());
        response.setRealName(user.getRealName());
        return response;
    }

    public void register(RegisterRequest request) {
        // 验证角色：注册时不允许选择管理员角色
        if (Constants.ROLE_ADMIN.equals(request.getRole())) {
            throw new RuntimeException("不允许注册管理员角色");
        }
        
        // 验证角色是否有效（只能是学生或教师）
        if (!Constants.ROLE_STUDENT.equals(request.getRole()) && 
            !Constants.ROLE_TEACHER.equals(request.getRole())) {
            throw new RuntimeException("无效的角色，只能注册为学生或教师");
        }
        
        QueryWrapper<User> wrapper = new QueryWrapper<>();
        wrapper.eq("username", request.getUsername());
        User existUser = userMapper.selectOne(wrapper);
        if (existUser != null) {
            throw new RuntimeException("用户名已存在");
        }

        User user = new User();
        user.setUsername(request.getUsername());
        user.setPassword(request.getPassword());
        user.setRealName(request.getRealName());
        user.setRole(request.getRole());
        user.setEmail(request.getEmail());
        user.setPhone(request.getPhone());
        user.setCreateTime(LocalDateTime.now());
        user.setUpdateTime(LocalDateTime.now());
        userMapper.insert(user);
    }

    public Page<User> getUserList(Integer page, Integer size, String role, String keyword) {
        Page<User> pageObj = new Page<>(page, size);
        QueryWrapper<User> wrapper = new QueryWrapper<>();
        if (role != null && !role.isEmpty()) {
            wrapper.eq("role", role);
        }
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.and(w -> w.like("username", keyword)
                    .or().like("real_name", keyword));
        }
        return userMapper.selectPage(pageObj, wrapper);
    }

    public User getUserById(Long id) {
        return userMapper.selectById(id);
    }

    public void updateUser(User user) {
        user.setUpdateTime(LocalDateTime.now());
        userMapper.updateById(user);
    }

    public void deleteUser(Long id) {
        userMapper.deleteById(id);
    }

    public User getCurrentUser(String username) {
        QueryWrapper<User> wrapper = new QueryWrapper<>();
        wrapper.eq("username", username);
        return userMapper.selectOne(wrapper);
    }

}
