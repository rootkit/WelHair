package com.hair.salon.adapter;

import java.util.List;

import com.hair.salon.R;
import com.hair.salon.bean.MyAddressBean;
import com.hair.salon.ui.AddAddressActivity;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

public class MyAddressAdapter extends BaseAdapter implements OnClickListener{

	
	private Context context;
	private List<MyAddressBean> MyAddresss;
	
	public MyAddressAdapter(Context context,List<MyAddressBean> objects) {
		this.context = context;
		this.MyAddresss = objects;
	}
	
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return MyAddresss.size();
	}

	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		return MyAddresss.get(position);
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
		MyAddressBean myAddressBean = MyAddresss.get(position);
		if(convertView == null){
			LayoutInflater inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView = inflater.inflate(R.layout.address_list_item_layout, null);
			holder = new Holder();
			//view = View.inflate(context, R.layout.address_list_item_layout, null);
			holder.tv_name = (TextView) convertView.findViewById(R.id.name);
			holder.tv_phone = (TextView) convertView.findViewById(R.id.phone);
			holder.tv_address = (TextView) convertView.findViewById(R.id.address);
			holder.editImg = (ImageView) convertView.findViewById(R.id.edit);
			holder.selectImg = (ImageView) convertView.findViewById(R.id.select);
			
			convertView.setTag(holder);
		}else{
			holder = (Holder)convertView.getTag();
		}
		
		
		holder.tv_name.setText("小飞");
		holder.tv_phone.setText("13837383738");
		holder.tv_address.setText("高新区管委会");
		
		holder.editImg.setOnClickListener(this);
		holder.selectImg.setOnClickListener(this);
		return convertView;
	}

	
	static class Holder{
		TextView tv_name;
		TextView tv_phone;
		TextView tv_address;
		ImageView editImg;
		ImageView selectImg;
	}


	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch(v.getId()){
			case R.id.edit:
				Intent intent = new Intent(context,AddAddressActivity.class);
				intent.putExtra("deal", "editAddress");
				context.startActivity(intent);
				break;
			case R.id.select:
				v.setBackgroundResource(R.drawable.address_selected);
				break;
		}
	}

}
