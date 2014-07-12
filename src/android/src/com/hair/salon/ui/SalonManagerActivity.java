package com.hair.salon.ui;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TextView;

import com.hair.salon.R;

public class SalonManagerActivity extends BaseActivity implements OnClickListener{

	private TextView title;
	private TextView back;
	
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.salon_manager_layout);
		
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("沙龙管理");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
	}


	@Override
	public void onClick(View v) {
		
	}
	
}
