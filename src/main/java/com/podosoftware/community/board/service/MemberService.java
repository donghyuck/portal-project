package com.podosoftware.community.board.service;

import java.util.List;

import com.podosoftware.community.board.model.Member;

import architecture.ee.web.model.DataSourceRequest;

public interface MemberService {

	public List<Member> getMemberList();

	public List<Member> getMemberList(String search);
	
	public Integer countMemberList(DataSourceRequest dataSourceRequest);
	
	public List<Member> findMemberList(DataSourceRequest dataSourceRequest, int startIndex, int maxResults);

	public void updateMemberInfo(Member member);

	public void createMember(Member member);
}
