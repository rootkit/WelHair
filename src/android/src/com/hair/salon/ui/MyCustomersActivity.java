package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.List;

import com.hair.salon.R;
import com.hair.salon.adapter.MyCustomersAdapter;
import com.hair.salon.adapter.RechargeRecordsAdapter;
import com.hair.salon.bean.HairStyleBean;
import com.hair.salon.bean.MyCustomersBean;
import com.hair.salon.bean.RechargeRecordsBean;

import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.TextView;

public class MyCustomersActivity extends BaseActivity implements OnClickListener{

	private TextView title;
	private TextView back;
	
	private ListView mListView;
	private MyCustomersAdapter mAdapter;
	private List<MyCustomersBean> mList = new ArrayList<MyCustomersBean>();
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.my_customers_activity);
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("我的客户");
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		mListView = (ListView) this.findViewById(R.id.stylist_list);
		mAdapter = new MyCustomersAdapter(MyCustomersActivity.this, mList);
		mListView.setAdapter(mAdapter);
		new GetHairStyleTask().execute();
		
		mListView.setOnItemClickListener(new CustomerItem());
	}
	
	class CustomerItem implements OnItemClickListener{

		@Override
		public void onItemClick(AdapterView<?> adapter, View v, int position,
				long id) {
			// TODO Auto-generated method stub
			Intent intent = new Intent(MyCustomersActivity.this,CustomerAppointmentActivity.class);
			startActivity(intent);
		}}
	
	private class GetHairStyleTask extends	AsyncTask<Void, Void, List<MyCustomersBean>> {
		
		@Override
		protected List<MyCustomersBean> doInBackground(Void... params) {
			return null;
		}

		@Override
		protected void onPostExecute(List<MyCustomersBean> result) {
			result = new ArrayList<MyCustomersBean>();
			for (int i = 0; i < 10; i++) {
				MyCustomersBean myCustomersBean = new MyCustomersBean();
				mList.add(myCustomersBean);
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
