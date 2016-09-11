package com.dos.finances.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.BeanPropertySqlParameterSource;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.stereotype.Repository;

import com.dos.finances.bean.FriendBean;
import com.dos.finances.bean.MemberBean;
import com.dos.finances.bean.MessageBean;

@Repository
public class MemberDao {
	
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	private NamedParameterJdbcTemplate namedJdbcTemplate;
	
	
	String sql;
	
	public MemberBean getLoginMember(HttpServletRequest request){
		return (MemberBean)request.getSession().getAttribute("loginMember");
	}
	
	
	public void addFriendMessage(HttpServletRequest request){
		MemberBean me = getLoginMember(request);
		String id = request.getParameter("id");
		
		System.out.println("me : " + me.getId());
		System.out.println("friend : " + id);
		sql ="insert into finance_message(time,sender,title,receiver,content,checked)"
				+ " values(now(),'"+me.getId()+"','"+me.getId()+"님의 친구 등록','"+id+"','"+me.getId()+"님께서 친구로 등록하셨습니다',false)";
		
		jdbcTemplate.update(sql);
		
	}
	

	
	public void getFriendList(HttpServletRequest request){
		String me = getLoginMember(request).getId();
		
		sql ="select * from finance_friend where me = '"+me+"'";
		
		List<FriendBean> fList = jdbcTemplate.query(sql, new FriendBeanRowMapper());
		
		
		request.setAttribute("fList", fList);
	}
	
	
	public void messageSearchService(HttpServletRequest request){

		String id = ((MemberBean)request.getSession().getAttribute("loginMember")).getId();
		int list = Integer.parseInt(request.getParameter("list"));
		String keyword = "%"+request.getParameter("keyword")+"%";
		int option = Integer.parseInt(request.getParameter("option"));
		
		
		System.out.println("id : " +id +"   keyword : " + keyword);
		
		String pageNo = request.getParameter("pageNo");
		
		int startNo = (Integer.parseInt(pageNo)-1)*10;
		int endNo = startNo + 10;
		
		

		String sql1 = null;
		//제목
		if(option==1){
			
			//보낸 메시지 리스트- 받는이
			if(list==1){
				sql1 = "select * from finance_message where sender = :id and title like :keyword order by time desc limit :startNo, :endNo";
			//받은 메시지 리스트- 받는이
			}else{
				sql1 = "select * from finance_message where receiver = :id and title like :keyword order by time desc limit :startNo, :endNo";
			}
			
		//받는이 or 보낸이
		}else{
			//보낸 메시지 리스트- 받는이
			if(list==1){
				sql1 = "select * from finance_message where sender = :id and receiver like :keyword order by time desc limit :startNo, :endNo";
			//받은 메시지 리스트- 받는이
			}else{
				sql1 = "select * from finance_message where receiver = :id and sender like :keyword order by time desc limit :startNo, :endNo";
			}
		}
		
		SqlParameterSource param = new MapSqlParameterSource().addValue("id",id)
				.addValue("startNo",startNo).addValue("endNo",endNo).addValue("keyword",keyword);
		
	
		
		
		List<MessageBean> messages = namedJdbcTemplate.query(sql1,param, new MessageBeanRowMapper());
		
		System.out.println("리스트 크기 : " + messages.size());
		request.setAttribute("messages", messages);
		
		
		//다음 페이지가 존재하는지 체크하는 알고리즘
		
		String sql2 = null;


		if(option==1){
			
			//보낸 메시지 리스트- 받는이
			if(list==1){
				sql2 = "select count(*) from finance_message where sender = :id and title like :keyword order by time desc";
			//받은 메시지 리스트- 받는이
			}else{
				sql2 = "select count(*) from finance_message where receiver = :id and title like :keyword order by time desc";
			}
			
		//받는이 or 보낸이
		}else{
			//보낸 메시지 리스트- 받는이
			if(list==1){
				sql2 = "select count(*) from finance_message where sender = :id and receiver like :keyword order by time desc";
			//받은 메시지 리스트- 받는이
			}else{
				sql2 = "select count(*) from finance_message where receiver = :id and sender like :keyword order by time desc";
			}
		}
		int totalCount = namedJdbcTemplate.queryForObject(sql2, param,Integer.class);
		System.out.println("totalCount : " + totalCount + "      endNo : " + endNo);
		if(totalCount < endNo){
			System.out.println("다음 페이지가 존재하지 않습니다.");
			request.setAttribute("nextPageExist",false);
		}else{
			System.out.println("다음 페이지가 존재 합니다.");
			request.setAttribute("nextPageExist",true);
		}
		
	}
	
