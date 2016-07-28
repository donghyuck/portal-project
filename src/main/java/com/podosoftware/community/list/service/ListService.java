package com.podosoftware.community.list.service;

import java.util.List;

import com.podosoftware.community.board.model.Board;
import com.podosoftware.community.board.model.DefaultQnaBoard;
import com.podosoftware.community.board.model.QnaBoard;

import architecture.ee.web.model.DataSourceRequest;

public interface ListService {


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
