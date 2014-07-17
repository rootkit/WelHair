package com.hair.salon.ui;

import com.hair.salon.R;

import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.TextView;

public class ProductionTuWenXiangQingActivity extends BaseActivity implements OnClickListener {

	private TextView title;
	private TextView mSubmit;
	private TextView back;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		
		super.onCreate(savedInstanceState);  
	    setContentView(R.layout.production_tuwenxiangqing_activity);  

	    
	    title = (TextView)findViewById(R.id.title_txt);
		title.setText("商品");
		
		mSubmit = (TextView)findViewById(R.id.title_submit);
		mSubmit.setVisibility(View.VISIBLE);
		mSubmit.setText("完成");
		mSubmit.setOnClickListener(this);
		
	   /* WebView wView = (WebView)findViewById(R.id.wv1);     
	    WebSettings wSet = wView.getSettings();     
	    wSet.setJavaScriptEnabled(true);     
	                 
	    //wView.loadUrl("file:///android_asset/index.html");    
	    //wView.loadUrl("content://com.android.htmlfileprovider/sdcard/index.html");  
	    wView.loadUrl("http://baike.so.com/doc/5663567.html"); */
	}

	
	
	@Override
	public void goBack(View view) {
		// TODO Auto-generated method stub
	}



	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch(v.getId()){
			case R.id.title_submit:
				ProductionTuWenXiangQingActivity.this.finish();
				break;
		}
	}
	 
}
