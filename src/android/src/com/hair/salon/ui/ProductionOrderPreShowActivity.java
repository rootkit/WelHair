package com.hair.salon.ui;

import com.hair.salon.R;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.TextView;

public class ProductionOrderPreShowActivity extends BaseActivity implements OnClickListener{

	private TextView title;
	private TextView back;
	private ImageView order_preview_imgIg;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.production_order_preshow_activity);
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("订单预览");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		initView();
	}
	
	private void initView(){
		
		order_preview_imgIg = (ImageView) this.findViewById(R.id.order_preview_img);
		order_preview_imgIg.setOnClickListener(this);
	}
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch(v.getId()){
		case R.id.order_preview_img:
			Intent intent = new Intent(ProductionOrderPreShowActivity.this,MyAddressActivity.class);
			startActivity(intent);
			break;
		default:
			break;
		}
		
	}

}
