package com.podosoftware.community.list.service;

import java.util.List;

import com.podosoftware.community.board.model.Board;
import com.podosoftware.community.board.model.DefaultQnaBoard;
import com.podosoftware.community.board.model.QnaBoard;
import com.podosoftware.community.list.domain.Member;

import architecture.ee.web.model.DataSourceRequest;

public interface ListService {

	public List<Member> getMemberList();

	public List<Member> getMemberList(String search);
	
	public Integer countMemberList(DataSourceRequest dataSourceRequest);
	
	public List<Member> findMemberList(DataSourceRequest dataSourceRequest, int startIndex, int maxResults);

	public void updateMemberInfo(Member member);

	public void createMember(Member member);

	public Integer countBoardList(DataSourceRequest dataSourceRequest);

	public List<Board> getBoardList(DataSourceRequest dataSourceRequest, int startIndex, int maxResults);

	public void write(Board board);

	public void delete(Board board);

	public void updateReadCount(Board board);
	
	public void updateQnaReadCount(QnaBoard qna);

	public List<QnaBoard> getQnaList(DataSourceRequest dataSourceRequest, int startIndex, int maxResults);

	public void qnaWrite(DefaultQnaBoard qna);

	public void writeReply(Board board);

	public void getNextBoard(Board board);

	public void getPreBoard(Board board);

}
