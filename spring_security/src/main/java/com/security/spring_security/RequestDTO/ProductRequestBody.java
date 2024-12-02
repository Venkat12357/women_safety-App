package com.security.spring_security.RequestDTO;

public record ProductRequestBody(String Name, String Description, int Price, int Stock) {
}
