package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
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
import android.widget.AdapterView.OnItemClickListener;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.hair.salon.R;
import com.hair.salon.adapter.SalonFragmentAdapter;
import com.hair.salon.bean.HairStyleBean;
import com.hair.salon.bean.SalonBean;
import com.hair.salon.ui.HairFragment.PopWindowClick;

public class SalonFragment extends Fragment implements OnClickListener {

	private static final String TAG = "HairFrament";

	private TextView title;
	private ListView mListView;
	private SalonFragmentAdapter mAdapter;
	private List<SalonBean> mList = new ArrayList<SalonBean>();
	private PopupWindow mPopupWindow;
	private TextView salonOrderSelection;
	private TextView salonAllSelection;
	private LinearLayout mSelectionLayout;
	
	private TextView default_orderTv;
	private TextView latest_styleTv;
	private TextView latest_welcomeTv;
	
	int[] arrOrderId = {R.id.default_order,R.id.latest_style,R.id.latest_welcome};
	TextView[] arrOrderTv = {default_orderTv,latest_styleTv,latest_welcomeTv};
	String[] arrOrderContext = new String[3];
	
	private TextView all_areaTv;
	private TextView area_oneTv;
	private TextView area_twoTv;
	private TextView area_threeTv;
	private TextView area_fourTv;
	
	int[] arrAreaId = {R.id.all_area,R.id.area_one,R.id.area_two,R.id.area_three,R.id.area_four};
	TextView[] arrAreaTv = {all_areaTv,area_oneTv,area_twoTv,area_threeTv,area_fourTv};
	String[] arrAreaContext = new String[5];
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		Log.d(TAG, "onCreate");
	}

	@Override
	public void onResume() {
		super.onResume();
		Log.d(TAG, "onResume");
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		Log.d(TAG, "onCreateView");
		View rootView = inflater.inflate(R.layout.salon_fragment, container,
				false);
		title = (TextView)rootView.findViewById(R.id.title_txt);
		rootView.findViewById(R.id.title_back).setVisibility(View.GONE);
		title.setText("沙龙");
		
		
		salonAllSelection = (TextView) rootView.findViewById(R.id.salon_all);
		salonAllSelection.setOnClickListener(this);
		salonOrderSelection = (TextView) rootView.findViewById(R.id.salon_order);
		salonOrderSelection.setOnClickListener(this);
		mSelectionLayout = (LinearLayout) rootView.findViewById(R.id.salon_top_layout);
		
		mListView = (ListView) rootView.findViewById(R.id.salon_list);
		mAdapter = new SalonFragmentAdapter(getActivity(), mList);
		mListView.setAdapter(mAdapter);
		new GetHairStyleTask().execute();
		mListView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				Intent intent = new Intent(getActivity(),SalonDetailActivity.class);
				startActivity(intent);
			}
			
		});

		return rootView;
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

	/**
	 * 排序
	 */
	private void showOrderSelectionPopup(){
		LayoutInflater mLayoutInflater = (LayoutInflater) getActivity()
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View view = mLayoutInflater.inflate(R.layout.hair_order_selcet_popup,
				null);
		
		int arrLen = arrOrderTv.length;
		String orderContext = salonOrderSelection.getText().toString();
		for(int i = 0;i < arrLen;i++){
			arrOrderTv[i] = (TextView)view.findViewById(arrOrderId[i]);
			arrOrderContext[i] = arrOrderTv[i].getText().toString();
			if(orderContext.equals(this.getString(R.string.activity_hari_selection_order))){
				
			}else{
				if(orderContext.equals(arrOrderContext[i])){
					arrOrderTv[i].setTextColor(Color.parseColor("#ffff740f"));
				}else{
					arrOrderTv[i].setTextColor(Color.parseColor("#FF888888"));
				}
			}
			arrOrderTv[i].setOnClickListener(new PopWindowClick(salonOrderSelection,arrOrderContext[i]));
		}
		
		/*mPopupWindow = new PopupWindow(view, salonSelection.getWidth(),
				LayoutParams.WRAP_CONTENT);*/
		mPopupWindow = new PopupWindow(view, LayoutParams.MATCH_PARENT,
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

		mPopupWindow.showAsDropDown(mSelectionLayout,salonOrderSelection.getWidth(),0);
	}
	
	class PopWindowClick implements OnClickListener{
		TextView textViewTv;
		String selectedContext;
		public PopWindowClick(TextView textView, String string) {
			// TODO Auto-generated constructor stub
			textViewTv = textView;
			selectedContext = string;
		}

		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			mPopupWindow.dismiss();
			textViewTv.setText(selectedContext);
			
		}}
	
	/**
	 * 全部区域
	 */
	private void showAreaSelectionPopup(){
		LayoutInflater mLayoutInflater = (LayoutInflater) getActivity()
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View view = mLayoutInflater.inflate(R.layout.hair_area_selcet_popup,
				null);
		
		int arrLen = arrAreaTv.length;
		String areaContext = salonAllSelection.getText().toString();
		for(int i = 0;i < arrLen;i++){
			arrAreaTv[i] = (TextView)view.findViewById(arrAreaId[i]);
			arrAreaContext[i] = arrAreaTv[i].getText().toString();
			if(areaContext.equals(this.getString(R.string.all_area_context))){
				
			}else{
				if(areaContext.equals(arrAreaContext[i])){
					arrAreaTv[i].setTextColor(Color.parseColor("#ffff740f"));
				}else{
					arrAreaTv[i].setTextColor(Color.parseColor("#FF888888"));
				}
			}
			arrAreaTv[i].setOnClickListener(new PopWindowClick(salonAllSelection,arrAreaContext[i]));
		}
		
		
		/*mPopupWindow = new PopupWindow(view, salonSelection.getWidth(),
				LayoutParams.WRAP_CONTENT);*/
		mPopupWindow = new PopupWindow(view, LayoutParams.MATCH_PARENT,
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

		mPopupWindow.showAsDropDown(mSelectionLayout,salonAllSelection.getWidth(),0);
	}
	
	@Override
	public void onClick(View v) {
		switch (v.getId()) {
			case R.id.salon_order:
				showOrderSelectionPopup();
				break;
			case R.id.salon_all:
				showAreaSelectionPopup();
				break;
			default:
				break;
			}
	}


}
