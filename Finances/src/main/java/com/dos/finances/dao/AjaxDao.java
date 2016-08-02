package com.dos.finances.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.dos.finances.bean.StockBean3;



@Repository
public class AjaxDao {
	
	
	private String sql;
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	
	@Autowired
	DataSource dataSource;
	
	@Autowired
	JdbcTemplate jdbcTemplate;
	
	public String sendMessageIdCheck(String id){
		
		
		String result = "false";

		sql = "select count(*) from finance_member where id='"+id+"'";
		int num = jdbcTemplate.queryForObject(sql, Integer.class);
		if(num == 1){
			
			result = "true";
		}
		return result;
	}
	
	
	public List<StockBean3> getSearchResult(String keyword){
		sql ="select * from finance_stock_list where name like ?";
		List<StockBean3> rList = new ArrayList<StockBean3>();
		StockBean3 result = null;
		try{
			conn = dataSource.getConnection();
			pstmt =conn.prepareStatement(sql);
			pstmt.setString(1, keyword+"%");
			
			rs = pstmt.executeQuery();
			int i = 0;
			while(rs.next()){
				if(i==10){
					break;
				}
				result = new StockBean3();
				result.setCode(rs.getString("code"));
				result.setName(rs.getString("name"));
				
				
				rList.add(result);
				i++;
				
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
		
		return rList;
	}
	
}
