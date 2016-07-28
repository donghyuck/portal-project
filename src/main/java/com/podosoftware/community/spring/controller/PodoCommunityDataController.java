package com.podosoftware.community.spring.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.NativeWebRequest;

import com.podosoftware.community.board.model.Board;
import com.podosoftware.community.board.model.DefaultBoard;
import com.podosoftware.community.board.model.DefaultQnaBoard;
import com.podosoftware.community.board.model.Member;
import com.podosoftware.community.board.model.QnaBoard;
import com.podosoftware.community.board.service.MemberService;
import com.podosoftware.community.list.service.ListService;

import architecture.common.user.SecurityHelper;
import architecture.common.user.User;
import architecture.common.util.StringUtils;
import architecture.ee.exception.NotFoundException;
import architecture.ee.web.model.DataSourceRequest;
import architecture.ee.web.model.DataSourceRequest.FilterDescriptor;
import architecture.ee.web.model.ItemList;
import architecture.ee.web.ws.Result;

@Controller("podo-community-data-controller")
@RequestMapping("/data/podo")
public class PodoCommunityDataController {
	
	private Log log = LogFactory.getLog(PodoCommunityDataController.class);
	
	@Inject
	@Qualifier("listService")
	private ListService listService;
	
	
	@Inject
	@Qualifier("memberService")
	private MemberService memberService;

	
	
	public void setListService(ListService listService) {
		this.listService = listService;
	}
	
		
	
	public MemberService getMemberService() {
		return memberService;
	}



	public void setMemberService(MemberService memberService) {
		this.memberService = memberService;
	}



	@RequestMapping(value = "/hello.json", method = { RequestMethod.POST, RequestMethod.GET })
    @ResponseBody
    public Map hello(NativeWebRequest request) throws NotFoundException {
	
		User user = SecurityHelper.getUser();	
		Map map = new HashMap();
	
		map.put("text", "this is " + user.getName() + ". what's up ?" );
		return map;
    }
	
	@RequestMapping(value = "/list.json", method = RequestMethod.GET)
	@ResponseBody
	public List<Member> getMemberList(@RequestParam(value = "search", required = false) String search, NativeWebRequest request) throws Exception {
		
		if(StringUtils.isNotEmpty(search)){
			return memberService.getMemberList(search);
		}else{
			return memberService.getMemberList();
		}
		
	}
	
	@RequestMapping(value = "/list/search.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public List<Member> getMemberSearchList(
			@RequestBody architecture.ee.web.model.DataSourceRequest dataSourceRequest,
			NativeWebRequest request) throws Exception {
		
		if( dataSourceRequest.getFilter()!=null){
			for( FilterDescriptor fd : dataSourceRequest.getFilter().getFilters()){
				if( StringUtils.equals(fd.getField(),"name"))
				{
					return memberService.getMemberList(fd.getValue().toString());
				}
			}
		}		
		return memberService.getMemberList();
	}
	
	@RequestMapping(value = "/list/find.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList findMemberSearchList(
			@RequestBody architecture.ee.web.model.DataSourceRequest dataSourceRequest) throws Exception {
			
		int total = 0;
		List<Member> items;
		
		total = memberService.countMemberList(dataSourceRequest);
		items = memberService.findMemberList(dataSourceRequest, dataSourceRequest.getSkip(), dataSourceRequest.getPageSize());

		return new ItemList(items, total);
	}
	
	
	@RequestMapping(value = "/list/update.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Member updateMemberInfo(
			@RequestBody Member member,
			NativeWebRequest request) throws Exception {
		
		memberService.updateMemberInfo(member);
		return member;
	}
	
	@RequestMapping(value = "/list/create.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Member createMember(
			@RequestBody Member member,
			NativeWebRequest request) throws Exception {
		
		memberService.createMember(member);
		return member;
	}

	@RequestMapping(value = "/board/listView.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList getBoardList(@RequestBody DataSourceRequest dataSourceRequest) throws Exception {
		int total = 0;
		List<Board> items;
		
		total = listService.countBoardList(dataSourceRequest);
		items = listService.getBoardList(dataSourceRequest, dataSourceRequest.getSkip(), dataSourceRequest.getPageSize());
		return new ItemList(items, total);
	}
	
	@RequestMapping(value = "/board/qnaListView.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList getQnaBoardList(@RequestBody DataSourceRequest dataSourceRequest) throws Exception {
		int total = 0;
		List<QnaBoard> items;
		
		total = listService.countBoardList(dataSourceRequest);
		items = listService.getQnaList(dataSourceRequest, dataSourceRequest.getSkip(), dataSourceRequest.getPageSize());
		return new ItemList(items, total);
	}
	
	@RequestMapping(value = "/board/write.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Board write(@RequestBody DefaultBoard board) throws Exception {
		listService.write(board);
		return board;
	}
	
	@RequestMapping(value = "/board/delete.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Result delete(@RequestBody DefaultBoard board) throws Exception {
		listService.delete(board);
		return Result.newResult();
	}
	
	/**
	 *  AJAX 통신은 특성상 반듯이 데이터가 있어야 합니다.
	 */
	
	@RequestMapping(value = "/board/updateReadCount.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Result updateReadCount(@RequestBody DefaultBoard board) throws Exception {
		listService.updateReadCount(board);
		return Result.newResult();
	}
	
	@RequestMapping(value = "/board/qna/write.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public QnaBoard qnaWrite(@RequestBody DefaultQnaBoard qna) throws Exception {
		listService.qnaWrite(qna);
		return qna;
	}
	
	@RequestMapping(value = "/board/updateQnaReadCount.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Result updateQnaReadCount(@RequestBody DefaultQnaBoard qna) throws Exception {
		listService.updateQnaReadCount(qna);
		return Result.newResult();
	}
	
	@RequestMapping(value = "/board/writeReply.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Board writeReply(@RequestBody DefaultBoard board) throws Exception {
		listService.writeReply(board);
		return board;
	}
	
	@RequestMapping(value = "/board/nextBoard.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Board getNextBoard(@RequestBody DefaultBoard board) throws Exception {
		listService.getNextBoard(board);
		return board;
	}
	
	@RequestMapping(value = "/board/preBoard.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Board getPreBoard(@RequestBody DefaultBoard board) throws Exception {
		listService.getPreBoard(board);
		return board;
	}
	
}
