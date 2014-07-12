package com.hair.salon.bean;

import android.widget.ImageView;

public class ProductionsBean {
	
	private String id;
	private ImageView productionName;
	private String productionDesc;
	private String productionPrice;
	private String productionDistance;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public ImageView getProductionName() {
		return productionName;
	}
	public void setProductionName(ImageView productionName) {
		this.productionName = productionName;
	}
	public String getProductionDesc() {
		return productionDesc;
	}
	public void setProductionDesc(String productionDesc) {
		this.productionDesc = productionDesc;
	}
	public String getProductionPrice() {
		return productionPrice;
	}
	public void setProductionPrice(String productionPrice) {
		this.productionPrice = productionPrice;
	}
	public String getProductionDistance() {
		return productionDistance;
	}
	public void setProductionDistance(String productionDistance) {
		this.productionDistance = productionDistance;
	}
	
}
