package com.hair.salon.ui;

import com.hair.salon.R;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class CustomerAppointmentActivity extends BaseActivity implements OnClickListener{
	
	private TextView title;
	private TextView back;
	private ImageView emailImg;
	
	private ImageView customer_imgIg;
	private TextView customer_nameTv;
	private TextView customer_appointment_numberTv;
	private ImageView work_photoIg;
	private TextView work_photo_dateTv;
	private RelativeLayout customer_layoutRl;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.customer_appointment_activity);
		init();
	}

	private void init() {
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("小刘");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		emailImg = (ImageView)findViewById(R.id.title_setting);
		emailImg.setVisibility(View.VISIBLE);
		emailImg.setImageResource(R.drawable.iconfont_youjian);
		emailImg.setOnClickListener(this);
		
		customer_layoutRl = (RelativeLayout) findViewById(R.id.customer_layout);
		customer_layoutRl.setOnClickListener(this);
		
		initView();
	}
	
	private void initView(){
		customer_imgIg = (ImageView) findViewById(R.id.customer_img);
		customer_nameTv = (TextView) findViewById(R.id.customer_name);
		customer_appointment_numberTv = (TextView) findViewById(R.id.customer_appointment_number);
		work_photoIg = (ImageView) findViewById(R.id.work_photo);
		work_photo_dateTv = (TextView) findViewById(R.id.work_photo_date);
		
		
		customer_imgIg.setImageResource(R.drawable.hair_style_img_7);
		work_photoIg.setImageResource(R.drawable.hair_style_img_3);
		customer_nameTv.setText("小刘");
		customer_appointment_numberTv.setText("累计预约1次");
		work_photo_dateTv.setText("2014/07/10");

	}
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch(v.getId()){
			case R.id.customer_layout:
				Intent intent = new Intent(CustomerAppointmentActivity.this,MyAppointmentInfoActivity.class);
				startActivity(intent);
				break;
		}
	}

}
