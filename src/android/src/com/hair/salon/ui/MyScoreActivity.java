package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.List;

import com.hair.salon.R;
import com.hair.salon.adapter.MyScoreAdapter;
import com.hair.salon.bean.MyScoreBean;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ListView;
import android.widget.TextView;

public class MyScoreActivity extends BaseActivity implements OnClickListener{

	private TextView mTitle;
	private TextView back;
	
	private ListView mListView;
	private MyScoreAdapter mAdapter;
	private List<MyScoreBean> mList = new ArrayList<MyScoreBean>();
	
	String[] arr_desc = {"完成预约","被预约一次","完成订单"};
	String[] arr_date = {"2014-06-13","2014-06-14","2014-06-15"};
	String[] arr_score = {"10","10","15"};
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.my_score_activity);
		mTitle = (TextView)findViewById(R.id.title_txt);
		mTitle.setText("我的积分");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		initView();
	}
	
	private void initView(){
		mListView = (ListView) this.findViewById(R.id.stylist_list);
		mAdapter = new MyScoreAdapter(MyScoreActivity.this, mList);
		mListView.setAdapter(mAdapter);
		new GetHairStyleTask().execute();
	}
	
private class GetHairStyleTask extends	AsyncTask<Void, Void, List<MyScoreBean>> {
		
		@Override
		protected List<MyScoreBean> doInBackground(Void... params) {
			return null;
		}

		@Override
		protected void onPostExecute(List<MyScoreBean> result) {
			result = new ArrayList<MyScoreBean>();
			for (int i = 0; i < arr_desc.length; i++) {
				MyScoreBean myScoreBean = new MyScoreBean();
				myScoreBean.setEvent_descTv(arr_desc[i]);
				myScoreBean.setHappen_dateTv(arr_date[i]);
				myScoreBean.setScore_numberTv("+ "+arr_score[i]);
				mList.add(myScoreBean);
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
