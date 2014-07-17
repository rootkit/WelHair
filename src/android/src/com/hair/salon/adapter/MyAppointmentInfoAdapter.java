package com.hair.salon.adapter;

import java.util.List;

import com.hair.salon.R;
import com.hair.salon.bean.MyAppointmentInfoBean;
import com.hair.salon.ui.ShowHairActivity;
import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

public class MyAppointmentInfoAdapter extends BaseAdapter implements OnClickListener{

	private Context context;
	private List<MyAppointmentInfoBean> myAppointmentInfo;
	
	public MyAppointmentInfoAdapter(Context context,List<MyAppointmentInfoBean> objects) {
		this.context = context;
		this.myAppointmentInfo = objects;
	}
	
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return myAppointmentInfo.size();
	}

	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		return myAppointmentInfo.get(position);
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		Holder holder;
		MyAppointmentInfoBean myAppointmentInfoBean = myAppointmentInfo.get(position);
		if(convertView == null){
			LayoutInflater inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView = inflater.inflate(R.layout.my_appointment_info_item, null);
			holder = new Holder();

			holder.hair_desginer_imgIg = (ImageView) convertView.findViewById(R.id.hair_desginer_img);
			holder.desinger_nameTv = (TextView) convertView.findViewById(R.id.desinger_name);
			holder.service_priceTv = (TextView) convertView.findViewById(R.id.service_price);
			holder.salon_nameTv = (TextView) convertView.findViewById(R.id.salon_name);
			holder.service_progressTv = (TextView) convertView.findViewById(R.id.service_progress);
			
			holder.salon_addressTv = (TextView) convertView.findViewById(R.id.salon_address);
			holder.appointment_subjectTv = (TextView) convertView.findViewById(R.id.appointment_subject);
			holder.appointment_timeTv = (TextView) convertView.findViewById(R.id.appointment_time);
			holder.preview_picTv = (TextView) convertView.findViewById(R.id.preview_pic);
			
			convertView.setTag(holder);
		}else{
			holder = (Holder)convertView.getTag();
		}
		
		holder.hair_desginer_imgIg.setImageResource(R.drawable.hair_style_img_7);;
		holder.desinger_nameTv.setText("小张");
		holder.service_priceTv.setText("￥80");
		holder.salon_nameTv.setText("飘丝丽坊");
		holder.service_progressTv.setText("已付款");
		holder.salon_addressTv.setText("会展中心");
		holder.appointment_subjectTv.setText("洗剪吹");
		holder.appointment_timeTv.setText("06-12 16:20");
		
		holder.preview_picTv.setOnClickListener(this);
		return convertView;
	}

	
	static class Holder{
		
		ImageView hair_desginer_imgIg;
		TextView desinger_nameTv;
		TextView service_priceTv;
		TextView salon_nameTv;
		TextView service_progressTv;
		TextView salon_addressTv;
		TextView appointment_subjectTv;
		TextView appointment_timeTv;
		TextView preview_picTv;
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch(v.getId()){
			case R.id.preview_pic:
				Intent intent = new Intent(context,ShowHairActivity.class);
				context.startActivity(intent);
				break;
			default:
				break;
		}
	}

}
