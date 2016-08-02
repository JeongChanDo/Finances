package com.dos.finances.bean;

import java.sql.Timestamp;

public class StockBean2 {
	//price_day에 저장하는 빈 객체
	Timestamp time;
	String code;
	String name;
	int price;
	
	

	
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}

	public Timestamp getTime() {
		return time;
	}
	public void setTime(Timestamp time) {
		this.time = time;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	
	
}
