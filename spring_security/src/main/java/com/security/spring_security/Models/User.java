package com.security.spring_security.Models;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonManagedReference;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;

@Entity
public class User {

    public User() {
    }
    
    @Id
    private int Id;
    private String userName;
    private String password;


   @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
   @JsonManagedReference
    private List<EmergencyContact> emergencyContacts;
    
    public int getId() {
        return Id;
    }
    public List<EmergencyContact> getEmergencyContacts() {
        return emergencyContacts;
    }
    public void setEmergencyContacts(List<EmergencyContact> emergencyContacts) {
        this.emergencyContacts = emergencyContacts;
    }
    public void setId(int id) {
        Id = id;
    }

    public String getUserName() {
        return userName;
    }
    public void setUserName(String userName) {
        this.userName = userName;
    }
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    
    
}
