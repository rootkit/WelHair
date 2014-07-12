package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.List;
import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Toast;
import com.hair.salon.R;
import com.hair.salon.adapter.StylistFragmentAdapter;
import com.hair.salon.bean.HairStyleBean;
import com.hair.salon.bean.SalonBean;

public class SalonDetailActivity extends BaseActivity implements OnClickListener{

	private TextView title;
	private TextView tvDesiginer;
	private TextView tvCommodity;
	private TextView tvComment;
	private ImageView telPhoneImg;
	private ImageView locMapImg;
	private ImageView hartImg;
	private ListView mListView;
	private StylistFragmentAdapter mAdapter;
	private List<SalonBean> mList = new ArrayList<SalonBean>();
	private TextView back;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.salon_detail);
		ImageView imgview = (ImageView)findViewById(R.id.title_setting);
		imgview.setVisibility(View.VISIBLE);
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("香格里拉");
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		initOnclick();
		
		mListView = (ListView) findViewById(R.id.salonDetailListView);
		//listview.addFooterView(list_footer);
		mAdapter = new StylistFragmentAdapter(this, mList);
		mListView.setAdapter(mAdapter);
		new GetHairStyleTask().execute();

		mListView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				Intent intent = new Intent(SalonDetailActivity.this,StylistDetailActivity.class);
				startActivity(intent);
			}
			
		});
	}

	private class GetHairStyleTask extends
	AsyncTask<Void, Void, List<HairStyleBean>> {

		@Override
		protected List<HairStyleBean> doInBackground(Void... params) {
			return null;
		}
		
		@Override
		protected void onPostExecute(List<HairStyleBean> result) {
			result = new ArrayList<HairStyleBean>();
		
			for (int i = 0; i < 10; i++) {
				SalonBean salonBean = new SalonBean();
				mList.add(salonBean);
			}
			mAdapter.notifyDataSetChanged();
		
			super.onPostExecute(result);
		}
	}

	
	private void initOnclick(){
		tvDesiginer = (TextView) this.findViewById(R.id.tv_desiginer);
		tvCommodity = (TextView) this.findViewById(R.id.tv_commodity);
		tvComment = (TextView) this.findViewById(R.id.tv_comment);
		telPhoneImg = (ImageView) this.findViewById(R.id.tel_phone_img);
		locMapImg = (ImageView) this.findViewById(R.id.loc_map_img);
		hartImg = (ImageView) this.findViewById(R.id.hart_img);
		tvDesiginer.setOnClickListener(this);
		tvCommodity.setOnClickListener(this);
		tvComment.setOnClickListener(this);
		telPhoneImg.setOnClickListener(this);
		locMapImg.setOnClickListener(this);
		hartImg.setOnClickListener(this);
	}
	@SuppressLint("ShowToast")
	@Override
	public void onClick(View v) {
		switch(v.getId()){
			case R.id.tv_desiginer:
				Toast.makeText(getApplicationContext(), "设计师", Toast.LENGTH_LONG);
				break;
			case R.id.tv_commodity:
				Toast.makeText(getApplicationContext(), "商品", Toast.LENGTH_LONG);
				break;
			case R.id.tv_comment:
				Toast.makeText(getApplicationContext(), "评论", Toast.LENGTH_LONG);
				break;
			case R.id.tel_phone_img:
				Toast.makeText(getApplicationContext(), "打电话", Toast.LENGTH_LONG);
				break;
			case R.id.loc_map_img:
				Toast.makeText(getApplicationContext(), "地图定位", Toast.LENGTH_LONG);
				break;
			case R.id.hart_img:
				Toast.makeText(getApplicationContext(), "点赞", Toast.LENGTH_LONG);
				break;
		}
	}
	
	public void goBack(View view){
		finish();
	}
	
	public void goLocation(View view){
		Intent intent = new Intent(this,SalonLocationActivity.class);
		startActivity(intent);
	}
}
