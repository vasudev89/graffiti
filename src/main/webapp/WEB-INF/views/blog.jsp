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

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/references/js/angular.min.js"></script>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/references/js/ProgressObject.js"></script>

<script type="text/javascript">
	var myApp = angular.module("myApp",["myAppChat"]);
	
/////////////////////////////////////
	
	myApp.factory('UserService', ['$http', '$q', function($http, $q){
	 
    return {
         		updateUserBlog: function(item){
                    return $http.post('http://localhost:9002/monkeybusiness/updateUserBlog/', item)
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
		
		<c:if test="${ empty dataValue}">
			$scope.data =
						{
							Username:"${userName}",
							Blogs:
								[
				               		
				              	]
						};
		</c:if>
		
		<c:if test="${ not empty dataValue}">
			$scope.data = JSON.parse('${dataValue}');
			
			console.log($scope.data);
			
			$scope.RefurbishLikes = function(input)
			{
				for( i = 0 ; i < $scope.data.Blogs.length ; i++ )
				{
					/* console.log($scope.data.Blogs[i].Likes);
					console.log($scope.data.Blogs[i].Likes.indexOf(input));
					console.log(input);
					
					console.log($scope.data.Blogs[i].LikeStatus);
					 */
					$scope.data.Blogs[i].LikeStatus = ( $scope.data.Blogs[i].Likes.indexOf(input) == -1 )? true:false;
					
					/* console.log($scope.data.Blogs[i].LikeStatus); */
				}
			}
			
			$scope.RefurbishLikes( $scope.currentUser );
			
			/* console.log($scope.data); */
			
		</c:if>		

		console.log( $scope.currentUser == $scope.data.Username )
		
		$scope.GenerateLikeList = function(input)
		{
			retval = "";
			for( i = 0 ; i < input.length; i++ )
				retval += input[i] + " , ";
			
			if( retval.length > 0 )
				retval = retval.substring(0,retval.length-3);
			else
				retval = "No likes so far.";
					
			return retval;
		}
		
		$scope.postText = "";
		//$scope.postComment = "";
		
		$scope.AddPost = function()
		{
			//console.log( $scope.postText );
			
			//console.log( $scope.data.Blogs.length );
			
			blogItem = 
						{
		        	   		PostID:$scope.data.Blogs.length + 1,
		        	   		Post: $scope.postText,
		        	   		show: true,
		        	   		editStatus: true,
		        	   		Likes: [],
		        	   		LikeStatus: true,
		        	   		Comments : []
		           		};
			
			$scope.data.Blogs.unshift(blogItem);
			
			$scope.sendBlogUpdate();
			
			$scope.UpdatePageSize();			
		}
		
		$scope.EditPost = function(input)
		{
			//console.log( $scope.postText );
			
			//console.log( $scope.data.Blogs.length );
			
			for( i = 0 ; i < $scope.data.Blogs.length ; i++ )
			{
				if( $scope.data.Blogs[i].PostID == input )
				{
					$scope.data.Blogs[i].show = !$scope.data.Blogs[i].show;
					$scope.data.Blogs[i].editStatus = !$scope.data.Blogs[i].editStatus;
					
					if( $scope.data.Blogs[i].editStatus == true )
						$scope.sendBlogUpdate();
				}
			}
			
			$scope.UpdatePageSize();			
		}
		
		$scope.postComment = '';
		
		$scope.AddComment = function(input,comment)
		{
			for( i = 0 ; i < $scope.data.Blogs.length ; i++ )
			{
				if( $scope.data.Blogs[i].PostID == input )
				{
					item = {Index: $scope.data.Blogs[i].Comments.length + 1 ,By: $scope.currentUser, Comment: comment, show: true , editStatus: true };
					
					$scope.data.Blogs[i].Comments.push( item );
				}
			}
			
			$scope.sendBlogUpdate();
			$scope.UpdatePageSize();
		}
		
		$scope.DeleteComment = function(input,Index)
		{
			mark_i = -1;
			mark_j = -1;
			
			l: for( i = 0 ; i < $scope.data.Blogs.length ; i++ )
			{
				if( $scope.data.Blogs[i].PostID == input )
				{
					for( j = 0 ; j < $scope.data.Blogs[i].Comments.length ; j++ )
					{
						if( $scope.data.Blogs[i].Comments[j].Index == Index )
						{
							mark_i = i;
							mark_j = j;
							
							break l;
						}
					}
				}
			}
			
			if( mark_i != -1 && mark_j != -1 )
			{
				$scope.data.Blogs[mark_i].Comments.splice( mark_j , 1 );
				
				$scope.sendBlogUpdate();
			}
			
			$scope.UpdatePageSize();
		}
		
		$scope.EditComment = function(input,Index)
		{
			mark_i = -1;
			mark_j = -1;
			
			l: for( i = 0 ; i < $scope.data.Blogs.length ; i++ )
			{
				if( $scope.data.Blogs[i].PostID == input )
				{
					for( j = 0 ; j < $scope.data.Blogs[i].Comments.length ; j++ )
					{
						if( $scope.data.Blogs[i].Comments[j].Index == Index )
						{
							mark_i = i;
							mark_j = j;
							
							break l;
						}
					}
				}
			}
			
			console.log( mark_i );
			
			if( mark_i != -1 && mark_j != -1 )
			{
				$scope.data.Blogs[mark_i].Comments[mark_j].show = !$scope.data.Blogs[mark_i].Comments[mark_j].show;
				$scope.data.Blogs[mark_i].Comments[mark_j].editStatus = !$scope.data.Blogs[mark_i].Comments[mark_j].editStatus;
				$scope.sendBlogUpdate();
			}
			
			$scope.UpdatePageSize();
		}
		
		$scope.DeletePost = function(input)
		{
			mark_i = -1;
			
			l: for( i = 0 ; i < $scope.data.Blogs.length ; i++ )
			{
				if( $scope.data.Blogs[i].PostID == input )
				{
					mark_i = i;
					break l;					
				}
			}
			
			if( mark_i != -1 )
			{
				$scope.data.Blogs.splice( mark_i , 1 );
				$scope.sendBlogUpdate();
			}
			
			$scope.UpdatePageSize();
		}
		
		$scope.AddLike = function(input)
		{
			for( i = 0 ; i < $scope.data.Blogs.length ; i++ )
			{
				if( $scope.data.Blogs[i].PostID == input )
				{
					if($scope.data.Blogs[i].LikeStatus == true)
					{
						if( $scope.data.Blogs[i].Likes.indexOf($scope.currentUser) == -1 )
						{
							$scope.data.Blogs[i].Likes.push( $scope.currentUser );
							$scope.data.Blogs[i].LikeStatus = ! $scope.data.Blogs[i].LikeStatus;
						}
					}
					else
					{
						$scope.data.Blogs[i].Likes.splice( $scope.data.Blogs[i].Likes.indexOf($scope.currentUser) , 1 );
						$scope.data.Blogs[i].LikeStatus = ! $scope.data.Blogs[i].LikeStatus;
					}					
				}
			}
			
			//$scope.GenerateLikes();
			$scope.sendBlogUpdate();
			$scope.UpdatePageSize();
		}
		
		$scope.sendBlogUpdate = function()
		{
			$scope.progressObj.SwitchFlag(true);
			$scope.stateDisabled = true;
			
			var resp = $UserService.updateUserBlog($scope.data)
            .then(
            		function(response)
            		{
            			$scope.response = response.status;
            			
            			if( $scope.response == "Updated" )
            			{
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
	}]);
	
	
</script>

<!--  -->

<c:import url="head.jsp"></c:import>

<body onload='resizing();onLoad()' ng-app="myApp" ng-controller='myCtrl'>

	

	<div class="body" id="body_div">
	
			<div class="container center" id="index_div_row">
				
				<br>
				
				<div class="row" ng-show="(currentUser == data.Username)">
					<div class="col-lg-12" style="font: small-caps 28px/50px Calibri, sans-serif; color: rgba(28,181,223,0.8); background-color: rgba(255,255,255,1.0); border-bottom: 1px solid rgb(128,0,0); text-align: left; padding-left: 15px; ">
						My Blogs
					</div>
				</div>
				
				<div class="row" ng-show="!(currentUser == data.Username)">
					<div class="col-lg-12" style="font: small-caps 28px/50px Calibri, sans-serif; color: rgba(28,181,223,0.8); background-color: rgba(255,255,255,1.0); border-bottom: 1px solid rgb(128,0,0); text-align: left; padding-left: 15px; ">
						Blogs : {{data.Username}}
					</div>
				</div>
				
				<div class="row">
			
				<div class="col-lg-12">
				
					<!--  -->
				
					<br>
				
					<table class="table center myprofile">
						
						<tr ng-show="updated">
						
							<td colspan="2">
								
									<span class="text-success bg-success error-font" >Updated Successfully</span>
								
							</td>
							
						</tr>
						
						<tr ng-show="currentUser == data.Username">
							
							<td colspan="2">
								
									<br>
										<textarea rows="5" class="form-control form-input" placeholder="Write a new Post..." ng-model="postText" ng-disabled="stateDisabled"></textarea>
									<br>
										<button type="button" class="btn btn-primary" style="color: #FFFFFF;" ng-click="AddPost()" ng-disabled="(postText=='') || stateDisabled"><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;&nbsp;Post&nbsp;&nbsp;&nbsp;</button>
									<br>
								<br>
							</td>
							
						</tr>
						
						<tr ng-show="data.Blogs.length == 0">
							
							<td colspan="2">
								
								<div class="blog-posts-nopost" style="text-align: center;">
				
									<label>No Blogs Posted yet.</label>
									
								</div>
								
							</td>
							
						</tr>
						
					</table>
				
					<!--  -->
				
				</div>
			
				
				<div class="row" ng-repeat="x in data.Blogs">
					<div class="col-lg-12">
						<div class="blog-posts center">
							
							<label>{{data.Username}} wrote:</label>
							<hr>
							<div class="blog-post-handle" style="box-shadow: 0px 0px 1px #999999;" ng-show="x.show">{{x.Post}}</div>
							<textarea rows="5" class="form-control form-input blog-post-comment" placeholder="Write something..." ng-model="x.Post" ng-show="!x.show" ng-disabled="stateDisabled"></textarea>
							<br>
							<button type="button" class="btn btn-success" ng-show="data.Username == currentUser" ng-click="EditPost(x.PostID)" ng-disabled="stateDisabled" ><span class="glyphicon glyphicon-edit"></span>&nbsp;&nbsp;&nbsp;<span ng-show="x.editStatus">Edit Post</span><span ng-show="!x.editStatus">Done</span>&nbsp;&nbsp;&nbsp;</button>
							&nbsp;&nbsp;
							<button type="button" class="btn btn-danger" ng-show="data.Username == currentUser" ng-click="DeletePost(x.PostID)" ng-disabled="stateDisabled" ><span class="glyphicon glyphicon-remove"></span>&nbsp;&nbsp;&nbsp;Delete Post&nbsp;&nbsp;&nbsp;</button>
							<br>
							
							<hr>
							<button type="button" class="btn btn-default" ng-click="AddLike(x.PostID)" ng-disabled="stateDisabled"><span class="glyphicon glyphicon-plus" ng-show="x.LikeStatus" ></span><span class="glyphicon glyphicon-minus" ng-show="!x.LikeStatus"></span>&nbsp;&nbsp;&nbsp;My Like&nbsp;&nbsp;&nbsp;</button>
							
							&nbsp;&nbsp;
							<label>Total Likes: {{x.Likes.length}}</label>
							
							<hr>
							<label>Current Likes:</label>
							<br>
							<br>
							<span class="blog-post-other">{{GenerateLikeList(x.Likes)}}</span>
							<hr>
							<label>Comments:</label>
							<hr>
							
							<div class="blog-post-other" ng-show="x.Comments.length == 0">No Comments so far.</div>
							
							<div ng-repeat="y in x.Comments track by $index">
								<label>{{y.By}} :</label>
								<br>
								<br>
								<div class="blog-post-other" ng-show="y.show" >{{y.Comment}}</div>
								<textarea rows="5" class="form-control form-input blog-post-comment" placeholder="Write a comment..." ng-model="y.Comment" ng-show="!y.show" ng-disabled="stateDisabled"></textarea>
								<br>
								<button type="button" class="btn btn-link" ng-show="y.By == currentUser" ng-click="DeleteComment(x.PostID , y.Index)" ng-disabled="stateDisabled" >Delete Comment</button>
								&nbsp;&nbsp;&nbsp;
								<button type="button" class="btn btn-link" ng-show="y.By == currentUser" ng-click="EditComment(x.PostID , y.Index)" ng-disabled="stateDisabled" ><span ng-show="y.editStatus">Edit Comment</span><span ng-show="!y.editStatus">Done</span></button>
								<hr>
							</div>
							
							<hr>
							
							<textarea rows="5" class="form-control form-input blog-post-comment" placeholder="Write a comment..." ng-model="postComment" ng-disabled="stateDisabled" ></textarea>
							<br>
							<button type="button" class="btn btn-primary" style="color: #FFFFFF;" ng-click="AddComment(x.PostID,postComment)" ng-disabled="stateDisabled" ><span class="glyphicon glyphicon-asterisk"></span>&nbsp;&nbsp;&nbsp;Comment&nbsp;&nbsp;&nbsp;</button>
						<div>
					</div>
				</div>
			
			<br>
			</div>
			
			
			
		</div>
		
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/references/js/resizebody.js"></script>
			
	
		</div>
	</div>
	</div>
</body>
</html>