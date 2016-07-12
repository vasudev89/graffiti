package com.monkeybusiness.ProfileModel;

import java.util.List;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.monkeybusiness.FriendListManager.FriendList;

@Repository
public class ProfileDAOImpl implements ProfileDAO
{

	@Autowired
	private SessionFactory sessionFactory;
	
	public SessionFactory getSessionFactory() {
		return sessionFactory.getCurrentSession().getSessionFactory();
	}

	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}
	
	public void insertProfile(Profile p) {
		sessionFactory.getCurrentSession().save(p);
		System.out.println("Inserted");
	}

	public void deleteProfile(long i) {
		sessionFactory.getCurrentSession().createQuery("delete from Profile as i where i.ID = :id").setLong("id", i).executeUpdate();
		System.out.println("Deleted");
	}

	public void updateProfile(Profile p) {
		sessionFactory.getCurrentSession().update(p);
	}

	public Profile getProfile(String i) {
		List l = sessionFactory.getCurrentSession().createQuery("from Profile as i where i.Username = :username").setString("username", i).list();
		if (l.size()>0)
		{
			return (Profile)l.get(0);
		}
		else
		{
			return null;
		}
	}

	public List<Profile> getAllProfiles() {
		return sessionFactory.getCurrentSession().createQuery("from Profile").list();
	}

	public String updateFriendList(String myemail, String email) {
		
		String retval = "Added";
		
		Profile p = this.getProfile(myemail);
		
		if( p != null )
		{
			String newFriendList = FriendList.insertFriend(myemail, email);
			
			if( FriendList.status.equals("Added") )
			{
				p.setFriendList(newFriendList);
				this.updateProfile(p);
			}
			
			retval = FriendList.status;
		}
		else
		{
			retval = "Not Added";
		}	
			
		return retval;
	}

}
