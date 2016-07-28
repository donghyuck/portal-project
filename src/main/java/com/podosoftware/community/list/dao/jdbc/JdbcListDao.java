package com.podosoftware.community.list.dao.jdbc;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.SqlParameterValue;
import org.springframework.stereotype.Repository;

import com.podosoftware.community.board.domain.Board;
import com.podosoftware.community.board.domain.QnaBoard;
import com.podosoftware.community.list.dao.ListDao;
import com.podosoftware.community.list.domain.Member;

import architecture.ee.spring.jdbc.support.ExtendedJdbcDaoSupport;
import architecture.ee.web.model.DataSourceRequest;

@Repository
public class JdbcListDao extends ExtendedJdbcDaoSupport implements ListDao {
	
	private static MemberListRowMapper rowMapper = new MemberListRowMapper();
	private static BoardRowMapper boardRowMapper = new BoardRowMapper();
	private static QnaBoardRowMapper qnaBoardRowMapper = new QnaBoardRowMapper();
	
	@Override
	public List<Member> getMemberList() {		
		return getExtendedJdbcTemplate().query(getBoundSql("PORTAL_CUSTOM.SELECT_PODO_MEMBER").getSql(), rowMapper );
	}
	
	@Override
	public List<Member> getSearchMemberList(String search) {
		return getExtendedJdbcTemplate().query
				(getBoundSql("PORTAL_CUSTOM.SEARCH_PODO_MEMBER").getSql(),
				rowMapper, new SqlParameterValue(Types.VARCHAR, search));
	}

    
    
	static class MemberListRowMapper implements RowMapper<Member> {
		//PODO_MEMBER_ROWMAPPER
		
		@Override
		public Member mapRow(ResultSet rs, int rowNum) throws SQLException {
			Member m = new Member();
			m.setId(rs.getLong("id"));
			m.setName(rs.getString("name"));
			m.setPhone(rs.getString("phone"));
			m.setPosition(rs.getString("position"));
			m.setGender(rs.getString("gender"));
			return m;
		}
	}
	
	static class BoardRowMapper implements RowMapper<Board> {
		
		@Override
		public Board mapRow(ResultSet rs, int rowNum) throws SQLException {
			Board b = new Board();
			b.setBoardCode(rs.getString("board_code"));
			b.setBoardName(rs.getString("board_name"));
			b.setBoardNo(rs.getLong("board_no"));
			b.setContent(rs.getString("content"));
			b.setImage(rs.getString("image"));
			b.setTitle(rs.getString("title"));
			b.setReadCount(rs.getInt("read_count"));
			b.setWriteDate(rs.getDate("write_date"));
			b.setWriter(rs.getString("writer"));
			b.setWritingRef(rs.getLong("writing_ref"));
			b.setWritingSeq(rs.getLong("writing_seq"));
			b.setWritingLevel(rs.getInt("writing_level"));
			return b;
		}
	}

	static class QnaBoardRowMapper implements RowMapper<QnaBoard> {
		
		@Override
		public QnaBoard mapRow(ResultSet rs, int rowNum) throws SQLException {
			QnaBoard q = new QnaBoard();
			q.setBoardCode(rs.getString("board_code"));
			q.setBoardName(rs.getString("board_name"));
			q.setBoardNo(rs.getLong("board_no"));
			q.setContent(rs.getString("content"));
			q.setImage(rs.getString("image"));
			q.setTitle(rs.getString("title"));
			q.setReadCount(rs.getInt("read_count"));
			q.setWriteDate(rs.getDate("write_date"));
			q.setWriter(rs.getString("writer"));
			q.setWritingRef(rs.getLong("writing_ref"));
			q.setWritingSeq(rs.getLong("writing_seq"));
			q.setWritingLevel(rs.getInt("writing_level"));
			q.setType(rs.getString("type"));
			q.setCategory(rs.getString("category"));
			return q;
		}
	}



	@Override
	public List<Member> findMemberList(DataSourceRequest dataSourceRequest, int startIndex, int maxResults) {
		
		Map<String, Object> map = new HashMap<String, Object>();		
		map.put("HAS_FILTER", dataSourceRequest.getFilter() == null ? false : true );
		map.put("FILTER", dataSourceRequest.getFilter());
		
		log.debug(getBoundSqlWithAdditionalParameter("PORTAL_CUSTOM.FIND_PODO_MEMBER", map).getSql());
		
		return getExtendedJdbcTemplate().queryScrollable(this.getBoundSqlWithAdditionalParameter("PORTAL_CUSTOM.FIND_PODO_MEMBER", map).getSql(),
				startIndex, maxResults, new Object[] { }, new int[] { }, rowMapper);
	}

	@Override
	public void updateMemberInfo(Member member) {
		
		getExtendedJdbcTemplate().update(this.getBoundSql("PORTAL_CUSTOM.UPDATE_PODO_MEMBER").getSql(),
				new SqlParameterValue(Types.VARCHAR, member.getName()),
				new SqlParameterValue(Types.VARCHAR, member.getPhone()),
				new SqlParameterValue(Types.VARCHAR, member.getPosition()),
				new SqlParameterValue(Types.VARCHAR, member.getGender()),
				new SqlParameterValue(Types.NUMERIC, member.getId())
				);
	}

