package com.hair.salon.adapter;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.AbsListView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;

import com.hair.salon.R;
import com.hair.salon.bean.HairStyleBean;
import com.hair.salon.bean.ProductionsBean;
import com.hair.salon.common.Constants;
import com.hair.salon.widget.CircleImageView;

public class HairFragmentAdapter extends BaseAdapter {

	private Context context;
	
	private List<HairStyleBean> mList = new ArrayList<HairStyleBean>();
	
	private int mWidth;
	
	public HairFragmentAdapter(Context context,List<HairStyleBean> mList2){
		this.context = context;
		this.mList = mList2;
		getWidth();
	}
	
	private void getWidth(){
		WindowManager wm = (WindowManager) context
                .getSystemService(Context.WINDOW_SERVICE);
		DisplayMetrics metric = new DisplayMetrics();
		wm.getDefaultDisplay().getMetrics(metric);
		mWidth = metric.widthPixels/2-20;   
	}
	
	@Override
	public int getCount() {
		return mList.size();
	}

	@Override
	public Object getItem(int position) {
		return mList.get(position);
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder holder;
		if(convertView==null){
			LayoutInflater inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView = inflater.inflate(R.layout.hair_style_grid_item, null);
			holder = new ViewHolder();
			holder.styleImg = (ImageView)convertView.findViewById(R.id.hair_style_img);
			holder.styledesginerImg = (CircleImageView)convertView.findViewById(R.id.hair_style_desginer_img);
			
			convertView.setTag(holder);
			if(mWidth<=0){
				getWidth();
			}
			LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,mWidth);
			holder.styleImg.setLayoutParams(layoutParams);
		}else{
			holder = (ViewHolder)convertView.getTag();
		}
		
		
		holder.styleImg.setImageResource(Constants.imgs[position]);
		holder.styledesginerImg.setImageResource(Constants.imgs[position]);
		return convertView;
	}

	private class ViewHolder{
		public ImageView styleImg;
		public CircleImageView styledesginerImg;
		
	}
}
