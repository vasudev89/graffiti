package com.monkeybusiness;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

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
	
	@RequestMapping(value="/profile" , method = RequestMethod.GET)
	public ModelAndView profile(HttpServletRequest request) throws IOException{
		ModelAndView mav = new ModelAndView("profile");
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		
		if (auth != null && !( auth.getName()==null) )
	    {    
	    	Profile p = ps.getProfile(auth.getName());
	    	
	    	mav.addObject("dataValue", p);
	    }
		
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
	
	@RequestMapping(value="/activities" , method = RequestMethod.GET)
	public ModelAndView activities(HttpServletRequest request) throws IOException{
		ModelAndView mav = new ModelAndView("activities");
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		
		if (auth != null && !( auth.getName()==null) )
	    {    
	    	System.out.println(auth.getName());
	    	
	    	Profile p = ps.getProfile(auth.getName());
	    	
	    	System.out.println( "Login: " + p.getLoginStatus() );
	    	
	    	p.setLoginStatus(true);
	    	
	    	ps.updateProfile(p);
	    	
	    }
		
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
