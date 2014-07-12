package com.hair.salon.ui;

import com.hair.salon.R;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.TextView;

public class ShowHairActivity extends BaseActivity implements OnClickListener{

	private TextView mTitle;
	private TextView back;
	private ImageView title_settingIg;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.show_hair_activity);
		mTitle = (TextView)findViewById(R.id.title_txt);
		mTitle.setText("秀美发");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		title_settingIg = (ImageView)findViewById(R.id.title_setting);
		title_settingIg.setVisibility(View.VISIBLE);
		title_settingIg.setImageResource(R.drawable.iconfont_edit);
		
		title_settingIg.setOnClickListener(this);
	}
	
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch(v.getId()){
			case R.id.title_setting:
				Intent intent = new Intent(ShowHairActivity.this,CustomerDataActivity.class);
				startActivity(intent);
				break;
		}
	}

}
