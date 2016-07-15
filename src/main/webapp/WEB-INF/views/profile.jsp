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

<script type="text/javascript" src="resources/references/js/ProgressObject.js"></script>

<script type="text/javascript">
	var myApp = angular.module("myApp",[]);
	
///////////////////////////////////////
	
	myApp.factory('UserService', ['$http', '$q', function($http, $q){
	 
    return {
         		updateUserDetails: function(item){
                    return $http.post('http://localhost:9002/monkeybusiness/updateUserDetails/', item)
                            .then(
                                    function(response){
                                        return response.data;
                                    }, 
                                    function(errResponse){
                                        console.error('Error while updating User');
                                        return $q.reject(errResponse);
                                    }
                            );
            		}
    		}
    		,
            {
         		updateUserPassword: function(item){
                    return $http.post('http://localhost:9002/monkeybusiness/updateUserPassword/', item)
                            .then(
                                    function(response){
                                        return response.data;
                                    }, 
                                    function(errResponse){
                                        console.error('Error while updating User Password');
                                        return $q.reject(errResponse);
                                    }
                            );
            }
    };
 
}]);

//////////////////////////////////////////////////
	
	myApp.controller("myCtrl",['$scope', 'UserService' ,function($scope , $UserService){
		
		$scope.data = ${dataValue};
		$scope.resetdata = ${dataValue};
		
		$scope.UserData = 	{ 
								Email: $scope.data.Email ,
								Username: $scope.data.Username,
								Gender: $scope.data.Gender,
								Phone: $scope.data.Phone,
								Location: $scope.data.Location,
								BasicInfo: $scope.data.BasicInfo
							};
		
		$scope.UserPasswordDetails = 	{ 
				Username: $scope.data.Username,
				CurrentPassword: "",
				NewPassword: "",
				ConfirmNewPassword: ""
			};
		
		$scope.updateUserData = function()
		{
			$scope.UserData =
			{ 
				Email: $scope.data.Email ,
				Username: $scope.data.Username,
				Gender: $scope.data.Gender,
				Phone: $scope.data.Phone,
				Location: $scope.data.Location,
				BasicInfo: $scope.data.BasicInfo
			};
		}
		
		$scope.progressObj = new ProgressObject();
		$scope.progressObj.Constructor( "ProfileProgress", "20px" , "20px" , "HeaderDiv" , 100, 5, 1.0 , 0, "Indeterminate");
		
		$scope.stateDisabled = false;
		
		$scope.data.Phone = parseInt($scope.data.Phone,10);
		
		$scope.Part1Errors = false;
		$scope.Part2Errors = false;
		
		$scope.EmailError = false;
		$scope.PhoneError = false;
		
		$scope.UpdatePageSize = function()
		{
			window.setTimeout(function()
			{
				document.getElementById("body_div").style.height = (document.getElementById("index_div_row").offsetHeight + 100) + 'px'; 
			}, 200);
		};
		
		$scope.ValidateEmail = function()
		{
			var reg = /\S+@\S+\.\S+/;
			$scope.EmailError = !reg.test( $scope.data.Email );
			
			$scope.Part1Errors = $scope.EmailError || $scope.PhoneError;
			
			$scope.UpdatePageSize();
			$scope.updateUserData();
			
			/* console.log( $scope.data.Email );
			console.log( $scope.UserData ); */
		}
		
		$scope.ValidatePhone = function()
		{
			var reg = /^[7-9][0-9]{9}$/;
			$scope.PhoneError = !reg.test( $scope.data.Phone );
			
			$scope.Part1Errors = $scope.EmailError || $scope.PhoneError;
			
			$scope.UpdatePageSize();
			$scope.updateUserData();
		}
		
		//$scope.CurrentPasswordError = $scope.NewPasswordError = $scope.ConfirmNewPasswordError = $scope.MatchNewPasswords = true;
		
		$scope.ValidateCurrentPassword = function()
		{
			var reg = /^.{6,15}$/;
			$scope.CurrentPasswordError = !reg.test( $scope.UserPasswordDetails.CurrentPassword );
			
			$scope.UpdatePageSize();
		}
		
		$scope.ValidateNewPassword = function()
		{
			var reg = /^.{6,15}$/;
			$scope.NewPasswordError = !reg.test( $scope.UserPasswordDetails.NewPassword );
			
			$scope.MatchNewPasswords = ($scope.UserPasswordDetails.NewPassword == "" || $scope.UserPasswordDetails.ConfirmNewPassword == "" )?true:!( $scope.UserPasswordDetails.NewPassword == $scope.UserPasswordDetails.ConfirmNewPassword );
			
			$scope.UpdatePageSize();
		}
		
		$scope.ValidateConfirmNewPassword = function()
		{
			var reg = /^.{6,15}$/;
			$scope.ConfirmNewPasswordError = !reg.test( $scope.UserPasswordDetails.ConfirmNewPassword );
			
			$scope.MatchNewPasswords = ($scope.UserPasswordDetails.NewPassword == "" || $scope.UserPasswordDetails.ConfirmNewPassword == "" )?true:!( $scope.UserPasswordDetails.NewPassword == $scope.UserPasswordDetails.ConfirmNewPassword );
			
			$scope.UpdatePageSize();
		}
		
		$scope.change = false;
		
		$scope.updated = false;
		$scope.passwordUpdated = false;
		$scope.passwordUpdatedWithError = false;
		$scope.passwordUpdateError = "Current Password Incorrect";
		
		$scope.sendPasswordForUpdate = function()
		{
			$scope.CurrentPasswordError = ( $scope.CurrentPasswordError == undefined ) ? true : $scope.CurrentPasswordError;
			$scope.NewPasswordError = ( $scope.NewPasswordError == undefined ) ? true : $scope.NewPasswordError;
			$scope.ConfirmNewPasswordError = ( $scope.ConfirmNewPasswordError == undefined ) ? true : $scope.ConfirmNewPasswordError;
			$scope.MatchNewPasswords = ( $scope.MatchNewPasswords == undefined ) ? true : $scope.MatchNewPasswords;
			
			$scope.Part2Errors = ( $scope.CurrentPasswordError || $scope.NewPasswordError || $scope.ConfirmPasswordError || $scope.MatchNewPasswords );
			
			if( $scope.Part2Errors == false )
			{
				$scope.progressObj.SwitchFlag(true);
				$scope.stateDisabled = true;
				
				var resp = $UserService.updateUserPassword($scope.UserPasswordDetails)
	            .then(
	            		function(response)
	            		{
	            			$scope.response = response.status;
	            			
	            			//console.log( $scope.response );
	            			
	            			if( $scope.response == "Password Incorrect" )
	            			{
	            				$scope.passwordUpdatedWithError = true;
	            				
	            				$scope.passwordUpdateError = "Current Password Incorrect";
	            				
	            				window.setTimeout(function()
	        		    		{
	        		    			$scope.$apply($scope.passwordUpdatedWithError = false);
	        		    		}, 5000);
	        		    				
	            			}
	            			
	            			if( $scope.response == "Updated" )
	            			{
	            				$scope.passwordUpdated = true;
	            				
	            				window.setTimeout(function()
	        		    		{
	        		    			$scope.$apply($scope.passwordUpdated = false);
	        		    		}, 5000);
	        		    				
	            			}
	            			
	            			if( $scope.response == "Same Password" )
	            			{
	            				$scope.passwordUpdatedWithError = true;
	            				
	            				$scope.passwordUpdateError = "New Password Cannot be the same as the Current Password";
	            				
	            				window.setTimeout(function()
	        		    		{
	        		    			$scope.$apply($scope.passwordUpdatedWithError = false);
	        		    		}, 5000);
	        		    				
	            			}
	            			
	            			$scope.progressObj.SwitchFlag(false);
		    				$scope.stateDisabled = false;
		    				
		    				
	            		}
		            , 
		                function(errResponse)
		                {
		                	console.error('Error while Updating User.');
		                } 
	        	);
				//console.log( $scope.UserPasswordDetails );
			}
			
			$scope.UpdatePageSize();
		}
		
		$scope.toggleChangeUpdate = function()
		{
			$scope.change = true;
			
			if( document.getElementById('change_update_btn').innerHTML == "Update" && !$scope.Part1Errors )
			{
				$scope.progressObj.SwitchFlag(true);
				$scope.stateDisabled = true;
				
				var resp = $UserService.updateUserDetails($scope.UserData)
	            .then(
	            		function()
	            		{
	            			$scope.progressObj.SwitchFlag(false);
		    				$scope.stateDisabled = false;
		    				
		    				$scope.updated = true;
		    				
		    				$scope.resetdata.Email = $scope.UserData.Email;
		    				$scope.resetdata.Gender = $scope.UserData.Gender;
		    				$scope.resetdata.Phone = $scope.UserData.Phone;
		    				$scope.resetdata.Location = $scope.UserData.Location;
		    				$scope.resetdata.BasicInfo = $scope.UserData.BasicInfo;
		    				
		    				$scope.letItBe();
	            		}
		            , 
		                function(errResponse)
		                {
		                	console.error('Error while Updating User.');
		                } 
	        	);
			}
			
			document.getElementById('change_update_btn').innerHTML = "Update";
			
			$scope.UpdatePageSize();
		}
		
		$scope.letItBe = function()
		{
			
			window.setTimeout(function()
    		{
				$scope.$apply($scope.updated = false);
    			
    			//console.log($scope.updated);
    		}, 5000);
			
			$scope.data = $scope.resetdata;
			$scope.change = false;
			document.getElementById('change_update_btn').innerHTML = "Change";
			
			$scope.progressObj.SwitchFlag(false);
			$scope.stateDisabled = false;
			
			$scope.EmailError = false;
			$scope.PhoneError = false;
			
			$scope.UpdatePageSize();
		}
		
		////////////////
		
		$scope.openFileChooser = function()
		{
			$('#trigger').trigger('click');
		};
		
		$scope.setFile = function(element)
		{
  			$scope.currentFile = element.files[0];
   			var reader = new FileReader();

  			reader.onload = function(event)
			{
    			$scope.data.Image = event.target.result
    			$scope.$apply()

  			};
  			// when the file is read it triggers the onload event above.
  			reader.readAsDataURL(element.files[0]);
  			
  			$scope.UpdatePageSize();
		};
		
		////////////////
				
	}]);
	
	
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
			
			<div class="wrapper" data-anim="base wrapper">
			  <div class="circle" data-anim="base left"></div>
			  <div class="circle" data-anim="base right"></div>
			</div>
			
			<div class="row">
			
				<div class="col-lg-12">
				
				<!--  -->
			
				<br>
			
				<table class="table center myprofile">
				
					<tr ng-show="updated">
						
						<td colspan="2">
							
								<span class="text-success bg-success error-font" >User Updated Successfully</span>
							
						</td>
						
					</tr>
				
					<tr>
						
						<td colspan="2">
								<button type="button" class="btn btn-link" ng-click="openFileChooser();" ng-disabled="stateDisabled">Change Picture</button>
								<br>
								<img ng-src="{{data.Image}}" class="img-responsive center_img profile-img"></img>
								<input type="file" id="trigger" ng-show="false" onchange="angular.element(this).scope().setFile(this)" accept="image/*">
							<br>
						</td>
						
					</tr>
				
					
				
					<tr>
						<td style="width: 50%;">Email ID:</td>
						<td style="width: 50%;">
							<label ng-show="!change">{{data.Email}}</label>
							<input ng-show="change" type="email" class="form-control form-input" placeholder="Enter Email" ng-model="data.Email" ng-change="ValidateEmail();" ng-disabled="stateDisabled"/>
							<span class="text-danger bg-danger error-font" ng-show="EmailError">Invalid Email</span>
						</td>
						
					</tr>
					
					<tr>
						<td>User Name:</td>
						<td>{{data.Username}}</td>
					</tr>
					
					<tr>
						<td>Gender:</td>
						<td>
							<label ng-show="!change">{{data.Gender}}</label>
							<select ng-show="change" class="form-control select-menu" ng-disabled="stateDisabled" ng-change="updateUserData();" ng-model="data.Gender" >
								<option value="Male">Male</option>
								<option value="Female">Female</option>								  
							</select>
						</td>
					</tr>
					
					<tr>
						<td>Phone:</td>
						<td>
							<label ng-show="!change">{{data.Phone}}</label>
							<input ng-show="change" type="number" class="form-control form-input" placeholder="Enter Phone" ng-model="data.Phone" ng-change="ValidatePhone();" ng-disabled="stateDisabled" ng-change="updateUserData();"/>
							<span class="text-danger bg-danger error-font table-text-center" ng-show="PhoneError">Invalid Phone. Must be a 10 Digit Phone Number.</span>
						</td>
					</tr>
					
					<tr>
						<td>Location:</td>
						<td>
							<label ng-show="!change">{{data.Location}}</label>
							<textarea ng-show="change" class="form-control form-input" placeholder="Enter Location" ng-disabled="stateDisabled" ng-change="updateUserData();" ng-model="data.Location"></textarea>
						</td>
					</tr>
					
					<tr>
						<td>Basic Info:</td>
						<td>
							<label ng-show="!change">{{data.BasicInfo}}</label>
							<textarea ng-show="change" class="form-control form-input" placeholder="Enter Location" ng-disabled="stateDisabled" ng-change="updateUserData();" ng-model="data.BasicInfo"></textarea>
						</td>
					</tr>
					
					<tr>
						<td colspan="2" >
							<div class="row">
								<br>
								<div class="col-md-2 col-md-offset-5"> 
									<button type="button" class="btn btn-info" id="change_update_btn" ng-click="toggleChangeUpdate();" ng-disabled="stateDisabled">Change</button>
									
									&nbsp;&nbsp;
									
									<button ng-show="change" type="button" class="btn btn-link" id="change_update_btn" ng-click="letItBe();" ng-disabled="stateDisabled">Let It Be</button> 
								</div>
							</div>
						</td>
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
				
					<tr ng-show="passwordUpdated">
						
						<td colspan="2">
							
								<span class="text-success bg-success error-font" >Password Updated Successfully</span>
							
						</td>
						
					</tr>
					
					<tr ng-show="passwordUpdatedWithError">
						
						<td colspan="2">
							
								<span class="text-danger bg-danger error-font">{{passwordUpdateError}}</span>
							
						</td>
						
					</tr>
				
					<tr>
						<td style="width: 50%;">Current Password:</td>
						<td style="width: 50%;">
							<input name="current_pass" path="current_pass" type="password" class="form-control form-input" placeholder="Enter Current Password" ng-model="UserPasswordDetails.CurrentPassword" ng-change="ValidateCurrentPassword();" ng-focus="ValidateCurrentPassword();" ng-disabled="stateDisabled" />
							<span class="text-danger bg-danger error-font table-text-center" ng-show="CurrentPasswordError">Current Password has to be between 6-15 Characters</span>
						</td>
						
					</tr>
					
					<tr>
						<td>New Password:</td>
						<td>
							<input name="new_pass" path="new_pass" type="password" class="form-control form-input" placeholder="Enter New Password" ng-model="UserPasswordDetails.NewPassword" ng-change="ValidateNewPassword();" ng-focus="ValidateNewPassword();" ng-disabled="stateDisabled"/>
							<span class="text-danger bg-danger error-font table-text-center" ng-show="NewPasswordError">New Password has to be between 6-15 Characters</span>
						</td>
					</tr>
					
					<tr>
						<td>Confirm New Password:</td>
						<td>
							<input name="cnew_pass" path="cnew_pass" type="password" class="form-control form-input" placeholder="Confirm New Password" ng-model="UserPasswordDetails.ConfirmNewPassword" ng-change="ValidateConfirmNewPassword();" ng-focus="ValidateConfirmNewPassword();" ng-disabled="stateDisabled"/>
							<span class="text-danger bg-danger error-font table-text-center" ng-show="ConfirmNewPasswordError">Confirm New Password has to be between 6-15 Characters</span>
						</td>
					</tr>
					
					<tr ng-show="MatchNewPasswords">
						<td></td>
						<td>
							<span class="text-danger bg-danger error-font table-text-center" ng-show="MatchNewPasswords">New Password & it's Confirmation must match</span>
						</td>
					</tr>
					
					<tr>
						<td colspan="2" >
							<div class="row">
								<br>
								<div class="col-md-2 col-md-offset-5"> <button type="submit" class="btn btn-success" ng-disabled="stateDisabled" ng-click="sendPasswordForUpdate();">Submit</button> </div>
							</div>
						</td>
					</tr>
						
				</table>
				
				<!--  -->
				
				</div>
			
			</div>
			
		</div>
			
		
	
	</div>
	
	<script type="text/javascript" src="resources/references/js/resizebody.js"></script>
	
</body>
</html>