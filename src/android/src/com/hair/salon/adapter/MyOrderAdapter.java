package com.hair.salon.adapter;

import java.util.List;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import com.hair.salon.R;
import com.hair.salon.bean.MyOrderBean;
import com.hair.salon.ui.OrdersCommentsActivity;

public class MyOrderAdapter extends BaseAdapter implements OnClickListener{

	private Context context;
	private List<MyOrderBean> MyOrder;
	
	public MyOrderAdapter(Context context,List<MyOrderBean> objects) {
		this.context = context;
		this.MyOrder = objects;
	}
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return MyOrder.size();
	}

	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		return MyOrder.get(position);
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
		MyOrderBean myOrderBean = MyOrder.get(position);
		//View view;
		if(convertView == null){
			LayoutInflater inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView = inflater.inflate(R.layout.my_order_activity_item, null);
			holder = new Holder();
			
			holder.salon_nameTv = (TextView) convertView.findViewById(R.id.salon_name);
			holder.production_statusTv = (TextView) convertView.findViewById(R.id.production_status);
			holder.production_nameTv = (TextView) convertView.findViewById(R.id.production_name);
			holder.production_capacityTv = (TextView) convertView.findViewById(R.id.production_capacity);
			holder.production_colorTv = (TextView) convertView.findViewById(R.id.production_color);
			holder.production_priceTv = (TextView) convertView.findViewById(R.id.production_price);
			holder.production_numberTv = (TextView) convertView.findViewById(R.id.production_number);
			holder.production_freightTv = (TextView) convertView.findViewById(R.id.production_freight);
			holder.production_price_combinedTv = (TextView) convertView.findViewById(R.id.production_price_combined);
			
			holder.production_imgIg = (ImageView) convertView.findViewById(R.id.production_img);
			holder.edit_imgIg = (ImageView) convertView.findViewById(R.id.edit_img);

			convertView.setTag(holder);
		}else{
			holder = (Holder)convertView.getTag();
		}
				
		holder.salon_nameTv.setText("欣欣沙龙");
		holder.production_statusTv.setText("已付款");
		holder.production_nameTv.setText("Safer洗发水");
		holder.production_capacityTv.setText("200毫升");
		holder.production_colorTv.setText("白色");
		holder.production_priceTv.setText("￥15.00");
		holder.production_numberTv.setText("1");
		holder.production_freightTv.setText("￥10.00");
		holder.production_price_combinedTv.setText("￥25.00");
		
		holder.edit_imgIg.setOnClickListener(this);
		return convertView;
	}

	static class Holder{
		TextView salon_nameTv;
		TextView production_statusTv;
		TextView production_nameTv;
		TextView production_capacityTv;
		TextView production_colorTv;
		TextView production_priceTv;
		TextView production_numberTv;
		TextView production_freightTv;
		TextView production_price_combinedTv;
		ImageView production_imgIg;
		ImageView edit_imgIg;
	}
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch(v.getId()){
		case R.id.edit_img:
			Intent intent = new Intent(context,OrdersCommentsActivity.class);
			context.startActivity(intent);
			break;
		default:
			break;
		}
	}

}
