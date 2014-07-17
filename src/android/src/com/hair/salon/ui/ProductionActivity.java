package com.hair.salon.ui;

import com.hair.salon.R;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

public class ProductionActivity extends BaseActivity implements OnClickListener{

	private TextView title;
	private TextView back;
	private ImageView salonEditImg;
	private ImageView heartImg;
	private TextView tuwenxiangqingTv;
	private TextView pinglunTv;
	private TextView buyNumberTv;
	private ImageView addImg;
	private ImageView plusImg;
	private Button buyBtn;
	private LinearLayout llTab;
	private String isCollect ="0";
	
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.production_activity);
		isCollect = "0";
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("商品");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		salonEditImg = (ImageView)findViewById(R.id.title_setting);
		salonEditImg.setVisibility(View.VISIBLE);
		initView();
	}

	private void initView(){
		heartImg = (ImageView) this.findViewById(R.id.hart_img);
		tuwenxiangqingTv = (TextView) this.findViewById(R.id.tuwenxiangqing_tv);
		pinglunTv = (TextView) this.findViewById(R.id.pinglun_tv);
		buyNumberTv = (TextView) this.findViewById(R.id.buy_number);
		addImg = (ImageView) this.findViewById(R.id.plus_img);
		plusImg = (ImageView) this.findViewById(R.id.add_img);
		buyBtn = (Button) this.findViewById(R.id.buy_production);
		llTab = (LinearLayout) this.findViewById(R.id.ll_tab);
		
		heartImg.setOnClickListener(this);
		tuwenxiangqingTv.setOnClickListener(this);
		pinglunTv.setOnClickListener(this);
		addImg.setOnClickListener(this);
		plusImg.setOnClickListener(this);
		buyBtn.setOnClickListener(this);
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch(v.getId()){
			case R.id.hart_img:
				collectClick(heartImg);
				break;
			case R.id.tuwenxiangqing_tv:
				showTuwenxiangqing();
				break;
			case R.id.pinglun_tv:
				showPinglun();
				break;
			case R.id.plus_img:
				plusNumber();
				break;
			case R.id.add_img:
				addNumber();
				break;
			case R.id.buy_production:
				Intent intent = new Intent(ProductionActivity.this,ProductionOrderPreShowActivity.class);
				startActivity(intent);
				break;
			default:
				break;
		}
	}
	
	
	private void collectClick(ImageView hair_heartImg){
		if("0".equals(isCollect)){
			isCollect = "1";
			hair_heartImg.setBackgroundResource(R.drawable.iconfont_xin_full);
		}else{
			isCollect = "0";
			hair_heartImg.setBackgroundResource(R.drawable.lucence_add004);
		}
	}
	
	private void showTuwenxiangqing(){
		/*	tuwenxiangqingTv.setBackgroundColor(Color.parseColor("#206BA7"));
		//tuwenxiangqingTv.setBackgroundResource(R.drawable.toolbar_bg);
		tuwenxiangqingTv.setTextColor(Color.parseColor("#FFFFFFFF"));
		pinglunTv.setBackgroundColor(Color.parseColor("#FFFFFFFF"));
		pinglunTv.setTextColor(Color.parseColor("#206BA7"));
		llTab.setBackgroundColor(Color.parseColor("#206BA7"));*/
		Intent intent = new Intent(ProductionActivity.this,ProductionTuWenXiangQingActivity.class);
		startActivity(intent);
		
		//llTab.setBackground(getResources().getDrawable(R.anim.shape_rounded_rectangle_blue));
		//llTab.setBackground(getResources().getDrawable(R.anim.shape_rounded_rectangle_blue));
	}
	
	private void showPinglun(){
		/*pinglunTv.setBackgroundColor(Color.parseColor("#206BA7"));
		pinglunTv.setTextColor(Color.parseColor("#FFFFFFFF"));
		tuwenxiangqingTv.setBackgroundColor(Color.parseColor("#FFFFFFFF"));
		tuwenxiangqingTv.setTextColor(Color.parseColor("#206BA7"));
		llTab.setBackgroundColor(Color.parseColor("#206BA7"));*/
		//llTab.setBackground(getResources().getDrawable(R.anim.shape_rounded_rectangle_blue));
		Intent intent = new Intent(ProductionActivity.this,OrdersCommentsActivity.class);
		startActivity(intent);
	}

	private void plusNumber(){
		String str = buyNumberTv.getText().toString();
		int originalNum = Integer.parseInt(str);
		if(originalNum > 0){
			originalNum = originalNum -1;
			buyNumberTv.setText(String.valueOf(originalNum));
		}
	}
	
	private void addNumber(){
		String str = buyNumberTv.getText().toString();
		int originalNum = Integer.parseInt(str);
		originalNum = originalNum + 1;
		buyNumberTv.setText(String.valueOf(originalNum));
	}
	
	
}
