package com.monkeybusiness;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.monkeybusiness.Hash.HashManager;
import com.monkeybusiness.ProfileModel.Profile;
import com.monkeybusiness.ProfileModel.ProfileService;
import com.monkeybusiness.ProfileRole.ProfileRoleService;

@Controller
public class MonkeyBusinessController {

	@Autowired
	ProfileService ps;
	
	@Autowired
	ProfileRoleService prs;
	
	@RequestMapping(value="/" , method = RequestMethod.GET)
	public ModelAndView home(HttpServletRequest request) throws IOException{
		ModelAndView mav = new ModelAndView("index");
		
		prs.generateProfileRoles();
		
		mav.addObject("addProfile", new Profile());
		
		return mav;
	}
	
	@RequestMapping(value="index" , method = RequestMethod.GET)
	public ModelAndView index(HttpServletRequest request) throws IOException{
		ModelAndView mav = new ModelAndView("index");
		
		mav.addObject("addProfile", new Profile());
		
		return mav;
	}
	
	@RequestMapping(value="index" , method = RequestMethod.POST)
	public ModelAndView index() throws IOException{
		ModelAndView mav = new ModelAndView("index");
		
		mav.addObject("addProfile", new Profile());
		
		return mav;
	}
	
	@RequestMapping(value="/aboutus" , method = RequestMethod.GET)
	public ModelAndView aboutus(HttpServletRequest request) throws IOException{
		ModelAndView mav = new ModelAndView("aboutus");
		return mav;
	}
	
	@RequestMapping(value="/profile/{userName}" , method = RequestMethod.GET)
	public ModelAndView profile(@PathVariable("userName") String username,  HttpServletRequest request) throws IOException{
		ModelAndView mav = new ModelAndView("profile");
		
		Profile p = ps.getProfile(username);
	    	
	    mav.addObject("dataValue", p);
	    mav.addObject("userName", username);
	    
		return mav;
	}
	
	@RequestMapping(value="/forum/{userName}" , method = RequestMethod.GET)
	public ModelAndView forum(@PathVariable("userName") String username,  HttpServletRequest request) throws IOException{
		ModelAndView mav = new ModelAndView("forum");
		
		Profile p = ps.getProfile(username);
	    
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		
		if (auth != null && !( auth.getName()==null) )
	    {   
			if( auth.getName().equals(username) )
			{
				mav.addObject("dataValue", (p == null)?null:p.getForums());
			}
			else
			{
				String temp = p.getFriendList();
				
				if( temp!=null && temp.contains(username) )
				{
					mav.addObject("dataValue", (p == null)?null:p.getForums());
				}
				else
				{
					mav.addObject("invalidUser", "invalidUser");
				}
			}
			
	    }
	    
	    System.out.println(username);
	    
	    mav.addObject("userName", username);
	    
		return mav;
	}
	
	@RequestMapping(value="/blog/{userName}" , method = RequestMethod.GET)
	public ModelAndView blog(@PathVariable("userName") String username,  HttpServletRequest request) throws IOException{
		ModelAndView mav = new ModelAndView("blog");
		
		Profile p = ps.getProfile(username);
	    
		mav.addObject("dataValue", (p == null)?null:p.getBlogs());
	    
	    System.out.println(username);
	    
	    mav.addObject("userName", username);
	    
		return mav;
	}
	
	@RequestMapping(value="/ulogout" , method = RequestMethod.GET)
	public String logout(HttpServletRequest request) throws IOException{
		String mav = new String("redirect:logout");
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		
		if (auth != null && !( auth.getName()==null) )
	    {    
	    	System.out.println(auth.getName());
	    	
	    	Profile p = ps.getProfile(auth.getName());
	    	
	    	System.out.println( "Login: " + p.getLoginStatus() );
	    	
	    	p.setLoginStatus(false);
	    	
	    	ps.updateProfile(p);
	    	
	    }
		
		return mav;
	}
	
	@RequestMapping(value="/hactivities" , method = RequestMethod.GET)
	public String hactivities(HttpServletRequest request) throws IOException{
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		
		if (auth != null && !( auth.getName()==null) )
		{
			Profile p = ps.getProfile(auth.getName());
			
			p.setLoginStatus(true);
			
			ps.updateProfile(p);
		}
		
		return "redirect:http://localhost:9002/monkeybusiness/activities/"+auth.getName();
	}
	
