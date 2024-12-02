package com.security.spring_security.Services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.security.spring_security.Models.EmergencyContact;
import com.security.spring_security.Models.User;
import com.security.spring_security.Repositiries.EmergencyRepo;
import com.security.spring_security.Repositiries.UserRepo;

@Service
public class EmeregencyService {
    
    @Autowired
    private EmergencyRepo emergencyRepo;

    @Autowired
    private UserRepo userRepo;


    public void saveContact(int userId, List<EmergencyContact> emRBody) {

        User user = userRepo.findById(userId).orElse(new User());
       
        for(EmergencyContact emr : emRBody)
        {
           emr.setUser(user);
           emergencyRepo.save(emr);
        }
    }

    public void DeleteContact(int contactId) {

        emergencyRepo.deleteById((long)contactId);
    }
}
