package com.hair.salon.ui;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.TextView;

import com.hair.salon.R;

public class SalonEditActivity extends BaseActivity implements OnClickListener {

	protected static final int SELECT_PICTURE = 0;
	protected static final int SELECT_CAMER = 1;

	private ImageView mImgeAdd1;
	private ImageView mImgeAdd2;
	private ImageView mImgeAdd3;
	private ImageView mImgeAdd4;
	Bitmap bmp;
	private TextView title;
	private TextView titleSumit;
	private TextView back;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.salon_edit);
		initView();
	}

	private void initView() {
		
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("编辑沙龙");
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		titleSumit = (TextView)findViewById(R.id.title_submit);
		titleSumit.setVisibility(View.VISIBLE);
		
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

		Intent intent = new Intent(SalonEditActivity.this,
				SelectPicPopupWindow.class);
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

	public void goLocation(View view){
		Intent intent = new Intent(this,SalonLocationActivity.class);
		startActivity(intent);
	}
}
