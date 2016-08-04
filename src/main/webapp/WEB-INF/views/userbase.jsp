<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<head>
	
	<c:import url="head-meta.jsp"></c:import>
	
	<style>
		.center
		{
		    margin: auto;
		    width: 80%;
		    border: 0px solid #73AD21;
		    
		}
		
		.center_img
		{
		    margin: auto;
		    width: 100%;
		    border: 0px solid #73AD21;
		    
		}
		
		.btn-responsive1
		{
		    white-space: normal !important;
		    word-wrap: break-word;
		}
		
		img
		{
		    display:block;
		    margin:auto;
		}
		
		//
		
		.animate-hide {
		 -webkit-transition:all cubic-bezier(0.250, 0.460, 0.450, 0.940) 2s;
		    -moz-transition:all cubic-bezier(0.250, 0.460, 0.450, 0.940) 2s;
		    -o-transition:all cubic-bezier(0.250, 0.460, 0.450, 0.940) 2s;
		    transition:all cubic-bezier(0.250, 0.460, 0.450, 0.940) 2s;
		  line-height:20px;
		  opacity:1;
		  padding:10px;
		  border:1px solid black;
		  background:white;
		}
		
		.animate-hide.ng-hide {
		  line-height:0;
		  opacity:0;
		  padding:0 10px;
		}
		
	</style>
	
</head>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/references/js/angular.min.js"></script>

<script type="text/javascript">
	var myApp = angular.module("myApp",["myAppChat"]);
	myApp.controller("myCtrl",function($scope ,$timeout){
		
		$scope.edit = true;
		
		$scope.count = 0;
		
		//$scope.data = data;
		$scope.data = ${dataValue};
		
		for( i = 0 ; i < $scope.data.length ; i++ )
		{
			$scope.data[i].Active = ( $scope.data[i].Active == "true" ) ? true : false;
			$scope.data[i].Delete = "false";			
		}
		
		console.log( $scope.data );
		
		$scope.countInit = function()
		{
			return $scope.count++;
		}
		
		$scope.showAll = function()
		{
			console.log(JSON.stringify( $scope.data ));
		}
		
		
		$scope.submitForUpdate = function()
		{	
			//alert('Bale');
			
			document.getElementById("sample").value = JSON.stringify($scope.data) ;
			
			console.log( JSON.stringify($scope.data) );
			
			$timeout(function()
			{	
				$("#ubh").submit();
			}, 200);
			//console.log(document.getElementById("sample").value);
			
		}
		
		$scope.roles = {
			    "1" : "User",
			    "2" : "Admin"
			};
		
	});
	
	
</script>

<c:import url="head.jsp"></c:import>

<body onload='resizing();onLoad()' ng-app="myApp" ng-controller='myCtrl'>
	
	<!--  -->
	
	<div class="body" id="body_div">
	
		<div class="container center" id="index_div_row">
	            
    
    <!--  -->
    
    <!--  -->
    <!--  -->
    
    <div class="container">
					<div class="row">
					<div class="col-lg-6 center">
					
					
					</div>
					</div>
					</div>
					
					<br><br>
					
					<!--  -->
	                <!--  -->
					
					
					
					<div class="container center" >
				
								<div style=" overflow-x: none; width: 100%; font-style: italic; font-weight: bold; font-size: 1.2vw; font-family: Segoe UI, Tahoma, sans-serif;" class="center">
									
									<div class="rTableHeading row">
									
										<div class="col-xs-12"><input type="text" id="search" value="" placeholder="Enter Search Keyword..." class="form-control" ng-model="searchKeyword.Username" ng-init="searchKeyword ='${searchKey}'" /></div>
										
										<div style="padding-top: 2%;padding-bottom: 2%;" class="col-xs-2">
										<br>
										<button type="button" class="btn btn-primary btn-responsive" ng-click="submitForUpdate();">Update</button>
										<br>
										<br>
										</div>
										
									
									</div>
									
									
									<div class="rTableHeading row">
									
										<div class="col-xs-3">Name</div>
										<div class="col-xs-3">Role</div>
										<div class="col-xs-3">Active</div>
										<div class="col-xs-3">Delete</div>
										
									
										<div style="width: 98%; height: 1px; background-color: #CCCCCC;" class="center"></div>
									
									</div>
				
									<form:form id="ubh" action="UpdateUsers" method="POST" modelAttribute="updateUsers">
										<form:input path="usersStatus" id="sample" type="hidden" value=""/>
									</form:form>
									
									<div ng-repeat="x in data | filter: searchKeyword" ng-init="number = countInit()" class="row" >
									
										
									
										<div style="padding-top: 2%;padding-bottom: 2%;" class="col-xs-3">{{ x.Username }}</div>
										
											
										<%--<form:input path="groupName" type="hidden" id="igname" value="{{ x.Group_Name }}"/> --%>
										
										<div style="padding-top: 2%;padding-bottom: 2%;" class="col-xs-3">
										<select ng-init="roles[x.Role]" ng-model="data[number].Role">
										    <option value='1'>User</option>
										    <option value='2'>Admin</option>
										    
										</select>
										
										</div>
										<%-- <form:input path="name" type="hidden" id="iname" value="{{ x.Name }}"/> --%>
										
										<%-- <form:input path="price" type="hidden" id="iprice" value="{{ x.Price }}"/>
										<form:input path="qty" type="hidden" id="iqty" value="{{ x.Qty }}"/>
										<form:input path="description" type="hidden" id="idescription" value="{{ x.Description }}"/> --%>
										
										<div style="padding-top: 2%;padding-bottom: 2%;" class="col-xs-3"><input type="checkbox" ng-model="x.Active"/></div>
										<%-- <form:input path="image" type="hidden" id="iimage" value="{{ x.Image }}"/> --%>
										
										<div style="padding-top: 2%;padding-bottom: 2%;" class="col-xs-3"> <div style="padding-top: 2%;padding-bottom: 2%;" class="col-xs-2"><input type="checkbox" ng-model="x.Delete"/></div> </div>
										<div style="width: 98%; height: 1px; background-color: #CCCCCC;" class="center"></div>
									
										
									
									</div>
					
									
									
								</div>
				
							
				
						</div>
				<!--  -->
	            
    <!--  -->
    <br><br>		
    				
    	<form:form id="viewdetails" action="ViewUser" method="POST" modelAttribute="viewUser">
					
					<form:input path="username" type="text" ng-show="false" ng-model="currItem.Username"/>
					   
		</form:form>
    				
		</div>
	</div>
    			
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/references/js/resizebody.js"></script>			
	<br><br>

</body>