package com.hair.salon.bean;

public class MyServicesBean {
	private String ServiceName;// 服务名称
	private String ServiceOriginalPrice;//原价
	private String ServiceDiscountPrice;//折后价
	public String getServiceName() {
		return ServiceName;
	}
	public void setServiceName(String serviceName) {
		ServiceName = serviceName;
	}
	public String getServiceOriginalPrice() {
		return ServiceOriginalPrice;
	}
	public void setServiceOriginalPrice(String serviceOriginalPrice) {
		ServiceOriginalPrice = serviceOriginalPrice;
	}
	public String getServiceDiscountPrice() {
		return ServiceDiscountPrice;
	}
	public void setServiceDiscountPrice(String serviceDiscountPrice) {
		ServiceDiscountPrice = serviceDiscountPrice;
	}
	
	
}
