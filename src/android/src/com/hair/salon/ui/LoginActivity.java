package com.hair.salon.ui;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;
import android.widget.Toast;

import com.hair.salon.R;
import com.hair.salon.common.Constants;

public class LoginActivity extends Activity implements OnClickListener{

	private ImageView outAppImg;
	private TextView zhuceAccountTv;
	private TextView loginTv;
	private ImageView qqImg;
	private ImageView xinlangImg;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_login);
		initViews();
	}
	
	private void initViews(){
		outAppImg = (ImageView) findViewById(R.id.out_app);
		zhuceAccountTv = (TextView) findViewById(R.id.zhuce_account);
		loginTv = (TextView) findViewById(R.id.login_tv);
		qqImg = (ImageView) findViewById(R.id.qq_img);;
		xinlangImg = (ImageView) findViewById(R.id.xinlang_img);;
		
		outAppImg.setOnClickListener(this);
		zhuceAccountTv.setOnClickListener(this);
		loginTv.setOnClickListener(this);
		qqImg.setOnClickListener(this);
		xinlangImg.setOnClickListener(this);
	}
	
	@Override
	public void onClick(View v) {
		switch(v.getId()){
		case R.id.out_app:
			finish();
			break;
		case R.id.zhuce_account:
			Intent intent_zhuce = new Intent(LoginActivity.this,RegisterActivity.class);
			startActivity(intent_zhuce);
			break;
		case R.id.login_tv:
			Intent intent_login = new Intent(LoginActivity.this,MainActivity.class);
			startActivity(intent_login);
			break;
		case R.id.qq_img:
			break;
		case R.id.xinlang_img:
			break;
	}
	}
	
	private long exitTime = 0;
	@Override
	  public boolean onKeyDown(int keyCode, KeyEvent event) {
	   // TODO Auto-generated method stub
		  if(keyCode == KeyEvent.KEYCODE_BACK && event.getAction() == KeyEvent.ACTION_DOWN){
		        if((System.currentTimeMillis()-exitTime) > 2000){  
		            Toast.makeText(getApplicationContext(), "再按一次退出程序", Toast.LENGTH_SHORT).show();                                
		            exitTime = System.currentTimeMillis();   
		        } else {
		            finish();
		           // System.exit(0);
		        }
		        return true;   
		    }
		    return super.onKeyDown(keyCode, event);
	  }
	
	

	
	
	
}
