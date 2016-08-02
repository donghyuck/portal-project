package com.podosoftware.community.board.model;

import java.sql.Date;

public interface Board {

	public String getBoardCode();

	public void setBoardCode(String boardCode);

	public String getBoardName();

	public void setBoardName(String boardName);

	public long getBoardNo();

	public void setBoardNo(long boardNo);

	public String getWriter();

	public void setWriter(String writer);

	public Date getWriteDate();

	public void setWriteDate(Date writeDate);

	public String getContent();

	public void setContent(String content);

	public String getTitle();

	public void setTitle(String title);

	public String getImage();

	public void setImage(String image);

	public int getReadCount();

	public void setReadCount(int readCount);

	public long getWritingRef();

	public void setWritingRef(long writingRef);

	public long getWritingSeq();

	public void setWritingSeq(long writingSeq);

	public int getWritingLevel();

	public void setWritingLevel(int writingLevel);
	
	public int getIndex();

	public void setIndex(int index);

}