	@Override
	public Integer countMemberList(DataSourceRequest dataSourceRequest) {
		
		Map<String, Object> map = new HashMap<String, Object>();		
		map.put("HAS_FILTER", dataSourceRequest.getFilter() == null ? false : true );
		map.put("FILTER", dataSourceRequest.getFilter());
		
		return getExtendedJdbcTemplate().queryForObject(getBoundSqlWithAdditionalParameter("PORTAL_CUSTOM.COUNT_PODO_MEMBER", map).getSql(), Integer.class);
	}

	@Override
	public void createMember(Member member) {
		long nextId = getNextId("PODO_MEMBER");
		member.setId(nextId);
		log.debug(member.getId());
		getExtendedJdbcTemplate().update(this.getBoundSql("PORTAL_CUSTOM.CREATE_PODO_MEMBER").getSql(), 
				new SqlParameterValue(Types.NUMERIC, member.getId()),
				new SqlParameterValue(Types.VARCHAR, member.getName()),
				new SqlParameterValue(Types.VARCHAR, member.getPhone()),
				new SqlParameterValue(Types.VARCHAR, member.getPosition()),
				new SqlParameterValue(Types.VARCHAR, member.getGender())
			);
	}

	@Override
	public List<Long> findMemberIDs(DataSourceRequest dataSourceRequest, int startIndex, int maxResults) {

		return getExtendedJdbcTemplate().queryScrollable(
				getBoundSql("PORTAL_CUSTOM.SELECT_PODO_MEMBER_IDS").getSql(),
				startIndex, maxResults, new Object[] { }, new int[] { }, Long.class);
	}

	@Override
	public Member getMemberById(Long id) {
		
		return getExtendedJdbcTemplate().queryForObject(
				getBoundSql("PORTAL_CUSTOM.SELECT_PODO_MEMBER_BY_ID").getSql(),
				rowMapper, new SqlParameterValue(Types.NUMERIC, id));
	}

	@Override
	public Integer countBoardList(DataSourceRequest dataSourceRequest) {
		return getExtendedJdbcTemplate().queryForObject(getBoundSqlWithAdditionalParameter("PORTAL_CUSTOM.COUNT_BOARD", dataSourceRequest.getData()).getSql(), Integer.class);
	}

	/*@Override
	public List<Long> getBoardList(DataSourceRequest dataSourceRequest, int startIndex, int maxResults) {
		return getExtendedJdbcTemplate().queryScrollable(this.getBoundSql("PORTAL_CUSTOM.GET_BOARD_LIST").getSql(),
				startIndex, maxResults, new Object[] { }, new int[] { }, Long.class);
	}*/

	@Override
	public List<Long> getBoardNo(DataSourceRequest dataSourceRequest, int startIndex, int maxResults) {
		return getExtendedJdbcTemplate().queryScrollable(getBoundSqlWithAdditionalParameter("PORTAL_CUSTOM.SELECT_BOARD_NO", dataSourceRequest.getData()).getSql(), 
				startIndex, maxResults, new Object[] { }, new int[] { }, Long.class);
	}

	@Override
	public Board getBoardListByNo(DataSourceRequest dataSourceRequest, Long no) {
		return getExtendedJdbcTemplate().queryForObject(getBoundSqlWithAdditionalParameter("PORTAL_CUSTOM.SELECT_BOARD_BY_NO", dataSourceRequest.getData()).getSql(), 
				boardRowMapper, new SqlParameterValue(Types.NUMERIC, no));
	}
	
	@Override
	public QnaBoard getQnaListByNo(DataSourceRequest dataSourceRequest, Long no) {
		try {
			return getExtendedJdbcTemplate().queryForObject(getBoundSqlWithAdditionalParameter("PORTAL_CUSTOM.SELECT_QNA_BOARD_BY_NO", dataSourceRequest.getData()).getSql(),
					qnaBoardRowMapper, new SqlParameterValue(Types.NUMERIC, no));
		} catch(EmptyResultDataAccessException e) {
			return null;
		}
	}
	
	@Override
	public void createBoard(Board board) {
		if(board.getBoardCode().equals("B001")) { // 글번호 시퀀스 
			long nextId = getNextId("PODO_FREE_BOARD");
			board.setBoardNo(nextId);
		} else if(board.getBoardCode().equals("B002")) {
			long nextId = getNextId("PODO_NOTICE_BOARD");
			board.setBoardNo(nextId);
		} 
		getExtendedJdbcTemplate().update(getBoundSql("PORTAL_CUSTOM.INSERT_BOARD").getSql(),
				new SqlParameterValue(Types.VARCHAR, board.getBoardName()),
				new SqlParameterValue(Types.NUMERIC, board.getBoardNo()),
				new SqlParameterValue(Types.VARCHAR, board.getWriter()),
				new SqlParameterValue(Types.VARCHAR, board.getTitle()),
				new SqlParameterValue(Types.VARCHAR, board.getContent()),
				new SqlParameterValue(Types.VARCHAR, board.getImage()),
				new SqlParameterValue(Types.NUMERIC, board.getBoardNo()),
				new SqlParameterValue(Types.VARCHAR, board.getBoardCode())
			);
	}
	
