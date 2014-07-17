package com.hair.salon.ui;

import com.hair.salon.R;

import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.EditorInfo;
import android.widget.EditText;
import android.widget.TextView;

public class WithdrawalActivity extends BaseActivity implements OnClickListener{
	private TextView title;
	private TextView back;
	private EditText recharge_numberEt;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.withdrawal_activity);
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("提现申请");
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		
		initView();
	}
	
	private void initView(){
		recharge_numberEt = (EditText)findViewById(R.id.recharge_number);
		recharge_numberEt.setInputType(EditorInfo.TYPE_CLASS_PHONE);
	}
	
	@Override
	public void onClick(View arg0) {
		// TODO Auto-generated method stub
		
	}
}
