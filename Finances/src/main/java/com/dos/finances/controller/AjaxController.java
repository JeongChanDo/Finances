package com.dos.finances.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.dos.finances.dao.AjaxDao;
import com.dos.finances.dao.MemberDao;
import com.dos.finances.dao.StockDao;
import com.dos.finances.etc.MessageSendIdCheck;
import com.dos.finances.etc.MessageSendIdCheckResult;

@RequestMapping("/ajax")
@Controller
public class AjaxController {
	
	@Autowired
	StockDao stockDao;
	
	
	@Autowired
	MemberDao memberDao;
	
	@Autowired
	AjaxDao ajaxDao;
	
	
	@RequestMapping("/idCheck")
	public String idCheck(String id,HttpServletRequest request){
		request.setAttribute("result",memberDao.idCheck(id));
		
		return "ajax/idCheck";
	}
	
	@RequestMapping(value = "/loginProcess", method = RequestMethod.POST)
	public String loginProcess(HttpServletRequest request,String id,String pass){
		request.setAttribute("result", memberDao.loginCheck(id, pass));
		return "ajax/loginProcess";
	}
	
	@RequestMapping("/autoComplete")
	public String autoComplete(String keyword,HttpServletRequest request){
		request.setAttribute("rList",ajaxDao.getSearchResult(keyword));
		
		return "ajax/autoComplete";
	}
	
	@RequestMapping("/myStockAjax")
	public String myStockAjax(String code,HttpServletRequest request){
		request.setAttribute("stockBean2",stockDao.getStockBean2(code));
		request.setAttribute("datas", stockDao.getStockListForGraph(code));
		request.setAttribute("datas2",stockDao.getStockListForGraphLatestMonth(code));
		return "ajax/myStockAjax";
	}
	
	@RequestMapping(value="/sendMessageCheck",method=RequestMethod.POST)
	@ResponseBody
	public MessageSendIdCheckResult messageIdCheck(@RequestBody MessageSendIdCheck ajaxRequest){
		MessageSendIdCheckResult result = new MessageSendIdCheckResult();
		
		
		
		
		String response = ajaxDao.sendMessageIdCheck(ajaxRequest.getId());
		result.setResult(response);
		
		
		return result;
	}
}