	public void messageListService(HttpServletRequest request){

		
		String id = ((MemberBean)request.getSession().getAttribute("loginMember")).getId();
		int list = Integer.parseInt(request.getParameter("list"));
		
		String pageNo = request.getParameter("pageNo");
		
		int startNo = (Integer.parseInt(pageNo)-1)*10;
		int endNo = startNo + 10;
		
		
		SqlParameterSource param = new MapSqlParameterSource().addValue("id",id)
				.addValue("startNo",startNo).addValue("endNo",endNo);
		
		
		String sql1 = null;
		
		if(list==1){
			sql1 = "select * from finance_message where sender = :id order by time desc limit :startNo, :endNo";
		}else{
			sql1 = "select * from finance_message where receiver = :id order by time desc limit :startNo, :endNo";
		}
		

		
		List<MessageBean> messages = namedJdbcTemplate.query(sql1,param, new MessageBeanRowMapper());
		
		System.out.println("리스트 크기 : " + messages.size());
		request.setAttribute("messages", messages);
		
		
		
		
		//다음 페이지가 존재하는지 체크하는 알고리즘
		
		String sql2 = null;

		//보낸 메시지 리스트
		if(list ==1 ){
			sql2 = "select count(*) from finance_message where sender = :id";
		}else{
		//받은 메시지 리스트	
			sql2 = "select count(*) from finance_message where receiver = :id";

		}
		int totalCount = namedJdbcTemplate.queryForObject(sql2, param,Integer.class);
		System.out.println("totalCount : " + totalCount + "      endNo : " + endNo);
		if(totalCount < endNo){
			System.out.println("다음 페이지가 존재하지 않습니다.");
			request.setAttribute("nextPageExist",false);
		}else{
			System.out.println("다음 페이지가 존재 합니다.");
			request.setAttribute("nextPageExist",true);
		}
		
		
		
		
	}
	
	public int getUncheckedMessageCount(String id){
		sql ="select count(*) from finance_message where receiver = '"+id+"' and checked = false";
		
		return jdbcTemplate.queryForObject(sql, Integer.class);
		
	}
	
	public void messageOpen(String id, int no){
		//받는이가 이 메시지를 확인할때 아래의 코드가 수행된다.
		sql="select receiver from finance_message where message_code = "+no;
		
		String receiver = jdbcTemplate.queryForObject(sql,String.class);
		
		if(!receiver.equals(id)){
			System.out.println("메시지 받는 회원이 아닙니다.");
			return;
		}
		
		
		sql = "select checked from finance_message where message_code = "+no;
		
		boolean checked = jdbcTemplate.queryForObject(sql, Boolean.class);
		
		
		
		if(checked){
			System.out.println("이미 확인한 메시지 입니다.");
		}else{
			System.out.println("처음 확인한 메시지 입니다.");
			sql = "update finance_message set checked = true where message_code = "+no;
			jdbcTemplate.update(sql);
		}
	}
	
	public MessageBean getMessageBean(int no){
		sql ="select * from finance_message where message_code = "+no;
		
		return jdbcTemplate.query(sql, new MessageBeanRowMapper()).get(0);
	}
	
	public void messageService(HttpServletRequest request){
		String id = ((MemberBean)request.getSession().getAttribute("loginMember")).getId();

		sql = "select * from finance_message where sender = '"+id+"' order by time desc limit 10";
		
		List<MessageBean> sendMessageList = jdbcTemplate.query(sql, new MessageBeanRowMapper());
		
		
		sql = "select * from finance_message where receiver = '"+id+"' order by time desc limit 10";
		
		List<MessageBean> receiveMessageList = jdbcTemplate.query(sql, new MessageBeanRowMapper());
		
		request.setAttribute("sendMessages",sendMessageList);
		request.setAttribute("receiveMessages",receiveMessageList);
		

	}
	
	public void addFriend(String me, String friend){
		sql = "insert into finance_friend values(now(),'"+me+"','"+friend+"')";
		jdbcTemplate.update(sql);
	}
	
	public boolean friendCheck(String myId,String id){
		
		boolean result = false;
		
		
		sql = "select count(*) from finance_friend where me = '"+myId+"' and friend = '"+id+"'" ;
		
		
		int check = jdbcTemplate.queryForObject(sql, Integer.class);
		
		if(check == 1){
			System.out.println("해당 회원은 친구로 등록되어 있습니다.");
			result= true;
		}
		return result;
	}
	
