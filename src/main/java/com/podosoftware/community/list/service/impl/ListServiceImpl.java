package com.podosoftware.community.list.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.podosoftware.community.board.domain.Board;
import com.podosoftware.community.board.domain.QnaBoard;
import com.podosoftware.community.list.dao.ListDao;
import com.podosoftware.community.list.domain.Member;
import com.podosoftware.community.list.service.ListService;
import com.podosoftware.community.spring.controller.PodoCommunityDataController;

import architecture.ee.web.model.DataSourceRequest;
import net.sf.ehcache.Cache;
import net.sf.ehcache.Element;

public class ListServiceImpl implements ListService {
	private Log log = LogFactory.getLog(PodoCommunityDataController.class);
	
	private ListDao listDao;
	
	private Cache memberCache;
	
	//private Cache boardCache;
	
	public void setlistDao(ListDao listDao) {
		this.listDao = listDao;
	}
	
	public Cache getMemberCache() {
		return memberCache;
	}

	public void setMemberCache(Cache memberCache) {
		this.memberCache = memberCache;
	}

	@Override
	public List<Member> getMemberList() {
		return listDao.getMemberList();
	}
	
	@Override
	public List<Member> getMemberList(String search) {
		return listDao.getSearchMemberList(search);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void updateMemberInfo(Member member)  {
		
		if(memberCache.get(member.getId()) != null) {
			memberCache.remove(member.getId());
		}
		
		listDao.updateMemberInfo(member);
	}

	@Override
	public List<Member> findMemberList(DataSourceRequest dataSourceRequest, int startIndex, int maxResults) {
		
		List<Long> ids = listDao.findMemberIDs(dataSourceRequest, startIndex, maxResults);
		List<Member> list = new ArrayList<Member>(ids.size());
		for(Long id : ids ){
			Member member ;
			if( memberCache.get(id) != null ){ //cache가 들어있으면
				member = (Member) memberCache.get(id).getObjectValue(); //가져오고				
			}else{ //cache가 비어있으면
				member = listDao.getMemberById(id); //db통신해서 넣어준다.
				memberCache.put(new Element(id, member));
			}
			list.add(member);
		}		
		return list; //listDao.findMemberList(dataSourceRequest, startIndex, maxResults);
	}

	@Override
	public Integer countMemberList(DataSourceRequest dataSourceRequest) {
		
		return listDao.countMemberList(dataSourceRequest);
	}

	@Override
	public void createMember(Member member) {
		listDao.createMember(member);
	}

	@Override
	public Integer countBoardList(DataSourceRequest dataSourceRequest) {
		return listDao.countBoardList(dataSourceRequest);
	}

	@Override
	public List<Board> getBoardList(DataSourceRequest dataSourceRequest, int startIndex, int maxResults) {
		List<Long> nos = listDao.getBoardNo(dataSourceRequest, startIndex, maxResults);
		List<Board> list = new ArrayList<Board>(nos.size());
		for(Long board_no : nos){
			Board board;
			board = new Board();
			if( memberCache.get(board_no) != null ){
				board = (Board) memberCache.get(board_no).getObjectValue();			
			} else {
				board = listDao.getBoardListByNo(dataSourceRequest, board_no);
				memberCache.put(new Element(board_no, board));
			}
			list.add(board);
		}		
		return list;
	}

	@Override
	public void write(Board board) {
		boolean isNewBoard = board.getBoardNo() <= 0L;
		
		if(isNewBoard) {
			listDao.createBoard(board);
		} else {
			listDao.updateBoard(board);
		}
		
		if(memberCache != null) {
			memberCache.remove(board.getBoardNo());
		}
	}
	
	@Override
	public void delete(Board board) {
		if(memberCache.get(board.getBoardNo()) != null) {
			memberCache.remove(board.getBoardNo());
		}
		listDao.delete(board);
	}

	@Override
	public void updateReadCount(Board board) {
		if(memberCache.get(board.getBoardNo()) != null) {
			memberCache.remove(board.getBoardNo());
		}
		listDao.updateReadCount(board);
	}
	
	@Override
	public void updateQnaReadCount(QnaBoard qna) {
		if(memberCache.get(qna.getBoardNo()) != null) {
			memberCache.remove(qna.getBoardNo());
		}
		listDao.updateQnaReadCount(qna);
	}

	@Override
	public List<QnaBoard> getQnaList(DataSourceRequest dataSourceRequest, int startIndex, int maxResults) {
		List<Long> qnaNos = listDao.getBoardNo(dataSourceRequest, startIndex, maxResults);
		List<QnaBoard> qnaList = new ArrayList<QnaBoard>(qnaNos.size());
		
		for(Long qna_no : qnaNos) {
			QnaBoard qna;
			qna = new QnaBoard();
			if(memberCache.get(qna_no) != null) {
				qna = (QnaBoard) memberCache.get(qna_no).getObjectValue();
			} else {
				qna = listDao.getQnaListByNo(dataSourceRequest, qna_no);
				memberCache.put(new Element(qna_no, qna));
			}
			qnaList.add(qna);
		}
		return qnaList;
	}

	@Override
	public void qnaWrite(QnaBoard qna) {
		boolean isNewQna = qna.getBoardNo() <= 0L;
		
		if(isNewQna) {
			listDao.createQnaBoard(qna);
		} else {
			listDao.updateQnaBoard(qna);
		}
		
		if(memberCache != null) {
			memberCache.remove(qna.getBoardNo());
		}
	}

	@Override
	public void writeReply(Board board) {
		listDao.createReply(board);
	}

	@Override
	public void getNextBoard(Board board) {
		long nextBoardNo = listDao.getNextBoardNo(board);
	}

	@Override
	public void getPreBoard(Board board) {
		
	}

}
