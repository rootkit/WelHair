package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.List;

import com.hair.salon.R;
import com.hair.salon.adapter.HairFragmentAdapter;
import com.hair.salon.bean.HairStyleBean;
import com.hair.salon.bean.ProductionsBean;

import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.BitmapDrawable;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup.LayoutParams;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemClickListener;

public class ProductionsFragment extends Fragment implements OnClickListener{
	
	private static final String TAG = "ProductionsFragment";
	private LinearLayout mSelectionLayout;
	private TextView title;
	private TextView productionsSelection;
	private ImageView settingImage;
	private GridView mGridView;
	private ProductionsFragmentAdapter mAdapter;
	private List<ProductionsBean> mList = new ArrayList<ProductionsBean>();
	private PopupWindow mPopupWindow;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
	}

	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
	}
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		Log.d(TAG, "onCreateView");
		View rootView = inflater.inflate(R.layout.productions_fragment, container,false);
		title = (TextView)rootView.findViewById(R.id.title_txt);
		title.setText("产品");
		rootView.findViewById(R.id.title_back).setVisibility(View.GONE);
		
		settingImage = (ImageView)rootView.findViewById(R.id.title_setting);
		settingImage.setVisibility(View.VISIBLE);
		settingImage.setImageResource(R.drawable.lucence_add008);
		settingImage.setOnClickListener(this);
		settingImage.setOnClickListener(this);
		
		mSelectionLayout = (LinearLayout) rootView.findViewById(R.id.productions_selection_layout);
		productionsSelection = (TextView) rootView.findViewById(R.id.productions_order);
		productionsSelection.setOnClickListener(this);
		
		mGridView = (GridView) rootView.findViewById(R.id.productions_grid);

		mAdapter = new ProductionsFragmentAdapter(getActivity(), mList);

		mGridView.setAdapter(mAdapter);

		new GetProductionsTask().execute();

		 mGridView.setOnItemClickListener(new OnItemClickListener() {
		
		 @Override
		 public void onItemClick(AdapterView<?> parent, View view,
		 int position, long id) {
			 Intent intent = new Intent(getActivity(),ProductionActivity.class);
			 getActivity().startActivity(intent);
			 //Toast.makeText(getActivity(),position+"", Toast.LENGTH_LONG).show();
		 }
		 });

		return rootView;
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
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
			case R.id.productions_order:
				showOrderSelectionPopup();
				break;
			case R.id.title_setting:
				break;
		}
	}

	
	/**
	 * 排序
	 */
	private void showOrderSelectionPopup(){
		LayoutInflater mLayoutInflater = (LayoutInflater) getActivity()
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View view = mLayoutInflater.inflate(R.layout.hair_order_selcet_popup,
				null);
		mPopupWindow = new PopupWindow(view, productionsSelection.getWidth(),
				LayoutParams.WRAP_CONTENT);
		mPopupWindow.setFocusable(true);
		mPopupWindow.setOutsideTouchable(true);
		mPopupWindow.setBackgroundDrawable(new BitmapDrawable());
		mPopupWindow.setTouchInterceptor(new OnTouchListener() {
			public boolean onTouch(View view, MotionEvent event) {
				if (event.getAction() == MotionEvent.ACTION_OUTSIDE) {
					mPopupWindow.dismiss();
					return true;
				}
				return false;
			}
		});

		mPopupWindow.showAsDropDown(mSelectionLayout,productionsSelection.getWidth(),0);
	}
}
