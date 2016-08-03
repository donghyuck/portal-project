package com.podosoftware.community.board.bbs.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.podosoftware.community.board.bbs.service.BbsService;
import com.podosoftware.community.board.dao.BoardDao;
import com.podosoftware.community.board.model.Board;
import com.podosoftware.community.board.model.DefaultBoard;
import com.podosoftware.community.board.model.DefaultQnaBoard;
import com.podosoftware.community.board.model.QnaBoard;

import architecture.ee.web.model.DataSourceRequest;
import net.sf.ehcache.Cache;
import net.sf.ehcache.Element;

public class BbsServiceImpl implements BbsService {
	
	private Log log = LogFactory.getLog(BbsServiceImpl.class);
	
	private BoardDao boardDao;
	
	private Cache boardCache;
	
	public void setBoardCache(Cache boardCache) {
		this.boardCache = boardCache;
	}

	public void setboardDao(BoardDao boardDao) {
		this.boardDao = boardDao;
	}

	@Override
	public Integer countBoardList(DataSourceRequest dataSourceRequest) {
		return boardDao.countBoardList(dataSourceRequest);
	}

	@Override
	public List<Board> getBoardList(DataSourceRequest dataSourceRequest, int startIndex, int maxResults) {
		List<Long> nos = boardDao.getBoardNo(dataSourceRequest, startIndex, maxResults);
		List<Board> list = new ArrayList<Board>(nos.size());
		
		for(Long board_no : nos){
			Board board = new DefaultBoard();
			
			if( boardCache.get(board_no) != null ){
				board = (DefaultBoard) boardCache.get(board_no).getObjectValue();			
			} else {
				board = boardDao.getBoardListByNo(dataSourceRequest, board_no);
				boardCache.put(new Element(board_no, board));
			}
			list.add(board);
		}		
		return list;
	}

	@Override
	public void write(Board board) {
		boolean isNewBoard = board.getBoardNo() <= 0L;
		
		if(isNewBoard) {
			boardDao.createBoard(board);
		} else {
			boardDao.updateBoard(board);
		}
		
		if(boardCache != null) {
			boardCache.remove(board.getBoardNo());
		}
	}
	
	@Override
	public void delete(Board board) {
		if(boardCache.get(board.getBoardNo()) != null) {
			boardCache.remove(board.getBoardNo());
		}
		boardDao.delete(board);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void updateReadCount(Board board) {
		if(boardCache.get(board.getBoardNo()) != null) {
			boardCache.remove(board.getBoardNo());
		}
		boardDao.updateReadCount(board);
	}
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void updateQnaReadCount(QnaBoard qna) {
		if(boardCache.get(qna.getBoardNo()) != null) {
			boardCache.remove(qna.getBoardNo());
		}
		boardDao.updateQnaReadCount(qna);
	}

	@Override
	public List<QnaBoard> getQnaList(DataSourceRequest dataSourceRequest, int startIndex, int maxResults) {
		List<Long> qnaNos = boardDao.getBoardNo(dataSourceRequest, startIndex, maxResults);
		List<QnaBoard> qnaList = new ArrayList<QnaBoard>(qnaNos.size());
		
		for(Long qna_no : qnaNos) {
			QnaBoard qna = new DefaultQnaBoard();
			if(boardCache.get(qna_no) != null) {
				qna = (DefaultQnaBoard) boardCache.get(qna_no).getObjectValue();
			} else {
				qna = boardDao.getQnaListByNo(dataSourceRequest, qna_no);
				boardCache.put(new Element(qna_no, qna));
			}
			qnaList.add(qna);
		}
		return qnaList;
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void qnaWrite(DefaultQnaBoard qna) {
		boolean isNewQna = qna.getBoardNo() <= 0L;
		
		if(isNewQna) {
			boardDao.createQnaBoard(qna);
		} else {
			boardDao.updateQnaBoard(qna);
		}		
		if(boardCache != null) {
			boardCache.remove(qna.getBoardNo());
		}
	}

	@Override
	public void writeReply(Board board) {
		boardDao.writeReply(board);
	}


}
