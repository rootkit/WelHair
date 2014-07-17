package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.List;
import com.hair.salon.R;
import com.hair.salon.adapter.ShowHairAdapter;
import com.hair.salon.bean.ShowHairBean;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

public class ShowHairActivity extends BaseActivity implements OnClickListener{

	private TextView mTitle;
	private TextView back;
	private ImageView title_settingIg;
	private ListView mListView;
	private ShowHairAdapter mAdapter;
	private List<ShowHairBean> mList = new ArrayList<ShowHairBean>();
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.show_hair_activity);
		mTitle = (TextView)findViewById(R.id.title_txt);
		mTitle.setText("秀美发");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		title_settingIg = (ImageView)findViewById(R.id.title_setting);
		title_settingIg.setVisibility(View.VISIBLE);
		title_settingIg.setImageResource(R.drawable.iconfont_edit);
		title_settingIg.setOnClickListener(this);
		
		initView();
	}
	
	private void initView(){
		mListView = (ListView) this.findViewById(R.id.stylist_list);
		mAdapter = new ShowHairAdapter(ShowHairActivity.this, mList);
		mListView.setAdapter(mAdapter);
		new GetHairStyleTask().execute();
	}
	
	
private class GetHairStyleTask extends	AsyncTask<Void, Void, List<ShowHairBean>> {
		
		@Override
		protected List<ShowHairBean> doInBackground(Void... params) {
			return null;
		}

		@Override
		protected void onPostExecute(List<ShowHairBean> result) {
			result = new ArrayList<ShowHairBean>();
			for (int i = 0; i < 10; i++) {
				ShowHairBean showHairBean = new ShowHairBean();
				mList.add(showHairBean);
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
				Intent intent = new Intent(ShowHairActivity.this,CustomerDataActivity.class);
				startActivity(intent);
				break;
		}
	}

}
