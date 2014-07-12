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
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.TextView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;

import com.hair.salon.R;
import com.hair.salon.adapter.StylistFragmentAdapter;
import com.hair.salon.bean.HairStyleBean;
import com.hair.salon.bean.SalonBean;

public class HairStylistFragment extends Fragment implements OnClickListener {

	private static final String TAG = "HairFrament";

	private ListView mListView;
	private StylistFragmentAdapter mAdapter;
	private List<SalonBean> mList = new ArrayList<SalonBean>();
	private TextView title;
	private PopupWindow mPopupWindow;
	private TextView stylistSelection;
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
		View rootView = inflater.inflate(R.layout.hair_stylist_fragment, container,
				false);
		title = (TextView)rootView.findViewById(R.id.title_txt);
		rootView.findViewById(R.id.title_back).setVisibility(View.GONE);
		title.setText("发型师");
		
		
		stylistSelection = (TextView) rootView.findViewById(R.id.stylist_order);
		stylistSelection.setOnClickListener(this);
		mSelectionLayout = (LinearLayout) rootView.findViewById(R.id.stylist_top_layout);
		
		mListView = (ListView) rootView.findViewById(R.id.stylist_list);
		mAdapter = new StylistFragmentAdapter(getActivity(), mList);
		mListView.setAdapter(mAdapter);
		new GetHairStyleTask().execute();
		mListView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				Intent intent = new Intent(getActivity(),StylistDetailActivity.class);
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

			for (int i = 0; i < 5; i++) {
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
		mPopupWindow = new PopupWindow(view, stylistSelection.getWidth(),
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

		mPopupWindow.showAsDropDown(mSelectionLayout,stylistSelection.getWidth(),0);
	}
	
	@Override
	public void onClick(View v) {
		switch (v.getId()) {
			case R.id.stylist_order:
				showOrderSelectionPopup();
				break;
		}
	}


}
