package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.List;

import com.hair.salon.R;
import com.hair.salon.adapter.OrdersCommentsAdapter;
import com.hair.salon.bean.OrdersCommentsBean;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.TextView;

public class OrdersCommentsAddActivity extends BaseActivity implements OnClickListener{

	private TextView mTitle;
	private TextView back;
	private TextView mSubmit;
	
	private ImageView mImgeAdd1;
	private ImageView mImgeAdd2;
	private ImageView mImgeAdd3;
	private ImageView mImgeAdd4;
	Bitmap bmp;
	private TextView chapingTv;
	private TextView zhongpingTv;
	private TextView haopingTv;
	int[] arrTbIds = {R.id.chaping,R.id.zhongping,R.id.haoping};
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.orders_comments_add_activity);
		mTitle = (TextView)findViewById(R.id.title_txt);
		mTitle.setText("新评论");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		mSubmit = (TextView)findViewById(R.id.title_submit);
		mSubmit.setVisibility(View.VISIBLE);
		mSubmit.setText("提交");
		
		initView();
		
	}
	
	private void initView(){
		mImgeAdd1 = (ImageView) findViewById(R.id.img_add1);
		mImgeAdd2 = (ImageView) findViewById(R.id.img_add2);
		mImgeAdd3 = (ImageView) findViewById(R.id.img_add3);
		mImgeAdd4 = (ImageView) findViewById(R.id.img_add4);
		mImgeAdd1.setOnClickListener(this);
		mImgeAdd2.setOnClickListener(this);
		mImgeAdd3.setOnClickListener(this);
		mImgeAdd4.setOnClickListener(this);
		
		chapingTv = (TextView)findViewById(R.id.chaping);
		zhongpingTv = (TextView)findViewById(R.id.zhongping);
		haopingTv = (TextView)findViewById(R.id.haoping);
		chapingTv.setOnClickListener(this);
		zhongpingTv.setOnClickListener(this);
		haopingTv.setOnClickListener(this);
	}
	

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		Intent intent = new Intent(OrdersCommentsAddActivity.this,SelectPicPopupWindow.class);
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
			case R.id.chaping:
				changeBgColor(R.id.chaping);
				break;
			case R.id.zhongping:
				changeBgColor(R.id.zhongping);
				break;
			case R.id.haoping:
				changeBgColor(R.id.haoping);
				break;
			default:
				break;
		}
	}

	private void changeBgColor(int id){
		TextView tvObj;
		int len = arrTbIds.length;
		
		for(int j = 0;j < len;j++){
			tvObj = (TextView)findViewById(arrTbIds[j]);
			if(id == arrTbIds[j]){
				//tvObj.setBackgroundColor(Color.parseColor("#206BA7"));
				tvObj.setBackground(getResources().getDrawable(R.anim.shape_rounded_rectangle_bg_blue));
				tvObj.setTextColor(Color.parseColor("#FFFFFFFF"));
			}else{
				//tvObj.setBackgroundColor(Color.parseColor("#FFFFFFFF"));
				tvObj.setBackground(getResources().getDrawable(R.anim.shape_rounded_rectangle));
				tvObj.setTextColor(Color.parseColor("#FF000000"));
			}
		}
	}

}
