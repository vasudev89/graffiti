<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

	<sec:authentication var="user" property="principal" />

<c:if test="${not empty pageContext.request.userPrincipal }">	
<%-- <script type="text/javascript" src="${pageContext.request.contextPath}/resources/references/js/angular.min.js"></script> --%>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/references/js/stomp.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/references/js/sockjs-0.3.4.min.js"></script>

<!--  -->
<script type="text/javascript">
	var myAppChat = angular.module("myAppChat",[]);
	
/////////////////////////////////////
	
	myAppChat.factory('myUserService', ['$http', '$q', function($http, $q){
		
    return {
    			GetAllFriends: function(item){
                    return $http.post('http://localhost:9002/monkeybusiness/GetAllFriends/', item)
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
			    GetCurrentUserImage: function(item){
			        return $http.post('http://localhost:9002/monkeybusiness/GetCurrentUserImage/', item)
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
	
	myAppChat.controller("myCtrl123",['$scope', 'myUserService' ,function($scope , $myUserService){
		
		$scope.currentUser = '${pageContext.request.userPrincipal.name}';
		//$scope.currentUser = 'vasudev89';
		
		$scope.currentUserImage;
		
		$scope.UpdatePageSize = function()
		{
			window.setTimeout(function()
			{
				document.getElementById("body_div").style.height = (document.getElementById("index_div_row").offsetHeight + 100) + 'px';
				$('#body_div').height( $('#body_div').height()<$(window).height()? $(window).height() : $('#body_div').height() );
			}, 200);
		};
		
		$scope.AllMyFriends;
		
		$scope.frequest = {currentUser : $scope.currentUser};
		
		//console.log("Sending Request");
		
		var resp = $myUserService.GetAllFriends($scope.frequest)
        .then(
        		function(response)
        		{
        			try
        			{
        				$scope.AllMyFriends = response.AllMyFriends;
        				
        				//console.log( $scope.AllMyFriends );
        				
	            		
        			}
        			catch(e)
        			{
        				$scope.AllMyFriends = [];
        			}
        			
        			//console.log("Friends:");
        			//console.log($scope.AllMyFriends);
        			
        			$scope.AllMyFriendsEmpty = ($scope.AllMyFriends.length == 0);
        		}
            , 
                function(errResponse)
                {
                	console.error('Error while getting Friends.');
                } 
    	);
		
		var resp1 = $myUserService.GetCurrentUserImage($scope.frequest)
        .then(
        		function(response)
        		{
        			try
        			{
        				$scope.currentUserImage = response.Image;
        				
        				//console.log( $scope.AllMyFriends );
        				
	            		
        			}
        			catch(e)
        			{
        				$scope.currentUserImage = "";
        			}
        			
        		}
            , 
                function(errResponse)
                {
                	console.error('Error while getting Current User Image.');
                } 
    	);
			
		//console.log( $scope.AllFriends );
		
		$scope.OpenChatWindow = function( User  )
		{
			for( i = 0 ; i < $scope.AllMyFriends.length ; i++ )
            {
            	if( $scope.AllMyFriends[i].Name == User )
            	{
            		$scope.AllMyFriends[i].ChatWindowOpen = !$scope.AllMyFriends[i].ChatWindowOpen;
            		
            		window.setTimeout(function(){
            			div = document.getElementById( $scope.AllMyFriends[i].Name );
                		div.scrollTop = div.scrollHeight;
                	}, 100);
            		
            		break;
            	}
            }
            
		}
		
		ws = new SockJS("/monkeybusiness/chat");
		
		stompClient = Stomp.over(ws);
		
		stompClient.connect({},function(frame)
		{
			stompClient.subscribe("/topic/chat",function(message)
			{
				console.log("Received:" + message.body);
				
				var json;
				
				try
				{
					json = JSON.parse(message.body);
				}
				catch(e)
				{
					json = null;
				}
				
				console.log("JSON: " + json)
				
				if( json != null && json.To == $scope.currentUser )
				{
					for( j = 0 ; j < $scope.AllMyFriends.length ; j++ )
		            {
		            	if( $scope.AllMyFriends[j].Name == json.From )
		            	{
		            		$scope.$apply( $scope.AllMyFriends[j].Messages.push( json ) );
		            		
		            		$scope.$apply( $scope.AllMyFriends[j].ReadStatus = "Unread");
		            		
		            		window.setTimeout(function(){
		            			div = document.getElementById( $scope.AllMyFriends[j].Name );
		                		div.scrollTop = div.scrollHeight;
		                	}, 100);
		            		
		            		break;
		            	}	
		            }
				}
				
			});
		},
		function(error)
		{
			console.log("STOMP protocol error:" + error);
		});
		
		$scope.HandleSend = function(User)
		{
			for( j = 0 ; j < $scope.AllMyFriends.length ; j++ )
            {
            	if( $scope.AllMyFriends[j].Name == User )
            	{
            		var data = {"From": $scope.currentUser, "To": User , "Message" : $scope.AllMyFriends[j].currentMessage , "status": "Unread"};
            		
            		$scope.AllMyFriends[j].Messages.push( data );
            		
            		$scope.AllMyFriends[j].currentMessage = "";

            		window.setTimeout(function(){
            			div = document.getElementById( $scope.AllMyFriends[j].Name );
                		div.scrollTop = div.scrollHeight;
                	}, 100);
            		
            		//console.log( $scope.AllMyFriends );
            	
            		console.log( "data" + data );
            		console.log( JSON.stringify(data) );
            		
            		stompClient.send('/app/chat',{}, JSON.stringify(data) );
            		
            		break;
            	}	
            }
		}
		
		$scope.HandleUnread = function(User)
		{
			console.log("Handle Unread");
			
			for( j = 0 ; j < $scope.AllMyFriends.length ; j++ )
            {
            	if( $scope.AllMyFriends[j].Name == User )
            	{
            		$scope.AllMyFriends[j].ReadStatus = "";
            		
            		var data = {"From": $scope.currentUser, "To": User };
            		
            		stompClient.send('/app/markUnread',{}, JSON.stringify(data) );
            		
            		break;
            	}	
            }
		}
		
	}]);
	
	angular.bootstrap( document.getElementById('chat') , ['myAppChat'] );
	
	
</script>
<!--  -->
</c:if>	
	
	<div class="Underline" id="HeaderDiv">
		<span class="Underline-Text">Graffitat&nbsp;&nbsp;&nbsp;</span>
	</div>
	
	<div id="navigation">
	
		<ul class="nav">
		<c:choose>
			
			<c:when test="${empty pageContext.request.userPrincipal }">
				
				<li><a class="navigation-element" href="${pageContext.request.contextPath}/index">Home</a></li>
				<li><a class="navigation-element" href="${pageContext.request.contextPath}/aboutus">About Us</a></li>
				
			</c:when>
			
			<c:otherwise>
				
				<li><a class="navigation-element" href="${pageContext.request.contextPath}/activities/${pageContext.request.userPrincipal.name}">${pageContext.request.userPrincipal.name}</a></li>
				<li><a class="navigation-element" href="${pageContext.request.contextPath}/profile/${pageContext.request.userPrincipal.name}">Profile</a></li>
				<li><a class="navigation-element" href="${pageContext.request.contextPath}/friends/${pageContext.request.userPrincipal.name}">Friends</a></li>
				<li><a class="navigation-element" href="${pageContext.request.contextPath}/blog/${pageContext.request.userPrincipal.name}">Blog</a></li>
				<li><a class="navigation-element" href="${pageContext.request.contextPath}/forum/${pageContext.request.userPrincipal.name}">Forum</a></li>
				<li><a class="navigation-element" href="${pageContext.request.contextPath}/gallery/${pageContext.request.userPrincipal.name}">Gallery</a></li>
				<li><a class="navigation-element" href="${pageContext.request.contextPath}/ulogout">Log Out</a></li>
				
			</c:otherwise>
			
		</c:choose>
		</ul>
	
	</div>
	
	<c:if test="${not empty pageContext.request.userPrincipal }">
		<div id="chat" ng-controller="myCtrl123">
			
			<button id="btn-chat-move"><</button>
			
			<div class="chat-header">Chats</div>
			
			<div class="container center" style="padding-left: 20px; margin: auto; width: 80%;">
			
				<br>
				<hr>
				<div class="row">
				
					<div class="col-lg-12">
						<input type="text" id="search" value="" placeholder="Search Friends..." class="form-control search-text" ng-model="searchChatKeyword.Name" ng-disabled="stateDisabled" />
					</div>
				
				</div>
				
				<div class="row" ng-repeat="x in AllMyFriends| filter: searchChatKeyword">
				
					<hr>
				
					<div class="container center" style="margin: auto; width: 100%;">
						<div class="row" style="background-color: rgba(255,255,255,0.95); font: 17px Calibri; font-variant: small-caps; font-style: oblique;">
							
						</div>
						<div class="row" style="background-color: rgba(255,255,255,0.95); font: 17px Calibri; font-variant: small-caps; font-style: oblique;">
					
							<br>
					
							<div class="row chat-unread-messages" ng-show="x.ReadStatus == 'Unread'">
								<span class="glyphicon glyphicon-envelope" style="color: rgb(128,0,0);"></span> &nbsp;&nbsp; Unread Messages
							</div>
					
							<br>
					
							<!--  -->
						
							<div class="col-lg-6">
								<img alt="{{x.Name}}" ng-src="${pageContext.request.contextPath}/{{x.Image}}" class="img-thumbnail" width="404"></img>
							</div>
							
							<div class="col-lg-6">
								<label>Name: <a href="${pageContext.request.contextPath}/profile/{{x.Name}}" ng-class="stateDisabled && 'link-disabled' || ''">{{x.Name}}</a></label>
								<button class="btn btn-success btn-sm" ng-click="OpenChatWindow(x.Name)">Chat</button>
								<br>
								<br>
							</div>
							
							<!--  -->
						
						</div>
						
						<div class="row" style="background-color: rgba(255,255,255,0.95); font: 17px Calibri; font-variant: small-caps; font-style: oblique;" ng-show="x.ChatWindowOpen">
					
							<!--  -->
							
							<div class="col-lg-12 form-control form-input blog-post-comment" style="height: 150px;overflow-y: scroll;" id="{{x.Name}}">
								<div>
									<span ng-repeat="z in x.Messages">
										<span ng-if="z.From == currentUser">
										<img alt="{{currentUser}}" ng-src="${pageContext.request.contextPath}/{{currentUserImage}}" class="img-thumbnail img-circle" width="60" style="position:absolute; right: 0px;"></img><br><br><br><br>
										<label class="form-control form-input blog-post-comment" style="text-align: right; width: 100%; font: 15px Calibri;font-variant: normal;font-style: oblique; font-weight: bold; line-height: 100%; background-color: #00CCCC; color: #FFFFFF;" ng-if="z.From == currentUser">{{z.Message}}</label>
										</span>
										
										<img alt="{{x.Name}}" ng-src="${pageContext.request.contextPath}/{{x.Image}}" class="img-thumbnail img-circle" width="60" ng-if="z.From != currentUser"></img>
										<label class="form-control form-input blog-post-comment" style="text-align: left; width: 100%; font: 15px Calibri;font-variant: normal;font-style: oblique; font-weight: bold; line-height: 100%; background-color: #FFFFFF; color: #00CCCC;" ng-if="z.From != currentUser">{{z.Message}}</label>
									</span>
								</div>
							</div>
								
							<!--  -->
						
						</div>
						
						<div class="row" style="background-color: rgba(255,255,255,0.8); font: 17px Calibri; font-variant: small-caps; font-style: oblique;" ng-show="x.ChatWindowOpen">
					
							<br>
					
							<!--  -->
							
							<div class="col-lg-12">
								<textarea rows="2" class="form-control form-input blog-post-comment" ng-model="x.currentMessage" ng-focus="HandleUnread(x.Name)"></textarea>
							</div>
								
							<!--  -->
						
						</div>
						
						<div class="row" style="background-color: rgba(255,255,255,0.8); font: 17px Calibri; font-variant: small-caps; font-style: oblique;" ng-show="x.ChatWindowOpen">
					
							<br>
					
							<!--  -->
							
							<div class="col-lg-12 center">
								<button class="btn btn-primary btn-sm" ng-click="HandleSend(x.Name)">Send</button>
								
							</div>
								
							
							<!--  -->
						
						</div>
						
						<div class="row" style="background-color: rgba(255,255,255,0.8); font: 17px Calibri; font-variant: small-caps; font-style: oblique;">
							<br>
						</div>
						
					</div>
					
				</div>
				
			</div>
			
		</div>
	</c:if>
	
	<footer class="container-fluid text-center footer">
		<p><b>&copy; Vasudev Vashisht</b></p>
	</footer>
	