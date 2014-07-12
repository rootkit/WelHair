package com.hair.salon.bean;

import java.util.HashMap;

import com.hair.salon.common.BaseParser;

import android.content.Context;


public class RequestVo {
	public int requestUrl;
	public int requestService;
	public Context context;
	public HashMap<String, String> requestDataMap;
	public BaseParser<?> jsonParser;

	public RequestVo() {
	}

	public RequestVo(int requestUrl, int requestService, Context context, HashMap<String, String> requestDataMap, BaseParser<?> jsonParser) {
		super();
		this.requestUrl = requestUrl;
		this.requestService = requestService;
		this.context = context;
		this.requestDataMap = requestDataMap;
		this.jsonParser = jsonParser;
	}
}
