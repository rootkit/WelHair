package com.hair.salon.ui;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;

import com.hair.salon.R;
import com.hair.salon.common.Constants;

public class RegisterActivity extends BaseActivity implements OnClickListener{

	private TextView niChengTv;
	private TextView loginNameTv;
	private TextView pwdTv;
	private TextView pwdRepeatTv;
	
	private TextView registerGukeTv;
	private TextView registerDresserTv;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_register);
		initViews();
	}
	
	private void initViews(){
		niChengTv = (TextView) findViewById(R.id.login_nicheng_edit);
		loginNameTv = (TextView) findViewById(R.id.login_name_edit);
		pwdTv = (TextView) findViewById(R.id.login_pwd_edit);
		pwdRepeatTv = (TextView) findViewById(R.id.login_repeat_pwd_edit);
		
		
		registerGukeTv = (TextView) findViewById(R.id.register_guke);
		registerDresserTv = (TextView) findViewById(R.id.register_dresser);
		
		
		registerGukeTv.setOnClickListener(this);
		registerDresserTv.setOnClickListener(this);
	}
	
	@Override
	public void onClick(View v) {
		switch(v.getId()){
		case R.id.register_guke:
			break;
		case R.id.register_dresser:
			break;
	}
}
	
	
	

	
	
	
}
