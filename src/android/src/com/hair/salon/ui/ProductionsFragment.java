package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.List;

import com.hair.salon.R;
import com.hair.salon.adapter.HairFragmentAdapter;
import com.hair.salon.bean.HairStyleBean;
import com.hair.salon.bean.ProductionsBean;
import com.hair.salon.ui.SalonFragment.PopWindowClick;

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
	private TextView productionsAllSelection;
	
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
		
		mSelectionLayout = (LinearLayout) rootView.findViewById(R.id.productions_selection_layout);
		
		productionsAllSelection = (TextView) rootView.findViewById(R.id.productions_all_areas);
		productionsAllSelection.setOnClickListener(this);
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
				Intent nintent = new Intent(getActivity(),QrCodeShowActivity.class);
				getActivity().startActivity(nintent);
				break;
			case R.id.productions_all_areas:
				showAreaSelectionPopup();
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
		String orderContext = productionsSelection.getText().toString();
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
			arrOrderTv[i].setOnClickListener(new PopWindowClick(productionsSelection,arrOrderContext[i]));
		}
		
		
		/*mPopupWindow = new PopupWindow(view, productionsSelection.getWidth(),
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

		mPopupWindow.showAsDropDown(mSelectionLayout,productionsSelection.getWidth(),0);
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
		String areaContext = productionsSelection.getText().toString();
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
			arrAreaTv[i].setOnClickListener(new PopWindowClick(productionsAllSelection,arrAreaContext[i]));
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

		mPopupWindow.showAsDropDown(mSelectionLayout,productionsAllSelection.getWidth(),0);
	}
}
