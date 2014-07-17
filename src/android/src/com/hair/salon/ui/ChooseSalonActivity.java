package com.hair.salon.ui;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.RelativeLayout;
import android.widget.TextView;
import com.hair.salon.R;

public class ChooseSalonActivity extends BaseActivity implements OnClickListener{

	private TextView title;
	private TextView back;
	private RelativeLayout join_salon_layoutRl;
	private RelativeLayout create_salon_layoutRl;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.choose_salon_activity);
		
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("请选择");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		initView();
	}
	
	private void initView(){
		join_salon_layoutRl = (RelativeLayout)findViewById(R.id.join_salon_layout);
		join_salon_layoutRl.setOnClickListener(this);
		create_salon_layoutRl = (RelativeLayout)findViewById(R.id.create_salon_layout);
		create_salon_layoutRl.setOnClickListener(this);
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch(v.getId()){
			case R.id.join_salon_layout:
				Intent intent = new Intent(this,JoinInSalonActivity.class);
				startActivity(intent);
				break;
			case R.id.create_salon_layout:
				Intent createintent = new Intent(this,CreateSalonActivity.class);
				startActivity(createintent);
				break;
			default:
				break;
		}
	}
}