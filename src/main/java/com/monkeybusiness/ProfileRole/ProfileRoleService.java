package com.monkeybusiness.ProfileRole;

import java.util.List;

public interface ProfileRoleService
{
	public void insertProfileRole(ProfileRole i);
	public void deleteProfileRole(int i);
	public void updateProfileRole(ProfileRole i);
	public ProfileRole getProfileRole(int i);
    public List<ProfileRole> getAllProfileRoles();
    public void generateProfileRoles();
}
