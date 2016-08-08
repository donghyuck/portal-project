package com.podosoftware.community.spring.controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.multipart.MultipartFile;
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
import architecture.ee.web.attachment.AttachmentManager;
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

	@Inject
	@Qualifier("attachmentManager")
	private AttachmentManager attachmentManager;

	public void setbbsService(BbsService bbsService) {
		this.bbsService = bbsService;
	}

	public MemberService getMemberService() {
		return memberService;
	}

	public void setMemberService(MemberService memberService) {
		this.memberService = memberService;
	}

	public AttachmentManager getAttachmentManager() {
		return attachmentManager;
	}

	public void setAttachmentManager(AttachmentManager attachmentManager) {
		this.attachmentManager = attachmentManager;
	}

	@RequestMapping(value = "/hello.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Map hello(NativeWebRequest request) throws NotFoundException {

		User user = SecurityHelper.getUser();
		Map map = new HashMap();

		map.put("text", "this is " + user.getName() + ". what's up ?");
		return map;
	}

	@RequestMapping(value = "/member/list.json", method = RequestMethod.GET)
	@ResponseBody
	public List<Member> getMemberList(@RequestParam(value = "search", required = false) String search,
			NativeWebRequest request) throws Exception {

		if (StringUtils.isNotEmpty(search)) {
			return memberService.getMemberList(search);
		} else {
			return memberService.getMemberList();
		}

	}

	@RequestMapping(value = "/member/list/search.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public List<Member> getMemberSearchList(@RequestBody architecture.ee.web.model.DataSourceRequest dataSourceRequest,
			NativeWebRequest request) throws Exception {

		if (dataSourceRequest.getFilter() != null) {
			for (FilterDescriptor fd : dataSourceRequest.getFilter().getFilters()) {
				if (StringUtils.equals(fd.getField(), "name")) {
					return memberService.getMemberList(fd.getValue().toString());
				}
			}
		}
		return memberService.getMemberList();
	}

	@RequestMapping(value = "/member/list/find.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public ItemList findMemberSearchList(@RequestBody architecture.ee.web.model.DataSourceRequest dataSourceRequest)
			throws Exception {

		int total = 0;
		List<Member> items;

		total = memberService.countMemberList(dataSourceRequest);
		items = memberService.findMemberList(dataSourceRequest, dataSourceRequest.getSkip(),
				dataSourceRequest.getPageSize());

		return new ItemList(items, total);
	}

	@RequestMapping(value = "/member/list/update.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Member updateMemberInfo(@RequestBody Member member, NativeWebRequest request) throws Exception {

		memberService.updateMemberInfo(member);
		return member;
	}

	@RequestMapping(value = "/member/list/create.json", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Member createMember(@RequestBody Member member, NativeWebRequest request) throws Exception {

		memberService.createMember(member);
		return member;
	}

	@RequestMapping(value = { "/board/free/list.json", "/board/notice/list.json" }, method = { RequestMethod.POST,
			RequestMethod.GET })
	@ResponseBody
	public ItemList getBoardList(@RequestBody DataSourceRequest dataSourceRequest) throws Exception {
		int total = 0;
		List<Board> items;

		total = bbsService.countBoardList(dataSourceRequest);
		items = bbsService.getBoardList(dataSourceRequest, dataSourceRequest.getSkip(),
				dataSourceRequest.getPageSize());
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

	@RequestMapping(value = { "/board/free/write.json", "/board/notice/write.json" }, method = { RequestMethod.POST,
			RequestMethod.GET })
	@ResponseBody
	public Board write(@RequestBody DefaultBoard board) throws Exception {

		bbsService.write(board);
		return board;
	}

	@RequestMapping(value = { "/board/free/delete.json", "/board/notice/delete.json",
			"/board/qna/delete.json" }, method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Result delete(@RequestBody DefaultBoard board) throws Exception {
		
		int objectType = 200 ;
		long objectId = board.getBoardNo();
		bbsService.delete(board);
		
		List<Attachment> list = attachmentManager.getAttachments(objectType, objectId);
		for( Attachment a : list)
			attachmentManager.removeAttachment(a);
		
		return Result.newResult();
	}

	@RequestMapping(value = { "/board/free/updateReadCount.json", "/board/notice/updateReadCount.json" }, method = {
			RequestMethod.POST, RequestMethod.GET })
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

	@RequestMapping(value = "/board/files/list.json", method = RequestMethod.POST)
	@ResponseBody
	public List<Attachment> getFiles(
			@RequestParam(value = "boardNo", defaultValue = "0", required = true) Long boardNo) {

		int objectType = 200;
		log.debug(boardNo);
		return attachmentManager.getAttachments(objectType, boardNo);

	}

	@RequestMapping(value = "/board/files/upload.json", method = RequestMethod.POST)
	@ResponseBody
	public List<Attachment> uploadFiles(
			@RequestParam(value = "boardNo", defaultValue = "0", required = true) Long boardNo,
			MultipartHttpServletRequest request) throws NotFoundException, IOException {
		User user = SecurityHelper.getUser();
		Iterator<String> names = request.getFileNames();
		int objectType = 200;
		List<Attachment> files = new ArrayList<Attachment>();

		log.debug("files" + names);

		while (names.hasNext()) {
			String fileName = names.next();
			log.debug("save files:" + fileName);
			MultipartFile mpf = request.getFile(fileName);
			InputStream is = mpf.getInputStream();
			if (boardNo > 0) {
				Attachment attachment = attachmentManager.createAttachment(objectType, boardNo,
						mpf.getOriginalFilename(), mpf.getContentType(), is, (int) mpf.getSize());
				attachmentManager.saveAttachment(attachment);
				files.add(attachment);
			}
		}
		return files;
	}

	@RequestMapping(value = "/board/files/download/{fileId:[\\p{Digit}]+}", method = { RequestMethod.GET, RequestMethod.POST })
	@ResponseBody
	public void downloadFile(@PathVariable("fileId") Long fileId, HttpServletResponse response) throws IOException {

		try {
			if (fileId > 0) {
				Attachment attachment = attachmentManager.getAttachment(fileId);
				InputStream input = attachmentManager.getAttachmentInputStream(attachment);
				response.setContentType(attachment.getContentType());
				response.setContentLength(attachment.getSize());
				IOUtils.copy(input, response.getOutputStream());
				response.setHeader("contentDisposition", "attachment;filename=" + getEncodedFileName(attachment));
				response.flushBuffer();
			}
		} catch (NotFoundException e) {
			response.sendError(404);
		}

	}

	protected String getEncodedFileName(Attachment attachment) {
		try {
			return URLEncoder.encode(attachment.getName(), "UTF-8");
		} catch (UnsupportedEncodingException e) {
			return attachment.getName();
		}
	}
}
