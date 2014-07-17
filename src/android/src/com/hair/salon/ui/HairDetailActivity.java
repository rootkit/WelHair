package com.hair.salon.ui;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;

import com.hair.salon.R;
import com.hair.salon.common.Constants;

public class HairDetailActivity extends BaseActivity implements OnClickListener{

	private ImageView mHairDetailImg;
	
	private LinearLayout mHairDetailImgsLayout;
	private RelativeLayout comment_layoutRl;
	private ImageView hair_heartImg;
	private TextView title;
	private TextView back;
	private TextView collect_numberTv;
	private String isCollect = "";
	
	/*public void goBack(View view){
		HairDetailActivity.this.finish();
	}*/
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		 setContentView(R.layout.hair_detail);
		 isCollect = "0";
		 title = (TextView)findViewById(R.id.title_txt);
		 title.setText("作品");
		 findViewById(R.id.title_setting).setVisibility(View.VISIBLE);
		 back = (TextView)findViewById(R.id.title_back);
		 back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
			
			
		initViews();
	}
	
	private void initViews(){

		comment_layoutRl = (RelativeLayout)findViewById(R.id.comment_layout);
		comment_layoutRl.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				Intent intent = new Intent(HairDetailActivity.this,OrdersCommentsActivity.class);
				startActivity(intent);
			}});
		collect_numberTv = (TextView)findViewById(R.id.collect_number);
		hair_heartImg = (ImageView)findViewById(R.id.hair_heart);
		hair_heartImg.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if("0".equals(isCollect)){
					isCollect = "1";
					hair_heartImg.setBackgroundResource(R.drawable.iconfont_xin_full);
					changeCollectNum("add");
				}else{
					isCollect = "0";
					hair_heartImg.setBackgroundResource(R.drawable.lucence_add004);
					changeCollectNum("plus");
				}
				
			}});
		
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
	
	private void changeCollectNum(String sign){
		String originalNum = collect_numberTv.getText().toString();
		originalNum = originalNum.substring(1, originalNum.length()-1);
		int num = Integer.parseInt(originalNum);
		String context = "";
		if("add".equals(sign)){
			num = num + 1;
			context = "(" + Integer.toString(num) +")";
			collect_numberTv.setText(context);
		}else if("plus".equals(sign)){
			num = num - 1;
			context = "(" + Integer.toString(num) +")";
			collect_numberTv.setText(context);
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
