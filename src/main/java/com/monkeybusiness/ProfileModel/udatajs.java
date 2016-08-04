package com.monkeybusiness.ProfileModel;

import java.util.ArrayList;

public class udatajs
{
	private ArrayList al = new ArrayList();
	
	public void addUser(Profile i)
	{
		al.add(i);
	}
	
	@Override
	public String toString() {
		
		String retval = "";
		
		for( Object x: al )
		{
			retval += x + ",";
		}
		
		if( retval.equals("") )
			retval = "[]";
		else
			retval = "[" + retval.substring(0, retval.length()-1) + "]";
		
		return retval;
	}
}
