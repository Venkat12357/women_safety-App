package com.security.spring_security.Repositiries;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.security.spring_security.Models.EmergencyContact;

@Repository
public interface EmergencyRepo extends JpaRepository<EmergencyContact, Long> {
    

}
