package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.List;
import com.hair.salon.R;
import com.hair.salon.adapter.MyOrderAdapter;
import com.hair.salon.bean.HairStyleBean;
import com.hair.salon.bean.MyOrderBean;
import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

public class MyOrderActivity extends BaseActivity implements OnClickListener{

	private TextView mTitle;
	private TextView back;
	private LinearLayout llTab;
	
	private TextView pre_payTv;
	private TextView already_payTv;
	int[] arrTbIds = {R.id.pre_pay,R.id.already_pay};
	
	private ListView mListView;
	private MyOrderAdapter mAdapter;
	private List<MyOrderBean> mList = new ArrayList<MyOrderBean>();
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.my_order_activity);
		mTitle = (TextView)findViewById(R.id.title_txt);
		mTitle.setText("订单列表");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		initView();
	}
	
	private void initView(){
		llTab = (LinearLayout) this.findViewById(R.id.title_label);
		pre_payTv = (TextView)findViewById(R.id.pre_pay);
		already_payTv = (TextView)findViewById(R.id.already_pay);
		
		pre_payTv.setOnClickListener(this);
		already_payTv.setOnClickListener(this);
		
		mListView = (ListView) this.findViewById(R.id.stylist_list);
		mAdapter = new MyOrderAdapter(MyOrderActivity.this, mList);
		mListView.setAdapter(mAdapter);
		new GetHairStyleTask().execute();
		changeBgColor(R.id.already_pay);
	}
	
	private class GetHairStyleTask extends	AsyncTask<Void, Void, List<HairStyleBean>> {
		
		@Override
		protected List<HairStyleBean> doInBackground(Void... params) {
			return null;
		}

		@Override
		protected void onPostExecute(List<HairStyleBean> result) {
			result = new ArrayList<HairStyleBean>();
			for (int i = 0; i < 10; i++) {
				MyOrderBean myOrderBean = new MyOrderBean();
				mList.add(myOrderBean);
			}
			mAdapter.notifyDataSetChanged();
			super.onPostExecute(result);
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
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch(v.getId()){
			case R.id.pre_pay:
				changeBgColor(R.id.pre_pay);
				break;
			case R.id.already_pay:
				changeBgColor(R.id.already_pay);
				break;
		}
	}

}
