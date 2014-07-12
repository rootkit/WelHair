package com.hair.salon.ui;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.TextView;

import com.hair.salon.R;

public class AddWorkActivity extends BaseActivity implements OnClickListener {

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

	private ImageView faceLongImge;
	private ImageView faceSquareImge;
	private ImageView faceGuaziImge;
	private ImageView faceCircleImge;
	private ImageView[] arrFaceStyleLabel = {faceLongImge,faceSquareImge,faceGuaziImge,faceCircleImge};
			
	private TextView sexFemaleTv;
	private TextView sexMaleTv;
	private TextView[] arrSexLabel = {sexFemaleTv,sexMaleTv};
	
	private TextView hairStyleShortTv;
	private TextView hairStyleSpreadTv;
	private TextView hairStyleModdleTv;
	private TextView hairStyleLongTv;
	private TextView[] arrHairStyleLabel = {hairStyleShortTv,hairStyleSpreadTv,hairStyleModdleTv,hairStyleLongTv};
	
	private TextView hairAmountLittleTv;
	private TextView hairAmountGeneralTv;
	private TextView hairAmountLargeTv;
	private TextView[] arrHairAmountLabel = {hairAmountLittleTv,hairAmountGeneralTv,hairAmountLargeTv};
	
	private int[] arrFaceShape = {R.id.face_long,R.id.face_square,R.id.face_guazi,R.id.face_circle};
	private int[] arrFaceNormal = {R.drawable.face_style_long_normal,R.drawable.face_style_square_normal,R.drawable.face_style_guazi_normal,R.drawable.face_style_circle_normal};
	private int[] arrFaceSelected = {R.drawable.face_style_long_selected,R.drawable.face_style_square_selected,R.drawable.face_style_guazi_selected,R.drawable.face_style_circle_selected};
	private int[] arrSex = {R.id.sex_female,R.id.sex_male};
	private int[] arrHairStyle = {R.id.hair_style_short,R.id.hair_style_spread,R.id.hair_style_moddle,R.id.hair_style_long};
	private int[] arrHairAmount = {R.id.hair_amount_little,R.id.hair_amount_general,R.id.hair_amount_large};
	
	
	
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.add_work);
		initView();
	}

	private void initView() {
		
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("添加作品");
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
		
		int faceStyleLen = arrFaceStyleLabel.length;
		for(int i = 0;i < faceStyleLen;i++){
			arrFaceStyleLabel[i] = (ImageView) findViewById(arrFaceShape[i]);
			arrFaceStyleLabel[i].setOnClickListener(new FaceStyleClick());
		}
		
		int sexLabelLen = arrSexLabel.length;
		for(int i = 0;i < sexLabelLen;i++){
			arrSexLabel[i] = (TextView) findViewById(arrSex[i]);
			arrSexLabel[i].setOnClickListener(new ChangeBgClick(arrSexLabel[i],arrSexLabel));
		}
		
		int hairStyleLabelLen = arrHairStyleLabel.length;
		for(int i = 0;i < hairStyleLabelLen;i++){
			arrHairStyleLabel[i] = (TextView) findViewById(arrHairStyle[i]);
			arrHairStyleLabel[i].setOnClickListener(new ChangeBgClick(arrHairStyleLabel[i],arrHairStyleLabel));
		}
		
		int hairAmountLabelLen = arrHairAmountLabel.length;
		for(int i = 0;i < hairAmountLabelLen;i++){
			arrHairAmountLabel[i] = (TextView) findViewById(arrHairAmount[i]);
			arrHairAmountLabel[i].setOnClickListener(new ChangeBgClick(arrHairAmountLabel[i],arrHairAmountLabel));
		}
	}
	
	/**
	 * 修改选中的控件背景颜色
	 * @author Administrator
	 *
	 */
	class ChangeBgClick implements OnClickListener{
		TextView[] arrLabel;
		TextView selectTv;
		public ChangeBgClick(TextView textView, TextView[] arrSexLabel) {
			// TODO Auto-generated constructor stub
			selectTv = textView;
			arrLabel = arrSexLabel;
		}

		@SuppressLint("ResourceAsColor")
		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			int len = arrLabel.length;
			for(int i = 0;i < len;i++){
				arrLabel[i].setBackgroundColor(Color.parseColor("#FFFFFFFF"));
			}
			selectTv.setBackgroundColor(Color.parseColor("#206BA7"));
		}
	}
	
	/**
	 * 修改脸型的样式
	 */
	class FaceStyleClick implements OnClickListener{
		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			int len = arrFaceShape.length;
			int imgId = v.getId();
			for(int i = 0;i < len;i++){
				if(imgId == arrFaceShape[i]){
					arrFaceStyleLabel[i].setImageResource(arrFaceSelected[i]);
				}else{
					arrFaceStyleLabel[i].setImageResource(arrFaceNormal[i]);
				}
			}
		}}
	
	@Override
	public void onClick(View v) {

		Intent intent = new Intent(AddWorkActivity.this,
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

}
