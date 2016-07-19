package com.podosoftware.community.list.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.podosoftware.community.board.domain.Board;
import com.podosoftware.community.list.dao.ListDao;
import com.podosoftware.community.list.domain.Member;
import com.podosoftware.community.list.service.ListService;

import architecture.ee.web.model.DataSourceRequest;
import net.sf.ehcache.Cache;
import net.sf.ehcache.Element;

public class ListServiceImpl implements ListService {
	
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
	
	/*public Cache getBoardCache() {
		return boardCache;
	}

	public void setBoardCache(Cache boardCache) {
		this.boardCache = boardCache;
	}
*/
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
				member = (Member)memberCache.get(id).getObjectValue(); //가져오고				
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
				board = listDao.getBoardListByNo(board_no);
				memberCache.put(new Element(board_no, board));
			}
			list.add(board);
		}		
		return list;
	}
	
	@Override
	public int countNoticeList(DataSourceRequest request) {
		return listDao.countNoticeList(request);
	}

	@Override
	public List<Board> getNoticeList(DataSourceRequest request, int startIndex, int maxResults) {
		List<Long> nos = listDao.getNoticeNo(request, startIndex, maxResults);
		List<Board> list = new ArrayList<Board>(nos.size());
		for(Long notice_no : nos){
			Board notice;
			notice = new Board();
			if( memberCache.get(notice_no) != null ){
				notice = (Board) memberCache.get(notice_no).getObjectValue();			
			} else {
				notice = listDao.getNoticeListByNo(notice_no);
				memberCache.put(new Element(notice_no, notice));
			}
			list.add(notice);
		}		
		return list;
	}

	@Override
	public void write(Board board) {
		listDao.write(board);
	}
	
	@Override
	public void delete(Board board) {
		listDao.delete(board);
	}

	@Override
	public void updateReadCount(Board board) {
		listDao.updateReadCount(board);
	}

}
