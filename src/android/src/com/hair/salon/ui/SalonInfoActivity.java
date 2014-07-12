package com.hair.salon.ui;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.TextView;

import com.hair.salon.R;

public class SalonInfoActivity extends BaseActivity implements OnClickListener{

	private TextView title;
	private TextView back;
	private ImageView salonEditImg;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.salon_info_layout);
		
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("沙龙资料");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		salonEditImg = (ImageView)findViewById(R.id.title_setting);
		salonEditImg.setVisibility(View.VISIBLE);
		salonEditImg.setImageResource(R.drawable.iconfont_xiugai);
		
		salonEditImg.setOnClickListener(this);
	}


	@Override
	public void onClick(View v) {
		Intent intent = new Intent(this,SalonEditActivity.class);
		startActivity(intent);
	}
	
}
