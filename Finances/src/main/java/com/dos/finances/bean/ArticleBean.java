package com.dos.finances.bean;

import java.sql.Timestamp;

import org.apache.ibatis.type.Alias;

@Alias("ArticleBean")
public class ArticleBean {
	int no;
	String title;
	String writer;
	String nickname;
	String content;
	int boardNo;
	Timestamp day;
	int ref;
	int seq;
	
	
	public int getNo() {
		return no;
	}
	public void setNo(int no) {
		this.no = no;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	

	public int getRef() {
		return ref;
	}
	public void setRef(int ref) {
		this.ref = ref;
	}
	public int getBoardNo() {
		return boardNo;
	}
	public void setBoardNo(int boardNo) {
		this.boardNo = boardNo;
	}
	public Timestamp getDay() {
		return day;
	}
	public void setDay(Timestamp day) {
		this.day = day;
	}
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	
	
	public void printArticleInfo(){
		System.out.println("\n---------\n");
		System.out.println("글 번호 : "+no);
		System.out.println("글 제목 : "+title);
		System.out.println("작성자 : "+writer);
		System.out.println("별명 : " + nickname);
		System.out.println("내용 : " + content);
		System.out.println("\n---------\n");
	}

}
