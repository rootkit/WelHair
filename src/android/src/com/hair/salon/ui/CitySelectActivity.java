package com.hair.salon.ui;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.google.gson.internal.LinkedTreeMap;
import com.hair.salon.R;
import com.hair.salon.bean.City;
import com.hair.salon.bean.RequestVo;
import com.hair.salon.common.Constants;
import com.hair.salon.widget.QuickAlphabeticBar;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ListView;

/**
 * 
 *  选择城市
 */
public class CitySelectActivity extends BaseActivity implements
		OnItemClickListener, OnItemSelectedListener {

	private static final String TAG = "CitySelectActivity";
	private Handler handler = new Handler();
	private ListView listview;
	private LinkedTreeMap lcity;
	private QuickAlphabeticBar alpha;
	//private DataCallback<ResponseVo> callback;

	

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.cityselect_activity);
		setTitle("选择城市");
		setBodyContent();
		alpha = (QuickAlphabeticBar)this.findViewById(R.id.fast_scroller);
		processLogic();
	}

	

	// 设置显示的内容
	private void setBodyContent() {
		listview = (ListView) findViewById(R.id.custonInfoListView);
		listview.setOnItemClickListener(this);
	}
	
	//private List<Map<String, Object>> getData() {
	private List<City> getData() {
		// map.put(参数名字,参数值)
		List<City> list = new ArrayList<City>();
		Map<String, Object> map = new HashMap<String, Object>();
		Iterator iterator=lcity.keySet().iterator();
		City cityBean = new City();
		int addNum = 0;
		char word='A';
		while(iterator.hasNext()){
			String objaaa=(String)iterator.next();
			List mapaaa=(List)lcity.get(objaaa);
			
			if(addNum == 0){
				map = new HashMap<String, Object>();
				cityBean.setCityName("当前定位城市");
				list.add(cityBean);
				cityBean = new City();
				cityBean.setCityName(Constants.SELECTCITY);
				list.add(cityBean);
			}
			addNum++;
			
			String cityNames = "";
			Object cityIds = null;
			
			
			for(int i=0;i<mapaaa.size();i++){
				
				if(i == 0 && mapaaa.size()>0){
					cityBean = new City();
					cityBean.setCityName(String.valueOf(word));
					cityBean.setSortKey(String.valueOf(word));
					list.add(cityBean);
				}
				
				cityBean = new City();
				map = new HashMap<String, Object>();
				cityIds = ((Map)mapaaa.get(i)).get("CityID");
				cityNames = ((Map)mapaaa.get(i)).get("CityName").toString().substring(0, ((Map)mapaaa.get(i)).get("CityName").toString().length());
				
				cityBean.setCityName(cityNames);
				cityBean.setCityID(cityIds.toString());
				cityBean.setSortKey(String.valueOf(word));
				
				list.add(cityBean);
			}
			
			
			
			word = getWord(word,1);
		}
		return list;
	}
	
	protected void processLogic() {
		
		RequestVo vo = new RequestVo();
		HashMap map = new HashMap();

		vo.requestDataMap = map;
		/*vo.requestUrl = R.string.listHomePageCity;
		vo.requestService = R.string.cityWebService;
		vo.jsonParser = new ResponseParser();
		vo.context = context;
		// getDataFromServer(vo,callback);
		getDataFromServer(vo, new DataCallback<ResponseVo>() {
			@Override
			public void processData(ResponseVo paramObject, boolean paramBoolean) {
				// TODO Auto-generated method stub
				Gson gson = new GsonBuilder().setDateFormat(
						"yyyy-MM-dd HH:mm:ss").create();
				LinkedTreeMap obj = gson.fromJson(paramObject.ReturnValue,
						LinkedTreeMap.class);
				lcity = obj;
				Map objaaa = (Map) lcity.get(0);
								
				CitySelectActivityAdapter adapter = new CitySelectActivityAdapter(CitySelectActivity.this, getData(), alpha);
				
				listview.setAdapter(adapter);
				
				alpha.init(CitySelectActivity.this);
				alpha.setListView(listview);
				alpha.setHight(alpha.getHeight());
				alpha.setVisibility(View.VISIBLE);
			}
		});
		*/
	}

	

	/**
	 * 列表选择单击事件
	 */
	@Override
	public void onItemClick(AdapterView<?> parent, View view, int position,
			long id) {
		City city= (City) parent.getAdapter().getItem(position);
		String cityContent = city.getCityName();
		String strCityId = city.getCityID();
		if(strCityId == null){
			
		}else{
			int cityContentid = Integer.parseInt(city.getCityID().toString().substring(0, city.getCityID().toString().length()-2));
			if(isInclude(cityContent)){
				
			}else{
				Intent Intent = new Intent(CitySelectActivity.this, MainActivity.class);
				Constants.SELECTCITY = cityContent;
				Constants.SELECTCITYID = cityContentid;
				startActivity(Intent);
			}
		}
	}

	@Override
	public void onNothingSelected(AdapterView<?> parent) {
	}

	@Override
	public void onItemSelected(AdapterView<?> arg0, View arg1, int arg2,
			long arg3) {
		// TODO Auto-generated method stub
	}
	
	/*
	 * 判断内容是否为大写字母(便于扩展)
	 */
	private Boolean isInclude(String searchStr){
		if("当前定位城市".equals(searchStr)){
			return true;
		}else{
			return Character.isUpperCase(searchStr.charAt(0));
		}
	}
	
	/*
	 * 生成城市首写字母
	 */
	private char getWord(char word,int add){
		int numValue = (int)word; 
		numValue = numValue + 1;
		word = (char)numValue; 
		return word;
	}
}