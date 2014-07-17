package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.List;
import com.hair.salon.R;
import com.hair.salon.adapter.MyMessagesAdapter;
import com.hair.salon.bean.MyMessagesBean;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.TextView;

public class MyMessagesActivity extends BaseActivity implements OnClickListener{

	private TextView title;
	private TextView back;
	
	private ListView mListView;
	private MyMessagesAdapter mAdapter;
	private List<MyMessagesBean> mList = new ArrayList<MyMessagesBean>();
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		
		super.onCreate(savedInstanceState);
		setContentView(R.layout.my_messages_activity);
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("私信");
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		mListView = (ListView) this.findViewById(R.id.stylist_list);
		mAdapter = new MyMessagesAdapter(MyMessagesActivity.this, mList);
		mListView.setAdapter(mAdapter);
		new GetHairStyleTask().execute();
		
		mListView.setOnItemClickListener(new CustomerItem());
	}
	
	class CustomerItem implements OnItemClickListener{

		@Override
		public void onItemClick(AdapterView<?> adapter, View v, int position,
				long id) {
			// TODO Auto-generated method stub
			//Intent intent = new Intent(MyMessagesActivity.this,CustomerAppointmentActivity.class);
			//startActivity(intent);
		}}
	
	private class GetHairStyleTask extends	AsyncTask<Void, Void, List<MyMessagesBean>> {
		
		@Override
		protected List<MyMessagesBean> doInBackground(Void... params) {
			return null;
		}

		@Override
		protected void onPostExecute(List<MyMessagesBean> result) {
			result = new ArrayList<MyMessagesBean>();
			for (int i = 0; i < 10; i++) {
				MyMessagesBean myMessagesBean = new MyMessagesBean();
				mList.add(myMessagesBean);
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
