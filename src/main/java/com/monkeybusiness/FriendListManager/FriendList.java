package com.monkeybusiness.FriendListManager;

public class FriendList
{
	static public String status = "";
	
	static public String insertFriend( String currentFriendList , String email )
	{
		FriendList.status = "";
		
		if( currentFriendList.equals("") || currentFriendList == null )
		{
			currentFriendList = "["+email+"]";
			FriendList.status = "Already Exists";
		}
		else if( !currentFriendList.contains(email) )
		{
			currentFriendList = currentFriendList.substring(0, currentFriendList.length()-1) + "," + email + "]";
			FriendList.status = "Added";
		}
		
		return currentFriendList;
	}
}
