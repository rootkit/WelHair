package com.hair.salon.adapter;

import java.util.List;

import com.hair.salon.R;
import com.hair.salon.bean.MyWorksBean;
import com.hair.salon.ui.HairDetailActivity;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

public class MyWorksAdapter extends BaseAdapter implements OnClickListener{

	private Context context;
	private List<MyWorksBean> MyWorks;
	private int mWidth;
	
	public MyWorksAdapter(Context context, List<MyWorksBean> objects) {
		// TODO Auto-generated constructor stub
		this.context = context;
		this.MyWorks = objects;
		getWidth();
	}
	
	private void getWidth(){
		WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
		DisplayMetrics metric = new DisplayMetrics();
		wm.getDefaultDisplay().getMetrics(metric);
		mWidth = metric.widthPixels/2-20;   
	}
	
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return MyWorks.size();
	}

	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		return MyWorks.get(position);
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		final Holder holder;
		MyWorksBean myWorksBean = MyWorks.get(position);
		if(convertView == null){
			LayoutInflater inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView = inflater.inflate(R.layout.my_works_layout_item, null);
			holder = new Holder();
			holder.work_photoIg = (ImageView) convertView.findViewById(R.id.work_photo);
			holder.work_photo_deleteIg = (ImageView) convertView.findViewById(R.id.work_photo_delete);
			holder.work_photo_dateTv = (TextView) convertView.findViewById(R.id.work_photo_date);
			convertView.setTag(holder);
		}else{
			holder = (Holder)convertView.getTag();
		}
		//view.setLayoutParams(new GridView.LayoutParams(200, 260));//重点行
		holder.work_photoIg.setImageResource(R.drawable.hair_style_img_3);
		holder.work_photo_deleteIg.setOnClickListener(this);
		holder.work_photo_dateTv.setText("2014/07/10");
		
		if(mWidth<=0){
			getWidth();
		}
		convertView.setLayoutParams(new GridView.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,mWidth+20));//重点行
		//LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,mWidth);
		//holder.work_photoIg.setLayoutParams(layoutParams);
		return convertView;
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch(v.getId()){
			case R.id.work_photo:
				Intent workintent = new Intent(context, HairDetailActivity.class);
				context.startActivity(workintent);
				break;
			case R.id.work_photo_delete:
				deleteWorks();
			default:
				break;
		}
	}
	
	private void deleteWorks() {
		Builder dailog = new AlertDialog.Builder(context).setTitle("提示")// 设置标题
				.setMessage("确定要删除该作品吗?")// 设置提示消息
				.setPositiveButton("确定", new DialogInterface.OnClickListener() {// 设置确定的按键
							@Override
							public void onClick(DialogInterface dialog,
									int which) {
								// do something
							}
						})
				.setNegativeButton("取消", new DialogInterface.OnClickListener() {// 设置取消按键
							@Override
							public void onClick(DialogInterface dialog,
									int which) {
								// do something
							}
						}).setCancelable(false);// 设置按返回键是否响应返回，这是是不响应
		dailog.show();// 显示
	}
	
	static class Holder{
		ImageView work_photoIg;
		ImageView work_photo_deleteIg;
		TextView work_photo_dateTv;
	}

}
