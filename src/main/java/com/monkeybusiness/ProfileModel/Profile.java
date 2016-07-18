package com.monkeybusiness.ProfileModel;

import java.sql.Blob;
import java.sql.Clob;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.Transient;
import javax.sql.rowset.serial.SerialClob;
import javax.validation.constraints.Size;

import org.hibernate.Hibernate;
import org.hibernate.engine.jdbc.ClobImplementer;
import org.hibernate.validator.constraints.Email;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;
import org.springframework.format.annotation.NumberFormat;
import org.springframework.format.annotation.NumberFormat.Style;

@Entity
public class Profile
{
	@Id @GeneratedValue(strategy=GenerationType.AUTO)
	private Long ID;
	
	private String Email;
	
	private String Username;
	
	private String Password;
	
	@Transient
	private String CPassword;
	
	private String Phone;
	
	private String Location;
	
	private String Image;
	
	private String Gender;
	
	@Lob
	private String FriendList = "[]";
	@Lob
	private String Blogs;
	@Lob
	private String Forums;
	@Lob
	private String ChatHistory = "[]";
	@Lob
	private String Notifications = "[]";
	
	private boolean LoginStatus;
	private String BasicInfo;
	
	private int Role = 1;
	private boolean Active = true;
	
	/*@AssertTrue(message="passVerify field should be equal than pass field")
	private boolean isValid() {
		return this.Password.equals(this.CPassword);
	}*/
	
	public String getImage() {
		return Image;
	}
	public void setImage(String image) {
		Image = image;
	}
	public String getGender() {
		return Gender;
	}
	public void setGender(String gender) {
		Gender = gender;
	}
	
	public String getCPassword() {
		return CPassword;
	}
	public void setCPassword(String cPassword) {
		CPassword = cPassword;
	}
	public boolean isActive() {
		return Active;
	}
	public void setActive(boolean active) {
		Active = active;
	}
	public int getRole() {
		return Role;
	}
	public void setRole(int role) {
		Role = role;
	}
	public Long getID() {
		return ID;
	}
	public void setID(Long iD) {
		ID = iD;
	}
	
	@Length(max=255,message="Email: Maximum length allowed is 255 characters.")
	@NotEmpty(message="Email field is mandatory.")
    @Email
	public String getEmail() {
		return Email;
	}
	public void setEmail(String email) {
		Email = email;
	}
	
	@Length(max=255,message="Username: Maximum length allowed is 255 characters.")
	@NotEmpty(message="Username field is mandatory.")
	public String getUsername() {
		return Username;
	}
	public void setUsername(String username) {
		Username = username;
	}
	
	@NotEmpty(message="Password field is mandatory.")
	@Size(min = 6, max = 15, message = "Your password must between 6 and 15 characters")
	public String getPassword() {
		return Password;
	}
	public void setPassword(String password) {
		Password = password;
	}
	
	@Length(max=10,min=10,message="Phone number is not valid. Should be of length 10.")
    @NotEmpty(message="Phone field is mandatory.") @NumberFormat(style= Style.NUMBER)
	public String getPhone() {
		return Phone;
	}
	public void setPhone(String phone) {
		Phone = phone;
	}
	
	@NotEmpty(message="Location field is mandatory.")
	public String getLocation() {
		return Location;
	}
	public void setLocation(String location) {
		Location = location;
	}
	
	public String getFriendList() {
		return FriendList;
	}
	public void setFriendList(String friendList) {
		FriendList = friendList;
	}
	public String getBlogs() {
		return Blogs;
	}
	public void setBlogs(String blogs) {
		Blogs = blogs;
	}
	public String getForums() {
		return Forums;
	}
	public void setForums(String forums) {
		Forums = forums;
	}
	public String getChatHistory() {
		return ChatHistory;
	}
	public void setChatHistory(String chatHistory) {
		ChatHistory = chatHistory;
	}
	public String getNotifications() {
		return Notifications;
	}
	public void setNotifications(String notifications) {
		Notifications = notifications;
	}
	public boolean getLoginStatus() {
		return LoginStatus;
	}
	public void setLoginStatus(boolean loginStatus) {
		LoginStatus = loginStatus;
	}
	
	@NotEmpty(message="Basic Info field is mandatory.")
	public String getBasicInfo() {
		return BasicInfo;
	}
	public void setBasicInfo(String basicInfo) {
		BasicInfo = basicInfo;
	}
	@Override
	public String toString() {
		return "{ID:\"" + ID + "\", Email:\"" + Email + "\", Username:\"" + Username + "\","
				+ "Phone:\"" + Phone + "\", Location:\"" + Location + "\", LoginStatus:\"" + LoginStatus + "\", BasicInfo:\"" + BasicInfo
				+ "\", Role:\"" + Role + "\", Active:\"" + Active + "\" , Image:\"" + Image + "\" , Gender:\"" + Gender + "\" }";
	}
	
	
	
}
