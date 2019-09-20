package com.hoony.msa.springboot.rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.hoony.msa.domain.model.CoffeeOrderCVO;
import com.hoony.msa.domain.model.OrderStatusDVO;
import com.hoony.msa.springboot.messageq.KafkaProducer;
import com.hoony.msa.springboot.service.CoffeeOrderServiceImpl;
import com.hoony.msa.springboot.service.IMsaServiceCoffeeMember;
import com.hoony.msa.springboot.service.IMsaServiceCoffeeStatus;
import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;

@RestController
public class CoffeeOrderRestController {
	
	@Autowired
	private CoffeeOrderServiceImpl coffeeOrderServiceImpl;
	
	@Autowired
	private KafkaProducer kafkaProducer;
	
	@Autowired
	private IMsaServiceCoffeeMember iMsaServiceCoffeeMember;
	
	@Autowired
	private IMsaServiceCoffeeStatus iMsaServiceCoffeeStatus;
	
	@HystrixCommand
	@RequestMapping(value = "/coffeeOrder", method = RequestMethod.POST)   // post 형식으로 받겠다.
	public ResponseEntity<CoffeeOrderCVO> coffeeOrder(@RequestBody CoffeeOrderCVO coffeeOrderCVO) {    // client로부터 들어오는 데이터 형식
		
	    System.out.println(coffeeOrderCVO);
	    
		//is member
		if(iMsaServiceCoffeeMember.coffeeMember(coffeeOrderCVO.getCustomerName())) {
			System.out.println(coffeeOrderCVO.getCustomerName() + " is a member!");
		}
		
		//coffee order
		coffeeOrderServiceImpl.coffeeOrder(coffeeOrderCVO);

		//kafka
		kafkaProducer.send("hoony-kafka-test", coffeeOrderCVO);
		
		return new ResponseEntity<CoffeeOrderCVO>(coffeeOrderCVO, HttpStatus.OK);
	}
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public ModelAndView coffeeOrderHome(ModelAndView mv) {
	    System.out.println("normal home page");
	    
	    System.out.println(coffeeOrderServiceImpl.coffeeOrderCount());
	    
	    mv.setViewName("test");
	    mv.addObject("orderNumber", coffeeOrderServiceImpl.coffeeOrderCount());
	    
	    return mv;
	}
	
   @PostMapping("coffeeOrderStatus")
    public ResponseEntity<OrderStatusDVO> coffeeOrderStatus() {
       
        //ResponseEntity<OrderStatusDVO> coffeeOrderStatus();
        System.out.println("postOrder");
        return iMsaServiceCoffeeStatus.coffeeOrderStatus();
    }
	 
}
