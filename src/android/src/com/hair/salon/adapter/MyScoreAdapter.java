package com.hair.salon.adapter;

import java.util.List;

import com.hair.salon.R;
import com.hair.salon.adapter.MyOrderAdapter.Holder;
import com.hair.salon.bean.MyOrderBean;
import com.hair.salon.bean.MyScoreBean;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class MyScoreAdapter extends BaseAdapter implements OnClickListener{

	private Context context;
	private List<MyScoreBean> MyScore;
	
	public MyScoreAdapter(Context context,List<MyScoreBean> objects) {
		this.context = context;
		this.MyScore = objects;
	}

	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return MyScore.size();
	}

	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		return MyScore.get(position);
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
		MyScoreBean myScoreBean = MyScore.get(position);
		//View view;
		if(convertView == null){
			LayoutInflater inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView = inflater.inflate(R.layout.my_score_activity_item, null);
			holder = new Holder();
			
			holder.up_lineTv = (TextView) convertView.findViewById(R.id.up_line);
			holder.below_lineTv = (TextView) convertView.findViewById(R.id.below_line);
			holder.event_descTv = (TextView) convertView.findViewById(R.id.event_desc);
			holder.score_numberTv = (TextView) convertView.findViewById(R.id.score_number);
			holder.happen_dateTv = (TextView) convertView.findViewById(R.id.happen_date);
			holder.circle_imgImg = (ImageView) convertView.findViewById(R.id.circle_img);
			holder.customer_layoutRl = (RelativeLayout) convertView.findViewById(R.id.customer_layout);

			convertView.setTag(holder);
		}else{
			holder = (Holder)convertView.getTag();
		}
				
		//holder.up_lineTv.setText("欣欣沙龙");
		//holder.below_lineTv.setText("已付款");
		
		if(position%2 == 1){
			holder.customer_layoutRl.setBackgroundColor(Color.WHITE);
		}else{
			holder.customer_layoutRl.setBackgroundColor(Color.parseColor("#FFF2F2F2"));
		}
		
		if(position == 0){
			holder.up_lineTv.setVisibility(View.INVISIBLE);
			holder.circle_imgImg.setImageResource(R.drawable.iconfont_sss);
			holder.below_lineTv.setVisibility(View.VISIBLE);
		}else{
			holder.circle_imgImg.setImageResource(R.drawable.iconfont_iconfontyuan);
			holder.up_lineTv.setVisibility(View.VISIBLE);
			holder.below_lineTv.setVisibility(View.VISIBLE);
		}
		
		if(position == (getCount() - 1)){
			holder.below_lineTv.setVisibility(View.INVISIBLE);
		}
		
		holder.event_descTv.setText(myScoreBean.getEvent_descTv());
		holder.score_numberTv.setText(myScoreBean.getScore_numberTv());
		holder.happen_dateTv.setText(myScoreBean.getHappen_dateTv());
		return convertView;
	}

	static class Holder{
		TextView up_lineTv;
		TextView below_lineTv;
		ImageView circle_imgImg;
		TextView event_descTv;
		TextView score_numberTv;
		TextView happen_dateTv;
		RelativeLayout customer_layoutRl;
	}
	
	@Override
	public void onClick(View arg0) {
		// TODO Auto-generated method stub
		
	}

}
