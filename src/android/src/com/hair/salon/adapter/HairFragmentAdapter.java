package com.hair.salon.adapter;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.drawable.Drawable;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hair.salon.R;
import com.hair.salon.bean.HairStyleBean;
import com.hair.salon.common.Constants;
import com.hair.salon.widget.CircleImageView;

public class HairFragmentAdapter extends BaseAdapter {

	private Context context;
	
	private List<HairStyleBean> mList = new ArrayList<HairStyleBean>();
	
	private int mWidth;
	private int[] arrCollect = new int[100];
	
	public HairFragmentAdapter(Context context,List<HairStyleBean> mList2){
		this.context = context;
		this.mList = mList2;
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
			convertView = inflater.inflate(R.layout.hair_style_grid_item, null);
			holder = new ViewHolder();
			holder.styleImg = (ImageView)convertView.findViewById(R.id.hair_style_img);
			holder.styledesginerImg = (CircleImageView)convertView.findViewById(R.id.hair_style_desginer_img);
			holder.collect_numTv = (TextView)convertView.findViewById(R.id.collect_num);
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
		holder.styledesginerImg.setImageResource(Constants.imgs[position]);
		holder.collect_numTv.setOnClickListener(new collectListener(holder,position));
		return convertView;
	}

	class collectListener implements OnClickListener{
		ViewHolder holder;
		int position;
		public collectListener(ViewHolder holder,int position) {
			// TODO Auto-generated constructor stub
			this.holder = holder;
			this.position = position;
		}

		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			System.out.println("arrCollect[position]==="+arrCollect[position]);
			if(0 == arrCollect[position]){
				arrCollect[position] = 1;
				//holder.collect_numTv.setBackgroundResource(R.drawable.iconfont_xin_full);
				//changeCollectNum("add");
				Drawable img_off;
				Resources res = context.getResources();
				img_off = res.getDrawable(R.drawable.iconfont_like_gray_full);
				// 调用setCompoundDrawables时，必须调用Drawable.setBounds()方法,否则图片不显示
				img_off.setBounds(0, 0, img_off.getMinimumWidth(), img_off.getMinimumHeight());
				holder.collect_numTv.setCompoundDrawables(img_off, null, null, null); //设置左图标
				changeCollectNum("add");
			}else{
				arrCollect[position] = 0;
				//holder.collect_numTv.setBackgroundResource(R.drawable.lucence_add004);
				//changeCollectNum("plus");
				Drawable img_off;
				Resources res = context.getResources();
				img_off = res.getDrawable(R.drawable.iconfont_like_gray);
				// 调用setCompoundDrawables时，必须调用Drawable.setBounds()方法,否则图片不显示
				img_off.setBounds(0, 0, img_off.getMinimumWidth(), img_off.getMinimumHeight());
				holder.collect_numTv.setCompoundDrawables(img_off, null, null, null); //设置左图标
				changeCollectNum("plus");
			}
		}
		
		private void changeCollectNum(String sign){
			String originalNum = holder.collect_numTv.getText().toString();
			originalNum = originalNum.substring(1, originalNum.length()-1);
			int num = Integer.parseInt(originalNum);
			String context = "";
			if("add".equals(sign)){
				num = num + 1;
				context = "(" + Integer.toString(num) +")";
				holder.collect_numTv.setText(context);
			}else if("plus".equals(sign)){
				num = num - 1;
				context = "(" + Integer.toString(num) +")";
				holder.collect_numTv.setText(context);
			}
		}
	}
	
	private class ViewHolder{
		public ImageView styleImg;
		public CircleImageView styledesginerImg;
		TextView collect_numTv;
		
	}
}
