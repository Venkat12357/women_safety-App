package com.security.spring_security.Controllers;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.security.spring_security.Models.EmergencyContact;
import com.security.spring_security.Models.User;
import com.security.spring_security.RequestDTO.LocationRequestBody;
import com.security.spring_security.Services.EmeregencyService;
import com.security.spring_security.Services.MessageHelper;
import com.security.spring_security.Services.Twillo;
import com.security.spring_security.Services.UserService;

import jakarta.mail.MessagingException;

@RestController
@CrossOrigin
public class panicControlller {

    @Autowired
    private UserService userService;

    @Autowired
    private EmeregencyService emergencyService;

    @Autowired
    private MessageHelper messageHelper;

    @Autowired
    private Twillo twillo;
   
    
    @PostMapping("/{userId}/location")
    public ResponseEntity<String> fetchLocation(@PathVariable("userId") int userId , 
                                   @RequestBody LocationRequestBody locationRequestBody)
    {
        User user = userService.getUser(userId);

        String location = "Help , I am Not Safe I am currently at here :- " + " " + 
                         "https://www.google.com/maps?q=" + 
                         locationRequestBody.latitude() + "," + locationRequestBody.longitude();
        System.out.println(location);

        return new ResponseEntity<>(twillo.sendSms(user.getEmergencyContacts() , location) , HttpStatus.OK);


    }
    
    @PostMapping("/{userId}/contacts")
    public ResponseEntity<Void> SaveContacts(@PathVariable("userId") int userId , @RequestBody List<EmergencyContact> EmRBody)
    {
        emergencyService.saveContact(userId , EmRBody);
      
        return new ResponseEntity<>(HttpStatus.OK);

    }
    @GetMapping("/{userId}/emergency-contacts")
    public ResponseEntity<List<EmergencyContact>> getContacts(@PathVariable("userId") int userId)
    {
        User user = userService.getUser(userId);
      
        return new ResponseEntity<>(user.getEmergencyContacts() , HttpStatus.OK);

    }

    @DeleteMapping("/{contactId}/Delete")
    public ResponseEntity<Void> deleteContact(@PathVariable("contactId") int contactId)
    {
        emergencyService.DeleteContact(contactId);

        return new ResponseEntity<>(HttpStatus.OK);
    }

    
   
}
