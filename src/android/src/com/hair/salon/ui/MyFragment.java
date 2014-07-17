package com.hair.salon.ui;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hair.salon.R;

public class MyFragment extends Fragment implements OnClickListener {

	private static final String TAG = "MyFrament";
	
	private TextView myAppointment;
	private TextView myCollection;
	private TextView my_orderTv;
	private TextView my_scoreTv;
	private ImageView settingImage;
	
	private TextView my_salonTv;
	private TextView my_accountTv;
	private TextView my_messageTv;
	private TextView my_customerTv;
	private TextView customer_appointmentTv;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		Log.d(TAG, "onCreate");
	}

	@Override
	public void onResume() {
		super.onResume();
		Log.d(TAG, "onResume");
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		Log.d(TAG, "onCreateView");
		View rootView = inflater.inflate(R.layout.my_fragment_main, container,
				false);
		
		settingImage = (ImageView)rootView.findViewById(R.id.title_setting);
		settingImage.setVisibility(View.VISIBLE);
		settingImage.setImageResource(R.drawable.title_setting);
		settingImage.setOnClickListener(this);
		
		
		
		initView(rootView);
		return rootView;
	}
	
	private void initView(View rootView){
		
		myAppointment = (TextView) rootView.findViewById(R.id.my_appointment);
		myCollection = (TextView) rootView.findViewById(R.id.my_colloction);
		my_orderTv = (TextView) rootView.findViewById(R.id.my_order);
		my_scoreTv = (TextView) rootView.findViewById(R.id.my_score);
		myAppointment.setOnClickListener(this);
		myCollection.setOnClickListener(this);
		my_orderTv.setOnClickListener(this);
		my_scoreTv.setOnClickListener(this);
		
		my_salonTv = (TextView) rootView.findViewById(R.id.my_salon);
		my_accountTv = (TextView) rootView.findViewById(R.id.my_account);
		my_messageTv = (TextView) rootView.findViewById(R.id.my_message);
		my_customerTv = (TextView) rootView.findViewById(R.id.my_customer);
		customer_appointmentTv = (TextView) rootView.findViewById(R.id.customer_appointment);
		
		my_salonTv.setOnClickListener(this);
		my_accountTv.setOnClickListener(this);
		my_messageTv.setOnClickListener(this);
		my_customerTv.setOnClickListener(this);
		customer_appointmentTv.setOnClickListener(this);
	}


	@Override
	public void onClick(View v) {
		switch (v.getId()) {
			case R.id.my_appointment:
				Intent intent = new Intent(getActivity(),MyAppointmentInfoActivity.class);
				startActivity(intent);
				break;
			case R.id.my_order:
				Intent orderintent = new Intent(getActivity(),MyOrderActivity.class);
				startActivity(orderintent);
				break;
			case R.id.my_score:
				Intent scoreintent = new Intent(getActivity(),MyScoreActivity.class);
				startActivity(scoreintent);
				break;
			case R.id.my_colloction:
				Intent collectionIntent = new Intent(getActivity(),MyCollectionInfoActivity.class);
				startActivity(collectionIntent);
				break;
			case R.id.title_setting:
				Intent settingIntent = new Intent(getActivity(),SettingsActivity.class);
				startActivity(settingIntent);
				break;
				
			case R.id.my_salon:
				Intent salonintent = new Intent(getActivity(),MySalonActivity.class);
				startActivity(salonintent);
				break;
			case R.id.my_account:
				Intent my_accountintent = new Intent(getActivity(),MyAccountActivity.class);
				startActivity(my_accountintent);
				break;
			case R.id.my_message:
				Intent mymessagesintent = new Intent(getActivity(),MyMessagesActivity.class);
				startActivity(mymessagesintent);
				break;
			case R.id.my_customer:
				Intent mycustomersIntent = new Intent(getActivity(),MyCustomersActivity.class);
				startActivity(mycustomersIntent);
				break;
			case R.id.customer_appointment:
				Intent customer_appointmentintent = new Intent(getActivity(),MyAppointmentInfoActivity.class);
				startActivity(customer_appointmentintent);
				break;
			default:
				break;
		}
	}

}
