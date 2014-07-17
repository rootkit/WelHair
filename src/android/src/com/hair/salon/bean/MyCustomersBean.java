package com.hair.salon.bean;

import android.widget.ImageView;
import android.widget.RelativeLayout;

public class MyCustomersBean {
	private ImageView customer_imgIg;
	private String customer_nameTv;
	private String customer_appointment_numberTv;
	private RelativeLayout customer_layoutRl;
	
	
	public RelativeLayout getCustomer_layoutRl() {
		return customer_layoutRl;
	}
	public void setCustomer_layoutRl(RelativeLayout customer_layoutRl) {
		this.customer_layoutRl = customer_layoutRl;
	}
	public ImageView getCustomer_imgIg() {
		return customer_imgIg;
	}
	public void setCustomer_imgIg(ImageView customer_imgIg) {
		this.customer_imgIg = customer_imgIg;
	}
	public String getCustomer_nameTv() {
		return customer_nameTv;
	}
	public void setCustomer_nameTv(String customer_nameTv) {
		this.customer_nameTv = customer_nameTv;
	}
	public String getCustomer_appointment_numberTv() {
		return customer_appointment_numberTv;
	}
	public void setCustomer_appointment_numberTv(
			String customer_appointment_numberTv) {
		this.customer_appointment_numberTv = customer_appointment_numberTv;
	}
	
}
