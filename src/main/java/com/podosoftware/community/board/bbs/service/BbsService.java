package com.podosoftware.community.board.bbs.service;

import java.util.List;

import com.podosoftware.community.board.model.Board;
import com.podosoftware.community.board.model.DefaultQnaBoard;
import com.podosoftware.community.board.model.QnaBoard;

import architecture.ee.web.model.DataSourceRequest;

public interface BbsService {


	public Integer countBoardList(DataSourceRequest dataSourceRequest);

	public List<Board> getBoardList(DataSourceRequest dataSourceRequest, int startIndex, int maxResults);

	public void write(Board board);

	public void delete(Board board);

	public void updateReadCount(Board board);
	
	public void updateQnaReadCount(QnaBoard qna);

	public List<QnaBoard> getQnaList(DataSourceRequest dataSourceRequest, int startIndex, int maxResults);

	public void qnaWrite(DefaultQnaBoard qna);

	public void writeReply(Board board);

}
