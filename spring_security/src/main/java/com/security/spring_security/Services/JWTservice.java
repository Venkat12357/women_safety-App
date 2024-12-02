package com.security.spring_security.Services;

import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;

import org.springframework.stereotype.Service;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;


@Service
public class JWTservice {

    Map<String , Object> claims = new HashMap<>();
    
    public String getToken(String username)
    {
        return Jwts.builder()
                   .claims()
                   .add(claims)
                   .subject(username)
                   .issuedAt(new Date(System.currentTimeMillis()))
                   .expiration(new Date(System.currentTimeMillis() + 60 * 60 * 30))
                   .and()
                   .signWith(getKey())
                   .compact();
            
    }

    private Key getKey() {

        KeyGenerator keyGen = null;
        SecretKey skey = null;
        String secretKey = "";
        
        try {

            keyGen = KeyGenerator.getInstance("HmacSHA256");
            skey = keyGen.generateKey();
            secretKey = Base64.getEncoder().encodeToString(skey.getEncoded());

        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }

           
        byte bytes[] = Decoders.BASE64.decode(secretKey);

       
        return Keys.hmacShaKeyFor(bytes);
    }
}
