package com.hair.salon.ui;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TextView;

import com.hair.salon.R;

public class MySalonActivity extends BaseActivity implements OnClickListener{

	private TextView title;
	private TextView designer;
	private TextView salonManager;
	private TextView salonInfo;
	private TextView back;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.my_salon);
		
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("我的沙龙");
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		designer = (TextView)findViewById(R.id.designer);
		salonManager = (TextView)findViewById(R.id.salon_manager);
		salonInfo = (TextView)findViewById(R.id.salon_info);
		
		designer.setOnClickListener(this);
		salonManager.setOnClickListener(this);
		salonInfo.setOnClickListener(this);
	}


	@Override
	public void onClick(View v) {
		switch(v.getId()){
		case R.id.designer:
			Intent designerIntent = new Intent(this,DesignerActivity.class);
			startActivity(designerIntent);
			break;
		case R.id.salon_manager:
			Intent managerSalonIntent = new Intent(this,SalonManagerActivity.class);
			startActivity(managerSalonIntent);
			break;
		case R.id.salon_info:
			Intent salonInfoIntent = new Intent(this,SalonInfoActivity.class);
			startActivity(salonInfoIntent);
			break;
		}
		
	}
	
}
