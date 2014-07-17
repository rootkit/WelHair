package com.hair.salon.ui;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TextView;

import com.hair.salon.R;

public class DesignerActivity extends BaseActivity implements OnClickListener {

	private TextView title;
	private TextView myWorks;
	private TextView myServices;
	private TextView myClients;
	private TextView myBooking;
	private TextView back;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.designer_layout);

		title = (TextView) findViewById(R.id.title_txt);
		title.setText("设计师");
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		myWorks = (TextView) findViewById(R.id.my_works);
		myServices = (TextView) findViewById(R.id.my_services);
		myClients = (TextView) findViewById(R.id.my_clients);
		myBooking = (TextView) findViewById(R.id.my_booking);

		myWorks.setOnClickListener(this);
		myServices.setOnClickListener(this);
		myClients.setOnClickListener(this);
		myBooking.setOnClickListener(this);
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.my_works:
			Intent worksIntent = new Intent(DesignerActivity.this,MyWorksActivity.class);
			startActivity(worksIntent);
			break;
		case R.id.my_services:
			Intent servicesIntent = new Intent(DesignerActivity.this,MyServicesActivity.class);
			startActivity(servicesIntent);
			break;
		case R.id.my_clients:
			Intent mycustomersIntent = new Intent(DesignerActivity.this,MyCustomersActivity.class);
			startActivity(mycustomersIntent);
			break;
		case R.id.my_booking:
			Intent customer_appointmentintent = new Intent(DesignerActivity.this,MyAppointmentInfoActivity.class);
			startActivity(customer_appointmentintent);
			break;

		}
	}

}
