package com.dos.finances.bean;

public class MemberBean {
	String id;
	String password;
	String gender;
	String nickname;
	String phone;
	String zip_code;
	String address1;
	String address2;
	int money;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	
	public String getZip_code() {
		return zip_code;
	}
	public void setZip_code(String zip_code) {
		this.zip_code = zip_code;
	}
	public String getAddress1() {
		return address1;
	}
	public void setAddress1(String address1) {
		this.address1 = address1;
	}
	public String getAddress2() {
		return address2;
	}
	public void setAddress2(String address2) {
		this.address2 = address2;
	}
	public int getMoney() {
		return money;
	}
	public void setMoney(int money) {
		this.money = money;
	}
	
	public void printMemberInfo(){
		System.out.println("\n--------------------------\n");
		System.out.println("###\t"+id+"님의 정보\t###");
		System.out.println("id : " + id);
		System.out.println("gender : " + gender);
		System.out.println("nickName : " + nickname);
		System.out.println("phone : " + phone );
		System.out.println("zip_code : " + zip_code);
		System.out.println("address1 : " + address1);
		System.out.println("address2 : " + address2);
		System.out.println("money : " + money);
		System.out.println("\n--------------------------\n");
	}
}
