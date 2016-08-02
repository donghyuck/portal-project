package com.podosoftware.community.board.model;

import java.sql.Date;

public class DefaultBoard implements Board {

	private String boardCode;
	private String boardName;
	private long boardNo;
	private String writer;
	private Date writeDate;
	private String content;
	private String title;
	private String image;
	private int readCount;
	private long writingRef; // 원본글
	private long writingSeq; // 답변글
	private int writingLevel; // 레벨
	private int index;

	public String getBoardCode() {
		return boardCode;
	}

	public void setBoardCode(String boardCode) {
		this.boardCode = boardCode;
	}

	public String getBoardName() {
		return boardName;
	}

	public void setBoardName(String boardName) {
		this.boardName = boardName;
	}

	public long getBoardNo() {
		return boardNo;
	}

	public void setBoardNo(long boardNo) {
		this.boardNo = boardNo;
	}

	public String getWriter() {
		return writer;
	}

	public void setWriter(String writer) {
		this.writer = writer;
	}

	public Date getWriteDate() {
		return writeDate;
	}

	public void setWriteDate(Date writeDate) {
		this.writeDate = writeDate;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public int getReadCount() {
		return readCount;
	}

	public void setReadCount(int readCount) {
		this.readCount = readCount;
	}

	public long getWritingRef() {
		return writingRef;
	}

	public void setWritingRef(long writingRef) {
		this.writingRef = writingRef;
	}

	public long getWritingSeq() {
		return writingSeq;
	}

	public void setWritingSeq(long writingSeq) {
		this.writingSeq = writingSeq;
	}

	public int getWritingLevel() {
		return writingLevel;
	}

	public void setWritingLevel(int writingLevel) {
		this.writingLevel = writingLevel;
	}

	public int getIndex() {
		return index;
	}

	public void setIndex(int index) {
		this.index = index;
	}
	

}
