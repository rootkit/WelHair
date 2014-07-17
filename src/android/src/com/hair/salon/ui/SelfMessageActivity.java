package com.hair.salon.ui;

import com.hair.salon.R;

import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

public class SelfMessageActivity  extends BaseActivity implements OnClickListener{


	private TextView mTitle;
	private TextView back;
	private TextView mSubmit;

	private ImageView mImgeAdd1;
	private ImageView mImgeAdd2;
	private ImageView mImgeAdd3;
	private ImageView mImgeAdd4;
	private ImageView customer_self_imgIg;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.self_message_activity);
		mTitle = (TextView)findViewById(R.id.title_txt);
		mTitle.setText("个人信息");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		mSubmit = (TextView)findViewById(R.id.title_submit);
		mSubmit.setVisibility(View.VISIBLE);
		mSubmit.setText("保存");
		
		initView();
	}
	
	private void initView(){
		mImgeAdd1 = (ImageView) findViewById(R.id.img_add1);
		mImgeAdd2 = (ImageView) findViewById(R.id.img_add2);
		mImgeAdd3 = (ImageView) findViewById(R.id.img_add3);
		mImgeAdd4 = (ImageView) findViewById(R.id.img_add4);
		customer_self_imgIg = (ImageView) findViewById(R.id.customer_self_img);
		mImgeAdd1.setOnClickListener(this);
		mImgeAdd2.setOnClickListener(this);
		mImgeAdd3.setOnClickListener(this);
		mImgeAdd4.setOnClickListener(this);
		customer_self_imgIg.setOnClickListener(this);
	}
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		Intent intent = new Intent(SelfMessageActivity.this,SelectPicPopupWindow.class);
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
		case R.id.customer_self_img:
			startActivityForResult(intent, 5);
			break;
		}
	}
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {

		if (resultCode == RESULT_OK) {
			ImageView photo;
			switch (requestCode) {
			case 1:
				photo = mImgeAdd1;
				break;
			case 2:
				photo = mImgeAdd2;
				break;
			case 3:
				photo = mImgeAdd3;
				break;
			case 4:
				photo = mImgeAdd4;
				break;
			case 5:
				photo = customer_self_imgIg;
				break;
			default:
				photo = mImgeAdd1;
				break;
			}

			if (data != null) {
				Uri mImageCaptureUri = data.getData();
				if (mImageCaptureUri != null) {
					Bitmap image;
					try {
						image = MediaStore.Images.Media.getBitmap(
								this.getContentResolver(), mImageCaptureUri);
						if (image != null) {
							photo.setImageBitmap(image);
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				} else {
					Bundle extras = data.getExtras();
					if (extras != null) {
						Bitmap image = extras.getParcelable("data");
						if (image != null) {
							photo.setImageBitmap(image);
						}
					}
				}
			}

		}
	}

}
