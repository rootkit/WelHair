package com.hair.salon.ui;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hair.salon.R;

public class SalonManagerActivity extends BaseActivity implements OnClickListener{

	private TextView title;
	private TextView back;
	private RelativeLayout approval_layoutRl;
	private RelativeLayout salon_earnings_layoutRl;
	private RelativeLayout withdrawal_layoutRl;
	private Button withdrawalBtn;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.salon_manager_layout);
		
		title = (TextView)findViewById(R.id.title_txt);
		title.setText("沙龙管理");
		
		back = (TextView)findViewById(R.id.title_back);
		back.setBackgroundDrawable(getResources().getDrawable(R.drawable.iconfont_fanhui));
		
		initView();
	}
	
	private void initView(){
		approval_layoutRl = (RelativeLayout)findViewById(R.id.approval_layout);
		approval_layoutRl.setOnClickListener(this);
		salon_earnings_layoutRl = (RelativeLayout)findViewById(R.id.salon_earnings_layout);
		salon_earnings_layoutRl.setOnClickListener(this);
		withdrawal_layoutRl = (RelativeLayout)findViewById(R.id.withdrawal_layout);
		withdrawal_layoutRl.setOnClickListener(this);
		withdrawalBtn = (Button)findViewById(R.id.withdrawal);
		withdrawalBtn.setOnClickListener(this);
	}


	@Override
	public void onClick(View v) {
		switch(v.getId()){
			case R.id.approval_layout:
				Intent approvalIntent = new Intent(SalonManagerActivity.this,ApprovalManagerActivity.class);
				startActivity(approvalIntent);
				break;
			case R.id.salon_earnings_layout:
				Intent searningsIntent = new Intent(SalonManagerActivity.this,SalonEarningsActivity.class);
				startActivity(searningsIntent);
				break;
			case R.id.withdrawal_layout:
				Intent withdrawalRecordsIntent = new Intent(SalonManagerActivity.this,WithdrawalRecordsActivity.class);
				startActivity(withdrawalRecordsIntent);
				break;
			case R.id.withdrawal:
				Intent withdrawalIntent = new Intent(SalonManagerActivity.this,WithdrawalActivity.class);
				startActivity(withdrawalIntent);
				break;
			default:
				break;
		}
	}
	
}
