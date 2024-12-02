package com.security.spring_security.Services;

import java.util.List;

import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.security.spring_security.Models.EmergencyContact;

import jakarta.mail.Session;
import jakarta.mail.Transport;


// Set up the SMTP server.

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

@Service
public class MessageHelper {

    private final JavaMailSender javaMailSender;

    public MessageHelper(JavaMailSender javaMailSender) {
        this.javaMailSender = javaMailSender;
    }

    public void sendEmergencyEmail(String location, List<EmergencyContact> contacts) throws MessagingException {
        java.util.Properties props = new java.util.Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        Session session = Session.getDefaultInstance(props, null);
        
        // Construct the message
        String to = "srimannaidu7849@gmail.com";
        String from = "rockyvenkat50@gmail.com";
        
        MimeMessage message = javaMailSender.createMimeMessage();
        
        MimeMessageHelper helper = new MimeMessageHelper(message, true);
        
        helper.setTo(to);
        helper.setSubject("HELLo");
        helper.setText(location, true);  // Use true for HTML content
        
        javaMailSender.send(message);
        System.out.println("Email sent to " + to);
        
        
    }
}
