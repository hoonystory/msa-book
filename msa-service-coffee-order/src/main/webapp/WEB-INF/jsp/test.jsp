<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	
	<style type = 'text/css'>
		body {
			font-size: 10px;
			font-family: 'consolas';
			width: 100%;
		}
		.orderContainer {
			display: block;
			width: 500px;
			margin: auto;
		}
		.inputText {
			font-size: 10px;
			font-family: 'consolas';
			width: 500px;
			height: 20px;
			margin:auto;
		}
		.inputBox {
			font-size: 10px;
			font-family: 'consolas';
			width: 200px;
			height: 17px;
		}
		.tableSize {
			font-size: 10px;
			width: 500px;
		}
		.id {
			font-size: 10px;
			width: 50px;
		}
		.orderHistory {
			font-size: 10px;
			width: 450px;
		}
	</style>
	
	<script type="text/javascript" src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script type="text/javascript">
		// 주어진 배열에서 요소 1개를 랜덤하게 골라 반환하는 함수
		/*
		function randomItem(a) {
			var idx= Math.floor(Math.random() * a.length);

			console.log(idx);
		  	return a[idx];
		}
		*/
		
		$(document).ready(function() {

			//alert("ready");
			/* 무작위 customerName 출력 */
			var orderId = "";
			var orderName = "";
			var orderNumber = "";
			var randCustomer = new Array( 'kevin', 'cj', 'hoon', 'todd', 'maria', 'olive', 'nets' );
			var idx= Math.floor(Math.random() * randCustomer.length);

			// id 입력			
			orderId += '<input class= "inputBox" type="text" ';
			orderId += 										'value="';
			orderId += 	idx + 1;
			orderId += 												'" name="id">';

			// 랜덤 고객 입력
			orderName += '<input class= "inputBox" type="text" '; 
			orderName += 									'value="';
			orderName += randCustomer[idx];
			orderName += 											'" name="customerName">';

			// 현재 주문번호 입력
			orderNumber += '<input class= "inputBox" type="text" '; 
			orderNumber += 									'value="';
			orderNumber += ${orderNumber} + 1;
			orderNumber += 											'" name="orderNumber">';

			//console.log(orderId);
			//console.log(orderName);
			//console.log(orderNumber);
			
			$("#id").append(orderId);
			$("#customerName").append(orderName);
			$("#orderNumber").append(orderNumber);
		});

		function handleFormSubmit() {

			//console.log($('#orderForm').serializeArray());
			
			//var items = document.getElementsById("orderForm");
			//var items = document.getElementsByClassName("orderForm");
			
			var items = $('#orderForm').serializeObject();
			var json_items = JSON.stringify(items);

			//console.log(items);
			//console.log(json_items);
			
			//alert('submit');

			//return json_items;
			sendData(json_items);
		};

		function sendData(data) {

			$.ajax({
	            type : 'post',
	            contentType : 'application/json',
	            url : '/coffeeOrder',
	            data : data,
	            dataType : 'json',
	            error: function(xhr, status, error){
	                alert(error);
	            },
	            success : function(){
		            console.log('success');
		            console.log(data);
		            /* alert('order accepted'); */

		            // data 가공해서 status 다시 데이터 요청하는 로직
		            // var dataFromOrder = JSON.parse(data);
		            // status의 sql select가 어떤 값을 주는가에 상관없이 무조건 값을 리턴하므로,  
		            var param = { "id": "1", "orderhistory" : ""};
		            console.log(param);
		            sendDataTotatus(JSON.stringify(param));
		            		            
	        	}
			});
		}

		function sendDataTotatus(data) {

			// order server --> status server의 controller를 호출하는 방법에 대해서 알아보자.
			$.ajax({
	            type : 'post',
	            contentType : 'application/json',
	            url : '/coffeeOrderStatus',
	            data : data,
	            dataType : 'json',
	            error: function(xhr, status, error){
	                alert(error);
	            },
	            success : function(){
		            console.log(data);
		            var stat = JSON.parse(data);
		            console.log('stat' + stat);
					var tableData = ' <tr><td>' + stat['id'] + '</td><td>' + stat['orderHistory'] + '</td></tr>';
		            $(".tableSize").append(tableData); 		            		            
	        	}
			});
		}
        
		// jquery 확장
		jQuery.fn.serializeObject = function() {
		    var obj = null;
		    try {

		    	// this[0].tagName이 form tag일 경우
		        if (this[0].tagName && this[0].tagName.toUpperCase() == "FORM") {
		            var arr = this.serializeArray();
		            if (arr) {
		                obj = {};
		                jQuery.each(arr, function() {
		                    obj[this.name] = this.value;
		                });
		            }//if ( arr ) {
		        }
		    } catch (e) {
		        alert(e.message);
		    } finally {
		    }
		 
		    return obj;
		};

	</script>	
<title>MSA Based Coffee-Order Service</title>
</head>
<body>
	<!-- <h1>test.jsp 입니다.</h1> -->
	<!-- <img src = 'http://www.golftimes.co.kr/news/photo/201908/124432_48472_1027.jpg'> -->
	
	<div class='orderContainer'>
		<img src = '/image/twosome.jpg' style='width: 100%; height: auto'>
		
		<!-- coffeeOrder -->
		<form id='orderForm' action=''>
			
			<!-- private String id;
			private String orderNumber; //주문번호 
			private String coffeeName;  //커피종류 
			private String coffeeCount; //커피개수 
			private String customerName;//회원명 --> 
			
			<div class='inputText' id='id'>
				id:
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;
				<!-- <input type='text' name='id'> -->
			</div>
			
			<div class='inputText' id='orderNumber'>
				orderNumber: &nbsp;
				<!-- <input type='text' name='orderNumber'> -->
			</div>
			
			<div class='inputText'>
				coffeeName:
				&nbsp;&nbsp;
				<select class= "inputBox" name='coffeeName' style='width:203px'>
					<option value='americano'>아메리카노</option>
					<option value='latte'>라떼</option>
					<option value='espresso'>에스프레소</option>
				</select>
			</div>
			
			<div class='inputText'>
				coffeeCount: &nbsp;
				<select class= "inputBox" name='coffeeCount' style='width:203px'>
					<option value='1'>1</option>
					<option value='2'>2</option>
					<option value='3'>3</option>
				</select>
			</div>
		
			<div class='inputText' id='customerName'>
				customerName:&nbsp;
			</div>
			
			<br>
			<input class='inputText' type='submit' value='place an Order' onclick='handleFormSubmit();'>

			<div>
				<table class='tableSize'>
					<tr>
						<th class='id'>id</th>
						<th class='orderHistory'>orderHistory</th>
					</tr>
				</table>
			</div>
			
		</form>		
	</div>
	
	<!-- xml config -->	
	<!--<resources mapping="/resources/**" location="/resources/" />
	    <resources mapping="/img/**" location="지정한 업로드 폴더 절대경로" /> -->
    
</body>



</html>