package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.List;

import com.hair.salon.R;
import com.hair.salon.adapter.SalonFragmentAdapter;
import com.hair.salon.bean.SalonBean;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ListView;
import android.widget.TextView;

public class JoinInSalonActivity extends BaseActivity implements OnClickListener{

	private TextView title;
	private TextView back;
	private TextView cityName;
	private ListView mListView;
	private SalonFragmentAdapter mAdapter;
	private List<SalonBean> mList = new ArrayList<SalonBean>();
	
	@Override
	public void goBack(View view){
	}
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.join_in_salon_activity);
		
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("请选择");
		
		back = (TextView)findViewById(R.id.title_submit);
		back.setVisibility(View.VISIBLE);
		back.setText("关闭");;
		back.setOnClickListener(this);
		
		cityName = (TextView)findViewById(R.id.title_back);
		cityName.setText("济南");
		
		mListView = (ListView) findViewById(R.id.salon_list);
		mAdapter = new SalonFragmentAdapter(JoinInSalonActivity.this, mList);
		mListView.setAdapter(mAdapter);
		new GetHairStyleTask().execute();
		
		initView();
	}
	
	private void initView(){
		
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
		switch(v.getId()){
			case R.id.title_submit:
				JoinInSalonActivity.this.finish();
				break;
		}
		
	}

}
