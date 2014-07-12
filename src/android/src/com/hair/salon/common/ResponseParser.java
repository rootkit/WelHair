package com.hair.salon.common;


import org.json.JSONException;

import android.text.TextUtils;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.hair.salon.bean.ResponseVo;

public class ResponseParser extends BaseParser<ResponseVo> {

	private static final String TAG = "RegisterParser";

	@Override
	public ResponseVo parseJSON(String paramString) throws JSONException {
		if(!TextUtils.isEmpty(paramString)){
			ResponseVo paramsInfo = null;
	        Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
	        //反序列化Json数据为 ResponseVo类型
	        paramsInfo = gson.fromJson(paramString, ResponseVo.class);
			return paramsInfo;
		}
		return new ResponseVo();
	}

}
