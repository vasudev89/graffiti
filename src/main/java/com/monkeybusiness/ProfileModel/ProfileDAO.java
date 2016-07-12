package com.monkeybusiness.ProfileModel;

import java.util.List;

public interface ProfileDAO
{
	public void insertProfile(Profile p);
	public void deleteProfile(long p);
	public void updateProfile(Profile p);
	public Profile getProfile(String pemail);
    public List<Profile> getAllProfiles();
    
    public String updateFriendList(String myemail, String email);
    
}
