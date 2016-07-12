package com.monkeybusiness.ProfileRole;

import java.util.List;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ProfileRoleDAOImpl implements ProfileRoleDAO
{
	@Autowired
	private SessionFactory sessionFactory;
 
	public SessionFactory getSessionFactory() {
		return sessionFactory.getCurrentSession().getSessionFactory();
	}

	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}
	
	
	public void insertProfileRole(ProfileRole i) {
		//Session session = getSessionFactory().getCurrentSession();
		sessionFactory.getCurrentSession().save(i);
		
		System.out.println("Inserted");
	}

	public void deleteProfileRole(int i) {
		sessionFactory.getCurrentSession().createQuery("delete from ProfileRole as i where i.ID = :id").setInteger("id", i).executeUpdate();
		
	}

	public void updateProfileRole(ProfileRole i) {
		sessionFactory.getCurrentSession().update(i);
	}

	public List<ProfileRole> getAllProfileRoles() {
		return sessionFactory.getCurrentSession().createQuery("from ProfileRole").list();
	}

	public ProfileRole getProfileRole(int i) {
		List l = sessionFactory.getCurrentSession().createQuery("from ProfileRole as i where i.Role = :id").setInteger("id", i).list();
		if (l.size()>0)
		{
			return (ProfileRole)l.get(0);
		}
		else
		{
			return null;
		}

	}

	public void generateProfileRoles() {
		try
		{
			ProfileRole ur ;//= new ProfileRole("Profile" , 1);
			
			ur = this.getProfileRole(1);
			
			if( ur == null )
			{
				ur = new ProfileRole("USER" , 1);
				
				this.insertProfileRole(ur);
			}
			
			ur = this.getProfileRole(2);
			
			if( ur == null )
			{
				ur = new ProfileRole("ADMIN" , 2);
				
				this.insertProfileRole(ur);
			}
		}
		catch( Exception e )
		{
			e.printStackTrace();
		}
	}
}
