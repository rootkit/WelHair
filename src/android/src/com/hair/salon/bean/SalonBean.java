package com.hair.salon.bean;

import android.widget.ImageView;

public class SalonBean {

	private String id;
	
	private ImageView salonImage;
	
	private String salonName;//����
	
	private String salonAddres;//����
	
	private String salonZanNum;//����
	
	private String latitude;//ά��
	private String longtitude;//����

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public ImageView getSalonImage() {
		return salonImage;
	}

	public void setSalonImage(ImageView salonImage) {
		this.salonImage = salonImage;
	}

	public String getSalonName() {
		return salonName;
	}

	public void setSalonName(String salonName) {
		this.salonName = salonName;
	}

	public String getSalonAddres() {
		return salonAddres;
	}

	public void setSalonAddres(String salonAddres) {
		this.salonAddres = salonAddres;
	}

	public String getSalonZanNum() {
		return salonZanNum;
	}

	public void setSalonZanNum(String salonZanNum) {
		this.salonZanNum = salonZanNum;
	}

	public String getLatitude() {
		return latitude;
	}

	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}

	public String getLongtitude() {
		return longtitude;
	}

	public void setLongtitude(String longtitude) {
		this.longtitude = longtitude;
	}
	
}
