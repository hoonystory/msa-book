package com.hoony.msa.springboot.service;

import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.hoony.msa.domain.model.OrderStatusDVO;

@FeignClient("msa-service-coffee-status")
public interface IMsaServiceCoffeeStatus {
    
    @RequestMapping(method = RequestMethod.POST, value = "/coffeeOrderStatus", consumes = "application/json")
    public ResponseEntity<OrderStatusDVO> coffeeOrderStatus();
    
}
