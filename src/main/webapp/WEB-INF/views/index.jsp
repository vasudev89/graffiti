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

	<c:import url="head.jsp"></c:import>

	<div class="body" id="body_div">
	
		<div class="container center">
			<div id="index_div_row" class="row">
				
				<div class="col-lg-5">
					<br>
					<c:import url="login.jsp"></c:import>
					<br><br>
					<div><img src="resources/images/1.jpg" class="img-responsive"></img></div>
				</div>
		
				<div class="col-lg-2" style="text-align: center; font-family: Impact, fantasy; font-variant: small-caps; font-size: 24px; font-weight: normal;">
					<br><br>
					OR
				</div>
		
				<div class="col-lg-5">
					<br>
					<c:import url="signup.jsp"></c:import>
				</div>
			
			<br>
			
			</div>
		</div>
		
		<script type="text/javascript">
				
			document.getElementById("body_div").style.height = (document.getElementById("index_div_row").offsetHeight + 120) + 'px';
				
			window.addEventListener('resize', function()
			{
				document.getElementById("body_div").style.height = (document.getElementById("index_div_row").offsetHeight + 120) + 'px';
			}, false);
				
		</script>
			
	
	</div>
	
</body>
</html>