package com.hair.salon.adapter;

import java.util.List;

import com.hair.salon.R;
import com.hair.salon.bean.MyServicesBean;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

public class MyServicesAdapter extends BaseAdapter{

	private Context context;
	private List<MyServicesBean> MyServices;
	
	public MyServicesAdapter(Context context,List<MyServicesBean> objects) {
		this.context = context;
		this.MyServices = objects;
	}
	
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return MyServices.size();
	}

	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		return MyServices.get(position);
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
		MyServicesBean orderDetail = MyServices.get(position);
		//View view;
		if(convertView == null){
			LayoutInflater inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView = inflater.inflate(R.layout.services_list_item_layout, null);
			holder = new Holder();
			
			holder.tv_service_name = (TextView) convertView.findViewById(R.id.service_name);
			holder.tv_orginal_price = (TextView) convertView.findViewById(R.id.orginal_price);
			holder.tv_distant_price = (TextView) convertView.findViewById(R.id.distant_price);
			
			convertView.setTag(holder);
		}else{
			holder = (Holder)convertView.getTag();
		}
		
		
		holder.tv_service_name.setText("烫发");
		holder.tv_orginal_price.setText("原价：200元");
		holder.tv_distant_price.setText("折后价：160元");
		
		return convertView;
	}
	
	static class Holder{
		TextView tv_service_name;
		TextView tv_orginal_price;
		TextView tv_distant_price;
	}

}
