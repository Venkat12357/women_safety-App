package com.security.spring_security.Services;

import com.security.spring_security.Models.Product;
import com.security.spring_security.Repositiries.ProductRepo;
import com.security.spring_security.RequestDTO.ProductRequestBody;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {

    @Autowired
    private ProductRepo repo;

    public void Add(ProductRequestBody productRequestBody) {

        Product prod = new Product();

        int generateId = (int) (Math.random() * 10000);

        prod.setId(generateId);
        prod.setName(productRequestBody.Name());
        prod.setDescription(productRequestBody.Description());
        prod.setPrice(productRequestBody.Price());
        prod.setStock(productRequestBody.Stock());

        repo.save(prod);
    }

    public List<Product> getAll() {

        return repo.findAll();
    }

    public void Update(int Id , ProductRequestBody productRequestBody) {

        Product prod = getProdByID(Id);

        prod.setName(productRequestBody.Name());
        prod.setDescription(productRequestBody.Description());
        prod.setPrice(productRequestBody.Price());
        prod.setStock(productRequestBody.Stock());

        repo.save(prod);
    }

    public Product getProdByID(int id) {

        return repo.findById(id).orElse(new Product());
    }
}
