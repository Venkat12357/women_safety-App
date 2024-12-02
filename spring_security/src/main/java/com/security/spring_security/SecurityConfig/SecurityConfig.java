package com.security.spring_security.SecurityConfig;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private UserDetailsService userDetailsService;

    @Bean
    public SecurityFilterChain securityFilter(HttpSecurity http) throws Exception
    {
        return http .csrf(customizer -> customizer.disable())
                    .authorizeHttpRequests(request -> request
                    .requestMatchers("/register" , "/login" , "/users" , "/location" )
                    .permitAll()
                    .requestMatchers("/{userId}/contacts")
                    .permitAll()
                    .requestMatchers("/{userId}/emergency-contacts")
                    .permitAll()
                    .requestMatchers("/{userId}/location")
                    .permitAll()
                            .requestMatchers("/{contactId}/Delete")
                            .permitAll()
                    .anyRequest().authenticated())
                    .httpBasic(Customizer.withDefaults())
                    .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                    .build();
    }

    @Bean
    public DaoAuthenticationProvider provider()
    {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setUserDetailsService(userDetailsService);
        provider.setPasswordEncoder(NoOpPasswordEncoder.getInstance());
        return provider;
    }

    @Bean
    public AuthenticationManager auth(AuthenticationConfiguration config) throws Exception
    {
        return config.getAuthenticationManager();
    }

}
