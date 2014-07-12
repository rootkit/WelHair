package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.List;

import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.hair.salon.R;
import com.hair.salon.adapter.MyServicesAdapter;
import com.hair.salon.adapter.StylistFragmentAdapter;
import com.hair.salon.bean.HairStyleBean;
import com.hair.salon.bean.MyServicesBean;
import com.hair.salon.bean.SalonBean;



public class MyServicesActivity extends BaseActivity implements OnClickListener{

	private TextView title;
	private TextView back;
	private ImageView mServiceAdd;
	
	private ListView mListView;
	private MyServicesAdapter mAdapter;
	private List<MyServicesBean> mList = new ArrayList<MyServicesBean>();
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.services_list_layout);
		
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("服务项目");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		mServiceAdd = (ImageView)findViewById(R.id.title_setting);
		mServiceAdd.setVisibility(View.VISIBLE);
		mServiceAdd.setImageResource(R.drawable.iconfont_add);
		mServiceAdd.setOnClickListener(this);
		
		mListView = (ListView) findViewById(R.id.list);
		//listview.addFooterView(list_footer);
		mAdapter = new MyServicesAdapter(this, mList);
		mListView.setAdapter(mAdapter);
		new GetHairStyleTask().execute();
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
				MyServicesBean myServicesBean = new MyServicesBean();
				mList.add(myServicesBean);
			}
			mAdapter.notifyDataSetChanged();
		
			super.onPostExecute(result);
		}
	}
	
	@Override
	public void onClick(View v) {
		switch(v.getId()){
			case R.id.title_setting:
				Intent intent = new Intent(this,AddServiceActivity.class);
				startActivity(intent);
				break;
			default:
				break;
		}
		
	}
	
}
