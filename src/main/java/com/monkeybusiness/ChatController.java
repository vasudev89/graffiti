package com.monkeybusiness;

import java.util.Iterator;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;

import com.fasterxml.jackson.core.JsonParser;
import com.monkeybusiness.ProfileModel.Profile;
import com.monkeybusiness.ProfileModel.ProfileService;

@Controller
public class ChatController {

	@Autowired
	ProfileService ps;
	
	@MessageMapping("/chat")
	public String processQuestion( String data )
	{
		System.out.println(data);
	
		JSONParser json = new JSONParser();
		
		try
		{
			JSONObject jobj = (JSONObject)json.parse(data);
			
			System.out.println("JSON Object: " + jobj.toJSONString());
			
			System.out.println( jobj.get("From") );
			System.out.println( jobj.get("To") );
			System.out.println( jobj.get("Message") );
			
			//
			
			Profile p1 = ps.getProfile( jobj.get("From").toString() );
			
			String temp = p1.getChatHistory();
			
			JSONParser jpar = new JSONParser();
			
			JSONArray chathist = new JSONArray();
			
			try
			{
				chathist = (JSONArray)jpar.parse(temp);
			}
			catch(Exception e)
			{
				System.out.println("CHAT HISTORY PARSE ERROR!!");
			}
			
			chathist.add(jobj);
			
			p1.setChatHistory(chathist.toJSONString());
			
			ps.updateProfile(p1);
			
			//
			
			Profile p2 = ps.getProfile( jobj.get("To").toString() );
			
			temp = p2.getChatHistory();
			
			jpar = new JSONParser();
			
			chathist = new JSONArray();
			
			try
			{
				chathist = (JSONArray)jpar.parse(temp);
			}
			catch(Exception e)
			{
				System.out.println("CHAT HISTORY PARSE ERROR!!");
			}
			
			chathist.add(jobj);
			
			p2.setChatHistory(chathist.toJSONString());
			
			ps.updateProfile(p2);
			
			//
		}
		catch( Exception e )
		{
			System.out.println("Error Parsing Chat Message");
		}
		
		return data;
	}
	
	@MessageMapping("/markUnread")
	public String markUnread( String data )
	{
		System.out.println(data);
	
		JSONParser json = new JSONParser();
		
		try
		{
			JSONObject jobj = (JSONObject)json.parse(data);
			
			System.out.println("JSON Object: " + jobj.toJSONString());
			
			System.out.println( jobj.get("From") );
			System.out.println( jobj.get("To") );
			
			//
			
			Profile p1 = ps.getProfile( jobj.get("From").toString() );
			
			String temp = p1.getChatHistory();
			
			JSONParser jpar = new JSONParser();
			
			JSONArray chathist = new JSONArray();
			
			try
			{
				chathist = (JSONArray)jpar.parse(temp);
				
				Iterator i = chathist.iterator();
				
				while(i.hasNext())
				{
					JSONObject jo = (JSONObject)i.next();
					
					jo.put("status", "read");
				}
			}
			catch(Exception e)
			{
				System.out.println("CHAT HISTORY PARSE ERROR!!");
			}
			
			p1.setChatHistory(chathist.toJSONString());
			
			ps.updateProfile(p1);
			
			//
			
			Profile p2 = ps.getProfile( jobj.get("To").toString() );
			
			temp = p2.getChatHistory();
			
			jpar = new JSONParser();
			
			chathist = new JSONArray();
			
			try
			{
				chathist = (JSONArray)jpar.parse(temp);
				
				Iterator i = chathist.iterator();
				
				while(i.hasNext())
				{
					JSONObject jo = (JSONObject)i.next();
					
					jo.put("status", "read");
				}
			}
			catch(Exception e)
			{
				System.out.println("CHAT HISTORY PARSE ERROR!!");
			}
			
			p2.setChatHistory(chathist.toJSONString());
			
			ps.updateProfile(p2);
			
			//
		}
		catch( Exception e )
		{
			System.out.println("Error Parsing Chat Message");
		}
		
		return data;
	}
	
}
