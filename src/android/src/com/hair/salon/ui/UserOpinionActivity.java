package com.hair.salon.ui;

import com.hair.salon.R;

import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.TextView;

public class UserOpinionActivity extends BaseActivity implements OnClickListener{

	private TextView mTitle;
	private TextView back;
	private TextView mSubmit;
	private EditText user_optionsEv;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.user_opinion_activity);
		mTitle = (TextView)findViewById(R.id.title_txt);
		mTitle.setText("用户反馈");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		mSubmit = (TextView)findViewById(R.id.title_submit);
		mSubmit.setVisibility(View.VISIBLE);
		mSubmit.setText("发送");
		
		user_optionsEv = (EditText)findViewById(R.id.user_options);
	}
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch(v.getId()){
			case R.id.title_submit:
				break;
			default:
				break;
		}
	}

}
