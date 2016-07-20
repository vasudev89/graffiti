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

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/references/js/angular.min.js"></script>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/references/js/ProgressObject.js"></script>

<script type="text/javascript">
	var myApp = angular.module("myApp",[]);
	
/////////////////////////////////////
	
	myApp.factory('UserService', ['$http', '$q', function($http, $q){
		
    return {
    			AddFriend: function(item){
                    return $http.post('http://localhost:9002/monkeybusiness/AddFriend/', item)
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
				,
				ConfirmRequest: function(item){
                    return $http.post('http://localhost:9002/monkeybusiness/ConfirmRequest/', item)
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
				,
				RemoveFriend: function(item){
                    return $http.post('http://localhost:9002/monkeybusiness/RemoveFriend/', item)
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
				,
				RemovePending: function(item){
			            return $http.post('http://localhost:9002/monkeybusiness/RemovePending/', item)
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
    };
 
}]);

//////////////////////////////////////////////////	
	
	myApp.controller("myCtrl",['$scope', 'UserService' ,function($scope , $UserService){
		
		$scope.currentUser = '${pageContext.request.userPrincipal.name}';
		//$scope.currentUser = 'vasudev89';
		
		$scope.UpdatePageSize = function()
		{
			window.setTimeout(function()
			{
				document.getElementById("body_div").style.height = (document.getElementById("index_div_row").offsetHeight + 100) + 'px';
				$('#body_div').height( $('#body_div').height()<$(window).height()? $(window).height() : $('#body_div').height() );
			}, 200);
		};
		
		$scope.progressObj = new ProgressObject();
		$scope.progressObj.Constructor( "ProfileProgress", "20px" , "20px" , "HeaderDiv" , 100, 5, 1.0 , 0, "Indeterminate");
		
		$scope.stateDisabled = false;
		
		$scope.updated = false;
		
		try{ $scope.data = JSON.parse('${dataValue}'); }
		catch(e) { $scope.data = []; }
		
		try{ $scope.AllFriends = JSON.parse('${AllFriends}'); }
		catch(e) { $scope.AllFriends = []; }
			
		//console.log( $scope.AllFriends );
		
		$scope.AllFriendsEmpty = ($scope.AllFriends.length == 0);
	
		try{ $scope.PendingFriends = JSON.parse('${PendingFriends}'); }
		catch(e) { $scope.PendingFriends = []; }
		
		$scope.PendingFriendsEmpty = ($scope.PendingFriends.length == 0);
		
		$scope.AddFriend = function( currentUser , FriendName )
		{
			$scope.progressObj.SwitchFlag(true);
			$scope.stateDisabled = true;
			
			$scope.frequest = { "currentUser" : currentUser , "FriendName" : FriendName };
			
			var resp = $UserService.AddFriend($scope.frequest)
            .then(
            		function(response)
            		{
            			$scope.response = response.status;
            			
            			if( $scope.response == "Updated" )
            			{
            				for( i = 0 ; i < $scope.AllFriends.length ; i++ )
            				{
            					if( $scope.AllFriends[i].Name == $scope.frequest.FriendName )
            					{
            						$scope.AllFriends[i].IsFriend = "Friend Request Pending";
            						break;
            					}	
            				}
            				
            				for( i = 0 ; i < $scope.PendingFriends.length ; i++ )
            				{
            					if( $scope.PendingFriends[i].Name == $scope.frequest.FriendName )
            					{
            						$scope.PendingFriends[i].IsFriend = "Friend Request Pending";
            						break;
            					}	
            				}
            				
            				console.log( $scope.AllFriends );
            				
            				$scope.updated = true;
            				
            				window.setTimeout(function()
        		    		{
        		    			$scope.$apply($scope.updated = false);
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
			
			$scope.UpdatePageSize();
		}
		
		$scope.RemovePending = function( currentUser , FriendName )
		{
			$scope.progressObj.SwitchFlag(true);
			$scope.stateDisabled = true;
			
			$scope.frequest = { "currentUser" : currentUser , "FriendName" : FriendName };
			
			var resp = $UserService.RemovePending($scope.frequest)
            .then(
            		function(response)
            		{
            			$scope.response = response.status;
            			
            			if( $scope.response == "Updated" )
            			{
            				for( i = 0 ; i < $scope.AllFriends.length ; i++ )
            				{
            					if( $scope.AllFriends[i].Name == $scope.frequest.FriendName )
            					{
            						$scope.AllFriends[i].IsFriend = "Add Friend";
            						break;
            					}	
            				}
            				
            				for( i = 0 ; i < $scope.PendingFriends.length ; i++ )
            				{
            					if( $scope.PendingFriends[i].Name == $scope.frequest.FriendName )
            					{
            						$scope.PendingFriends[i].IsFriend = "Add Friend";
            						break;
            					}	
            				}
            				
            				console.log( $scope.AllFriends );
            				
            				$scope.updated = true;
            				
            				window.setTimeout(function()
        		    		{
        		    			$scope.$apply($scope.updated = false);
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
			
			$scope.UpdatePageSize();
		}
		
		$scope.RemoveFriend = function( currentUser , FriendName )
		{
			$scope.progressObj.SwitchFlag(true);
			$scope.stateDisabled = true;
			
			$scope.frequest = { "currentUser" : currentUser , "FriendName" : FriendName };
			
			var resp = $UserService.RemoveFriend($scope.frequest)
            .then(
            		function(response)
            		{
            			$scope.response = response.status;
            			
            			if( $scope.response == "Updated" )
            			{
            				for( i = 0 ; i < $scope.AllFriends.length ; i++ )
            				{
            					if( $scope.AllFriends[i].Name == $scope.frequest.FriendName )
            					{
            						$scope.AllFriends[i].IsFriend = "Add Friend";
            						break;
            					}	
            				}
            				
            				for( i = 0 ; i < $scope.PendingFriends.length ; i++ )
            				{
            					if( $scope.PendingFriends[i].Name == $scope.frequest.FriendName )
            					{
            						$scope.PendingFriends[i].IsFriend = "Add Friend";
            						break;
            					}	
            				}
            				
            				console.log( $scope.AllFriends );
            				
            				$scope.updated = true;
            				
            				window.setTimeout(function()
        		    		{
        		    			$scope.$apply($scope.updated = false);
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
			
			$scope.UpdatePageSize();
		}
		
		$scope.ConfirmRequest = function( currentUser , FriendName )
		{
			$scope.progressObj.SwitchFlag(true);
			$scope.stateDisabled = true;
			
			$scope.frequest = { "currentUser" : currentUser , "FriendName" : FriendName };
			
			var resp = $UserService.ConfirmRequest($scope.frequest)
            .then(
            		function(response)
            		{
            			$scope.response = response.status;
            			
            			if( $scope.response == "Updated" )
            			{
            				for( i = 0 ; i < $scope.AllFriends.length ; i++ )
            				{
            					if( $scope.AllFriends[i].Name == $scope.frequest.FriendName )
            					{
            						$scope.AllFriends[i].IsFriend = "Friends";
            						break;
            					}	
            				}
            				
            				for( i = 0 ; i < $scope.PendingFriends.length ; i++ )
            				{
            					if( $scope.PendingFriends[i].Name == $scope.frequest.FriendName )
            					{
            						$scope.PendingFriends[i].IsFriend = "Friends";
            						break;
            					}	
            				}
            				
            				console.log( $scope.AllFriends );
            				
            				$scope.updated = true;
            				
            				window.setTimeout(function()
        		    		{
        		    			$scope.$apply($scope.updated = false);
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
			
			$scope.UpdatePageSize();
		}
		
		
		//console.log($scope.data);
		
	}]);
	
	
</script>

<!--  -->

<body onload='resizing();onLoad()' ng-app="myApp" ng-controller='myCtrl'>

	<c:import url="head.jsp"></c:import>

	<div class="body" id="body_div">
	
		<div class="container center" id="index_div_row">

			<table class="table center myprofile">
						
				<tr ng-show="updated">
						
					<td colspan="2">
								
						<span class="text-success bg-success error-font" >Update Successful</span>
								
					</td>
							
				</tr>
				
			</table>
			
			<br>
			
			<div class="row" ng-show="currentUser == data.Username">
				<div class="col-lg-12" style="font: small-caps 28px/50px Calibri, sans-serif; color: rgba(28,181,223,0.8); background-color: rgba(255,255,255,1.0); border-bottom: 1px solid rgb(128,0,0); text-align: left; padding-left: 15px; ">
					Pending Requests: {{data.Username}}
				</div>
			</div>
			
			<br>
			
			<table class="table center myprofile" ng-show="PendingFriendsEmpty && (currentUser == data.Username)">
						
				<tr>
							
					<td colspan="2">
								
						<div class="blog-posts-nopost" style="text-align: center;">
				
							<label>No Pending Requests.</label>
									
						</div>
								
					</td>
							
				</tr>
						
			</table>
			
			
			
			<table style="width: 80%;" class="table center" ng-show="!( PendingFriendsEmpty && (currentUser == data.Username) )">
				<br>
				
				<tr>
					<td ng-show="( (currentUser == data.Username) )">
						<br>
						<input type="text" id="search" value="" placeholder="Enter Search Keyword..." class="form-control search-text" ng-model="searchPendingKeyword" ng-disabled="stateDisabled" />
					</td>
				</tr>
				
				<tr ng-repeat="x in PendingFriends| filter: searchPendingKeyword">
					<td class="blog-posts">
						<hr>
						<br>
						<div class="container">
							<div class="row">
								<div class="col-lg-3">
									<img alt="{{x.Name}}" ng-src="${pageContext.request.contextPath}/{{x.Image}}" class="img-thumbnail img-center" width="104"></img>
								</div>
								<div class="col-lg-9">
									
									<div class="container center">
										<div class="row">
											<div class="col-lg-3">
												<br>
												<label>Name: <a href="${pageContext.request.contextPath}/profile/{{x.Name}}" ng-class="stateDisabled && 'link-disabled' || ''">{{x.Name}}</a></label>
												<br>
											</div>
											<div class="col-lg-3">
												<br>
												<span class="user-online" ng-show="x.Online">Online</span>
												<span class="user-offline" ng-show="!x.Online">Offline</span>
												<br>
											</div>
											<div class="col-lg-6">
												<br>
												<label>Friendship Status:</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												<button class="btn btn-primary" ng-show="x.IsFriend == 'Add Friend'" ng-disabled="stateDisabled" ng-click="AddFriend(currentUser,x.Name)" >{{x.IsFriend}}</button>
												<button class="btn btn-primary" ng-show="x.IsFriend == 'Friends'" ng-disabled="stateDisabled" ng-click="RemoveFriend(currentUser,x.Name)" >Friends (Click to Remove)</button>
												<button class="btn btn-primary" ng-show="x.IsFriend == 'Confirm Request'" ng-disabled="stateDisabled" ng-click="ConfirmRequest(currentUser,x.Name)" >Confirm Request</button>
												<button class="btn btn-primary" ng-show="x.IsFriend == 'Friend Request Pending'" ng-disabled="stateDisabled" ng-click="RemovePending(currentUser,x.Name)" >Request Pending (Click to Undo)</button>
												<br>
											</div>
										</div>
										<div class="row">
											<div class="col-lg-3">
												<br>
												<label class="btn btn-link" ng-class="stateDisabled && 'link-disabled' || ''" style="font-size: 16px;"><a href="${pageContext.request.contextPath}/blog/{{x.Name}}" >- Blogs</a></label>
												<br>
											</div>
											<div class="col-lg-3">
												<br>
												<label class="btn btn-link" style="font-size: 16px;" ng-class="stateDisabled && 'link-disabled' || ''"><a href="${pageContext.request.contextPath}/forum/{{x.Name}}">- Forums</a></label>
												<br>
											</div>
											<div class="col-lg-6">
												<br>
												<label class="btn btn-link" style="font-size: 16px;" ng-class="stateDisabled && 'link-disabled' || ''"><a href="${pageContext.request.contextPath}/friend/{{x.Name}}">- Friends</a></label>
												<br>
											</div>
										</div>
										<div class="row">
											<div class="col-lg-6">
												<br>
												<label>Basic Info:</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label>{{x.BasicInfo}}</label>
												<br>
											</div>
										</div>
									</div>
									
								</div>
								
							</div>
							
						</div>
						<br>
						
					</td>
				</tr>
									  	
			</table>
			
			<!--  -->
			
			<div class="row">
				<div class="col-lg-12" style="font: small-caps 28px/50px Calibri, sans-serif; color: rgba(28,181,223,0.8); background-color: rgba(255,255,255,1.0); border-bottom: 1px solid rgb(128,0,0); text-align: left; padding-left: 15px; ">
					Friends: {{data.Username}}
				</div>
			</div>
			
			<br>
			
			<table class="table center myprofile" ng-show="AllFriendsEmpty">
						
				<tr>
							
					<td colspan="2">
								
						<div class="blog-posts-nopost" style="text-align: center;">
				
							<label>No friends to show.</label>
									
						</div>
								
					</td>
							
				</tr>
						
			</table>
			
			<br>
			
			<table style="width: 80%;" class="table center" ng-show="!AllFriendsEmpty">
				
				<tr>
					<td>
						<br>
						<input type="text" id="search" value="" placeholder="Enter Search Keyword..." class="form-control search-text" ng-model="searchKeyword" ng-disabled="stateDisabled" />
					</td>
				</tr>
				
				<tr ng-repeat="x in AllFriends| filter: searchKeyword">
					<td class="blog-posts">
						<hr>
						<br>
						<div class="container">
							<div class="row">
								<div class="col-lg-3">
									<img alt="{{x.Name}}" ng-src="${pageContext.request.contextPath}/{{x.Image}}" class="img-thumbnail img-center" width="104"></img>
								</div>
								<div class="col-lg-9">
									
									<div class="container center">
										<div class="row">
											<div class="col-lg-3">
												<br>
												<label>Name: <a href="${pageContext.request.contextPath}/profile/{{x.Name}}" ng-class="stateDisabled && 'link-disabled' || ''">{{x.Name}}</a></label>
												<br>
											</div>
											<div class="col-lg-3">
												<br>
												<span class="user-online" ng-show="x.Online">Online</span>
												<span class="user-offline" ng-show="!x.Online">Offline</span>
												<br>
											</div>
											<div class="col-lg-6">
												<br>
												<label>Friendship Status:</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												<button class="btn btn-primary" ng-show="x.IsFriend == 'Add Friend'" ng-disabled="stateDisabled" ng-click="AddFriend(currentUser,x.Name)" >{{x.IsFriend}}</button>
												<button class="btn btn-primary" ng-show="x.IsFriend == 'Friends'" ng-disabled="stateDisabled" ng-click="RemoveFriend(currentUser,x.Name)" >Friends (Click to Remove)</button>
												<button class="btn btn-primary" ng-show="x.IsFriend == 'Confirm Request'" ng-disabled="stateDisabled" ng-click="ConfirmRequest(currentUser,x.Name)" >Confirm Request</button>
												<button class="btn btn-primary" ng-show="x.IsFriend == 'Friend Request Pending'" ng-disabled="stateDisabled" ng-click="RemovePending(currentUser,x.Name)" >Request Pending (Click to Undo)</button>
												<br>
											</div>
										</div>
										<div class="row">
											<div class="col-lg-3">
												<br>
												<label class="btn btn-link" ng-class="stateDisabled && 'link-disabled' || ''" style="font-size: 16px;"><a href="${pageContext.request.contextPath}/blog/{{x.Name}}" >- Blogs</a></label>
												<br>
											</div>
											<div class="col-lg-3">
												<br>
												<label class="btn btn-link" style="font-size: 16px;" ng-class="stateDisabled && 'link-disabled' || ''"><a href="${pageContext.request.contextPath}/forum/{{x.Name}}">- Forums</a></label>
												<br>
											</div>
											<div class="col-lg-6">
												<br>
												<label class="btn btn-link" style="font-size: 16px;" ng-class="stateDisabled && 'link-disabled' || ''"><a href="${pageContext.request.contextPath}/friend/{{x.Name}}">- Friends</a></label>
												<br>
											</div>
										</div>
										<div class="row">
											<div class="col-lg-6">
												<br>
												<label>Basic Info:</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label>{{x.BasicInfo}}</label>
												<br>
											</div>
										</div>
									</div>
									
								</div>
								
							</div>
							
						</div>
						<br>
						
					</td>
				</tr>
									  	
			</table>
			
		</div>
			
	</div>
	
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/references/js/resizebody.js"></script>
	
</body>
</html>