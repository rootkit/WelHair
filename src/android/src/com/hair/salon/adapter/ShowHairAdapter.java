package com.hair.salon.adapter;

import java.util.List;

import android.content.Context;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hair.salon.R;
import com.hair.salon.adapter.OrdersCommentsAdapter.Holder;
import com.hair.salon.bean.OrdersCommentsBean;
import com.hair.salon.bean.ShowHairBean;

public class ShowHairAdapter extends BaseAdapter implements OnClickListener{

	
	private Context context;
	private List<ShowHairBean> ShowHair;
	
	private int mWidth;
	
	
	public ShowHairAdapter(Context context,List<ShowHairBean> objects) {
		this.context = context;
		this.ShowHair = objects;
		getWidth();
	}

	private void getWidth(){
		WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
		DisplayMetrics metric = new DisplayMetrics();
		wm.getDefaultDisplay().getMetrics(metric);
		mWidth = (metric.widthPixels - 50)/4;   
	}
	
	
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return ShowHair.size();
	}

	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		return ShowHair.get(position);
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		Holder holder;
		ShowHairBean showHairBean = ShowHair.get(position);
		//View view;
		if(convertView == null){
			LayoutInflater inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView = inflater.inflate(R.layout.show_hair_activity_item, null);
			holder = new Holder();
			
			holder.commentTv = (TextView) convertView.findViewById(R.id.comment);
			holder.hair_img_oneIg = (ImageView) convertView.findViewById(R.id.hair_img_one);
			holder.hair_img_twoIg = (ImageView) convertView.findViewById(R.id.hair_img_two);
			holder.hair_img_threeIg = (ImageView) convertView.findViewById(R.id.hair_img_three);
			holder.hair_img_fourIg = (ImageView) convertView.findViewById(R.id.hair_img_four);
			holder.img_layoutLl = (LinearLayout) convertView.findViewById(R.id.img_layout);
			
			LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,mWidth);
			holder.img_layoutLl.setLayoutParams(layoutParams);
			
			convertView.setTag(holder);
		}else{
			holder = (Holder)convertView.getTag();
		}
		
		
		holder.commentTv.setText("不错不错 赞一个");
		if(position%2 == 0){
			holder.hair_img_oneIg.setImageResource(R.drawable.hair_style_img_1);
			holder.hair_img_twoIg.setImageResource(R.drawable.hair_style_img_2);
			holder.hair_img_threeIg.setImageResource(R.drawable.hair_style_img_3);
			holder.hair_img_fourIg.setImageResource(R.drawable.hair_style_img_8);
		}else{
			holder.hair_img_oneIg.setImageResource(R.drawable.hair_style_img_4);
			holder.hair_img_twoIg.setImageResource(R.drawable.hair_style_img_5);
			holder.hair_img_threeIg.setImageResource(R.drawable.hair_style_img_6);
			holder.hair_img_fourIg.setImageResource(R.drawable.hair_style_img_7);
		}
		return convertView;
	}

	static class Holder{
		TextView commentTv;
		ImageView hair_img_oneIg;
		ImageView hair_img_twoIg;
		ImageView hair_img_threeIg;
		ImageView hair_img_fourIg;
		LinearLayout img_layoutLl;
	}
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		
	}

}
