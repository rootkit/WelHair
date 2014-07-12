package com.hair.salon.ui;

import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.ActionBarActivity;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.RadioButton;
import android.widget.TextView;
import android.widget.Toast;

import com.hair.salon.R;

public class MainActivity extends ActionBarActivity implements OnClickListener{

	private RadioButton mHairStyleRadio;
	private RadioButton mSalonRadion;
	private RadioButton mHairDresserRadio;
	private RadioButton mMyRadio;
	private RadioButton mProductionsRadio;
	
	private HairFragment mHairFragment;
	private SalonFragment mSalonFragment;
	private HairStylistFragment mStylistFragment;
	private MyFragment mMyFragment;
	private ProductionsFragment mProductionsFragment;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);

		initView();
		
		
	}

	private void initView(){
		
		mHairStyleRadio = (RadioButton)findViewById(R.id.hair_style);
		mSalonRadion = (RadioButton)findViewById(R.id.hair_salon);
		mHairDresserRadio = (RadioButton)findViewById(R.id.hair_dresser);
		mMyRadio = (RadioButton)findViewById(R.id.my_radiobutton);
		mProductionsRadio = (RadioButton)findViewById(R.id.productions);
		
		mHairStyleRadio.setOnClickListener(this);
		mSalonRadion.setOnClickListener(this);
		mHairDresserRadio.setOnClickListener(this);
		mMyRadio.setOnClickListener(this);
		mProductionsRadio.setOnClickListener(this);
		showTab(0);
	}

	@Override
	public void onClick(View v) {
		this.mHairStyleRadio.setBackgroundResource(R.drawable.root_bottom_tab1);
		this.mSalonRadion.setBackgroundResource(R.drawable.root_bottom_tab2);
		this.mProductionsRadio.setBackgroundResource(R.drawable.root_bottom_tab3);
		this.mHairDresserRadio.setBackgroundResource(R.drawable.root_bottom_tab4);
		this.mMyRadio.setBackgroundResource(R.drawable.root_bottom_tab5);
		switch(v.getId()){
		case R.id.hair_style:
			this.mHairStyleRadio.setBackgroundResource(R.drawable.root_bottom_tab1selected);
			showTab(0);
			break;
		case R.id.hair_salon:
			this.mSalonRadion.setBackgroundResource(R.drawable.root_bottom_tab2selected);
			showTab(1);
			break;
		case R.id.productions:
			this.mProductionsRadio.setBackgroundResource(R.drawable.root_bottom_tab3selected);
			showTab(2);
			break;
		case R.id.hair_dresser:
			this.mHairDresserRadio.setBackgroundResource(R.drawable.root_bottom_tab4selected);
			showTab(3);
			break;
		case R.id.my_radiobutton:
			this.mMyRadio.setBackgroundResource(R.drawable.root_bottom_tab5selected);
			showTab(4);
			break;
			
		}
	}
	
	private void showTab(int index){
		FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
		hidenFragments(transaction);
		switch(index){
		case 0:
			if(mHairFragment==null){
				mHairFragment = new HairFragment();
				transaction.add(R.id.container, mHairFragment);
			}else{
				transaction.show(mHairFragment);
			}
			transaction.commit();
			break;
		case 1:
			if(mSalonFragment==null){
				mSalonFragment = new SalonFragment();
				transaction.add(R.id.container, mSalonFragment);
			}else{
				transaction.show(mSalonFragment);
			}
			transaction.commit();
			break;
		case 2:
			if(mProductionsFragment==null){
				mProductionsFragment = new ProductionsFragment();
				transaction.add(R.id.container, mProductionsFragment);
			}else{
				transaction.show(mProductionsFragment);
			}
			transaction.commit();
			break;
		case 3:
			if(mStylistFragment==null){
				mStylistFragment = new HairStylistFragment();
				transaction.add(R.id.container, mStylistFragment);
			}else{
				transaction.show(mStylistFragment);
			}
			transaction.commit();
			break;
		case 4:
			if(mMyFragment==null){
				mMyFragment = new MyFragment();
				transaction.add(R.id.container, mMyFragment);
			}else{
				transaction.show(mMyFragment);
			}
			transaction.commit();
			break;
		}
	}
	
	private void hidenFragments(FragmentTransaction transaction){
		if(mHairFragment!=null){
			transaction.hide(mHairFragment);
		}
		if(mSalonFragment!=null){
			transaction.hide(mSalonFragment);
		}
		if(mProductionsFragment!=null){
			transaction.hide(mProductionsFragment);
		}
		if(mStylistFragment!=null){
			transaction.hide(mStylistFragment);
		}
		if(mMyFragment!=null){
			transaction.hide(mMyFragment);
		}
		
	}
	
	/*private long exitTime = 0;
	@Override
	  public boolean onKeyDown(int keyCode, KeyEvent event) {
	   // TODO Auto-generated method stub
		  if(keyCode == KeyEvent.KEYCODE_BACK && event.getAction() == KeyEvent.ACTION_DOWN){
		        if((System.currentTimeMillis()-exitTime) > 2000){  
		            Toast.makeText(getApplicationContext(), "再按一次退出程序", Toast.LENGTH_SHORT).show();                                
		            exitTime = System.currentTimeMillis();   
		        } else {
		            finish();
		           // System.exit(0);
		        }
		        return true;   
		    }
		    return super.onKeyDown(keyCode, event);
	  }*/
}
