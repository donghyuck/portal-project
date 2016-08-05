package com.podosoftware.community.board.model;

public class AttachFile {
	
	private int attachFileId;
	private String fileName;
	private int fileSize;
	private String file_type;
	private long board_no;
	
	public int getAttachFileId() {
		return attachFileId;
	}
	public void setAttachFileId(int attachFileId) {
		this.attachFileId = attachFileId;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public int getFileSize() {
		return fileSize;
	}
	public void setFileSize(int fileSize) {
		this.fileSize = fileSize;
	}
	public String getFile_type() {
		return file_type;
	}
	public void setFile_type(String file_type) {
		this.file_type = file_type;
	}
	public long getBoard_no() {
		return board_no;
	}
	public void setBoard_no(long board_no) {
		this.board_no = board_no;
	}
	
}
