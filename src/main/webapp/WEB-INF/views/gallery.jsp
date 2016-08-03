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
    			GetUserGallery: function(item){
                    return $http.post('http://localhost:9002/monkeybusiness/GetUserGallery/', item)
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
				DeleteFromGallery: function(item){
            		return $http.post('http://localhost:9002/monkeybusiness/DeleteFromGallery/', item)
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

///////////////////////////////////////

	myApp.service('fileUpload', ['$http', function ($http) {
	    this.uploadFileToUrl = function(file, paramuser, uploadUrl){
	        var fd = new FormData();
	        fd.append('file', file);
	        //fd.append('user','vasudev89');
	        return $http.post(uploadUrl, fd, {
	            transformRequest: angular.identity,
	            headers: {'Content-Type': undefined , user: paramuser}
	        })
	        .then(
                    function(response){
                        return response.data;
                    }, 
                    function(errResponse){
                        console.error('Error while updating User');
                        return "error";
                    }
            );
	    }
	}]);
	
///////////////////////////////////////

//////////////////////////////////////////////////	
	
	myApp.controller("myCtrl",['$scope', 'UserService', 'fileUpload' ,function($scope , $UserService , $fileUpload){
		
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
							Gallery:
								[
				               		
				              	]
						};
		</c:if>
		
		<c:if test="${ not empty dataValue}">
			
			try
			{
				//$scope.data = JSON.parse('${dataValue}');
				
				//$scope.data.Username = "${userName}";
				
				$scope.data = {
				
				"Username":"${userName}",
				"Gallery": JSON.parse('${dataValue}')
					};
			}
			catch(e)
			{
				$scope.data =
				{
					Username:"${userName}",
					Gallery:
						[
		               		
		              	]
				};
			}
			
						
		</c:if>		

		console.log($scope.data);
		
		console.log( $scope.currentUser == $scope.data.Username )
		
		$scope.invalidPicType = false;
		
		$scope.img_counter = 0;;
		
		$scope.invalidFiles = false;
		
		$scope.filesUrls = [];
		
		for( i = 0 ; i < $scope.data.Gallery.length ; i++ )
		{
			var json = { "ImageUrl" : $scope.data.Gallery[i] , "del" : false };
			
			$scope.data.Gallery[i] = json;
		}
		
		$scope.SelectAll = function()
		{
			for( i = 0 ; i < $scope.data.Gallery.length ; i++ )
			{
				$scope.data.Gallery[i].del = true;
			}
		}
		
		$scope.UnselectAll = function()
		{
			for( i = 0 ; i < $scope.data.Gallery.length ; i++ )
			{
				$scope.data.Gallery[i].del = false;
			}
		}
		
		$scope.GalleryForDelete = [];
		
		$scope.Delete = function()
		{
			$scope.GalleryForDelete = "";
			
			for( i = 0 ; i < $scope.data.Gallery.length ; i++ )
			{
				if( $scope.data.Gallery[i].del == true )
				{
					$scope.GalleryForDelete += ";" + $scope.data.Gallery[i].ImageUrl ;
				}
			}
			
			console.log( $scope.GalleryForDelete );
			
			$scope.frequest = { "currentUser" : $scope.currentUser , "GalleryForDelete" : $scope.GalleryForDelete };
			
			var resp = $UserService.DeleteFromGallery($scope.frequest)
            .then(
            		function(response)
            		{
            			try
            			{
            				//$scope.data = JSON.parse('${dataValue}');
            				
            				//$scope.data.Username = "${userName}";
            				
            				//console.log( JSON.parse(response) );
            				
            				$scope.data = response;
            				
            				for( i = 0 ; i < $scope.data.Gallery.length ; i++ )
            				{
            					var json = { "ImageUrl" : $scope.data.Gallery[i] , "del" : false };
            					
            					$scope.data.Gallery[i] = json;
            				}
            				
            				$scope.UpdatePageSize();
            			}
            			catch(e)
            			{
            				$scope.data =
            				{
            					Username:"${userName}",
            					Gallery:
            						[
            		               		
            		              	]
            				};
            			}
            		}
	            , 
	                function(errResponse)
	                {
	                	console.error('Error while Updating User.');
	                } 
        	);
			
			$scope.UpdatePageSize();
		}
		
		$scope.getFileDetails = function (e) {

            $scope.$apply(function () {

            	$scope.files = [];
            	$scope.filesUrls = [];
            	$scope.img_counter = 0;
            	
            	$scope.invalidFiles = false;
            	
                // STORE THE FILE OBJECT IN AN ARRAY.
                for (var i = 0; i < e.files.length; i++) {
                    $scope.files.push(e.files[i])
                    
                    var reader = new FileReader();
                    
                    reader.onload = function(event)
        			{
                    	//console.log( event.target);
                    	
                    	window.setTimeout(function(){
                    	
                    		if( event.target.result.indexOf("image/jpeg") != -1 )
        	                	$scope.$apply( $scope.filesUrls.push({"ImageUrl": event.target.result }) );
                    		else
                    			$scope.$apply( $scope.invalidFiles = true );
                    		
                    		$scope.UpdatePageSize();
                    		
                    	},100);
                    	
        	  		};
        	  		
        	  		reader.readAsDataURL(e.files[i]);
                }
                
                window.setTimeout(function(){
                
                	counter = 0;
                	
                	for (var i = 0; i < e.files.length; i++) {
                		var extension = e.files[i].name.substring(e.files[i].name.lastIndexOf('.'));
                		
                		extension = extension.substring(1,extension.length);
                		
                		if(extension == "jpg")
                		{
                			$scope.$apply( $scope.filesUrls[counter].Name = String(extension) );
                			$scope.$apply( $scope.filesUrls[counter++].File = e.files[i] );
                		}	
                    }
                	
                	console.log($scope.filesUrls);
                	
                },200);
                
                console.log( $scope.filesUrls );

            });
            
        };
        
     	// NOW UPLOAD THE FILES.
        $scope.uploadFiles = function () {
        	$('#file').trigger('click');
     	}
     	
        $scope.startUpload = function () {
        	
        	$scope.progressObj.SwitchFlag(true);
			$scope.stateDisabled = true;
        	
        	var data = new FormData();

        	$scope.filedata = [];
        	
        	for (var i = 0; i < $scope.filesUrls.length; i++) {
        		$scope.filedata.push( $scope.filesUrls[i].File );
        	}
        	
            for (var i in $scope.filedata) {
                data.append("uploadedFile", $scope.filedata[i]);
            }

            // ADD LISTENERS.
            var objXhr = new XMLHttpRequest();
            
            objXhr.addEventListener("progress", updateProgress, false);
            
            // SEND FILE DETAILS TO THE API.
            
            var uploadUrl = "http://localhost:9002/monkeybusiness/updateGallery/";
            
            objXhr.open("POST", uploadUrl);
            
            
            objXhr.setRequestHeader("user", $scope.data.Username );
            
            objXhr.send(data);
            
        }
        
     	// UPDATE PROGRESS BAR.
        function updateProgress(e) {
     		
     		console.log( e );
     		
     		$scope.$apply( $scope.progressObj.SwitchFlag(false) );
     		$scope.$apply( $scope.stateDisabled = false ) ;
			
     		$scope.$apply( $scope.filesUrls = [] );
     		
     		$scope.$apply( $scope.updated = true );
     		
     		$scope.UpdatePageSize();
     		
     		window.setTimeout(function()
     		{
     			$scope.$apply( $scope.updated = false );
     		
     			$scope.UpdatePageSize();
     			
     		},5000);
     		
     		//
     		
			$scope.frequest = { "currentUser" : $scope.currentUser };
			
			var resp = $UserService.GetUserGallery($scope.frequest)
            .then(
            		function(response)
            		{
            			try
            			{
            				//$scope.data = JSON.parse('${dataValue}');
            				
            				//$scope.data.Username = "${userName}";
            				
            				//console.log( JSON.parse(response) );
            				
            				$scope.data = response;
            				
            				for( i = 0 ; i < $scope.data.Gallery.length ; i++ )
            				{
            					var json = { "ImageUrl" : $scope.data.Gallery[i] , "del" : false };
            					
            					$scope.data.Gallery[i] = json;
            				}
            				
            				$scope.UpdatePageSize();
            			}
            			catch(e)
            			{
            				$scope.data =
            				{
            					Username:"${userName}",
            					Gallery:
            						[
            		               		
            		              	]
            				};
            			}
	    				
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
			
			<c:if test="${empty invalidUser}">
			<!--  -->
				
				<br>
				
				<div class="row" ng-show="(currentUser == data.Username)">
					<div class="col-lg-12" style="font: small-caps 28px/50px Calibri, sans-serif; color: rgba(28,181,223,0.8); background-color: rgba(255,255,255,1.0); border-bottom: 1px solid rgb(128,0,0); text-align: left; padding-left: 15px; ">
						My Gallery
					</div>
				</div>
				
				<div class="row" ng-show="!(currentUser == data.Username)">
					<div class="col-lg-12" style="font: small-caps 28px/50px Calibri, sans-serif; color: rgba(28,181,223,0.8); background-color: rgba(255,255,255,1.0); border-bottom: 1px solid rgb(128,0,0); text-align: left; padding-left: 15px; ">
						Gallery : {{data.Username}}
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
								<input type="file" id="file" name="file" multiple
						            onchange="angular.element(this).scope().getFileDetails(this)" ng-show="false" />
						
								<br>
						
						        <input type="button" ng-click="uploadFiles()" value="Choose File(s)" class="btn btn-danger" ng-disabled="stateDisabled" />
						
								<br>
								<br>
								
							</td>
							
						</tr>
						
						<tr ng-show="currentUser == data.Username">
							
							<td colspan="2" >
								
								<div style="margin: auto; width: 85%;">
								
								<br>
								<input type="button" ng-click="startUpload()" value="Upload" class="btn btn-link" ng-disabled="stateDisabled" ng-show="!(filesUrls.length == 0)" />
								<br>
								
								<span ng-repeat="x in filesUrls track by $index" style="margin: auto; width: 85%;">
								  	
								  	<img src="{{x.ImageUrl}}" class="img img-thumbnail img-responsive" width="20%" height="20%" style="margin: 5px;" ng-if="x.Name == 'jpg'"></img>
									
								</span>
								
								</div>
							</td>
							
						</tr>
						
						<tr ng-show="invalidFiles">
							
							<td colspan="2">
								
								<div class="alert alert-danger" style="text-align: center;">
				
									<label>Some files were invalid. Possible Cause: Only JPEG files supported</label>
									
								</div>
								
							</td>
							
						</tr>
						
						<tr ng-show="data.Gallery.length == 0">
							
							<td colspan="2">
								
								<div class="blog-posts-nopost" style="text-align: center;">
				
									<label>Gallery Empty.</label>
									
								</div>
								
							</td>
							
						</tr>
						
						<tr ng-show="data.Gallery.length != 0">
							
							<td colspan="2" >
								
								<div class="row" ng-show="(data.Gallery.length != 0)">
									<div class="col-lg-12" style="font: small-caps 28px/50px Calibri, sans-serif; color: rgba(28,181,223,0.8); background-color: rgba(255,255,255,1.0); border-bottom: 1px solid rgb(128,0,0); text-align: left; padding-left: 15px; ">
										Gallery:
									</div>
								</div>
								
								<br>
								
								<div style="margin: auto; width: 85%;">
								
									<div ng-show="(currentUser == data.Username)" >
										<input type="button" ng-click="SelectAll()" value="Select All" class="btn btn-primary" ng-disabled="stateDisabled" />
									  	&nbsp;&nbsp;&nbsp;
									  	<input type="button" ng-click="UnselectAll()" value="Unselect All" class="btn btn-success" ng-disabled="stateDisabled"  />
									  	&nbsp;&nbsp;&nbsp;
									  	<input type="button" ng-click="Delete()" value="Delete" class="btn btn-danger" ng-disabled="stateDisabled" />
									  	<br>
									  	<br>
									</div>
								
								<span ng-repeat="y in data.Gallery track by $index" style="margin: auto; width: 85%;">
								  	
								  	<img src="${pageContext.request.contextPath}/{{y.ImageUrl}}" class="img img-thumbnail img-responsive" width="220px" style="margin: 5px;"></img>
									<input type="checkbox" value="" ng-model="y.del" ng-show="(currentUser == data.Username)" />
									
								</span>
								
								</div>
								
							</td>
							
						</tr>
						
					</table>
				
					<!--  -->
				
				</div>
			
		</div>
		<!--  -->
		</c:if>
		
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/references/js/resizebody.js"></script>
	</div>
	</div>
</body>
</html>