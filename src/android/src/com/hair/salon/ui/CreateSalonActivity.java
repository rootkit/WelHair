package com.hair.salon.ui;

import com.hair.salon.R;

import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.TextView;

public class CreateSalonActivity extends BaseActivity implements OnClickListener{

	private TextView title;
	private TextView back;
	private ImageView mImgeAdd0;
	private ImageView mImgeAdd1;
	private ImageView mImgeAdd2;
	private ImageView mImgeAdd3;
	private ImageView mImgeAdd4;
	Bitmap bmp;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.create_salon_activity);
		
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("添加沙龙");
		
		back = (TextView)findViewById(R.id.title_submit);
		back.setVisibility(View.VISIBLE);
		back.setText("提交");;
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		initView();
	}
	
	private void initView(){
		mImgeAdd0 = (ImageView) findViewById(R.id.img_add0);
		mImgeAdd1 = (ImageView) findViewById(R.id.img_add1);
		mImgeAdd2 = (ImageView) findViewById(R.id.img_add2);
		mImgeAdd3 = (ImageView) findViewById(R.id.img_add3);
		mImgeAdd4 = (ImageView) findViewById(R.id.img_add4);
		mImgeAdd0.setOnClickListener(this);
		mImgeAdd1.setOnClickListener(this);
		mImgeAdd2.setOnClickListener(this);
		mImgeAdd3.setOnClickListener(this);
		mImgeAdd4.setOnClickListener(this);
	}
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		Intent intent = new Intent(CreateSalonActivity.this,SelectPicPopupWindow.class);
		switch (v.getId()) {
		case R.id.img_add0:
			startActivityForResult(intent, 0);
			break;
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
		default:
				break;
		}
	}
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {

		if (resultCode == RESULT_OK) {
			ImageView photo;
			switch (requestCode) {
			case 0:
				photo = mImgeAdd0;
				break;
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
