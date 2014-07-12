package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.List;

import android.content.Intent;
import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.AdapterView.OnItemClickListener;

import com.hair.salon.R;
import com.hair.salon.adapter.StylistFragmentAdapter;
import com.hair.salon.bean.HairStyleBean;
import com.hair.salon.bean.SalonBean;

public class MyCollectionInfoActivity extends BaseActivity implements OnClickListener{
	
	private TextView title;
	private TextView back;
	
	private TextView collection_zuopinsTv;
	private TextView collection_salonsTv;
	private TextView collection_designersTv;
	private TextView collection_productionsTv;
	private LinearLayout llTab;
	
	private ListView mListView;
	private StylistFragmentAdapter mAdapter;
	private List<SalonBean> mList = new ArrayList<SalonBean>();
	
	int[] arrTbIds = {R.id.collection_zuopins,R.id.collection_salons,R.id.collection_designers,R.id.collection_productions};
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.collection_main);
		
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("收藏");
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		initView();
	}
	
	private void initView(){
		collection_zuopinsTv = (TextView)findViewById(R.id.collection_zuopins);
		collection_salonsTv = (TextView)findViewById(R.id.collection_salons);
		collection_designersTv = (TextView)findViewById(R.id.collection_designers);
		collection_productionsTv = (TextView)findViewById(R.id.collection_productions);
		llTab = (LinearLayout) this.findViewById(R.id.title_label);
		
		collection_zuopinsTv.setOnClickListener(this);
		collection_salonsTv.setOnClickListener(this);
		collection_designersTv.setOnClickListener(this);
		collection_productionsTv.setOnClickListener(this);
		
		collection_designersTv.setBackgroundColor(Color.parseColor("#206BA7"));
		collection_designersTv.setTextColor(Color.parseColor("#FFFFFFFF"));
		
		mListView = (ListView) this.findViewById(R.id.stylist_list);
		mAdapter = new StylistFragmentAdapter(MyCollectionInfoActivity.this, mList);
		mListView.setAdapter(mAdapter);
		new GetHairStyleTask().execute();
		mListView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				Intent intent = new Intent(MyCollectionInfoActivity.this,StylistDetailActivity.class);
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
	
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch(v.getId()){
			case R.id.collection_zuopins:
				changeBgColor(R.id.collection_zuopins);
				break;
			case R.id.collection_salons:
				changeBgColor(R.id.collection_salons);
				break;
			case R.id.collection_designers:
				changeBgColor(R.id.collection_designers);
				break;
			case R.id.collection_productions:
				changeBgColor(R.id.collection_productions);
				break;
		}
	}
	
	
	private void changeBgColor(int id){
		TextView tvObj;
		int len = arrTbIds.length;
		
		for(int j = 0;j < len;j++){
			tvObj = (TextView)findViewById(arrTbIds[j]);
			if(id == arrTbIds[j]){
				tvObj.setBackgroundColor(Color.parseColor("#206BA7"));
				tvObj.setTextColor(Color.parseColor("#FFFFFFFF"));
			}else{
				tvObj.setBackgroundColor(Color.parseColor("#FFFFFFFF"));
				tvObj.setTextColor(Color.parseColor("#206BA7"));
			}
		}
		llTab.setBackgroundColor(Color.parseColor("#206BA7"));
	}
	
}
