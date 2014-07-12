package com.hair.salon.bean;

import android.widget.TextView;

public class MyAddressBean {
	TextView tv_name; //理发师名
	TextView tv_phone;//电话
	TextView tv_address;//地址
	public TextView getTv_name() {
		return tv_name;
	}
	public void setTv_name(TextView tv_name) {
		this.tv_name = tv_name;
	}
	public TextView getTv_phone() {
		return tv_phone;
	}
	public void setTv_phone(TextView tv_phone) {
		this.tv_phone = tv_phone;
	}
	public TextView getTv_address() {
		return tv_address;
	}
	public void setTv_address(TextView tv_address) {
		this.tv_address = tv_address;
	}
	
}
