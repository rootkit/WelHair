package com.hair.salon.ui;

import com.hair.salon.R;

import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class RechargeToAccountActivity extends BaseActivity implements OnClickListener{

	private TextView mTitle;
	private TextView back;
	
	private Button recharge_to_accountBtn;
	private EditText recharge_numberEt;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.recharge_to_account_activity);
		mTitle = (TextView)findViewById(R.id.title_txt);
		mTitle.setText("账户充值");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		initView();
	}
	
	private void initView(){
		recharge_numberEt = (EditText)findViewById(R.id.recharge_number);
		recharge_numberEt.setInputType(EditorInfo.TYPE_CLASS_PHONE);
	//	recharge_to_accountBtn = (Button)findViewById(R.id.up_to_account);
		//recharge_to_accountBtn.setOnClickListener(this);
	}
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		
	}

}
