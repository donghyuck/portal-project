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

import com.podosoftware.community.board.domain.Board;
import com.podosoftware.community.list.domain.Member;
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
	
	/*@Inject
	@Qualifier("boardService")
	private BoardService boardService;
	*/
	public void setListService(ListService listService) {
		this.listService = listService;
	}

	/*public void setBoardService(BoardService boardService) {
		this.boardService = boardService;
	}*/
	
	
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
			return listService.getMemberList(search);
		}else{
			return listService.getMemberList();
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
					return listService.getMemberList(fd.getValue().toString());
				}
			}
		}		
		return listService.getMemberList();
	}
	
	@RequestMapping(value = "/list/find.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList findMemberSearchList(
			@RequestBody architecture.ee.web.model.DataSourceRequest dataSourceRequest) throws Exception {
			
		int total = 0;
		List<Member> items;
		
		total = listService.countMemberList(dataSourceRequest);
		items = listService.findMemberList(dataSourceRequest, dataSourceRequest.getSkip(), dataSourceRequest.getPageSize());

		return new ItemList(items, total);
	}
	
	
	@RequestMapping(value = "/list/update.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Member updateMemberInfo(
			@RequestBody Member member,
			NativeWebRequest request) throws Exception {
		
		listService.updateMemberInfo(member);
		return member;
	}
	
	@RequestMapping(value = "/list/create.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Member createMember(
			@RequestBody Member member,
			NativeWebRequest request) throws Exception {
		
		listService.createMember(member);
		return member;
	}

	@RequestMapping(value = "/board/listView.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList getBoardList(@RequestBody DataSourceRequest dataSourceRequest) throws Exception {
		int total = 0;
		List<Board> items;
		//log.debug(dataSourceRequest.getData());
		
		total = listService.countBoardList(dataSourceRequest);
		items = listService.getBoardList(dataSourceRequest, dataSourceRequest.getSkip(), dataSourceRequest.getPageSize());

		return new ItemList(items, total);
	}
	
	@RequestMapping(value = "/board/write.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Board write(@RequestBody Board board, DataSourceRequest request) throws Exception {
		listService.write(board, request);
		return board;
	}
	
	@RequestMapping(value = "/board/delete.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public void delete(@RequestBody Board board) throws Exception {
		listService.delete(board);
	}
	
	@RequestMapping(value = "/board/updateReadCount.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public void updateReadCount(@RequestBody Board board) throws Exception {
		listService.updateReadCount(board);
	}
	
	
}
