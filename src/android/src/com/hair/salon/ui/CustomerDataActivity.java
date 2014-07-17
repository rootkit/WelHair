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
import android.widget.Toast;

public class CustomerDataActivity extends BaseActivity implements OnClickListener{

	private TextView mTitle;
	private TextView back;
	private TextView mSubmit;
	private EditText comment_contextEdt;
	
	private ImageView mImgeAdd1;
	private ImageView mImgeAdd2;
	private ImageView mImgeAdd3;
	private ImageView mImgeAdd4;
	Bitmap bmp;
	String upPic = "";
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.customer_data_activity);
		mTitle = (TextView)findViewById(R.id.title_txt);
		mTitle.setText("客户资料");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		mSubmit = (TextView)findViewById(R.id.title_submit);
		mSubmit.setVisibility(View.VISIBLE);
		mSubmit.setText("保存");
		mSubmit.setOnClickListener(this);
		
		
		mImgeAdd1 = (ImageView) findViewById(R.id.img_add1);
		mImgeAdd2 = (ImageView) findViewById(R.id.img_add2);
		mImgeAdd3 = (ImageView) findViewById(R.id.img_add3);
		mImgeAdd4 = (ImageView) findViewById(R.id.img_add4);
		mImgeAdd1.setOnClickListener(this);
		mImgeAdd2.setOnClickListener(this);
		mImgeAdd3.setOnClickListener(this);
		mImgeAdd4.setOnClickListener(this);
		
		upPic = "0";
		initView();
	}
	
	/**
	 * 初始化页面控件
	 */
	private void initView(){
		comment_contextEdt = (EditText)findViewById(R.id.comment_context);
	}
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		Intent intent = new Intent(CustomerDataActivity.this,SelectPicPopupWindow.class);
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
		case R.id.title_submit:
			upUserData();
			break;
		default:
			break;
		}
	}
	
	/**
	 * 上传客户资料
	 */
	private void upUserData(){
		String commentContext = comment_contextEdt.getText().toString();
		if("".equals(commentContext) || "".equals(commentContext.replace(" ", ""))){
			Toast.makeText(getApplicationContext(), "请输入点心得吧 :)", Toast.LENGTH_LONG).show();
		}else{
			if("0".equals(upPic)){
				Toast.makeText(getApplicationContext(), "难道你就不想加点图片增强记忆吗?", Toast.LENGTH_LONG).show();
			}else{
				//上传保存
			}
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
				upPic = "1";
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
