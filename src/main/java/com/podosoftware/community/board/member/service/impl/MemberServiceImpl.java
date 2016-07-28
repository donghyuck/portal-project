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
	
	private BoardDao listDao;
	
	private Cache memberCache;
	
	

	public BoardDao getListDao() {
		return listDao;
	}

	public void setListDao(BoardDao listDao) {
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

}
