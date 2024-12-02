package com.security.spring_security.Services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.security.spring_security.Models.User;
import com.security.spring_security.Models.UserPrincipal;
import com.security.spring_security.Repositiries.UserRepo;

@Service
public class MyUserDeatailServices implements UserDetailsService {

    @Autowired
    private UserRepo userRepo;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
      
        User user = userRepo.findByUserName(username);

        if(user == null)
        {
            throw new UsernameNotFoundException("User not Fond");
        }

        return new UserPrincipal(user);
    }
    
}
