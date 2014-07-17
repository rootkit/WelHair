package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.List;

import com.hair.salon.R;
import com.hair.salon.adapter.SalonFragmentAdapter;
import com.hair.salon.bean.HairStyleBean;
import com.hair.salon.bean.ProductionsBean;
import com.hair.salon.bean.SalonBean;

import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.AdapterView.OnItemClickListener;

public class SalonProductionsActivity extends BaseActivity implements OnClickListener{

	private TextView mTitle;
	private TextView back;
	private GridView mGridView;
	private ProductionsFragmentAdapter mAdapter;
	private List<ProductionsBean> mList = new ArrayList<ProductionsBean>();
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.salon_productions_activity);
		mTitle = (TextView)findViewById(R.id.title_txt);
		mTitle.setText("香格里拉的商品");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		initView();
	}
	
	private void initView(){
		mGridView = (GridView) findViewById(R.id.productions_grid);
		mAdapter = new ProductionsFragmentAdapter(SalonProductionsActivity.this, mList);
		mGridView.setAdapter(mAdapter);
		new GetProductionsTask().execute();
		mGridView.setOnItemClickListener(new OnItemClickListener() {
		
		 @Override
		 public void onItemClick(AdapterView<?> parent, View view,
		 int position, long id) {
			 Intent intent = new Intent(SalonProductionsActivity.this,ProductionActivity.class);
			 startActivity(intent);
			 //Toast.makeText(getActivity(),position+"", Toast.LENGTH_LONG).show();
		 }
		 });
	}
	
private class GetProductionsTask extends AsyncTask<Void, Void, List<HairStyleBean>> {
		
		@Override
		protected List<HairStyleBean> doInBackground(Void... params) {
			return null;
		}
		
		@Override
		protected void onPostExecute(List<HairStyleBean> result) {
			result = new ArrayList<HairStyleBean>();
			for (int i = 0; i < 10; i++) {
				ProductionsBean productionsBean = new ProductionsBean();
				mList.add(productionsBean);
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
