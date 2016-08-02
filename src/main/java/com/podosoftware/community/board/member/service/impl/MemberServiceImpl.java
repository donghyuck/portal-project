package com.podosoftware.community.board.member.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.podosoftware.community.board.dao.BoardDao;
import com.podosoftware.community.board.member.service.MemberService;
import com.podosoftware.community.board.model.Member;

import architecture.ee.web.model.DataSourceRequest;
import net.sf.ehcache.Cache;
import net.sf.ehcache.Element;

public class MemberServiceImpl implements MemberService {

	private Log log = LogFactory.getLog(MemberServiceImpl.class);
	
	private BoardDao boardDao;
	
	private Cache memberCache;

	public BoardDao getboardDao() {
		return boardDao;
	}

	public void setboardDao(BoardDao boardDao) {
		this.boardDao = boardDao;
	}

	public Cache getMemberCache() {
		return memberCache;
	}

	public void setMemberCache(Cache memberCache) {
		this.memberCache = memberCache;
	}

	@Override
	public List<Member> getMemberList() {
		return boardDao.getMemberList();
	}
	
	@Override
	public List<Member> getMemberList(String search) {
		return boardDao.getSearchMemberList(search);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void updateMemberInfo(Member member)  {
		
		if(memberCache.get(member.getId()) != null) {
			memberCache.remove(member.getId());
		}
		
		boardDao.updateMemberInfo(member);
	}

	@Override
	public List<Member> findMemberList(DataSourceRequest dataSourceRequest, int startIndex, int maxResults) {
		
		List<Long> ids = boardDao.findMemberIDs(dataSourceRequest, startIndex, maxResults);
		List<Member> list = new ArrayList<Member>(ids.size());
		for(Long id : ids ){
			Member member ;
			if( memberCache.get(id) != null ){ //cache가 들어있으면
				member = (Member) memberCache.get(id).getObjectValue(); //가져오고				
			}else{ //cache가 비어있으면
				member = boardDao.getMemberById(id); //db통신해서 넣어준다.
				memberCache.put(new Element(id, member));
			}
			list.add(member);
		}		
		return list; //boardDao.findMemberList(dataSourceRequest, startIndex, maxResults);
	}

	@Override
	public Integer countMemberList(DataSourceRequest dataSourceRequest) {		
		return boardDao.countMemberList(dataSourceRequest);
	}

	@Override
	public void createMember(Member member) {
		boardDao.createMember(member);
	}

}
