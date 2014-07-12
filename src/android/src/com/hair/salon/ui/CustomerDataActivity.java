package com.hair.salon.ui;

import com.hair.salon.R;

import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.TextView;

public class CustomerDataActivity extends BaseActivity implements OnClickListener{

	private TextView mTitle;
	private TextView back;
	private TextView mSubmit;

	private ImageView mImgeAdd1;
	private ImageView mImgeAdd2;
	private ImageView mImgeAdd3;
	private ImageView mImgeAdd4;
	Bitmap bmp;
	
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.customer_data_activity);
		mTitle = (TextView)findViewById(R.id.title_txt);
		mTitle.setText("客户资料");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		mSubmit = (TextView)findViewById(R.id.title_submit);
		mSubmit.setVisibility(View.VISIBLE);
		mSubmit.setText("保存");
	
		mImgeAdd1 = (ImageView) findViewById(R.id.img_add1);
		mImgeAdd2 = (ImageView) findViewById(R.id.img_add2);
		mImgeAdd3 = (ImageView) findViewById(R.id.img_add3);
		mImgeAdd4 = (ImageView) findViewById(R.id.img_add4);
		mImgeAdd1.setOnClickListener(this);
		mImgeAdd2.setOnClickListener(this);
		mImgeAdd3.setOnClickListener(this);
		mImgeAdd4.setOnClickListener(this);
	}
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		Intent intent = new Intent(CustomerDataActivity.this,SelectPicPopupWindow.class);
		switch (v.getId()) {
		case R.id.img_add1:
			startActivityForResult(intent, 1);
			break;
		case R.id.img_add2:
			startActivityForResult(intent, 2);
			break;
		case R.id.img_add3:
			startActivityForResult(intent, 3);
			break;
		case R.id.img_add4:
			startActivityForResult(intent, 4);
			break;
		}
	}

}