	//회원정보를 DB에 입력하는 메소드
	
	public void insertMember(MemberBean member){
	
		sql = "insert into finance_member values(:id,:password,:gender,:nickname,:phone,'"+member.getZip_code()+"',:address1,:address2,5000000)";
		
		SqlParameterSource namedParam = new BeanPropertySqlParameterSource(member);
		
		namedJdbcTemplate.update(sql, namedParam);
	}
	
	
	public void sendMessageProcess(MessageBean message){
		String content = message.getContent();
		
		content.replaceAll("\u0020","&nbsp;");
		content.replaceAll("\r\n","<br/>");
		message.setContent(content);
		SqlParameterSource beanParam = new BeanPropertySqlParameterSource(message);
		
		sql ="insert into finance_message(time,sender,title,receiver,content,checked) values(now(),:sender,:title,:receiver,:content,false)";
		
		namedJdbcTemplate.update(sql, beanParam);
	}

	
	public boolean loginCheck(String id, String pass){
	
	boolean result = false;
	sql = "select password from finance_member where id = '"+id+"'";
	
	String password = jdbcTemplate.queryForObject(sql,String.class);
	
	if(pass.equals(password)){
		System.out.println("비밀번호가 일치합니다.");
		result= true;
	}else{
		System.out.println("비밀번호가 일치하지 않습니다.");
	}

	return result;
	}
	
	public MemberBean getMemberBean(String id){
		sql = "select * from finance_member where id = '"+id+"'";
		return jdbcTemplate.queryForObject(sql, new MemberBeanRowMapper());
	}
	
	public boolean idCheck(String id){
		sql = "select count(*) from finance_member where id = '"+id+"'";
		boolean idCheck = false;
		
		int check = jdbcTemplate.queryForObject(sql, Integer.class);
		if(check == 1){
			idCheck = true;
			
		}

		//중복이면 false 리턴
		return !idCheck;
	}
	
	
	public boolean checkInterestStock(String id,String code){
		boolean isInterested = false;
		sql = "select count(*) from finance_interest where id = '"+id+"' and code = '"+code+"'";
		int check = jdbcTemplate.queryForObject(sql, Integer.class);
		
		if(check==1){//id와 code 에 해당하는 데이터가 존재하여 count가 1이 된다면 참 처리 하라
			isInterested = true;
		}
	
		return isInterested;
	}
	
	class MemberBeanRowMapper implements RowMapper<MemberBean>{

		@Override
		public MemberBean mapRow(ResultSet rs, int rowNum) throws SQLException {
			
			MemberBean m = new MemberBean();
			
			m.setId(rs.getString(1));
			m.setGender(rs.getString(3));
			m.setNickname(rs.getString(4));
			m.setPhone(rs.getString(5));
			m.setZip_code(rs.getString(6));
			m.setAddress1(rs.getString(7));
			m.setAddress2(rs.getString(8));
			m.setMoney(rs.getInt(9));
			
			return m;
		}
		
	}
	
	class MessageBeanRowMapper implements RowMapper<MessageBean>{

		@Override
		public MessageBean mapRow(ResultSet rs, int rowNum) throws SQLException {
			MessageBean m = null;
			m = new MessageBean();
			m.setMessageCode(rs.getInt(1));
			m.setTime(rs.getTimestamp(2));
			m.setSender(rs.getString(3));
			m.setTitle(rs.getString(4));
			m.setReceiver(rs.getString(5));
			m.setContent(rs.getString(6));
			m.setChecked(rs.getBoolean(7));
			System.out.println("\n\n message_code : " + m.getMessageCode() );
			System.out.println("time : " + m.getTime());
			System.out.println("title : " +m.getTitle());
			System.out.println("sender : " + m.getSender());
			System.out.println("receiver : " + m.getReceiver());
			System.out.println("content : " + m.getContent());
			System.out.println("checked : " + m.isChecked());
				
			return m;
		}
		
	}
	
	class FriendBeanRowMapper implements RowMapper<FriendBean>{
		@Override
		public FriendBean mapRow(ResultSet rs, int arg1) throws SQLException {
			FriendBean f = new FriendBean();
			f.setTime(rs.getTimestamp("time"));
			f.setMe(rs.getString("me"));
			f.setFriend(rs.getString("friend"));
			
			System.out.println("\n\n Friend Info\n time : " + f.getTime() +"\n me : " + f.getMe() +"\n friend : " +f.getFriend());
			return f;
		}
		
	}

	
}
