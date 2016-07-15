package com.monkeybusiness.ProfileModel;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ProfileServiceImpl implements ProfileService
{
	@Autowired
	ProfileDAO pdao;

	@Transactional
	public void insertProfile(Profile p) {
		pdao.insertProfile(p);
	}

	@Transactional
	public void deleteProfile(long p) {
		pdao.deleteProfile(p);
	}

	@Transactional
	public void updateProfile(Profile p) {
		pdao.updateProfile(p);
	}

	@Transactional
	public Profile getProfile(String pusername) {
		return pdao.getProfile(pusername);
	}

	@Transactional
	public List<Profile> getAllProfiles() {
		return pdao.getAllProfiles();
	}

	@Transactional
	public String updateFriendList(String myemail, String email) {
		return pdao.updateFriendList(myemail, email);
	}

}
