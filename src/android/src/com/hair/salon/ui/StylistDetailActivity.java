package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.BitmapDrawable;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.DatePicker.OnDateChangedListener;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;
import android.widget.PopupWindow;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.TimePicker.OnTimeChangedListener;

import com.hair.salon.R;
import com.hair.salon.adapter.StylistDetailAdapter;
import com.hair.salon.bean.StylistDetailBean;

public class StylistDetailActivity extends BaseActivity implements OnClickListener {

	private Button makeAppiontment;
	private PopupWindow mPopupWindow;
	private String isCollect ="0";
	private LinearLayout mServiceLayout;

	private TextView checkedServie;
	private TextView servicePrice;
	private TextView cancel;
	private TextView title;
	private TextView back;
	private ImageView emailImg;
	private LinearLayout mysalon_layoutLl;
	private DatePicker date=null;
	private TimePicker time=null;
	private ImageView hartImg;
	private StylistDetailAdapter mAdapter;
	private GridView mGridView;
	private List<StylistDetailBean> mList = new ArrayList<StylistDetailBean>();
	
	int[] arrPic = { R.drawable.hair_style_img_1,R.drawable.hair_style_img_2,
			R.drawable.hair_style_img_3,R.drawable.hair_style_img_4};
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.stylist_detail);
		isCollect = "0";
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("发型师");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		emailImg = (ImageView)findViewById(R.id.title_setting);
		emailImg.setVisibility(View.VISIBLE);
		emailImg.setImageResource(R.drawable.iconfont_youjian);
		emailImg.setOnClickListener(this);
		initView();
	}

	private void initView() {
		
		setGridContent();
		makeAppiontment = (Button) findViewById(R.id.make_appointment);
		makeAppiontment.setOnClickListener(this);
		mysalon_layoutLl = (LinearLayout)findViewById(R.id.mysalon_layout);
		mysalon_layoutLl.setOnClickListener(this);
		hartImg = (ImageView) this.findViewById(R.id.hart_img);
		hartImg.setOnClickListener(this);
	}

	
	private void setGridContent() {
		// 准备要添加的数据条目
		/*List<Map<String, Object>> items = new ArrayList<Map<String, Object>>();
		for (int i = 0; i < arrPic.length; i++) {
			Map<String, Object> item = new HashMap<String, Object>();
			item.put("imageItem", arrPic[i]);
			items.add(item);
		}

		// 实例化一个适配器
		SimpleAdapter adapter = new SimpleAdapter(this, items,
				R.layout.stylist_detail_item, new String[] { "imageItem"}, new int[] { R.id.image_item });
		// 获得GridView实例
		//GridView gridview = (GridView) findViewById(R.id.stylist_detail_grid);
		MyGridView gridview = (MyGridView) findViewById(R.id.stylist_detail_grid); 
		//MyGridView gridview = (MyGridView) findViewById(R.id.stylist_detail_grid);
		//gridview.setNumColumns(3);// 可以在xml中设置
		// 将GridView和数据适配器关联
		gridview.setAdapter(adapter);*/
		mGridView = (GridView) findViewById(R.id.stylist_detail_grid);
		mAdapter = new StylistDetailAdapter(StylistDetailActivity.this, mList);
		mGridView.setAdapter(mAdapter);
		new GetProductionsTask().execute();
	}
	
private class GetProductionsTask extends AsyncTask<Void, Void, List<StylistDetailBean>> {
		
		@Override
		protected List<StylistDetailBean> doInBackground(Void... params) {
			return null;
		}
		
