package com.hair.salon.ui;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;

import com.hair.salon.R;
import com.hair.salon.common.Constants;

public class HairDetailActivity extends Activity implements OnClickListener{

	private ImageView mHairDetailImg;
	
	private LinearLayout mHairDetailImgsLayout;

	private TextView title;
	private TextView back;
	
	public void goBack(View view){
		HairDetailActivity.this.finish();
	}
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		 setContentView(R.layout.hair_detail);
		initViews();
	}
	
	private void initViews(){
		
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("作品");
		findViewById(R.id.title_setting).setVisibility(View.VISIBLE);
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		mHairDetailImg = (ImageView)findViewById(R.id.hair_detail_img);
		mHairDetailImg.setImageResource(Constants.imgs[0]);
		mHairDetailImgsLayout = (LinearLayout)findViewById(R.id.hair_detail_img_container);
		LayoutParams params = new LinearLayout.LayoutParams(180, 180);
		for(int i=0;i<Constants.imgs.length;i++){
			ImageView view = new ImageView(this);
			view.setLayoutParams(params);
			view.setPadding(10, 10, 10, 10);
			view.setId(Constants.imgs[i]);
			view.setImageResource(Constants.imgs[i]);
			view.setScaleType(ScaleType.CENTER_CROP);
			view.setOnClickListener(this);
			mHairDetailImgsLayout.addView(view);
		}
		
	}

	@Override
	public void onClick(View v) {
		mHairDetailImg.setImageResource(v.getId());
	}
	
	public void goHairDresser(View view){
		Intent intent = new Intent(this,StylistDetailActivity.class);
		startActivity(intent);
	}
}
