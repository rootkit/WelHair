package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.List;

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
import android.widget.AdapterView.OnItemClickListener;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.hair.salon.R;
import com.hair.salon.adapter.SalonFragmentAdapter;
import com.hair.salon.bean.HairStyleBean;
import com.hair.salon.bean.SalonBean;

public class SalonFragment extends Fragment implements OnClickListener {

	private static final String TAG = "HairFrament";

	private TextView title;
	private ListView mListView;
	private SalonFragmentAdapter mAdapter;
	private List<SalonBean> mList = new ArrayList<SalonBean>();
	private PopupWindow mPopupWindow;
	private TextView salonSelection;
	private LinearLayout mSelectionLayout;
	
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
		
		salonSelection = (TextView) rootView.findViewById(R.id.salon_order);
		salonSelection.setOnClickListener(this);
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
		mPopupWindow = new PopupWindow(view, salonSelection.getWidth(),
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

		mPopupWindow.showAsDropDown(mSelectionLayout,salonSelection.getWidth(),0);
	}
	
	@Override
	public void onClick(View v) {
		switch (v.getId()) {
			case R.id.salon_order:
				showOrderSelectionPopup();
				break;
			}
	}


}
