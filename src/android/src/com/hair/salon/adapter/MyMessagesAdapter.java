package com.hair.salon.adapter;

import java.util.List;

import com.hair.salon.R;
import com.hair.salon.adapter.MyCustomersAdapter.Holder;
import com.hair.salon.bean.MyCustomersBean;
import com.hair.salon.bean.MyMessagesBean;

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

public class MyMessagesAdapter extends BaseAdapter implements OnClickListener{

	private Context context;
	private List<MyMessagesBean> MyMessages;
	
	public MyMessagesAdapter(Context context, List<MyMessagesBean> objects) {
		// TODO Auto-generated constructor stub
		this.context = context;
		this.MyMessages = objects;
	}
	
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return MyMessages.size();
	}

	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		return MyMessages.get(position);
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		Holder holder = new Holder();
		MyMessagesBean myMessagesBean = MyMessages.get(position);
		if(convertView == null){
			LayoutInflater inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView = inflater.inflate(R.layout.my_messages_activity_item, null);
			holder = new Holder();
			
			holder.customer_imgIg = (ImageView) convertView.findViewById(R.id.customer_img);
			holder.customer_nameTv = (TextView) convertView.findViewById(R.id.customer_name);
			holder.customer_layoutRl = (RelativeLayout) convertView.findViewById(R.id.customer_layout);

			convertView.setTag(holder);
		}else{
			holder = (Holder)convertView.getTag();
		}
		
		if(position%2 == 1){
			holder.customer_layoutRl.setBackgroundColor(Color.parseColor("#FFF2F2F2"));
		}else{
			holder.customer_layoutRl.setBackgroundColor(Color.WHITE);
		}
		
		holder.customer_imgIg.setImageResource(R.drawable.hair_style_img_7);
		holder.customer_nameTv.setText("小刘");
		
		return convertView;
	}
	
	static class Holder{
		ImageView customer_imgIg;
		TextView customer_nameTv;
		RelativeLayout customer_layoutRl;
	}

	@Override
	public void onClick(View arg0) {
		// TODO Auto-generated method stub
		
	}

}
