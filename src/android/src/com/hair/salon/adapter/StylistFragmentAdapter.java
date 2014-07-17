package com.hair.salon.adapter;

import java.util.ArrayList;
import java.util.List;
import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import com.hair.salon.R;
import com.hair.salon.bean.SalonBean;
import com.hair.salon.common.Constants;
import com.hair.salon.widget.CircleImageView;

public class StylistFragmentAdapter extends BaseAdapter {

	private Context context;
	
	private List<SalonBean> mList = new ArrayList<SalonBean>();
	
	public StylistFragmentAdapter(Context context,List<SalonBean> mList){
		this.context = context;
		this.mList = mList;
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
			convertView = inflater.inflate(R.layout.stylist_list_item, null);
			holder = new ViewHolder();
			holder.designerImg = (CircleImageView)convertView.findViewById(R.id.hair_desginer_img);
			
			convertView.setTag(holder);
		}else{
			holder = (ViewHolder)convertView.getTag();
		}
		if(position%2==1){
			//convertView.setBackgroundColor(Color.LTGRAY);
			convertView.setBackgroundColor(Color.parseColor("#F5F6F8"));
		}else{
			convertView.setBackgroundColor(Color.WHITE);
		}
		holder.designerImg.setImageResource(Constants.imgs[position]);
		return convertView;
	}

	private class ViewHolder{
		public CircleImageView designerImg;
	}
	
}
