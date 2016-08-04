<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<sec:authentication var="user" property="principal" />

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<c:import url="head-meta.jsp"></c:import>	
</head>
<body onload='onLoad()'>

	<c:import url="/head"/>

	<div class="body">
	
		<!--  -->
		
		<div style="font: 28px/50px Calibri, sans-serif;" >
		
		<script type="text/javascript" src="resources/references/js/canvasback.js" ></script>
		
		<canvas id="myCanvas" width="1500" height="800" style="position: absolute; left: 0px; background-color : rgba(255, 255, 255, 1.0);"></canvas>
		
		<div id="AboutUsDiv" class="container" style="font: small-caps 28px/50px Calibri, sans-serif; color: #333333; opacity: 0.85; width: 100%;" class="table-responsive">
		
			<br>
			
			<div class="row">
				<div class="col-lg-12" style="font: small-caps 28px/50px Calibri, sans-serif; color: rgba(28,181,223,0.8); background-color: rgba(255,255,255,1.0); border-bottom: 1px solid rgb(128,0,0); border-top: 0px solid rgb(128,0,0); text-align: left; padding-left: 15px; ">
					About-Us
				</div>
			</div>
			
			
			<div class="row" style="height: 20px;">
			</div>
			
			<div class="row">
			
				<div class="col-lg-12">
				
					<table style="width: 100%;" class="table">
			<tr>
				<p style="font-style: italic;font-weight: bold;font-size: 16px;font-family: Segoe UI, Tahoma, sans-serif; color: #FFFFFF; background-color: #333333; padding: 20px; opacity: 0.8; box-shadow: 5px 5px 20px #000000; line-height: 25px;" ><span style="color: #FFFFFF; font-size: 32px;">Graffitat</span> <span style="color: #FFC706; font-size: 24px;"> - Connect</span> and engage.</p>
			</tr>
							  	
			<tr>
				<p style="font-style: italic;font-weight: bold;font-size: 16px;font-family: Segoe UI, Tahoma, sans-serif; color: #333333; background-color: #FFFFFF; padding: 20px; opacity: 0.8; box-shadow: 5px 5px 20px #000000; line-height: 20px;" ><span style="color: #333333; font-size: 24px;">A</span> social platform to enhance connectivity in its user base. Connect and engage with your peers on our platform. Exchange great Thoughts and Ideas and change the way people think.</p>
			</tr>
			
			<tr>
				<p style="font-style: italic;font-weight: bold;font-size: 16px;font-family: Segoe UI, Tahoma, sans-serif; color: #333333; background-color: #FFFFFF; padding: 20px; opacity: 0.8; box-shadow: 5px 5px 20px #000000; line-height: 20px;" ><span style="color: #333333; font-size: 24px;">We</span> would provide you with a variety of services which include :</p>
				<ol style="font-style: italic;font-weight: bold;font-size: 16px;font-family: Segoe UI, Tahoma, sans-serif; color: #333333; background-color: #FFFFFF; padding: 5px; opacity: 0.8; box-shadow: 5px 5px 20px #000000; line-height: 20px;" class="list-group">
					<li class="list-group-item"> - Blogs</li>
					<li class="list-group-item"> - Forums</li>
					<li class="list-group-item"> - Chats</li>
				</ol>
			</tr>
							  	
			<br>
							  	
		</table>
				
				</div>
			
			</div>
		
		</div>
		
	</div>
	
		
		<!--  -->
	
	</div>
	
</body>
</html>
	