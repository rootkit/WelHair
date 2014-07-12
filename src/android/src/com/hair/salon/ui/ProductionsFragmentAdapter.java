package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.List;

import com.hair.salon.R;
import com.hair.salon.bean.ProductionsBean;
import com.hair.salon.common.Constants;
import android.content.Context;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;

public class ProductionsFragmentAdapter extends BaseAdapter {
	
	private Context context;
	private List<ProductionsBean> mList = new ArrayList<ProductionsBean>();
	private int mWidth;
	
	public ProductionsFragmentAdapter(Context context,List<ProductionsBean> mList) {
		// TODO Auto-generated constructor stub
		this.context = context;
		this.mList = mList;
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
		// TODO Auto-generated method stub
		return mList.size();
	}

	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		return mList.get(position);
	}

	@Override
	public long getItemId(int arg0) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		ViewHolder holder;
		if(convertView==null){
			LayoutInflater inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView = inflater.inflate(R.layout.productions_grid_item, null);
			holder = new ViewHolder();
			holder.styleImg = (ImageView)convertView.findViewById(R.id.hair_style_img);
			
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
		return convertView;
	}
	
	private class ViewHolder{
		public ImageView styleImg;
	}
}
