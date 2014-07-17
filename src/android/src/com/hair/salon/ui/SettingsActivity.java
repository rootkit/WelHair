package com.hair.salon.ui;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.hair.salon.R;

public class SettingsActivity extends BaseActivity implements OnClickListener{

	
	private TextView mTitle;
	private TextView join_salonTv;
	private TextView myAddress;
	private TextView back;
	
	private TextView exchange_integralTv;
	private TextView return_opinionTv;
	private TextView version_updateTv;
	private TextView score_to_usTv;
	
	private ImageView customer_imgIg;
	private Button out_loginBtn;
	private Button btn_loginBtn;
	private LinearLayout user_msg_layoutLl;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.setting_main);
		mTitle = (TextView)findViewById(R.id.title_txt);
		mTitle.setText("设置");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		initView();
		
	}
	
	private void initView(){
		join_salonTv = (TextView)findViewById(R.id.join_salon);
		join_salonTv.setOnClickListener(this);
		myAddress = (TextView)findViewById(R.id.my_address);
		myAddress.setOnClickListener(this);
		
		exchange_integralTv = (TextView)findViewById(R.id.exchange_integral);
		exchange_integralTv.setOnClickListener(this);
		return_opinionTv = (TextView)findViewById(R.id.return_opinion);
		return_opinionTv.setOnClickListener(this);
		version_updateTv = (TextView)findViewById(R.id.version_update);
		version_updateTv.setOnClickListener(this);
		score_to_usTv = (TextView)findViewById(R.id.score_to_us);
		score_to_usTv.setOnClickListener(this);
		
		customer_imgIg = (ImageView)findViewById(R.id.customer_img);
		customer_imgIg.setOnClickListener(this);
		
		out_loginBtn = (Button)findViewById(R.id.out_login);
		out_loginBtn.setOnClickListener(this);
		
		btn_loginBtn = (Button)findViewById(R.id.btn_login);
		btn_loginBtn.setOnClickListener(this);
		user_msg_layoutLl = (LinearLayout)findViewById(R.id.user_msg_layout);
	}

	@Override
	public void onClick(View v) {
		switch(v.getId()){
		case R.id.join_salon:
			Intent intent = new Intent(SettingsActivity.this,ChooseSalonActivity.class);
			startActivity(intent);
			break;
		case R.id.my_address:
			Intent addressIntent = new Intent(this,MyAddressActivity.class);
			startActivity(addressIntent);
			break;
		case R.id.exchange_integral:
			Toast.makeText(getApplicationContext(), "敬请期待", Toast.LENGTH_LONG).show();
			break;
		case R.id.return_opinion:
			Intent opinionIntent = new Intent(this,UserOpinionActivity.class);
			startActivity(opinionIntent);
			break;
		case R.id.version_update:
			Toast.makeText(getApplicationContext(), "版本更新", Toast.LENGTH_LONG).show();
			break;
		case R.id.score_to_us:
			Toast.makeText(getApplicationContext(), "给我们打分", Toast.LENGTH_LONG).show();
			break;
		case R.id.customer_img:
			Intent selfmessageIntent = new Intent(this,SelfMessageActivity.class);
			startActivity(selfmessageIntent);
			break;
		case R.id.btn_login:
			Intent outloginIntent = new Intent(this,LoginActivity.class);
			startActivity(outloginIntent);
			break;
		case R.id.out_login:
			btn_loginBtn.setVisibility(View.VISIBLE);
			user_msg_layoutLl.setVisibility(View.GONE);
			break;
	}
		
		
	}
	
}
