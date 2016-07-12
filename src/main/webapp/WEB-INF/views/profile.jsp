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

<!--  -->

<script type="text/javascript" src="resources/references/js/angular.min.js"></script>

<script type="text/javascript">
	var myApp = angular.module("myApp",[]);
	
	myApp.controller("myCtrl",function($scope ,$timeout){
		
		$scope.data = ${dataValue};
				
	});
	
	
</script>

<!--  -->

<body onload='resizing();onLoad();' ng-app="myApp" ng-controller='myCtrl'>

	<c:import url="head.jsp"></c:import>

	<div class="body" id="body_div">
	
		<div class="container center" id="index_div_row">
			
			<br>
			
			<div class="row">
				<div class="col-lg-12" style="font: small-caps 28px/50px Calibri, sans-serif; color: rgba(28,181,223,0.8); background-color: rgba(255,255,255,1.0); border-bottom: 1px solid rgb(128,0,0); text-align: left; padding-left: 15px; ">
					My Profile
				</div>
			</div>
			
			<div class="row">
			
				<div class="col-lg-12">
				
				<!--  -->
			
				<br>
			
				<table class="table center myprofile">
				
					<tr>
						<td colspan="2"><img ng-src="{{data.Image}}" class="img-responsive center_img"></img></td>
						
					</tr>
				
					<tr>
						<td>Email ID:</td>
						<td>{{data.Email}}</td>
					</tr>
					
					<tr>
						<td>User Name:</td>
						<td>{{data.Username}}</td>
					</tr>
					
					<tr>
						<td>Phone:</td>
						<td>{{data.Phone}}</td>
					</tr>
					
					<tr>
						<td>Location:</td>
						<td>{{data.Location}}</td>
					</tr>
					
					<tr>
						<td>Basic Info:</td>
						<td>{{data.BasicInfo}}</td>
					</tr>
					
				</table>
				
				<!--  -->
				
				</div>
			
			</div>
			
			<br>
			
			<div class="row">
				<div class="col-lg-12" style="font: small-caps 28px/50px Calibri, sans-serif; color: rgba(28,181,223,0.8); background-color: rgba(255,255,255,1.0); border-bottom: 1px solid rgb(128,0,0); text-align: left; padding-left: 15px; ">
					Change Password
				</div>
			</div>
			
			<div class="row">
			
				<div class="col-lg-12">
				
				<!--  -->
			
				<br>
				<br>
			
				<table class="table center myprofile">
				
					<tr>
						<td>Current Password:</td>
						<td><input name="current_pass" path="current_pass" type="password" class="form-control form-input" placeholder="Enter Current Password"/></td>
					</tr>
					
					<tr>
						<td>New Password:</td>
						<td><input name="new_pass" path="new_pass" type="password" class="form-control form-input" placeholder="Enter New Password"/></td>
					</tr>
					
					<tr>
						<td>Confirm New Password:</td>
						<td><input name="cnew_pass" path="cnew_pass" type="password" class="form-control form-input" placeholder="Confirm New Password"/></td>
					</tr>
					
					<tr>
						<td colspan="2" >
							<div class="row">
								<div class="col-md-2 col-md-offset-5"> <button type="submit" class="btn btn-success">Submit</button> </div>
							</div>
						</td>
					</tr>
						
				</table>
				
				<!--  -->
				
				</div>
			
			</div>
			
		</div>
			
		
	
	</div>
	
	<script type="text/javascript">
		
		function resizing()
		{
			document.getElementById("body_div").style.height = (document.getElementById("index_div_row").offsetHeight + 120) + 'px';
			
			window.addEventListener('resize', function()
			{
				document.getElementById("body_div").style.height = (document.getElementById("index_div_row").offsetHeight + 120) + 'px';
			}, false);
		}
				
	</script>
	
</body>
</html>