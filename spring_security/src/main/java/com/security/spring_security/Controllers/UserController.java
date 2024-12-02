package com.security.spring_security.Controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.security.spring_security.Models.User;
import com.security.spring_security.RequestDTO.UserRequestBody;
import com.security.spring_security.Services.UserService;

@RestController
@CrossOrigin
public class UserController {

    @Autowired
    private UserService userService;
    
    @PostMapping("/register")
    public ResponseEntity<Void> RegisterUser(@RequestBody UserRequestBody userDTO)
    {
        userService.registerUser(userDTO.username() , userDTO.password());

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PostMapping("/login")
    public ResponseEntity<String> loginUser(@RequestBody User user)
    {

        return new ResponseEntity<>(userService.verify(user) , HttpStatus.OK);
    }

    @GetMapping("/users")
    public ResponseEntity<List<User>> loginUser()
    {

        return new ResponseEntity<>(userService.getAll() , HttpStatus.OK);
    }
}
