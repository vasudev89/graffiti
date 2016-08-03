package com.monkeybusiness;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
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
		
		String imagename = p.getImage();
		
		String path = context.getRealPath("/");
        
        System.out.println(path);
        
        File directory = new File(path + imagename);
		
        directory.delete();
        
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
	
	@CrossOrigin
    @RequestMapping(value = "/updateUserBlog/", method = RequestMethod.POST)
    public ResponseEntity<String> updateUserBlog(HttpServletResponse response,@RequestBody JSONObject data, UriComponentsBuilder ucBuilder) {
        
		System.out.println(data.get("Username"));
		
		Profile p = ps.getProfile(data.get("Username").toString());
		
		p.setBlogs(data.toJSONString());
		
		ps.updateProfile(p);
		
		JSONObject json = new JSONObject();
		
		json.put("status", "Updated");
		
        System.out.println(json.toString());
        
        return new ResponseEntity<String>(json.toString(), HttpStatus.CREATED);
    }
	
	@CrossOrigin
    @RequestMapping(value = "/AddFriend/", method = RequestMethod.POST)
    public ResponseEntity<String> AddFriend(HttpServletResponse response,@RequestBody JSONObject data, UriComponentsBuilder ucBuilder) {
        
		System.out.println(data.get("currentUser"));
		System.out.println(data.get("FriendName"));
		
		Profile p = ps.getProfile( data.get("FriendName").toString() );
		
		if( p.getPendingFriendList() == null )
			p.setPendingFriendList( data.get("currentUser").toString());
		else
			p.setPendingFriendList( p.getPendingFriendList() + "," + data.get("currentUser").toString() );
		
		ps.updateProfile(p);
		
		JSONObject json = new JSONObject();
		
		json.put("status", "Updated");
		
        System.out.println(json.toString());
        
        return new ResponseEntity<String>(json.toString(), HttpStatus.CREATED);
    }
	
	@CrossOrigin
    @RequestMapping(value = "/RemovePending/", method = RequestMethod.POST)
    public ResponseEntity<String> RemovePending(HttpServletResponse response,@RequestBody JSONObject data, UriComponentsBuilder ucBuilder) {
        
		System.out.println(data.get("currentUser"));
		System.out.println(data.get("FriendName"));
		
		Profile p = ps.getProfile( data.get("FriendName").toString() );
		
		if( p.getPendingFriendList() != null && p.getPendingFriendList().contains(data.get("currentUser").toString()) )
		{
			String temp = p.getPendingFriendList();
			
			temp = temp.replaceAll( data.get("currentUser").toString() , "");
			
			temp = temp.replaceAll( ",," , "");
			
			p.setPendingFriendList(temp);
			
			ps.updateProfile(p);
		}
		
		JSONObject json = new JSONObject();
		
		json.put("status", "Updated");
		
        System.out.println(json.toString());
        
        return new ResponseEntity<String>(json.toString(), HttpStatus.CREATED);
    }
	
	@CrossOrigin
    @RequestMapping(value = "/ConfirmRequest/", method = RequestMethod.POST)
    public ResponseEntity<String> ConfirmRequest(HttpServletResponse response,@RequestBody JSONObject data, UriComponentsBuilder ucBuilder) {
        
		System.out.println(data.get("currentUser"));
		System.out.println(data.get("FriendName"));
		
		Profile p1 = ps.getProfile( data.get("currentUser").toString() );
		Profile p2 = ps.getProfile( data.get("FriendName").toString() );
		
		if( p1.getPendingFriendList() != null && p1.getPendingFriendList().contains(data.get("FriendName").toString()) )
		{
			String temp = p1.getPendingFriendList();
			
			temp = temp.replaceAll( data.get("FriendName").toString() , "");
			
			temp = temp.replaceAll( ",," , "");
			
			p1.setPendingFriendList(temp);
			
			ps.updateProfile(p1);
		}
		
		if( p1.getFriendList() == null )
			p1.setFriendList( data.get("FriendName").toString());
		else
			p1.setFriendList( p1.getFriendList() + "," + data.get("FriendName").toString() );
		
		ps.updateProfile(p1);
		
		if( p2.getFriendList() == null )
			p2.setFriendList( data.get("currentUser").toString());
		else
			p2.setFriendList( p2.getFriendList() + "," + data.get("currentUser").toString() );
		
		ps.updateProfile(p2);
		
		JSONObject json = new JSONObject();
		
		json.put("status", "Updated");
		
        System.out.println(json.toString());
        
        return new ResponseEntity<String>(json.toString(), HttpStatus.CREATED);
    }
	
	@CrossOrigin
    @RequestMapping(value = "/GetAllFriends/", method = RequestMethod.POST)
    public ResponseEntity<String> GetAllFriends(HttpServletResponse response,@RequestBody JSONObject data, UriComponentsBuilder ucBuilder) {
        
		System.out.println(data.get("currentUser"));
		
		Profile p1 = ps.getProfile( data.get("currentUser").toString() );
		
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
		
		JSONArray jarr = new JSONArray();
		
		if( p1 != null && p1.getFriendList() != null )
		{
			String friends[] = p1.getFriendList().split(",");
			
			for( String friend: friends )
			{
				Profile pe = ps.getProfile(friend);
				
				if( pe != null )
				{
					JSONObject jobj = new JSONObject();
					
					jobj.put("Name", pe.getUsername());
					jobj.put("Online", pe.getLoginStatus());
					jobj.put("Image", pe.getImage().replaceAll("\\\\", ""));
					jobj.put("BasicInfo", pe.getBasicInfo());
					jobj.put("ChatWindowOpen", false);
					jobj.put("ReadStatus", "");
		
					JSONArray messages = new JSONArray();
					
					try
					{
						for( Object x:chathist )
						{
							JSONObject newx = (JSONObject)x;
							
							if	( 
									(
											newx.get("From").equals( p1.getUsername() ) && 
											newx.get("To").equals( pe.getUsername() ) 
									)
									||
									(
											newx.get("From").equals( pe.getUsername() ) && 
											newx.get("To").equals( p1.getUsername() ) 
									)
								)
							{
								messages.add(newx);
								
								if( newx.get("status") != null && newx.get("status").equals( "Unread" ) )
								{
									jobj.put("ReadStatus", "Unread");
								}
							}
						}
					}
					catch(Exception e)
					{
						System.out.println("CHAT RETRIEVAL ERROR!!");
					}
					
					jobj.put("Messages", messages);
					jobj.put("currentMessage", "");
					
					jarr.add(jobj);
				}
			}
			
		}
		
		JSONObject json = new JSONObject();
		
		json.put("AllMyFriends", jarr);
		
        System.out.println(json.toString());
		
        return new ResponseEntity<String>(json.toString(), HttpStatus.CREATED);
    }
	
	@CrossOrigin
    @RequestMapping(value = "/GetCurrentUserImage/", method = RequestMethod.POST)
    public ResponseEntity<String> GetCurrentUserImage(HttpServletResponse response,@RequestBody JSONObject data, UriComponentsBuilder ucBuilder) {
        
		System.out.println(data.get("currentUser"));
		
		Profile p1 = ps.getProfile( data.get("currentUser").toString() );
		
		JSONObject json = new JSONObject();
		
		json.put("Image", p1.getImage());
		
        System.out.println(json.toString());
		
        return new ResponseEntity<String>(json.toString(), HttpStatus.CREATED);
    }
	
	@CrossOrigin
    @RequestMapping(value = "/RemoveFriend/", method = RequestMethod.POST)
    public ResponseEntity<String> RemoveFriend(HttpServletResponse response,@RequestBody JSONObject data, UriComponentsBuilder ucBuilder) {
        
		System.out.println(data.get("currentUser"));
		System.out.println(data.get("FriendName"));
		
		JSONObject json = new JSONObject();
		
		if( data.get("currentUser") != null && !data.get("currentUser").equals("") && data.get("FriendName") != null && !data.get("FriendName").equals("") )
		{
			Profile p1 = ps.getProfile( data.get("currentUser").toString() );
			Profile p2 = ps.getProfile( data.get("FriendName").toString() );
			
			if( p1.getFriendList() != null && p1.getFriendList().contains(data.get("FriendName").toString()) )
			{
				String temp = p1.getFriendList();
				
				temp = temp.replaceAll( data.get("FriendName").toString() , "");
				
				temp = temp.replaceAll( ",," , "");
				
				p1.setFriendList(temp);
				
				ps.updateProfile(p1);
			}
			
			if( p2.getFriendList() != null && p2.getFriendList().contains(data.get("currentUser").toString()) )
			{
				String temp = p2.getFriendList();
				
				temp = temp.replaceAll( data.get("currentUser").toString() , "");
				
				temp = temp.replaceAll( ",," , "");
				
				p2.setFriendList(temp);
				
				ps.updateProfile(p2);
			}
			
			json.put("status", "Updated");
			
	        System.out.println(json.toString());
		}
		else
		{
			json.put("status", "Not Updated");
		}
		
        
        return new ResponseEntity<String>(json.toString(), HttpStatus.CREATED);
    }
	
	@CrossOrigin
    @RequestMapping(value = "/updateUserForum/", method = RequestMethod.POST)
    public ResponseEntity<String> updateUserForum(HttpServletResponse response,@RequestBody JSONObject data, UriComponentsBuilder ucBuilder) {
        
		System.out.println(data.get("Username"));
		
		Profile p = ps.getProfile(data.get("Username").toString());
		
		p.setForums(data.toJSONString());
		
		ps.updateProfile(p);
		
		JSONObject json = new JSONObject();
		
		json.put("status", "Updated");
		
        System.out.println(json.toString());
        
        return new ResponseEntity<String>(json.toString(), HttpStatus.CREATED);
    }
	
	@CrossOrigin
    @RequestMapping(value = "/updateGallery/", method = RequestMethod.POST )
    public @ResponseBody String updateGallery( MultipartHttpServletRequest request , HttpServletResponse response , UriComponentsBuilder ucBuilder) {
        
		System.out.println( "In update Gallery" );
		
		System.out.println( request.getHeader("user") );
		
		JSONObject json = new JSONObject();
		
		json.put("status", "Failed");
		
		List<MultipartFile> files = request.getFiles("uploadedFile");
		
		int counter = 1;
		
		for( MultipartFile myfile : files )
		{
			String hashname[] = myfile.getOriginalFilename().split(",");
			
			BufferedOutputStream stream = null;
			
			try
		    {
				String path = context.getRealPath("/");
		        
		        System.out.println(path);
		        
		        File directory = null;
		        
		        System.out.println( myfile );
		        
		        if (myfile.getContentType().contains("image"))
		        {
		            directory = new File(path + "\\resources\\images");
		            
		            System.out.println(directory);
		            
		            byte[] bytes = null;
		            File file = null;
		            bytes = myfile.getBytes();
		            
		            if (!directory.exists()) directory.mkdirs();
		           
		            if( hashname.length > 0 )
		            {
		            	String tempval = HashManager.generateHashCode( request.getHeader("user") + hashname[0] ) + ".jpg";
		            	
		            	file = new File(directory.getAbsolutePath() + System.getProperty("file.separator") + tempval);
		            	
			            System.out.println(file.getAbsolutePath());
			            
			            stream = new BufferedOutputStream(new FileOutputStream(file));
			            stream.write(bytes);
			            stream.close();
			            
			            Profile p = ps.getProfile(request.getHeader("user"));
			            
			            if( p != null )
			            {
			            	String temp = p.getGallery();
			            	
			            	if(temp == null)
			            	{
			            		p.setGallery("resources/images/" + tempval );
			            	}
			            	else
			            	{
			            		p.setGallery(p.getGallery() + ",resources/images/" + tempval );
			            	}
			            	
			            	System.out.println("Gallery:" + p.getGallery());
			            	
			            	ps.updateProfile(p);
			            	
			            	json.put("status", "Uploaded");
			            	
			            	/*JSONObject jobj = new JSONObject();
			            	
			            	jobj.put("status", "Progress" );
			            	jobj.put("Counter", counter++ );
			            	jobj.put("imagesrc", "resources/images/" + tempval );
			            	
			            	return jobj.toJSONString();*/
			            	
			            }
		            }

		        }
		    }
		    catch (Exception e)
		    {
		    	e.printStackTrace();
		    }

		}
		
		JSONObject jobj = new JSONObject();
    	
    	jobj.put("status", "Completed" );
    	
    	return jobj.toJSONString();
    }
	
	@CrossOrigin
    @RequestMapping(value = "/GetUserGallery/", method = RequestMethod.POST)
    public ResponseEntity<String> GetUserGallery(HttpServletResponse response,@RequestBody JSONObject data, UriComponentsBuilder ucBuilder) {
        
		System.out.println(data.get("currentUser"));
		
		Profile p = ps.getProfile( data.get("currentUser").toString() );
		
		JSONObject json = new JSONObject();
		
		json.put("Username", data.get("currentUser").toString() );
		
		JSONArray jarr = new JSONArray();
		
		try
		{
			String temp[] = p.getGallery().split(",");
			
			for( String t: temp )
			{
				if( t!= null && !t.equals("") )
				{
					jarr.add(t.replaceAll("\\\\", ""));
				}
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		
		json.put("Gallery", jarr );
		
        System.out.println(json.toString());
		
        return new ResponseEntity<String>(json.toString(), HttpStatus.CREATED);
    }
	
	@CrossOrigin
    @RequestMapping(value = "/DeleteFromGallery/", method = RequestMethod.POST)
    public ResponseEntity<String> DeleteFromGallery(HttpServletResponse response,@RequestBody JSONObject data, UriComponentsBuilder ucBuilder) {
        
		System.out.println(data.get("currentUser"));
		
		Profile p = ps.getProfile( data.get("currentUser").toString() );
		
		try
		{
			String temp = p.getGallery();
			
			String jar[] = ( data.get("GalleryForDelete").toString().split(";") );
			
			System.out.println(jar.toString());
			
			for( Object x: jar )
			{
				temp = temp.replaceAll(x.toString(), "");
				temp = temp.replaceAll(",,", "");
			}
			
			p.setGallery(temp);
			
			ps.updateProfile(p);
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		
		JSONObject json = new JSONObject();
		
		json.put("Username", data.get("currentUser").toString() );
		
		JSONArray jarr = new JSONArray();
		
		try
		{
			String temp[] = p.getGallery().split(",");
			
			for( String t: temp )
			{
				if( t!= null && !t.equals("") )
				{
					jarr.add(t.replaceAll("\\\\", ""));
				}
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		
		json.put("Gallery", jarr );
		
        System.out.println(json.toString());
		
        return new ResponseEntity<String>(json.toString(), HttpStatus.CREATED);
    }
}
