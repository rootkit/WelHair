package com.hair.salon.adapter;

import java.util.List;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hair.salon.R;
import com.hair.salon.bean.OrdersCommentsBean;

public class OrdersCommentsAdapter extends BaseAdapter implements OnClickListener{

	private Context context;
	private List<OrdersCommentsBean> OrdersComments;
	
	public OrdersCommentsAdapter(Context context, List<OrdersCommentsBean> objects) {
		// TODO Auto-generated constructor stub
		this.context = context;
		this.OrdersComments = objects;
	}

	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return OrdersComments.size();
	}

	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		return OrdersComments.get(position);
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
		OrdersCommentsBean ordersCommentsBean = OrdersComments.get(position);
		//View view;
		if(convertView == null){
			LayoutInflater inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView = inflater.inflate(R.layout.orders_comments_activity_items, null);
			holder = new Holder();
			
			holder.customer_nameTv = (TextView) convertView.findViewById(R.id.customer_name);
			holder.comments_contextTv = (TextView) convertView.findViewById(R.id.comments_context);
			holder.comment_timeTv = (TextView) convertView.findViewById(R.id.comment_time);
			holder.pic_layoutLl = (LinearLayout) convertView.findViewById(R.id.pic_layout);
			
			holder.customer_imgIg = (ImageView) convertView.findViewById(R.id.customer_img);
			holder.show_img_oneIg = (ImageView) convertView.findViewById(R.id.show_img_one);
			holder.show_img_twoIg = (ImageView) convertView.findViewById(R.id.show_img_two);
			holder.show_img_threeIg = (ImageView) convertView.findViewById(R.id.show_img_three);
			holder.show_img_fourIg = (ImageView) convertView.findViewById(R.id.show_img_four);
			
			convertView.setTag(holder);
		}else{
			holder = (Holder)convertView.getTag();
		}
		
		
		holder.customer_nameTv.setText("小刘");
		holder.comments_contextTv.setText("环境不错，下次还会来的");
		holder.comment_timeTv.setText("07-08 08:26");
		
		if(position%2 == 0){
			holder.pic_layoutLl.setVisibility(View.GONE);
		}else{
			holder.pic_layoutLl.setVisibility(View.VISIBLE);
			holder.customer_imgIg.setImageResource(R.drawable.hair_style_img_7);
			holder.show_img_oneIg.setImageResource(R.drawable.hair_style_img_1);
			holder.show_img_twoIg.setImageResource(R.drawable.hair_style_img_2);
			holder.show_img_twoIg.setImageResource(R.drawable.hair_style_img_3);
			holder.show_img_fourIg.setImageResource(R.drawable.hair_style_img_4);
		}
		return convertView;
	}

	static class Holder{
		TextView customer_nameTv;
		TextView comments_contextTv;
		TextView comment_timeTv;
		LinearLayout pic_layoutLl;
		ImageView customer_imgIg;
		ImageView show_img_oneIg;
		ImageView show_img_twoIg;
		ImageView show_img_threeIg;
		ImageView show_img_fourIg;
	}
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		
	}

}
