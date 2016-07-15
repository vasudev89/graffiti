package com.monkeybusiness;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.util.UriComponentsBuilder;

import com.monkeybusiness.ProfileModel.Profile;
import com.monkeybusiness.ProfileModel.ProfileService;

@CrossOrigin(origins = "http://localhost:9002", maxAge = 3600)
@RestController
public class RESTController
{
	@Autowired
	ProfileService ps;
	
	@CrossOrigin
    @RequestMapping(value = "/updateUserDetails/", method = RequestMethod.POST)
    public ResponseEntity<String> updateUserDetails(HttpServletResponse response,@RequestBody JSONObject data, UriComponentsBuilder ucBuilder) {
        
		System.out.println(data);
		
		Profile p = ps.getProfile(data.get("Username").toString());
		
		p.setEmail(data.get("Email").toString());
		p.setPhone(data.get("Phone").toString());
		p.setBasicInfo(data.get("BasicInfo").toString());
		p.setLocation(data.get("Location").toString());
		
		if( !p.getGender().equals( data.get("Gender").toString() ) )
		{
			p.setGender(data.get("Gender").toString());
			p.setImage( ( data.get("Gender").toString().equals("Male") ) ? "resources/images/profilepic_male.jpg" : "resources/images/profilepic_female.jpg" );
		}
		
		ps.updateProfile(p);
		
		JSONObject json = new JSONObject();
        	        
        json.put("status", "Updated");
        
        System.out.println(json.toString());
        
        return new ResponseEntity<String>(json.toString(), HttpStatus.CREATED);
    }
	
	@CrossOrigin
    @RequestMapping(value = "/updateUserPassword/", method = RequestMethod.POST)
    public ResponseEntity<String> updateUserPassword(HttpServletResponse response,@RequestBody JSONObject data, UriComponentsBuilder ucBuilder) {
        
		System.out.println(data);
		
		Profile p = ps.getProfile(data.get("Username").toString());
		
		JSONObject json = new JSONObject();
		
		if( p.getPassword().equals(data.get("CurrentPassword").toString()) )
		{
			if( data.get("NewPassword").toString().equals(data.get("CurrentPassword").toString()) )
			{
				json.put("status", "Same Password");
			}
			else
			{
				p.setPassword( data.get("NewPassword").toString() );
				ps.updateProfile(p);
				json.put("status", "Updated");
			}
			
		}
		else
		{
			json.put("status", "Password Incorrect");
		}
		
        System.out.println(json.toString());
        
        return new ResponseEntity<String>(json.toString(), HttpStatus.CREATED);
    }
}