		@Override
		protected void onPostExecute(List<StylistDetailBean> result) {
			result = new ArrayList<StylistDetailBean>();
			for (int i = 0; i < 6; i++) {
				StylistDetailBean stylistDetailBean = new StylistDetailBean();
				mList.add(stylistDetailBean);
			}
			mAdapter.notifyDataSetChanged();
			super.onPostExecute(result);
		}
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.make_appointment:
			showMakeAppointmentPopup();
			break;
		case R.id.cancel:
			mPopupWindow.dismiss();
			break;
		case R.id.submit:
			Intent intent = new Intent(this,MakeAppointmentSubmitActivity.class);
			startActivity(intent);
			break;
		case R.id.title_setting:
			break;
		case R.id.mysalon_layout:
			Intent salonintent = new Intent(StylistDetailActivity.this,SalonDetailActivity.class);
			startActivity(salonintent);
			break;
		case R.id.hart_img:
			collectClick(hartImg);
			break;
		}
	}
	
	private void collectClick(ImageView hair_heartImg){
		if("0".equals(isCollect)){
			isCollect = "1";
			hair_heartImg.setBackgroundResource(R.drawable.iconfont_xin_full);
		}else{
			isCollect = "0";
			hair_heartImg.setBackgroundResource(R.drawable.lucence_add004);
		}
	}

	private void showMakeAppointmentPopup() {
		LayoutInflater mLayoutInflater = (LayoutInflater) this
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View view = mLayoutInflater.inflate(R.layout.make_appointment_popup,
				null);
		mPopupWindow = new PopupWindow(view, LayoutParams.MATCH_PARENT,
				LayoutParams.WRAP_CONTENT);
		
		title = (TextView)view.findViewById(R.id.title_txt);
		title.setText("发型师");
		back =  (TextView)view.findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		emailImg = (ImageView)view.findViewById(R.id.title_setting);
		emailImg.setVisibility(View.VISIBLE);
		emailImg.setImageResource(R.drawable.iconfont_youjian);
		emailImg.setOnClickListener(this);
		
		mServiceLayout = (LinearLayout) view.findViewById(R.id.service_layout);
		servicePrice = (TextView) view.findViewById(R.id.service_price);
		cancel = (TextView) view.findViewById(R.id.cancel);
		cancel.setOnClickListener(this);
		
		view.findViewById(R.id.submit).setOnClickListener(this);
		
		initService();
		initDateTime(view);
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
		mPopupWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM,
				0, 0);

	}

	@SuppressLint("NewApi")
	private void initDateTime(View view){
		this.date=(DatePicker) view.findViewById(R.id.date);
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
			this.date.setCalendarViewShown(false);
	    }
		
	/*	DatePicker dp = findDatePicker((ViewGroup) this.date.getWindow().getDecorView());
		if (dp != null) {
		    ((ViewGroup) dp.getChildAt(0)).getChildAt(0).setVisibility(View.GONE);
		 
		}*/ 
		
		this.time=(TimePicker) view.findViewById(R.id.time);
		//设置时间为24小时制
		this.time.setIs24HourView(true);
		//为时间改变添加监听
		this.time.setOnTimeChangedListener(new OnTimeChangedListenerImp());
		//为日期添加监听,注意是init
		this.date.init(this.date.getYear(), this.date.getMonth(), this.date.getDayOfMonth(), new OnDateChangedListenerImp());
	} 
	
	/**
	 * 从当前Dialog中查找DatePicker子控件
	 * 
	 * @param group
	 * @return
	 */
	private DatePicker findDatePicker(ViewGroup group) {
	    if (group != null) {
	        for (int i = 0, j = group.getChildCount(); i < j; i++) {
	            View child = group.getChildAt(i);
	            if (child instanceof DatePicker) {
	                return (DatePicker) child;
	            } else if (child instanceof ViewGroup) {
	                DatePicker result = findDatePicker((ViewGroup) child);
	                if (result != null)
	                    return result;
	            }
	        }
	    }
	    return null;
	 
	} 
	
	private class OnTimeChangedListenerImp implements OnTimeChangedListener{
		public void onTimeChanged(TimePicker view, int hourOfDay, int minute) {
			//StylistDetailActivity.this.setDate();
		}
	}
	
	private class OnDateChangedListenerImp implements OnDateChangedListener{
		public void onDateChanged(DatePicker view, int year, int monthOfYear,int dayOfMonth) {
			//StylistDetailActivity.this.setDate();
		}
	}
	
	private OnClickListener serviceItemClickListener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			if(checkedServie!=null){
				checkedServie.setBackgroundColor(Color.WHITE);
			}
			checkedServie = (TextView)v;
			//v.setBackgroundColor(Color.BLUE);
			v.setBackgroundColor(Color.parseColor("#70A0C6"));
			servicePrice.setText((String)v.getTag());
		}
	};

	private void initService() {
		LayoutParams params = new LayoutParams(LayoutParams.MATCH_PARENT,
				LayoutParams.WRAP_CONTENT);
		params.topMargin = 10;
		TextView tv = new TextView(this);
		tv.setLayoutParams(params);
		tv.setText("精剪");
		tv.setTextColor(Color.parseColor("#D6D6D6"));
		tv.setTag("￥300");
		tv.setPadding(10, 10, 10, 10);
		tv.setGravity(Gravity.CENTER);
		tv.setBackgroundColor(Color.WHITE);
		tv.setOnClickListener(serviceItemClickListener);
		mServiceLayout.addView(tv);

		tv = new TextView(this);
		tv.setLayoutParams(params);
		tv.setText("烫发");
		tv.setTextColor(Color.parseColor("#D6D6D6"));
		tv.setTag("￥200");
		tv.setPadding(10, 10, 10, 10);
		tv.setGravity(Gravity.CENTER);
		tv.setBackgroundColor(Color.WHITE);
		tv.setOnClickListener(serviceItemClickListener);
		mServiceLayout.addView(tv);
		
	}
}
