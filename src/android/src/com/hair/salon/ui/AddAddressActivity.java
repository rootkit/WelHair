package com.hair.salon.ui;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.hair.salon.R;

public class AddAddressActivity extends BaseActivity implements OnClickListener{

	private TextView title;
	private TextView mSubmit;
	private TextView back;
	
	private EditText city_nameEv;
	private EditText receive_nameEv;
	private EditText phone_numberEv;
	private EditText detail_addressEv;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.add_address_layout);
	    
		title = (TextView)findViewById(R.id.title_txt);
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		mSubmit = (TextView)findViewById(R.id.title_submit);
		mSubmit.setVisibility(View.VISIBLE);
		mSubmit.setText("保存");
		
		initView();
		
		Intent intent=getIntent();
	    String dealSign=intent.getStringExtra("deal");
		if(dealSign.equals("addAddress")){
			title.setText("添加收货地址");
		}else if(dealSign.equals("editAddress")){
			title.setText("编辑收货地址");
		}
	}

	private void initView(){
		city_nameEv = (EditText)findViewById(R.id.city_name);
		receive_nameEv = (EditText)findViewById(R.id.receive_name);
		phone_numberEv = (EditText)findViewById(R.id.phone_number);
		detail_addressEv = (EditText)findViewById(R.id.detail_address);
	}

	@Override
	public void onClick(View v) {
		switch(v.getId()){
		case R.id.city_name:
			Intent intent = new Intent(AddAddressActivity.this,CitySelectActivity.class);
			startActivity(intent);
			break;
		case R.id.title_submit:
			break;
		}
		
	}
	
}
