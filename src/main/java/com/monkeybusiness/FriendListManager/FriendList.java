package com.monkeybusiness.FriendListManager;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class FriendList
{
	static public String status = "";
	
	public static void addMessage( JSONArray jarr, String who , String message )
	{
		JSONObject jobj = new JSONObject();
		
		jobj.put(who, message);
		
		jarr.add(jobj);
		
	}
	
	public static void generateFriendsMessages( String friendlist )
	{
		String friends[] = friendlist.split(",");
		
		JSONArray jarr = new JSONArray();
		
		for( String friend:friends )
		{
			if( friend != null && !friend.equals("") )
			{
				System.out.println(friend);
				
				JSONObject jobj = new JSONObject();
				
				jobj.put("With", friend);
				
				JSONArray messages = new JSONArray();
				
				addMessage(messages, "I", "Hi");
				
				jobj.put("Messages", messages);
				
				jarr.add(jobj);
			}
				
		}
		
		System.out.println(jarr);
	}
	
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
	
	public static void main( String args[] )
	{
		generateFriendsMessages(",rakesh,narender");
	}
}
