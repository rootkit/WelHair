package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.List;

import android.annotation.SuppressLint;
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

	private TextView default_orderTv;
	private TextView latest_styleTv;
	private TextView latest_welcomeTv;
	
	int[] arrOrderId = {R.id.default_order,R.id.latest_style,R.id.latest_welcome};
	TextView[] arrOrderTv = {default_orderTv,latest_styleTv,latest_welcomeTv};
	String[] arrOrderContext = new String[3];
	
	private TextView hair_style_sex_allTv;
	private TextView hair_style_sex_maleTv;
	private TextView hair_style_sex_femaleTv;
	
	int[] arrSexId = {R.id.hair_style_sex_all,R.id.hair_style_sex_male,R.id.hair_style_sex_female};
	TextView[] arrSexTv = {hair_style_sex_allTv,hair_style_sex_maleTv,hair_style_sex_femaleTv};
	String[] arrSexContext = new String[3];
	
	private TextView hair_style_select_allTv;
	private TextView hair_style_select_shortTv;
	private TextView hair_style_select_longTv;
	private TextView hair_style_select_spreadTv;
	private TextView hair_style_select_middleTv;
	
	int[] arrStyleId = {R.id.hair_style_select_all,R.id.hair_style_select_short,R.id.hair_style_select_long,R.id.hair_style_select_spread,R.id.hair_style_select_middle};
	TextView[] arrStyleTv = {hair_style_select_allTv,hair_style_select_shortTv,hair_style_select_longTv,hair_style_select_spreadTv,hair_style_select_middleTv};
	String[] arrStyleContext = new String[5];
	
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
		default:
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
		
		int arrLen = arrOrderTv.length;
		String orderContext = hairOrderSelection.getText().toString();
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
			arrOrderTv[i].setOnClickListener(new PopWindowClick(hairOrderSelection,arrOrderContext[i]));
		}
		
		mPopupWindow = new PopupWindow(view, hairOrderSelection.getWidth(),
				LayoutParams.WRAP_CONTENT);
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

		mPopupWindow.showAsDropDown(mSelectionLayout,hairSexSelection.getWidth()*2,0);
		
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
	 * 性别
	 */
	private void showSexSelectionPopup() {
		LayoutInflater mLayoutInflater = (LayoutInflater) getActivity()
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View view = mLayoutInflater.inflate(R.layout.hair_sex_selcet_popup,
				null);
		/*mPopupWindow = new PopupWindow(view, hairSexSelection.getWidth()*2,
				LayoutParams.WRAP_CONTENT);*/
		
		int arrLen = arrSexTv.length;
		String sexContext = hairSexSelection.getText().toString();
		for(int i = 0;i < arrLen;i++){
			arrSexTv[i] = (TextView)view.findViewById(arrSexId[i]);
			arrSexContext[i] = arrSexTv[i].getText().toString();
			if(sexContext.equals(this.getString(R.string.activity_hari_selection_sex))){
				
			}else{
				if(sexContext.equals(arrSexContext[i])){
					arrSexTv[i].setTextColor(Color.parseColor("#ffff740f"));
				}else{
					arrSexTv[i].setTextColor(Color.parseColor("#FF888888"));
				}
			}
			arrSexTv[i].setOnClickListener(new PopWindowClick(hairSexSelection,arrSexContext[i]));
		}
		
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

		mPopupWindow.showAsDropDown(mSelectionLayout,hairStyleSelection.getWidth(),0);
		//mPopupWindow.showAsDropDown(mSelectionLayout);
	}
	
	/**
	 * 发质
	 */
	private void showHairSelectionPopup() {
		LayoutInflater mLayoutInflater = (LayoutInflater) getActivity()
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View view = mLayoutInflater.inflate(R.layout.hair_style_selcet_popup,
				null);
		
		
		int arrLen = arrStyleTv.length;
		String styleContext = hairStyleSelection.getText().toString();
		for(int i = 0;i < arrLen;i++){
			arrStyleTv[i] = (TextView)view.findViewById(arrStyleId[i]);
			arrStyleContext[i] = arrStyleTv[i].getText().toString();
			if(styleContext.equals(this.getString(R.string.activity_hari_selection_style))){
				
			}else{
				if(styleContext.equals(arrStyleContext[i])){
					arrStyleTv[i].setTextColor(Color.parseColor("#ffff740f"));
				}else{
					arrStyleTv[i].setTextColor(Color.parseColor("#FF888888"));
				}
			}
			arrStyleTv[i].setOnClickListener(new PopWindowClick(hairStyleSelection,arrStyleContext[i]));
		}
		
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
