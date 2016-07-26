package com.podosoftware.community.list.dao;

import java.util.List;

import com.podosoftware.community.board.domain.Board;
import com.podosoftware.community.board.domain.QnaBoard;
import com.podosoftware.community.list.domain.Member;

import architecture.ee.web.model.DataSourceRequest;


public interface ListDao {

	public List<Member> getMemberList();

	public List<Member> getSearchMemberList(String search);

	//public List<Member> findMemberList(DataSourceRequest dataSourceRequest);

	public void updateMemberInfo(Member member);

	public List<Member> findMemberList(DataSourceRequest dataSourceRequest, int startIndex, int maxResults);
	
	public List<Long> findMemberIDs(DataSourceRequest dataSourceRequest, int startIndex, int maxResults);
	
	public Member getMemberById(Long id);
	
	public Integer countMemberList(DataSourceRequest dataSourceRequest);

	public void createMember(Member member);

	public Integer countBoardList(DataSourceRequest dataSourceRequest);

	//public List<Long> getBoardList(DataSourceRequest dataSourceRequest, int startIndex, int maxResults);

	public List<Long> getBoardNo(DataSourceRequest dataSourceRequest, int startIndex, int maxResults);

	public Board getBoardListByNo(DataSourceRequest dataSourceRequest, Long no);

	public QnaBoard getQnaListByNo(DataSourceRequest dataSourceRequest, Long no);
	
	public void createBoard(Board board);
	
	public void updateBoard(Board board);

	public void delete(Board board);
	
	public void updateReadCount(Board board);
	
	public void updateQnaReadCount(QnaBoard qna);

	public void createQnaBoard(QnaBoard qna);

	public void updateQnaBoard(QnaBoard qna);

}
