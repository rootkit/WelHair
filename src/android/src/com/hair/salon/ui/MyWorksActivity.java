package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;

import com.hair.salon.R;
import com.hair.salon.adapter.MyWorksAdapter;
import com.hair.salon.bean.MyWorksBean;

public class MyWorksActivity extends BaseActivity implements OnClickListener {

	private TextView title;
	private TextView back;
	private ImageView salonEditImg;
	private ImageView addWorkImg;

	/*private ImageView work_photoIg;
	private ImageView work_photo_deleteIg;
	private TextView work_photo_dateTv;*/
	private MyWorksAdapter mAdapter;
	int[] arrPic = { R.drawable.hair_style_img_1,R.drawable.hair_style_img_2,
			R.drawable.hair_style_img_3,R.drawable.hair_style_img_4};
	private GridView mGridView;
	private List<MyWorksBean> mList = new ArrayList<MyWorksBean>();
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.my_works_layout);

		title = (TextView) findViewById(R.id.title_txt);
		title.setText("作品集");
		back = (TextView) findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(
				R.drawable.iconfont_fanhui));
		addWorkImg = (ImageView) findViewById(R.id.title_setting);
		addWorkImg.setVisibility(View.VISIBLE);
		addWorkImg.setImageResource(R.drawable.iconfont_add);

		addWorkImg.setOnClickListener(this);

		initView();
	}

	private void initView() {
		/*work_photoIg = (ImageView) findViewById(R.id.work_photo);
		work_photo_deleteIg = (ImageView) findViewById(R.id.work_photo_delete);
		work_photo_dateTv = (TextView) findViewById(R.id.work_photo_date);

		work_photoIg.setImageResource(R.drawable.hair_style_img_3);
		work_photo_dateTv.setText("2014/07/10");

		work_photoIg.setOnClickListener(this);
		work_photo_deleteIg.setOnClickListener(this);*/
		
		setGridContent();
	}

	private void setGridContent() {
		// 准备要添加的数据条目
		/*List<Map<String, Object>> items = new ArrayList<Map<String, Object>>();
		for (int i = 0; i < arrPic.length; i++) {
			Map<String, Object> item = new HashMap<String, Object>();
			item.put("imageItem", arrPic[i]);
			items.add(item);
		}

		// 实例化一个适配器
		SimpleAdapter adapter = new SimpleAdapter(this, items,
				R.layout.stylist_detail_item, new String[] { "imageItem"}, new int[] { R.id.image_item });
		*/
		mGridView = (GridView) findViewById(R.id.hair_style_grid);
		mAdapter = new MyWorksAdapter(MyWorksActivity.this, mList);
		mGridView.setAdapter(mAdapter);
		new GetProductionsTask().execute();
	}
	
private class GetProductionsTask extends AsyncTask<Void, Void, List<MyWorksBean>> {
		
		@Override
		protected List<MyWorksBean> doInBackground(Void... params) {
			return null;
		}
		
		@Override
		protected void onPostExecute(List<MyWorksBean> result) {
			result = new ArrayList<MyWorksBean>();
			for (int i = 0; i < 5; i++) {
				MyWorksBean myWorksBean = new MyWorksBean();
				mList.add(myWorksBean);
			}
			mAdapter.notifyDataSetChanged();
			super.onPostExecute(result);
		}
	}
	
	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.title_setting:
			Intent intent = new Intent(this, AddWorkActivity.class);
			startActivity(intent);
			break;
		case R.id.work_photo:
			Intent workintent = new Intent(this, HairDetailActivity.class);
			startActivity(workintent);
			break;
		default:
			break;
		}
	}


}
