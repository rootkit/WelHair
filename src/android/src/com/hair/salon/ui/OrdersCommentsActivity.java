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
import com.hair.salon.adapter.MyOrderAdapter;
import com.hair.salon.adapter.OrdersCommentsAdapter;
import com.hair.salon.bean.HairStyleBean;
import com.hair.salon.bean.OrdersCommentsBean;

public class OrdersCommentsActivity extends BaseActivity implements OnClickListener{

	private TextView mTitle;
	private TextView back;
	private ImageView title_settingIg;
	
	private ListView mListView;
	private OrdersCommentsAdapter mAdapter;
	private List<OrdersCommentsBean> mList = new ArrayList<OrdersCommentsBean>();

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.orders_comments_activity);
		mTitle = (TextView)findViewById(R.id.title_txt);
		mTitle.setText("评论");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		title_settingIg = (ImageView)findViewById(R.id.title_setting);
		title_settingIg.setVisibility(View.VISIBLE);
		title_settingIg.setImageResource(R.drawable.iconfont_xiugai);
		title_settingIg.setOnClickListener(this);
		
		mListView = (ListView) this.findViewById(R.id.stylist_list);
		mAdapter = new OrdersCommentsAdapter(OrdersCommentsActivity.this, mList);
		mListView.setAdapter(mAdapter);
		new GetHairStyleTask().execute();
	}
	
	private class GetHairStyleTask extends	AsyncTask<Void, Void, List<OrdersCommentsBean>> {
		
		@Override
		protected List<OrdersCommentsBean> doInBackground(Void... params) {
			return null;
		}

		@Override
		protected void onPostExecute(List<OrdersCommentsBean> result) {
			result = new ArrayList<OrdersCommentsBean>();
			for (int i = 0; i < 10; i++) {
				OrdersCommentsBean ordersCommentsBean = new OrdersCommentsBean();
				mList.add(ordersCommentsBean);
			}
			mAdapter.notifyDataSetChanged();
			super.onPostExecute(result);
		}
	}
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch(v.getId()){
			case R.id.title_setting:
				Intent intent = new Intent(OrdersCommentsActivity.this,OrdersCommentsAddActivity.class);
				startActivity(intent);
				break;
		}
	}

}
