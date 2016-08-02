package com.podosoftware.community.board.model;

public class DefaultQnaBoard extends DefaultBoard implements QnaBoard {

	private String type;
	private String category;
	
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	
}
