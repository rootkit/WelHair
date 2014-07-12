package com.hair.salon.ui;

import com.hair.salon.R;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class MyAccountActivity extends BaseActivity implements OnClickListener {

	
	private TextView mTitle;
	private TextView back;
	
	private RelativeLayout rechargeRl;
	private Button recharge_to_accountBtn;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.my_account_activity);
		mTitle = (TextView)findViewById(R.id.title_txt);
		mTitle.setText("我的账户");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		initView();
	}
	
	private void initView(){
		rechargeRl = (RelativeLayout)findViewById(R.id.recharge);
		recharge_to_accountBtn = (Button)findViewById(R.id.recharge_to_account);
		rechargeRl.setOnClickListener(this);
		recharge_to_accountBtn.setOnClickListener(this);
	}
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch(v.getId()){
			case R.id.recharge:
				Intent intent = new Intent(MyAccountActivity.this,RechargeRecordsActivity.class);
				startActivity(intent);
				break;
			case R.id.recharge_to_account:
				Intent recharge_to_accountintent = new Intent(MyAccountActivity.this,RechargeToAccountActivity.class);
				startActivity(recharge_to_accountintent);
				break;
		}
	}

}

