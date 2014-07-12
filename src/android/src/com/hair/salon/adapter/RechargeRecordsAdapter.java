package com.hair.salon.adapter;

import java.util.List;

import com.hair.salon.R;
import com.hair.salon.adapter.OrdersCommentsAdapter.Holder;
import com.hair.salon.bean.OrdersCommentsBean;
import com.hair.salon.bean.RechargeRecordsBean;

import android.content.Context;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

public class RechargeRecordsAdapter extends BaseAdapter implements OnClickListener{

	private Context context;
	private List<RechargeRecordsBean> RechargeRecords;
	
	public RechargeRecordsAdapter(Context context, List<RechargeRecordsBean> objects) {
		// TODO Auto-generated constructor stub
		this.context = context;
		this.RechargeRecords = objects;
	}
	
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return RechargeRecords.size();
	}

	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		return position;
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		final Holder holder = new Holder();
		RechargeRecordsBean rechargeRecordsBean = RechargeRecords.get(position);
		View view;
		if(convertView == null){
			view = View.inflate(context, R.layout.recharge_records_activity_item, null);
		}else{
			view = convertView;
		}
		holder.recharge_statusTv = (TextView) view.findViewById(R.id.recharge_status);
		holder.recharge_amountTv = (TextView) view.findViewById(R.id.recharge_amount);
		holder.recharge_timeTv = (TextView) view.findViewById(R.id.recharge_time);
		holder.record_numberTv = (TextView) view.findViewById(R.id.record_number);
		
		
		
		holder.recharge_statusTv.setText("交易成功");
		holder.recharge_amountTv.setText("100.00");
		holder.recharge_timeTv.setText("07-08 08:26");
		holder.record_numberTv.setText("充值【20140630123426238963】");
		
		return view;
	}
	
	
	
	
	static class Holder{
		TextView recharge_statusTv;
		TextView recharge_amountTv;
		TextView recharge_timeTv;
		TextView record_numberTv;
		
	}
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		
	}
	

}
