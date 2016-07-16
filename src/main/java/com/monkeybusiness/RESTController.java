package com.monkeybusiness;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletContext;
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
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.UriComponentsBuilder;

import com.monkeybusiness.Hash.HashManager;
import com.monkeybusiness.ProfileModel.Profile;
import com.monkeybusiness.ProfileModel.ProfileService;

@CrossOrigin(origins = "http://localhost:9002", maxAge = 3600)
@RestController
public class RESTController
{
	@Autowired
	ProfileService ps;
	
	@Autowired
    ServletContext context;
	
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
			
			if( p.getImage().equals("resources/images/profilepic_male.jpg") || p.getImage().equals("resources/images/profilepic_female.jpg") )
				p.setImage( ( data.get("Gender").toString().equals("Male") ) ? "resources/images/profilepic_male.jpg" : "resources/images/profilepic_female.jpg" );
		}
		
		ps.updateProfile(p);
		
		p = ps.getProfile(data.get("Username").toString());
		
		JSONObject json = new JSONObject();
        	        
        json.put("status", "Updated");
        json.put("imagesrc", p.getImage());
        
        System.out.println(json.toString());
        
        return new ResponseEntity<String>(json.toString(), HttpStatus.CREATED);
    }
	
	@CrossOrigin
    @RequestMapping(value = "/deleteUserImage/", method = RequestMethod.POST)
    public ResponseEntity<String> deleteUserImage(HttpServletResponse response,@RequestBody JSONObject data, UriComponentsBuilder ucBuilder) {
        
		System.out.println(data);
		
		Profile p = ps.getProfile(data.get("Username").toString());
		
		p.setImage( p.getGender().equals("Male")  ? "resources/images/profilepic_male.jpg" : "resources/images/profilepic_female.jpg" );
		
		ps.updateProfile(p);
		
		p = ps.getProfile(data.get("Username").toString());
		
		JSONObject json = new JSONObject();
        	        
        json.put("status", "Updated");
        json.put("imagesrc", p.getImage());
        
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
	
	@CrossOrigin
    @RequestMapping(value = "/updateProfilePicture/", method = RequestMethod.POST )
    public ResponseEntity<String> updateProfilePicture(MultipartHttpServletRequest request , HttpServletResponse response , UriComponentsBuilder ucBuilder) {
        
		System.out.println( request.getHeader("user") );
		
		System.out.println( request.getFile("file").getName() );
		System.out.println( request.getFile("file").getSize() );
		System.out.println( request.getFile("file").getContentType() );
		System.out.println( request.getFile("file").getOriginalFilename() );
		
		String hashname[] = request.getFile("file").getOriginalFilename().split(",");
		
		JSONObject json = new JSONObject();
		
		json.put("status", "Failed");
		
		BufferedOutputStream stream = null;
		
		try
	    {
			String path = context.getRealPath("/");
	        
	        System.out.println(path);
	        
	        File directory = null;
	        
	        System.out.println( request.getFile("file") );
	        
	        if (request.getFile("file").getContentType().contains("image"))
	        {
	            directory = new File(path + "\\resources\\images");
	            
	            System.out.println(directory);
	            
	            byte[] bytes = null;
	            File file = null;
	            bytes = request.getFile("file").getBytes();
	            
	            if (!directory.exists()) directory.mkdirs();
	           
	            if( hashname.length > 0 )
	            {
	            	file = new File(directory.getAbsolutePath() + System.getProperty("file.separator") + HashManager.generateHashCode( request.getHeader("user") + hashname[0] ) + ".jpg");
		            
		            System.out.println(file.getAbsolutePath());
		            
		            stream = new BufferedOutputStream(new FileOutputStream(file));
		            stream.write(bytes);
		            stream.close();
		            
		            Profile p = ps.getProfile(request.getHeader("user"));
		            
		            if( p != null )
		            {
		            	p.setImage("resources/images/" + HashManager.generateHashCode( request.getHeader("user") + hashname[0] ) + ".jpg" );
		            	
		            	ps.updateProfile(p);
		            	
		            	json.put("status", "Uploaded");
		            	json.put("imagesrc", "resources/images/" + HashManager.generateHashCode( request.getHeader("user") + hashname[0] ) + ".jpg" );
		            }
	            }

	        }
	    }
	    catch (Exception e)
	    {
	    	e.printStackTrace();
	    }
		
		System.out.println(json.toString());
        
        return new ResponseEntity<String>(json.toString(), HttpStatus.CREATED);
    }
}
