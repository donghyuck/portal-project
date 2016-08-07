package com.podosoftware.community.spring.controller;

import java.io.IOException;
import java.util.ArrayList;
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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.podosoftware.community.board.bbs.service.BbsService;
import com.podosoftware.community.board.member.service.MemberService;
import com.podosoftware.community.board.model.AttachFile;
import com.podosoftware.community.board.model.Board;
import com.podosoftware.community.board.model.DefaultBoard;
import com.podosoftware.community.board.model.DefaultQnaBoard;
import com.podosoftware.community.board.model.Member;
import com.podosoftware.community.board.model.QnaBoard;

import architecture.common.user.SecurityHelper;
import architecture.common.user.User;
import architecture.common.util.StringUtils;
import architecture.ee.exception.NotFoundException;
import architecture.ee.web.attachment.Attachment;
import architecture.ee.web.model.DataSourceRequest;
import architecture.ee.web.model.DataSourceRequest.FilterDescriptor;
import architecture.ee.web.model.ItemList;
import architecture.ee.web.ws.Result;

@Controller("podo-community-data-controller")
@RequestMapping("/data/podo")
public class PodoCommunityDataController {
	
	private Log log = LogFactory.getLog(PodoCommunityDataController.class);
	
	@Inject
	@Qualifier("bbsService")
	private BbsService bbsService;
	
	@Inject
	@Qualifier("memberService")
	private MemberService memberService;

	public void setbbsService(BbsService bbsService) {
		this.bbsService = bbsService;
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
	
	@RequestMapping(value = "/member/list.json", method = RequestMethod.GET)
	@ResponseBody
	public List<Member> getMemberList(@RequestParam(value = "search", required = false) String search, NativeWebRequest request) throws Exception {
		
		if(StringUtils.isNotEmpty(search)){
			return memberService.getMemberList(search);
		}else{
			return memberService.getMemberList();
		}
		
	}
	
	@RequestMapping(value = "/member/list/search.json", method = { RequestMethod.POST, RequestMethod.GET })
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
	
	@RequestMapping(value = "/member/list/find.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList findMemberSearchList(
			@RequestBody architecture.ee.web.model.DataSourceRequest dataSourceRequest) throws Exception {
			
		int total = 0;
		List<Member> items;
		
		total = memberService.countMemberList(dataSourceRequest);
		items = memberService.findMemberList(dataSourceRequest, dataSourceRequest.getSkip(), dataSourceRequest.getPageSize());

		return new ItemList(items, total);
	}
	
	
	@RequestMapping(value = "/member/list/update.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Member updateMemberInfo(
			@RequestBody Member member,
			NativeWebRequest request) throws Exception {
		
		memberService.updateMemberInfo(member);
		return member;
	}
	
	@RequestMapping(value = "/member/list/create.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Member createMember(
			@RequestBody Member member,
			NativeWebRequest request) throws Exception {
		
		memberService.createMember(member);
		return member;
	}

	@RequestMapping(value = {"/board/free/list.json", "/board/notice/list.json"}, method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList getBoardList(@RequestBody DataSourceRequest dataSourceRequest) throws Exception {
		int total = 0;
		List<Board> items;
		
		total = bbsService.countBoardList(dataSourceRequest);
		items = bbsService.getBoardList(dataSourceRequest, dataSourceRequest.getSkip(), dataSourceRequest.getPageSize());
		return new ItemList(items, total);
	}
	
	@RequestMapping(value = "/board/qna/list.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList getQnaBoardList(@RequestBody DataSourceRequest dataSourceRequest) throws Exception {
		int total = 0;
		List<QnaBoard> items;
		
		total = bbsService.countBoardList(dataSourceRequest);
		items = bbsService.getQnaList(dataSourceRequest, dataSourceRequest.getSkip(), dataSourceRequest.getPageSize());
		return new ItemList(items, total);
	}
	
	@RequestMapping(value = {"/board/free/write.json", "/board/notice/write.json"}, method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Board write(@RequestBody DefaultBoard board) throws Exception {
		bbsService.write(board);
		return board;
	}
	
	@RequestMapping(value = {"/board/free/delete.json", "/board/notice/delete.json", "/board/qna/delete.json"}, method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Result delete(@RequestBody DefaultBoard board) throws Exception {
		bbsService.delete(board);
		return Result.newResult();
	}
	
	@RequestMapping(value = {"/board/free/updateReadCount.json", "/board/notice/updateReadCount.json"}, method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Result updateReadCount(@RequestBody DefaultBoard board) throws Exception {
		bbsService.updateReadCount(board);
		return Result.newResult();
	}
	
	@RequestMapping(value = "/board/qna/write.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public QnaBoard qnaWrite(@RequestBody DefaultQnaBoard qna) throws Exception {
		bbsService.qnaWrite(qna);
		return qna;
	}
	
	@RequestMapping(value = "/board/qna/updateReadCount.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Result updateQnaReadCount(@RequestBody DefaultQnaBoard qna) throws Exception {
		bbsService.updateQnaReadCount(qna);
		return Result.newResult();
	}
	
	@RequestMapping(value = "/board/free/writeReply.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Board writeReply(@RequestBody DefaultBoard board) throws Exception {
		bbsService.writeReply(board);
		return board;
	}
	
	@RequestMapping(value = "/board/qna/writeReply.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Board writeQnaReply(@RequestBody DefaultQnaBoard qna) throws Exception {
		bbsService.writeQnaReply(qna);
		return qna;
	}

}
