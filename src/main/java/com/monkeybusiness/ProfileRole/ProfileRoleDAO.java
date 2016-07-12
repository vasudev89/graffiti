package com.monkeybusiness.ProfileRole;

import java.util.List;

public interface ProfileRoleDAO
{
	public void insertProfileRole(ProfileRole i);
	public void deleteProfileRole(int i);
	public void updateProfileRole(ProfileRole i);
	public void generateProfileRoles();
	public ProfileRole getProfileRole(int i);
    public List<ProfileRole> getAllProfileRoles();
}
