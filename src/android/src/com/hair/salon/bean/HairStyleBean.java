package com.hair.salon.bean;

import android.widget.ImageView;

public class HairStyleBean {

	private String id;
	
	private ImageView hairImage;
	
	private ImageView hairDesignImage;
	
	private String hairDesigner;
	
	private String hairDesignerTitle;//ְ��
	
	private String hairSalonName;//����
	
	private String haircollectionNum;//�ղ�
	
	private String hairmessageNum;//��������

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public ImageView getHairImage() {
		return hairImage;
	}

	public void setHairImage(ImageView hairImage) {
		this.hairImage = hairImage;
	}

	public ImageView getHairDesignImage() {
		return hairDesignImage;
	}

	public void setHairDesignImage(ImageView hairDesignImage) {
		this.hairDesignImage = hairDesignImage;
	}

	public String getHairDesigner() {
		return hairDesigner;
	}

	public void setHairDesigner(String hairDesigner) {
		this.hairDesigner = hairDesigner;
	}

	public String getHairDesignerTitle() {
		return hairDesignerTitle;
	}

	public void setHairDesignerTitle(String hairDesignerTitle) {
		this.hairDesignerTitle = hairDesignerTitle;
	}

	public String getHairSalonName() {
		return hairSalonName;
	}

	public void setHairSalonName(String hairSalonName) {
		this.hairSalonName = hairSalonName;
	}

	public String getHaircollectionNum() {
		return haircollectionNum;
	}

	public void setHaircollectionNum(String haircollectionNum) {
		this.haircollectionNum = haircollectionNum;
	}

	public String getHairmessageNum() {
		return hairmessageNum;
	}

	public void setHairmessageNum(String hairmessageNum) {
		this.hairmessageNum = hairmessageNum;
	}
	
}
