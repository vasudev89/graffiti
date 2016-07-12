package com.monkeybusiness.ProfileRole;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ProfileRoleServiceImpl implements ProfileRoleService 
{
	@Autowired
    ProfileRoleDAO dao;
    
    @Transactional
    public void insertProfileRole(ProfileRole i) {
		dao.insertProfileRole(i);
	}

    @Transactional
	public void deleteProfileRole(int i) {
		dao.deleteProfileRole(i);
	}

    @Transactional
	public void updateProfileRole(ProfileRole i) {
		dao.updateProfileRole(i);
	}

	@Transactional
	public List<ProfileRole> getAllProfileRoles() {
		return dao.getAllProfileRoles();
	}

	@Transactional
	public ProfileRole getProfileRole(int i) {
		return dao.getProfileRole(i);
	}

	@Transactional
	public void generateProfileRoles() {
		dao.generateProfileRoles();
	}
}
