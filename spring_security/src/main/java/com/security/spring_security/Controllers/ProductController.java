package com.security.spring_security.Controllers;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.security.spring_security.Models.Product;
import com.security.spring_security.RequestDTO.ProductRequestBody;
import com.security.spring_security.Services.ProductService;

@RestController
@RequestMapping("/products")
@CrossOrigin
public class ProductController {


    private ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @PostMapping("/Add")
    public ResponseEntity<Void> AddProduct(@RequestBody ProductRequestBody productRequestBody)
    {
       productService.Add(productRequestBody);

       return new ResponseEntity<>(HttpStatus.OK);
    }

    @GetMapping("/")
    public ResponseEntity<List<Product>> getAllProducts()
    {

        return new ResponseEntity<>(productService.getAll(), HttpStatus.OK);
    }

    @GetMapping("/{ID}")
    public ResponseEntity<Product> getById(@PathVariable int ID)
    {
        return new ResponseEntity<>(productService.getProdByID(ID), HttpStatus.OK);
    }

    @PutMapping("/{ID}/Add")
    public ResponseEntity<Void> UpdateProduct(@PathVariable("ID") int ID , @RequestBody ProductRequestBody productRequestBody)
    {
        productService.Update(ID , productRequestBody);

        return new ResponseEntity<>(HttpStatus.OK);
    }
}
