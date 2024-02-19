package com.company.dto;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name="user")
public class UserDtoXml {
	private String    status;
	private List<UserDto> list;
	
	public UserDtoXml() { super(); }
	public UserDtoXml(String status, List<UserDto> list) {
		super();
		this.status = status;
		this.list = list;
	}
	@XmlElement
	public void setStatus(String status) { this.status = status; }
	@XmlElement(name="user")
	public void setList(List<UserDto> list) { this.list = list; }
	
	public String getStatus() { return status; }
	public List<UserDto> getList() { return list; }
}
