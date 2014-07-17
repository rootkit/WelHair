package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.List;
import com.hair.salon.R;
import com.hair.salon.adapter.RechargeRecordsAdapter;
import com.hair.salon.bean.HairStyleBean;
import com.hair.salon.bean.RechargeRecordsBean;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ListView;
import android.widget.TextView;

public class RechargeRecordsActivity extends BaseActivity implements OnClickListener{

	private TextView title;
	private TextView back;
	private ListView mListView;
	private RechargeRecordsAdapter mAdapter;
	private List<RechargeRecordsBean> mList = new ArrayList<RechargeRecordsBean>();
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.recharge_records_activity);
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("充值记录");
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		mListView = (ListView) this.findViewById(R.id.stylist_list);
		mAdapter = new RechargeRecordsAdapter(RechargeRecordsActivity.this, mList);
		mListView.setAdapter(mAdapter);
		new GetHairStyleTask().execute();
		
		
	}
	
	private class GetHairStyleTask extends	AsyncTask<Void, Void, List<RechargeRecordsBean>> {
		
		@Override
		protected List<RechargeRecordsBean> doInBackground(Void... params) {
			return null;
		}

		@Override
		protected void onPostExecute(List<RechargeRecordsBean> result) {
			result = new ArrayList<RechargeRecordsBean>();
			for (int i = 0; i < 10; i++) {
				RechargeRecordsBean rechargeRecordsBean = new RechargeRecordsBean();
				mList.add(rechargeRecordsBean);
			}
			mAdapter.notifyDataSetChanged();
			super.onPostExecute(result);
		}
	}

	@Override
	public void onClick(View arg0) {
		// TODO Auto-generated method stub
		
	}

}
