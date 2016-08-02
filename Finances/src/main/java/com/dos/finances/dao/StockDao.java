package com.dos.finances.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.stereotype.Controller;

import com.dos.finances.bean.BuyStockBean;
import com.dos.finances.bean.StockBean2;
import com.dos.finances.bean.StockBean4;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;


@Controller
public class StockDao {
	
	
	String sql;
	
	@Autowired
	JdbcTemplate jdbcTemplate;
	
	@Autowired
	NamedParameterJdbcTemplate namedParamJdbcTemplate;
	
	@Autowired
	DataSource dataSource;
	
	Connection conn;
	PreparedStatement pstmt;
	ResultSet rs;
	

	
	//업데이트시 safe update 옵션이 켜진경우 사용
	
	public void unlcokSafeUpdate(){
		
		sql = "set sql_safe_updates=0";
		
		jdbcTemplate.update(sql);
	}
	
	//총 주가 자산
	public int getTotalStockSum(String id){
		sql  = "select * from finance_stock_trade_buy where id = '"+id+"'";
		
		List<Integer> list = jdbcTemplate.query(sql,new RowMapper<Integer>(){

			@Override
			public Integer mapRow(ResultSet rs, int rowNum) throws SQLException {
				int volume = rs.getInt("volume");
				int price = rs.getInt("price");
				
				
				return volume * price;
			}
			
		});
		int sum = 0;
		for(int a : list){
			sum += a;
		}
		
	
		return sum;
	}
	
	//구입한 주식 목록 리스트
	public List<BuyStockBean> getBuyStockList(String id){
		sql ="select t1.time,t1.id, t1.code,t1.name,t1.price,"
				+ "t1.totalprice, t1.volume, t2.price "
				+ "from finance_stock_trade_buy t1, "
				+ "(select * from finance_stock_price_day"
				+ " where time = (select max(time) from finance_stock_price_day)) t2"
				+ " where t1.code = t2.code and t1.id = '"+id+"' order by time desc";
		
		return jdbcTemplate.query(sql, new BuyStockBeanRowMapper());
	}
	
	//구입한 주식 
	public BuyStockBean getBuyStockBean(String code, String id, String time){
		
		sql ="select t1.time,t1.id, t1.code,t1.name,t1.price,"
				+ "t1.totalprice, t1.volume, t2.price "
				+ "from finance_stock_trade_buy t1, "
				+ "(select * from finance_stock_price_day"
				+ " where time = (select max(time) from finance_stock_price_day)) t2"
				+ " where t1.code = t2.code and t1.id = '"+id+"' "
				+ "and t1.code = '"+code+"' and t1.time = '"+time+"'";

		return jdbcTemplate.queryForObject(sql, new BuyStockBeanRowMapper());
	}

	
	
	
	//종가 가져오는 메소드
	public List<StockBean4> getYesterdayStockList(){
		
		
		//p2는 지난 종가와 이번 종가의 차이
		sql = "select s1.code, s1.name, s1.price price1, (s1.price-s2.price) price2 from"
				+ " (select * from finance_stock_price_day where time ="
				+ " (select max(time) from finance_stock_price_day) order by code)"
				+ " s1, (select * from finance_stock_price_day where time ="
				+ " (select max(time) from finance_stock_price_day where time"
				+ " like (select concat(substr(min(time),1,10),'%') from"
				+ " finance_stock_price_day)) order by code) s2 where s1.code ="
				+ " s2.code";
		
		return jdbcTemplate.query(sql, new StockBean4RowMapper());
		
	}
	
