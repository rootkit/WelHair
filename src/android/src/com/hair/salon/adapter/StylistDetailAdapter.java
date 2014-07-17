package com.hair.salon.adapter;

import java.util.List;

import com.hair.salon.R;
import com.hair.salon.adapter.MyWorksAdapter.Holder;
import com.hair.salon.bean.MyWorksBean;
import com.hair.salon.bean.StylistDetailBean;
import com.hair.salon.ui.HairDetailActivity;

import android.content.Context;
import android.content.Intent;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;

public class StylistDetailAdapter extends BaseAdapter implements OnClickListener{
	private Context context;
	private List<StylistDetailBean> MyWorks;
	private int mWidth;
	
	public StylistDetailAdapter(Context context, List<StylistDetailBean> objects) {
		// TODO Auto-generated constructor stub
		this.context = context;
		this.MyWorks = objects;
		getWidth();
	}
	
	private void getWidth(){
		WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
		DisplayMetrics metric = new DisplayMetrics();
		wm.getDefaultDisplay().getMetrics(metric);
		mWidth = metric.widthPixels/2-20;   
	}
	
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return MyWorks.size();
	}

	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		return MyWorks.get(position);
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		final Holder holder;
		StylistDetailBean mtylistDetailBean = MyWorks.get(position);
		if(convertView == null){
			LayoutInflater inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView = inflater.inflate(R.layout.stylist_detail_item, null);
			holder = new Holder();
			holder.work_photoIg = (ImageView) convertView.findViewById(R.id.image_item);
			convertView.setTag(holder);
		}else{
			holder = (Holder)convertView.getTag();
		}
		//view.setLayoutParams(new GridView.LayoutParams(200, 260));//重点行
		if(position%2 == 0){
			holder.work_photoIg.setImageResource(R.drawable.hair_style_img_2);
		}else if(position%3 == 0){
			holder.work_photoIg.setImageResource(R.drawable.hair_style_img_3);
		}else if(position%5 == 0){
			holder.work_photoIg.setImageResource(R.drawable.hair_style_img_5);
		}else{
			holder.work_photoIg.setImageResource(R.drawable.hair_style_img_6);
		}
		
		if(mWidth<=0){
			getWidth();
		}
		convertView.setLayoutParams(new GridView.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,mWidth+20));//重点行
		holder.work_photoIg.setOnClickListener(this);
		//LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,mWidth);
		//holder.work_photoIg.setLayoutParams(layoutParams);
		return convertView;
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch(v.getId()){
			case R.id.image_item:
				Intent workintent = new Intent(context, HairDetailActivity.class);
				context.startActivity(workintent);
				break;
			default:
				break;
		}
	}
	
	static class Holder{
		ImageView work_photoIg;
	}

}
