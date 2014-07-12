package com.hair.salon.ui;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.TextView;

import com.hair.salon.R;

public class MyWorksActivity extends BaseActivity implements OnClickListener{

	private TextView title;
	private TextView back;
	private ImageView salonEditImg;
	private ImageView addWorkImg;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.my_works_layout);
		
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("作品集");
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		addWorkImg = (ImageView)findViewById(R.id.title_setting);
		addWorkImg.setVisibility(View.VISIBLE);
		addWorkImg.setImageResource(R.drawable.iconfont_add);
		
		addWorkImg.setOnClickListener(this);
	}


	@Override
	public void onClick(View v) {
		switch(v.getId()){
			case R.id.title_setting:
				Intent intent = new Intent(this,AddWorkActivity.class);
				startActivity(intent);
				break;
			default: 
				break; 
		}
		
	}
	
}