	//관심주 - 종가 가져오는 메소드
	public List<StockBean4> getInterestedStockList(String id){
		
		List<StockBean4> iList = new ArrayList<StockBean4>();
		//p2는 지난 종가와 이번 종가의 차이
		sql = "select l1.code, l1.name, l1.price1, l1.price2 from"
				+ " (select s1.code, s1.name, s1.price price1, (s1.price-s2.price) price2"
				+ " from (select * from finance_stock_price_day"
				+ " where time = (select max(time) from finance_stock_price_day)"
				+ " order by code) s1, (select * from finance_stock_price_day"
				+ " where time = (select max(time) from finance_stock_price_day"
				+ " where time like (select concat(substr(min(time),1,10),'%')"
				+ " from finance_stock_price_day)) order by code) s2"
				+ " where s1.code = s2.code) l1,"
				+ " (select s2.code code,s2.name name,s2.price price"
				+ " from	(select * from finance_interest where id = ?) s1,"
				+ " (select * from finance_stock_price_day  where time ="
				+ " (select max(time) from finance_stock_price_day)) s2"
				+ " where s1.code = s2.code order by s2.name) l2 where l1.code = l2.code";
		StockBean4 stock;
		
		try{
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				stock = new StockBean4();
				stock.setCode(rs.getString(1));
				stock.setName(rs.getString(2));
				stock.setPrice(rs.getInt(3));
				stock.setPrice2(rs.getInt(4));
				iList.add(stock);
			}
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			try{
				if(rs !=null) rs.close();
				if(pstmt !=null) pstmt.close();
				if(conn !=null) conn.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		
		return iList;
		
	}
	
	
	public StockBean2 getStockBean2(String code){
		sql = "select * from finance_stock_price_day where code = '"+code+"' "
				+ "and time = (select max(time) from finance_stock_price_day where code = '"+code+"')";
		
		
		
		return jdbcTemplate.queryForObject(sql,new StockBean2RowMapper());
		
	}
	
	public List<String> getStockListForGraph(String code){
		//데이터 수 부터 구하자
		sql = "select count(*) from finance_stock_price_day where code = '"+code+"' ";
		
		int count = 0;
		
		count = jdbcTemplate.queryForObject(sql, Integer.class);
		
		List<String> timePrice = new ArrayList<String>();
		sql = "select substr(time,12,5), price from finance_stock_price_day where code = '"+code+"' order by time";
		//	sql = "select substr(time,10,5) time, price from finance_stock_price_day where code = ? order by time";

		
		String times = "[";//시간정보
		String prices = "[";//가격정보
		
		
		int[] minMax = new int[count];
		try{
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			int i = 0;
			while(rs.next()){
				minMax[i] += Integer.parseInt(rs.getString(2));
				
				times += "'"+rs.getString(1)+"'"+(i==count-1?"":",");
				prices +=rs.getString(2)+(i==count-1?"":",");	
				i++;
			}
			
			times +="]";
			prices +="]";
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			try{
				if(rs !=null) rs.close();
				if(pstmt !=null) pstmt.close();
				if(conn !=null) conn.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		
		
		
		Arrays.sort(minMax);
		
		
		String min = ""+minMax[0]; // 최소값 
		String max = ""+minMax[count-1]; //최댓값 
		String interval = ""+Math.round((minMax[count-1]-minMax[0])/2);//주기  round
		
		
		timePrice.add(times);
		timePrice.add(prices);
		timePrice.add(min);
		timePrice.add(max);
		timePrice.add(interval);
		
		return timePrice;
	}
	
	public List<String> getStockListForGraphLatestMonth(String code){
		//데이터 수 부터 구하자
		sql = "select count(*) from finance_stock_price_month where code = '"+code+"' order by day desc";
		
		int count = 0;
		
		count = jdbcTemplate.queryForObject(sql, Integer.class);
		
		
		List<String> timePrice = new ArrayList<String>();
		sql = "select day, price from finance_stock_price_month where code = '"+code+"' order by day";
		//	sql = "select substr(time,10,5) time, price from finance_stock_price_day where code = ? order by time";

		
		String times = "[";//시간정보
		String prices = "[";//가격정보
		
		
		int[] minMax = new int[count];
		try{
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			int i = 0;
			while(rs.next()){
				minMax[i] += Integer.parseInt(rs.getString(2));
				
				times += "'"+rs.getString(1).substring(5,10)+"'"+(i==count-1?"":",");
				prices +=rs.getString(2)+(i==count-1?"":",");	
				i++;
			}
			
			times +="]";
			prices +="]";
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			try{
				if(rs !=null) rs.close();
				if(pstmt !=null) pstmt.close();
				if(conn !=null) conn.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		
		
		
		Arrays.sort(minMax);
		
		
		String min = ""+minMax[0]; // 최소값 
		String max = ""+minMax[count-1]; //최댓값 
		String interval = ""+Math.round((minMax[count-1]-minMax[0])/2);//주기  round
		
		
		timePrice.add(times);
		timePrice.add(prices);
		timePrice.add(min);
		timePrice.add(max);
		timePrice.add(interval);
		
		
		return timePrice;
	}
	
	//오늘 등록된 데이터를 finance_stock_price_total 테이블에 입력시킨다.
	public void updatePriceTotal(){
		System.out.println("업데이트 시작");
		sql = "insert into finance_stock_price_total select * "
				+ "from finance_stock_price_day where time like "
				+ "(select concat(substr(max(time),1,10),'%')"
				+ " from finance_stock_price_day) order by time desc";

		
		jdbcTemplate.update(sql);
	}
	
	//지지난 일자에 대한 정보  price_day에서 삭제하는 메소드
	public void deletePriceDay(){
		System.out.println("지지난 일자 정보 삭제 시작");
		sql = "delete from finance_stock_price_day where time like "
				+ "(select t.* from (select concat(substr(min(time),1,10),'%')"
				+ " time from finance_stock_price_day) t)";

		jdbcTemplate.update(sql);

	}
	
	public void buyProcess
		(int volume, int price, int totalPrice, int balance, String code, String id,String name){
		System.out.println("name : " + name);

		//매입 기록
		sql = "insert into finance_stock_trade_buy values(:time,:id,:code,:name,:price,:totalPrice,:volume)";
		
		SqlParameterSource namedParam = 
				new MapSqlParameterSource().addValue("time",new Timestamp(System.currentTimeMillis())).
				addValue("id",id).addValue("code",code).addValue("name",name)
				.addValue("price",price).addValue("totalPrice",totalPrice).addValue("volume",volume);
		
		namedParamJdbcTemplate.update(sql, namedParam);
		
		//history 기록
		sql = "insert into finance_stock_trade_history values(:time,:id,:code,:name,:price,:totalPrice,:volume,'buy')";
		
		namedParamJdbcTemplate.update(sql, namedParam);

		//회원정보 변경
		sql ="update finance_member set money = "+balance+" where id = '"+id+"'";
		
		jdbcTemplate.update(sql);
		
		
		//매입 기록
		sql ="update finance_stock set stock = stock + "+volume +" where code = '"+code+"'";
		
		jdbcTemplate.update(sql);

	
		
	}
	
	public void stockholderProcess(HttpServletRequest request){
		String code = request.getParameter("code");
		
		sql = "select stock from finance_stock where code = '"+code+"'";
		int totalStock = jdbcTemplate.queryForObject(sql, Integer.class);
		request.setAttribute("totalStock",totalStock);


		
		Map<String,Integer> totalStockById = getTotalStockAboutCode(code);
		Iterator<Map.Entry<String,Integer>> mapIter = totalStockById.entrySet().iterator();
		
		
		
		//가져온 map을 정렬시켜야한다.. arrayList 로 담자
		ArrayList<Stockholder> sList = new ArrayList<Stockholder>();
		
		Stockholder s = null;
		
		while(mapIter.hasNext()){
			s = new Stockholder();
			Map.Entry<String, Integer> mapEntry = mapIter.next();
			s.setName(mapEntry.getKey());
			s.setVolume(mapEntry.getValue());
			
			sList.add(s);
			
		}
		
		sList.sort(new Comparator<Stockholder>(){


			@Override
			public int compare(Stockholder a, Stockholder b) {

				
				if(a.getVolume() == b.getVolume()){
					return 0;
				} 
				
				return  a.getVolume() > b.getVolume() ? -1 : 1;
				
			}
		});
		
		
		int numberOfStockholder = 0;
		int etcStockVolume = 0;
		//jsonData 만들기
		if(!sList.isEmpty()){
			Iterator<Stockholder> iter = sList.iterator();
		
			
			JsonArray array = new JsonArray();
			JsonObject b = null;
			
		
			
				while(iter.hasNext()){
					
					//info 페이지에 표시되는 사람수는 5명까지 하고 나머지는 기타로 넣자
					if(numberOfStockholder<5){
						 b = new JsonObject();
						 
						Stockholder stockholder = iter.next();
					
			
						b.addProperty("name",stockholder.getName());
						b.addProperty("y",stockholder.getVolume());
						
						array.add(b);
						System.out.println("b.toString : " + b.toString());
						
						numberOfStockholder++;
					
					//numberOfStockholder가 5보다 같거나 크면 etcStockVolume에 volume을 +시키자
					}else{
						Stockholder stockholder = iter.next();

						etcStockVolume += stockholder.getVolume();
						
					}
					
				}//while문 종료
			System.out.println("기타 주주 주식 보유량 : " +etcStockVolume);

			b = new JsonObject();
			
			b.addProperty("name","기타");
			b.addProperty("y",etcStockVolume);
			

			array.add(b);
			
			System.out.println("array.toString() : " + array.toString());
	
			request.setAttribute("stockholderData", array);
		}
		
		System.out.println("주주 수 : " + numberOfStockholder);
	}
	
	public Map<String,Integer> getTotalStockAboutCode(String code){
		sql = "select id,volume from finance_stock_trade_buy where code = '"+code+"' order by volume desc";
		
		
		//해당 주식을 매입한 아이디들의 리스트를 구한다.
		List<String> stockholderList = jdbcTemplate.query(sql, new RowMapper<String>(){

			@Override
			public String mapRow(ResultSet rs, int rowNum) throws SQLException {

				return rs.getString("id");
			}
		});
		
		System.out.println("중복포함 아이디 갯수 : "+stockholderList.size());
		Set<String> stockholderSet = new HashSet<String>();
		
	
		Iterator<String> listIter = stockholderList.iterator();
		while(listIter.hasNext()){
			stockholderSet.add(listIter.next());
		}
		
		System.out.println("중복제외 아이디 갯수 : "+stockholderSet.size());

		
		//중복 제외한 아이디들 가지고 각 회원들이 가진 총 주식수를 계산한다.
		
		
		
		
		
		
		
		
		//아이디와 총갯수를 담을 Map을 구하자
		Map<String,Integer> totalStock = new HashMap<String,Integer>();
		
		
		
		Iterator<String>  setIter= stockholderSet.iterator();
		
		
		while(setIter.hasNext()){
			String id = setIter.next();
			sql="select volume from finance_stock_trade_buy where id = '"+id+"'";
			
			
			List<Integer> volumeList= jdbcTemplate.query(sql, new RowMapper<Integer>(){
				@Override
				public Integer mapRow(ResultSet rs, int rowNum) throws SQLException {
					return rs.getInt(1);
				}
			});
			
			//위 쿼리문으로 해당 아이디의 시기별 모든 주식의 량 데이터를 구해 리스트에 담고 이터레이터로 돌린다.
			Iterator<Integer> volumeIter = volumeList.iterator();
			int totalVolume = 0;
			
			//이터레이터로 돌리면서 존재하는 모든 볼륨들을 totalVolume 변수에 합을 구하도록 한다.
			while(volumeIter.hasNext()){
				totalVolume += volumeIter.next();
			}
			
			System.out.println("결과 \n id : " + id + " totalVolume : " + totalVolume+"\n\n");
			
			
			//map에다가 아이디와 해당아이디가 가진 그 주식의 총량을 담는다.
			totalStock.put(id,totalVolume);
			
		}
		
	
		
		return totalStock;
	}
	
	public Map<String,Integer> getTotalStockCodeAndVolumeAboutId(String id){
		sql = "select code from finance_stock_trade_buy where id = '"+id+"'";
		
		
		//해당 아이디가 보유한 모든 주식들의 code를 가지고 온다
		List<String> stockList = jdbcTemplate.query(sql, new RowMapper<String>(){

			@Override
			public String mapRow(ResultSet rs, int rowNum) throws SQLException {

				return rs.getString("code");
			}
		});
		
		System.out.println("중복포함 code 갯수 : "+stockList.size());
		Set<String> stockSet = new HashSet<String>();
		
	
		Iterator<String> listIter = stockList.iterator();
		while(listIter.hasNext()){
			stockSet.add(listIter.next());
		}
		
		System.out.println("중복제외 code 갯수 : "+stockSet.size());

		
		//중복 제외한 코드들 가지고 해당 회원이 각 코드(주식) 별 총 주식수를 계산한다.
		
		//코드와 총갯수를 담을 Map을 구하자
		Map<String,Integer> totalStock = new HashMap<String,Integer>();
		
		
		
		Iterator<String>  setIter= stockSet.iterator();
		
		//코드를 하나하나 돌리자
		while(setIter.hasNext()){
			String code = setIter.next();
			sql="select volume from finance_stock_trade_buy where id = '"+id+"' and code = '"+code+"'";
			
			
			List<Integer> volumeList= jdbcTemplate.query(sql, new RowMapper<Integer>(){
				@Override
				public Integer mapRow(ResultSet rs, int rowNum) throws SQLException {
					return rs.getInt(1);
				}
			});
			
			//위 쿼리문으로 해당 아이디와 주식의 량 데이터를 구해 리스트에 담고 이터레이터로 돌린다.
			Iterator<Integer> volumeIter = volumeList.iterator();
			
			int totalVolume = 0;
			
			//이터레이터로 돌리면서 존재하는 모든 볼륨들을 totalVolume 변수에 합을 구하도록 한다.
			while(volumeIter.hasNext()){
				totalVolume += volumeIter.next();
			}
			
			System.out.println("결과 \n code : " + code + " totalVolume : " + totalVolume+"\n\n");
			
			
			//map에다가 아이디와 해당아이디가 가진 그 주식의 총량을 담는다.
			totalStock.put(code,totalVolume);
			
		}
		
		return totalStock;
	}
	
	public Map<String,Integer> getTotalStockNameAndVolumeAboutId(String id){
		sql = "select code from finance_stock_trade_buy where id = '"+id+"'";
		
		
		//해당 아이디가 보유한 모든 주식들의 code를 가지고 온다
		List<String> stockList = jdbcTemplate.query(sql, new RowMapper<String>(){

			@Override
			public String mapRow(ResultSet rs, int rowNum) throws SQLException {

				return rs.getString("code");
			}
		});
		
		System.out.println("중복포함 code 갯수 : "+stockList.size());
		Set<String> stockSet = new HashSet<String>();
		
	
		Iterator<String> listIter = stockList.iterator();
		while(listIter.hasNext()){
			stockSet.add(listIter.next());
		}
		
		System.out.println("중복제외 code 갯수 : "+stockSet.size());

		
		//중복 제외한 코드들 가지고 해당 회원이 각 코드(주식) 별 총 주식수를 계산한다.
		
		//코드와 총갯수를 담을 Map을 구하자
		Map<String,Integer> totalStock = new HashMap<String,Integer>();
		
		
		
		Iterator<String>  setIter= stockSet.iterator();
		
		//코드를 하나하나 돌리자
		while(setIter.hasNext()){
			String code = setIter.next();
			sql="select volume from finance_stock_trade_buy where id = '"+id+"' and code = '"+code+"'";
			
			
			List<Integer> volumeList= jdbcTemplate.query(sql, new RowMapper<Integer>(){
				@Override
				public Integer mapRow(ResultSet rs, int rowNum) throws SQLException {
					return rs.getInt(1);
				}
			});
			
			//위 쿼리문으로 해당 아이디와 주식의 량 데이터를 구해 리스트에 담고 이터레이터로 돌린다.
			Iterator<Integer> volumeIter = volumeList.iterator();
			
			int totalVolume = 0;
			
			//이터레이터로 돌리면서 존재하는 모든 볼륨들을 totalVolume 변수에 합을 구하도록 한다.
			while(volumeIter.hasNext()){
				totalVolume += volumeIter.next();
			}
			
			System.out.println("결과 \n code : " + code + " totalVolume : " + totalVolume+"\n\n");
			
			
			//map에다가 주식 이름과 해당아이디가 가진 그 주식의 총량을 담는다.
			totalStock.put(getStockName(code),totalVolume);
			
		}
		
		return totalStock;
	}
	
	public String getStockName(String code){
		sql ="select name from finance_stock_list where code = '"+code+"'";
		
		return jdbcTemplate.queryForObject(sql, String.class);
	}
	
	
	public void sellProcess
		(String time, int remain,int volume, int price,
				int totalPrice, int balance, String code, String id,String name){
		System.out.println("보유량 - 매도량 : " + (remain - volume));
		//time, code, id는 finance_stock_buy 수정하는데 사용.
		
		SqlParameterSource namedParam = new MapSqlParameterSource()
				.addValue("id",id).addValue("code",code).addValue("volume",remain-volume)
				.addValue("totalPrice", totalPrice).addValue("balance", balance)
				.addValue("name", name).addValue("time", time).addValue("price",price)
				.addValue("timestamp",new Timestamp(System.currentTimeMillis()));
		
		
		if(remain - volume == 0){
			//전량 매도시
			//trade_buy 기록 삭제
			sql = "delete from finance_stock_trade_buy where id = :id and code = :code and time = :time";

			namedParamJdbcTemplate.update(sql, namedParam);

			
		}else{
			//잔량이 있을시
			sql = "update finance_stock_trade_buy set volume = :volume where id = :id and code = :code and time = :time";
			namedParamJdbcTemplate.update(sql, namedParam);

		}
			
		
		//매도 기록
		sql = "insert into finance_stock_trade_sell values(:timestamp,:id,:code,:name,:price,:totalPrice,"+volume+")";
		
		
		namedParamJdbcTemplate.update(sql, namedParam);

		
		
		
		//history 기록
		sql = "insert into finance_stock_trade_history values(:timestamp,:id,:code,:name,:price,:totalPrice,"+volume+",'sell')";
		namedParamJdbcTemplate.update(sql, namedParam);

		
		//회원정보 변경
		sql ="update finance_member set money = "+balance+" where id = '"+id+"'";
		
		jdbcTemplate.update(sql);
	
		

		//매도 기록
		sql ="update finance_stock set stock = stock - "+volume +" where code = '"+code+"'";
		
		jdbcTemplate.update(sql);
		
	}
	
	//주식관련 기록 아이디 o
	public void recordStock(String code, String id, int sort){
		//sort 1 - 조회 2 - 매수 3 - 매도
		sql = "insert into finance_stock_count values(now(),:code,:sort,:id)";
		
		SqlParameterSource param = new MapSqlParameterSource().addValue("code",code)
				.addValue("sort",sort).addValue("id",id);
		
		namedParamJdbcTemplate.update(sql,param);
	}
	
	//주식관련 기록 아이디 x
	public void recordStock(String code, int sort){
		//sort 1 - 조회 2 - 매수 3 - 매도
		sql = "insert into finance_stock_count values(now(),'"+code+"',"+sort+",null)";
		
		jdbcTemplate.update(sql);
	}
	
	
	public void insertBookmark(String id, String code){
		sql = "insert into finance_interest values('"+id+"','"+code+"')";
		
		jdbcTemplate.update(sql);
	}
	
	//북마크를 삭제하는 메소드
	public void deleteBookmark(String id,String code){
		sql = "delete from finance_interest where id = '"+id+"' and code = '"+code+"'";
		
		jdbcTemplate.update(sql);
		
	}
	
	
	class BuyStockBeanRowMapper implements RowMapper<BuyStockBean>{

		@Override
		public BuyStockBean mapRow(ResultSet rs, int rowNum) throws SQLException {
			
			BuyStockBean b = new BuyStockBean();
			b.setTime(rs.getTimestamp(1));
			b.setId(rs.getString(2));
			b.setCode(rs.getString(3));
			b.setName(rs.getString(4));
			b.setPrice(rs.getInt(5));
			b.setTotalPrice(rs.getInt(6));
			b.setVolume(rs.getInt(7));
			b.setCurrentPrice(rs.getInt(8));
			
			return b;
		}
		
	}

	
	
	class StockBean2RowMapper implements RowMapper<StockBean2>{

		@Override
		public StockBean2 mapRow(ResultSet rs, int rowNum) throws SQLException {
			StockBean2 stock = new StockBean2();
			stock.setTime(rs.getTimestamp("time"));
			stock.setCode(rs.getString("code"));
			stock.setName(rs.getString("name"));
			stock.setPrice(rs.getInt("price"));
			return stock;
		}
		
	}
	
	class StockBean4RowMapper implements RowMapper<StockBean4>{

		@Override
		public StockBean4 mapRow(ResultSet rs, int rowNum) throws SQLException {
			StockBean4 s = new StockBean4();
			s.setCode(rs.getString("code"));
			s.setName(rs.getString("name"));
			s.setPrice(rs.getInt("price1"));
			s.setPrice2(rs.getInt("price2"));
			return s;
		}
		
	}
	
	
	class Stockholder{
		String name;
		int volume;
		
		public String getName() {
			return name;
		}
		public void setName(String name) {
			this.name = name;
		}
		public int getVolume() {
			return volume;
		}
		public void setVolume(int volume) {
			this.volume = volume;
		}
		
		
	}
}
