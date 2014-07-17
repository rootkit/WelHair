package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.List;

import com.hair.salon.R;
import com.hair.salon.adapter.SalonFragmentAdapter;
import com.hair.salon.bean.SalonBean;

import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.AdapterView.OnItemClickListener;

public class SalonDesigersActivity extends BaseActivity implements OnClickListener{

	private ListView mListView;
	private SalonFragmentAdapter mAdapter;
	private List<SalonBean> mList = new ArrayList<SalonBean>();
	private TextView mTitle;
	private TextView back;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.salon_desigers_activity);
		mTitle = (TextView)findViewById(R.id.title_txt);
		mTitle.setText("香格里拉的设计师");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		initView();
	}
	
	private void initView(){
		mListView = (ListView) findViewById(R.id.stylist_list);
		mAdapter = new SalonFragmentAdapter(SalonDesigersActivity.this, mList);
		mListView.setAdapter(mAdapter);
		new GetHairStyleTask().execute();
		mListView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				Intent intent = new Intent(SalonDesigersActivity.this,SalonDetailActivity.class);
				startActivity(intent);
			}
			
		});
	}
	
	private class GetHairStyleTask extends AsyncTask<Void, Void, List<SalonBean>> {

		@Override
		protected List<SalonBean> doInBackground(Void... params) {
			return null;
		}

		@Override
		protected void onPostExecute(List<SalonBean> result) {
			result = new ArrayList<SalonBean>();

			for (int i = 0; i < 10; i++) {
				SalonBean salonBean = new SalonBean();
				mList.add(salonBean);
			}
			mAdapter.notifyDataSetChanged();

			super.onPostExecute(result);
		}
	}
	
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		
	}

}