	@RequestMapping(value="/activities/{userName}" , method = RequestMethod.GET)
	public ModelAndView activities(@PathVariable("userName") String username,  HttpServletRequest request) throws IOException{
		ModelAndView mav = new ModelAndView("activities");
		
		Profile p = ps.getProfile(username);
    	
		ArrayList<Profile> allProfiles = (ArrayList<Profile>)ps.getAllProfiles();
		
		JSONArray jarr = new JSONArray();
		
		System.out.println(username);
		
		for( Profile pe : allProfiles )
		{
			if( !pe.getUsername().equals(username) )
			{
				JSONObject jobj = new JSONObject();
				
				jobj.put("Name", pe.getUsername());
				jobj.put("Online", pe.getLoginStatus());
				jobj.put("Image", pe.getImage().replaceAll("\\\\", ""));
				jobj.put("BasicInfo", pe.getBasicInfo());
				
				/*System.out.println( pe.getFriendList() );
				System.out.println( p.getUsername() );
				System.out.println( pe.getPendingFriendList() );
				*/
				
				if( pe.getFriendList() != null && pe.getFriendList().contains(p.getUsername()) )
					{
						jobj.put("IsFriend", "Friends");
					}
					else if( pe.getPendingFriendList() != null && pe.getPendingFriendList().contains(p.getUsername()) )
					{
						jobj.put("IsFriend", "Friend Request Pending");
					}
					else if( p.getPendingFriendList() != null && p.getPendingFriendList().contains(pe.getUsername()) )
					{
						jobj.put("IsFriend", "Confirm Request");
					}
					else
					{
						jobj.put("IsFriend", "Add Friend");
					}
								System.out.println(jobj);
				
				jarr.add(jobj);
			} 
		}
		
		System.out.println(jarr);
		
		mav.addObject("dataValue", p);
	    mav.addObject("userName", username);
	    mav.addObject("AllUsers", jarr);
	    
		return mav;
	}
	
	@RequestMapping(value="/friends/{userName}" , method = RequestMethod.GET)
	public ModelAndView friend(@PathVariable("userName") String username,  HttpServletRequest request) throws IOException{
		ModelAndView mav = new ModelAndView("friends");
		
		Profile p = ps.getProfile(username);
    	
		JSONArray jarr = new JSONArray();
		
		String temp = p.getFriendList();
		
		if( temp != null )
		{
			String friends[] = temp.split(",");
			
			for( String friend : friends )
			{
				if( friend != null && !friend.equals("") )
				{
					Profile pe = ps.getProfile(friend);
					
					JSONObject jobj = new JSONObject();
					
					jobj.put("Name", pe.getUsername());
					jobj.put("Online", pe.getLoginStatus());
					jobj.put("Image", pe.getImage().replaceAll("\\\\", ""));
					jobj.put("BasicInfo", pe.getBasicInfo());
					
					jobj.put("IsFriend", "Friends");
					
					jarr.add(jobj);
				}
			}
		}
		
		mav.addObject("AllFriends", jarr);
		
		//
		
		temp = p.getPendingFriendList();
		
		jarr = new JSONArray();
		
		if( temp != null )
		{
			String friends[] = temp.split(",");
			
			for( String friend : friends )
			{
				if( friend != null && !friend.equals("") )
				{
					Profile pe = ps.getProfile(friend);
					
					JSONObject jobj = new JSONObject();
					
					jobj.put("Name", pe.getUsername());
					jobj.put("Online", pe.getLoginStatus());
					jobj.put("Image", pe.getImage().replaceAll("\\\\", ""));
					jobj.put("BasicInfo", pe.getBasicInfo());
					
					jobj.put("IsFriend", "Confirm Request");
					
					jarr.add(jobj);
				}
			}
		}
		
		mav.addObject("PendingFriends", jarr);
		
		//
		
		mav.addObject("dataValue", p);
	    mav.addObject("userName", username);
	    
		return mav;
	}
	
	@RequestMapping(value="/login" , method = RequestMethod.POST)
	public String login() throws IOException{
		return "redirect:/index";
	}
	
	@RequestMapping(value="InsertProfile" , method = RequestMethod.POST)
	public ModelAndView insertProfile(
			@Valid @ModelAttribute("addProfile")Profile p, 
			BindingResult bind
			) throws IOException{
		ModelAndView mav = new ModelAndView("index");
		
		System.out.println("In Profile Insert");
		
		if(bind.hasErrors())
		{
			mav.addObject("addProfile", p);
			
			mav.addObject("binderror", "binderror");
			
			System.out.println("In Profile Insert: Bind Errors");
		}	
		else
		{	
			if( !p.getPassword().equals(p.getCPassword()) )
			{
				mav.addObject("error", "Passwords do not match");
				
				System.out.println("In Profile Insert: Passwords do not match");
			}
			else
			{
				Profile validateuser = ps.getProfile(p.getUsername());
				
				if( validateuser == null )
				{
					if( p.getGender().equals("Male") )
					{
						p.setImage("resources/images/profilepic_male.jpg");
					}
					else
					{
						p.setImage("resources/images/profilepic_female.jpg");
					}
					
					//p.setPassword( HashManager.generateHashCode( p.getPassword() ));
					
					ps.insertProfile(p);
					
					mav.addObject("success", "User Created Successfully");
					mav.addObject("addProfile", new Profile());
					
					System.out.println("In Profile Insert: User Created Successfully");
					
				}
				else
				{
					mav.addObject("error", "Username Already In Use");
					
					System.out.println("In Profile Insert: User Already Exists");
				}
			}
			
			
		}
		
		//mav.addObject("addProfile", new Profile());
		
		return mav;
	}
}
