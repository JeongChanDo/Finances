package com.dos.finances.etc;

import java.time.LocalDate;
import java.time.LocalTime;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;


@WebListener
public class URICommandListener implements ServletContextListener{

	public void contextInitialized(ServletContextEvent sce){
		
		System.out.println("스레드 갯수 : " + Thread.activeCount());
		Thread.currentThread().interrupt();
		
		Thread.currentThread().getThreadGroup().list();
		
		ServletContext ctx = sce.getServletContext();
		
		final long timeInterval = 1000;
		
	
			Runnable runnable = new Runnable(){
		
			
				public void run(){
									
					boolean isOpen = false;
					
					//지금 장이 열렸는지 여부 체크부터 하자
					
					LocalDate nowDate = LocalDate.now();
					LocalTime nowTime = LocalTime.now();
					
					
					
					String nowDay = nowDate.getDayOfWeek().toString();
					
					//장이 열렸는지 체크
					if(!(nowDay.equals("SATURDAY")||nowDay.equals("SUNDAY"))){
						//오늘이 토요일 또는 일요일이 아니고
						
						if(nowTime.getHour()>=9&&nowTime.getHour()<=14){
							//9~14시 사이면은
							
							isOpen=true;
						}else{//아니면
							isOpen=false;
						}
					}else{
						isOpen=false;
					}//장이 열렸는지 체크 - 완료
					
					System.out.println("서버 시작시 장 열렸는지 여부 : " + (isOpen?"  장이 열려있습니다.":"  장이 닫혀있습니다.")+" - "+"오늘은 "+nowDay+" 입니다.");
					sce.getServletContext().setAttribute("isOpen", isOpen);
	
					while(!Thread.currentThread().isInterrupted()){
						LocalTime now = LocalTime.now();
						LocalDate date = LocalDate.now();
						
						String day = date.getDayOfWeek().toString();
						
						String time = now.getHour()+":"+now.getMinute()+":"+now.getSecond(); 

						
						

						//장이 마감된 토요일 또는 일요일이 아니면
						if(!(day.equals("SATURDAY")||day.equals("SUNDAY"))){
							//지금 시간이 8시 또는 14시 이고
							if(now.getHour()==8||now.getHour()==15){
								//현재 시간이 8시이고 50분보다 크면..
								if(now.getHour()==8 &&now.getMinute()>=45){
									
									//시작15분전 알림
									if(time.equals("8:45:0")){
										System.out.println("시작 15분전");
									}
									
									//시작5분전 알림
									if(time.equals("8:55:0")){
										System.out.println("시작 5분전");
										
										
									}
									
									//시작 1분전 알림
									if(time.equals("8:59:0")){
										System.out.println("시작 1분전");
										
										
									}
								}else if(now.getHour()==15 &&now.getMinute()>=24){		
									//현재 시간이 14시이고 50분보다 크면..
		
									//마감 5분전 알림
									if(time.equals("15:25:0")){
										System.out.println("마감 5분전");
									}
									
									//마감 1분전 알림
									if(time.equals("15:29:0")){
										System.out.println("마감 1분전");
										
							
									}
								}
							}//장 시작, 마감 알림 종료
							
							
							if((now.getHour()>=9&&now.getHour()<=14)||(now.getHour()==15&&now.getMinute()<=26)){//시간이 9:0:0~15:59:59
								
								if(time.equals("9:0:0")){//9시 정각되면
									isOpen = true;
									System.out.println("장이 열렸습니다.");
									sce.getServletContext().setAttribute("isOpen", isOpen);
									
							
								}
							
								
							}//장이 열린동안	15:25:0 에 마지막으로 입력 종료
						
							
							
						
						
						

							if(time.equals("15:30:1")){//시장마친후 15시 0분 1초
								System.out.println("장 종료");
								isOpen = false;
								sce.getServletContext().setAttribute("isOpen", isOpen);
							
							
							
								
							}
						
						}//토 or 일 요일이 아니면  - 조건문 종료
						
						
							
						try{
							Thread.sleep(timeInterval);
						}catch(InterruptedException e){
							e.printStackTrace();
						}
					
					}
				}
				
			};
			
			Thread thread = new Thread(runnable);
			thread.start();
		
	}
	
	public void contextDestroyed(ServletContextEvent sce){
		Thread.interrupted();
		Thread.currentThread().interrupt();
	}
}