	@Override
	public void updateBoard(Board board) {
		getExtendedJdbcTemplate().update(getBoundSql("PORTAL_CUSTOM.UPDATE_BOARD").getSql(), 
				new SqlParameterValue(Types.VARCHAR, board.getTitle()),
				new SqlParameterValue(Types.VARCHAR, board.getContent()),
				new SqlParameterValue(Types.VARCHAR, board.getImage()),
				new SqlParameterValue(Types.VARCHAR, board.getBoardCode()),
				new SqlParameterValue(Types.NUMERIC, board.getBoardNo())
			);
	}
	
	@Override
	public void delete(Board board) {
		getExtendedJdbcTemplate().update(this.getBoundSql("PORTAL_CUSTOM.DELETE_BOARD").getSql(), 
				new SqlParameterValue(Types.VARCHAR, board.getBoardCode()),
				new SqlParameterValue(Types.NUMERIC, board.getBoardNo())
			);
	}

	@Override
	public void updateReadCount(Board board) {
		getExtendedJdbcTemplate().update(this.getBoundSql("PORTAL_CUSTOM.UPDATE_READ_COUNT").getSql(),
					new SqlParameterValue(Types.VARCHAR, board.getBoardCode()),
					new SqlParameterValue(Types.NUMERIC, board.getBoardNo())
				);
	}
	
	@Override
	public void updateQnaReadCount(QnaBoard qna) {
		getExtendedJdbcTemplate().update(this.getBoundSql("PORTAL_CUSTOM.UPDATE_READ_COUNT").getSql(),
					new SqlParameterValue(Types.VARCHAR, qna.getBoardCode()),
					new SqlParameterValue(Types.NUMERIC, qna.getBoardNo())
				);
	}

	@Override
	public void createQnaBoard(QnaBoard qna) {
		long nextId = getNextId("PODO_QNA_BOARD");
		qna.setBoardNo(nextId);
		
		getExtendedJdbcTemplate().update(getBoundSql("PORTAL_CUSTOM.INSERT_BOARD").getSql(),
				new SqlParameterValue(Types.VARCHAR, qna.getBoardName()),
				new SqlParameterValue(Types.NUMERIC, qna.getBoardNo()),
				new SqlParameterValue(Types.VARCHAR, qna.getWriter()),
				new SqlParameterValue(Types.VARCHAR, qna.getTitle()),
				new SqlParameterValue(Types.VARCHAR, qna.getContent()),
				new SqlParameterValue(Types.VARCHAR, qna.getImage()),
				new SqlParameterValue(Types.NUMERIC, qna.getBoardNo()),
				new SqlParameterValue(Types.VARCHAR, qna.getBoardCode())
			);
		
		getExtendedJdbcTemplate().update(getBoundSql("PORTAL_CUSTOM.INSERT_QNA_BOARD").getSql(),
				new SqlParameterValue(Types.VARCHAR, qna.getType()),
				new SqlParameterValue(Types.VARCHAR, qna.getCategory()),
				new SqlParameterValue(Types.VARCHAR, qna.getBoardCode()),
				new SqlParameterValue(Types.NUMERIC, qna.getBoardNo())
			);
		
	}

	@Override
	public void updateQnaBoard(QnaBoard qna) {
		getExtendedJdbcTemplate().update(getBoundSql("PORTAL_CUSTOM.UPDATE_BOARD").getSql(), 
				new SqlParameterValue(Types.VARCHAR, qna.getTitle()),
				new SqlParameterValue(Types.VARCHAR, qna.getContent()),
				new SqlParameterValue(Types.VARCHAR, qna.getImage()),
				new SqlParameterValue(Types.VARCHAR, qna.getBoardCode()),
				new SqlParameterValue(Types.NUMERIC, qna.getBoardNo())
			);
		
		getExtendedJdbcTemplate().update(getBoundSql("PORTAL_CUSTOM.UPDATE_QNA_BOARD").getSql(), 
				new SqlParameterValue(Types.VARCHAR, qna.getCategory()),
				new SqlParameterValue(Types.VARCHAR, qna.getBoardCode()),
				new SqlParameterValue(Types.NUMERIC, qna.getBoardNo())
			);
		
	}

	@Override
	public void createReply(Board board) {
		
	}
 
	@Override
	public long getNextBoardNo(Board board) {
		return getExtendedJdbcTemplate().update(getBoundSql("PORTAL_CUSTOM.GET_NEXT_BOARD_NO").getSql(), 
				new SqlParameterValue(Types.VARCHAR, board.getBoardCode()),
				new SqlParameterValue(Types.NUMERIC, board.getBoardNo()), Long.class
			);
	}


}
