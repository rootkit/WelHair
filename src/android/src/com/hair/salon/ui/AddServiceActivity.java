package com.hair.salon.ui;

import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TextView;

import com.hair.salon.R;

public class AddServiceActivity extends BaseActivity implements OnClickListener{

	private TextView title;
	private TextView back;
	private TextView mSubmit;
	
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.add_service_layout);
		
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("添加服务");
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		mSubmit = (TextView)findViewById(R.id.title_submit);
		mSubmit.setVisibility(View.VISIBLE);
		mSubmit.setText("保存");
		
	}


	@Override
	public void onClick(View v) {
		
	}
	
}
