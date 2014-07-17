package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ListView;
import android.widget.TextView;

import com.hair.salon.R;
import com.hair.salon.adapter.MyAddressAdapter;
import com.hair.salon.adapter.MyServicesAdapter;
import com.hair.salon.bean.HairStyleBean;
import com.hair.salon.bean.MyAddressBean;
import com.hair.salon.bean.MyServicesBean;

public class MyAddressActivity extends BaseActivity implements OnClickListener{

	private TextView title;
	private TextView mSubmit;
	private TextView back;
	private ListView mListView;
	private MyAddressAdapter mAdapter;
	private List<MyAddressBean> mList = new ArrayList<MyAddressBean>();
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.address_list_layout);
		
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("送货地址");
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		mSubmit = (TextView)findViewById(R.id.title_submit);
		mSubmit.setVisibility(View.VISIBLE);
		mSubmit.setText("新建");
		mSubmit.setOnClickListener(this);
		
		initView();
		
	}
	
	private void initView(){
		mListView = (ListView) findViewById(R.id.list);
		//listview.addFooterView(list_footer);
		mAdapter = new MyAddressAdapter(this, mList);
		mListView.setAdapter(mAdapter);
		new GetHairStyleTask().execute();
	}
	

	private class GetHairStyleTask extends
	AsyncTask<Void, Void, List<MyAddressBean>> {

		@Override
		protected List<MyAddressBean> doInBackground(Void... params) {
			return null;
		}
		
		@Override
		protected void onPostExecute(List<MyAddressBean> result) {
			result = new ArrayList<MyAddressBean>();
		
			for (int i = 0; i < 10; i++) {
				MyAddressBean myAddressBean = new MyAddressBean();
				mList.add(myAddressBean);
			}
			mAdapter.notifyDataSetChanged();
		
			super.onPostExecute(result);
		}
	}

	@Override
	public void onClick(View v) {
		switch(v.getId()){
			case R.id.title_submit:
				Intent intent = new Intent(this,AddAddressActivity.class);
				intent.putExtra("deal", "addAddress");
				startActivity(intent);
				break;
			default:
				break;
		}
		
	}
	
}
