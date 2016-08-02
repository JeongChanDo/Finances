package com.dos.finances.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.dos.finances.bean.StockBean2;
import com.dos.finances.bean.TradeHistoryBean;


@Repository
public class ETCDao {
	
	
	private String sql;
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	@Autowired
	DataSource dataSource;
	
	public List<TradeHistoryBean> getTradeHistoryBeanList(String id){
		List<TradeHistoryBean> hList = new ArrayList<TradeHistoryBean>();
		sql ="select * from finance_stock_trade_history where id = ? order by time desc";
		TradeHistoryBean h = null;
		try{
			
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,id);
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				h = new TradeHistoryBean();
				h.setTime(rs.getTimestamp(1));
				h.setId(rs.getString(2));
				h.setCode(rs.getString(3));
				h.setName(rs.getString(4));
				h.setPrice(rs.getInt(5));
				h.setTotalPrice(rs.getInt(6));
				h.setVolume(rs.getInt(7));
				h.setSort(rs.getString(8));
				
				hList.add(h);
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
		
		
		return hList;
	}
	
	public List<StockBean2> getInterestList(String id){
		List<StockBean2> iList = new ArrayList<StockBean2>();
		StockBean2 stock;
		sql = "select s2.code code,s2.name name,s2.price price from"
				+ " (select * from finance_interest where id = ?) s1,"
				+ " (select * from finance_stock_price_day "
				+ "where time = (select max(time) from finance_stock_price_day)) s2"
				+ " where s1.code = s2.code order by s2.name";
				
		try{
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				stock = new StockBean2();
				stock.setCode(rs.getString(1));
				stock.setName(rs.getString(2));
				stock.setPrice(rs.getInt(3));
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
}
