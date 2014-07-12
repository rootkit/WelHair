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
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.GridView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.TextView;
import android.widget.Toast;

import com.hair.salon.R;
import com.hair.salon.adapter.HairFragmentAdapter;
import com.hair.salon.bean.HairStyleBean;

public class HairFragment extends Fragment implements OnClickListener {

	private static final String TAG = "HairFrament";

	private LinearLayout mSelectionLayout;
	private TextView title;
	private TextView hairStyleSelection;
	private TextView hairSexSelection;
	private TextView hairOrderSelection;
	private TextView cityName;
	private GridView mGridView;
	private HairFragmentAdapter mAdapter;

	private List<HairStyleBean> mList = new ArrayList<HairStyleBean>();

	private PopupWindow mPopupWindow;

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
		View rootView = inflater.inflate(R.layout.hair_fragment, container,false);

		title = (TextView)rootView.findViewById(R.id.title_txt);
		title.setText("发型");
		//rootView.findViewById(R.id.title_back).setVisibility(View.GONE);
		cityName = (TextView)rootView.findViewById(R.id.title_back);
				cityName.setText("济南");
		mSelectionLayout = (LinearLayout) rootView.findViewById(R.id.hair_selection_layout);

		hairStyleSelection = (TextView) rootView.findViewById(R.id.hair_selection_style);
		hairSexSelection = (TextView) rootView.findViewById(R.id.hair_selection_sex);
		hairOrderSelection = (TextView) rootView.findViewById(R.id.hair_selection_order);

		hairStyleSelection.setOnClickListener(this);
		hairSexSelection.setOnClickListener(this);
		hairOrderSelection.setOnClickListener(this);
		cityName.setOnClickListener(this);
		mGridView = (GridView) rootView.findViewById(R.id.hair_style_grid);

		mAdapter = new HairFragmentAdapter(getActivity(), mList);

		mGridView.setAdapter(mAdapter);

		new GetHairStyleTask().execute();

		 mGridView.setOnItemClickListener(new OnItemClickListener() {
		
		 @Override
		 public void onItemClick(AdapterView<?> parent, View view,
		 int position, long id) {
			 Intent intent = new Intent(getActivity(),HairDetailActivity.class);
			 getActivity().startActivity(intent);
			 //Toast.makeText(getActivity(),position+"", Toast.LENGTH_LONG).show();
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
				HairStyleBean hairStyleBean = new HairStyleBean();
				mList.add(hairStyleBean);
			}
			mAdapter.notifyDataSetChanged();

			super.onPostExecute(result);
		}
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.hair_selection_style:
			showHairSelectionPopup();
			break;
		case R.id.hair_selection_sex:
			showSexSelectionPopup();
			break;
		case R.id.hair_selection_order:
			showOrderSelectionPopup();
			break;
		case R.id.title_back:
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
		mPopupWindow = new PopupWindow(view, hairOrderSelection.getWidth(),
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

		mPopupWindow.showAsDropDown(mSelectionLayout,hairSexSelection.getWidth()*2,0);
	}
	
	/**
	 * 性别
	 */
	private void showSexSelectionPopup() {
		LayoutInflater mLayoutInflater = (LayoutInflater) getActivity()
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View view = mLayoutInflater.inflate(R.layout.hair_sex_selcet_popup,
				null);
		mPopupWindow = new PopupWindow(view, hairSexSelection.getWidth()*2,
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

		mPopupWindow.showAsDropDown(mSelectionLayout,hairStyleSelection.getWidth(),0);
	}
	
	/**
	 * 发质
	 */
	private void showHairSelectionPopup() {
		LayoutInflater mLayoutInflater = (LayoutInflater) getActivity()
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View view = mLayoutInflater.inflate(R.layout.hair_style_selcet_popup,
				null);
		mPopupWindow = new PopupWindow(view, LayoutParams.MATCH_PARENT,
				LayoutParams.WRAP_CONTENT);
		// ���ý����ڵ�����
		mPopupWindow.setFocusable(true);
		// ����������������ʧ
		mPopupWindow.setOutsideTouchable(true);
		// �����Ϊ�˵�����Back��Ҳ��ʹ����ʧ�����Ҳ�����Ӱ����ı���?
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

		mPopupWindow.showAsDropDown(mSelectionLayout);
	}

	
}
