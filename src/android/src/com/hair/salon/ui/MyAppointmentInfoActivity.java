package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.List;

import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ListView;
import android.widget.TextView;

import com.hair.salon.R;
import com.hair.salon.adapter.MyAppointmentInfoAdapter;
import com.hair.salon.bean.HairStyleBean;
import com.hair.salon.bean.MyAppointmentInfoBean;

public class MyAppointmentInfoActivity extends BaseActivity implements OnClickListener{

	private TextView title;
	private TextView back;
	
	private ListView mListView;
	private MyAppointmentInfoAdapter mAdapter;
	private List<MyAppointmentInfoBean> mList = new ArrayList<MyAppointmentInfoBean>();
	
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.my_appointment_info);
		
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("预约");
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		mListView = (ListView) this.findViewById(R.id.stylist_list);
		mAdapter = new MyAppointmentInfoAdapter(MyAppointmentInfoActivity.this, mList);
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
				MyAppointmentInfoBean myAppointmentInfoBean = new MyAppointmentInfoBean();
				mList.add(myAppointmentInfoBean);
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
