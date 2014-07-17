package com.hair.salon.ui;

import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TextView;

import com.hair.salon.R;

public class SalonEarningsActivity extends BaseActivity implements OnClickListener{
	private TextView title;
	private TextView back;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.approval_earnings_activity);
		
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("沙龙收益");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		initView();
	}
	
	private void initView(){
		
	}
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		
	}
}
