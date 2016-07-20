<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

	<sec:authentication var="user" property="principal" />
	
	<div class="Underline" id="HeaderDiv">
		<span class="Underline-Text">Graffiti&nbsp;&nbsp;&nbsp;</span>
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
				<li><a class="navigation-element" href="${pageContext.request.contextPath}/ulogout">Log Out</a></li>
				
			</c:otherwise>
			
		</c:choose>
		</ul>
	
	</div>
	
	<footer class="container-fluid text-center footer">
		<p><b>&copy; Vasudev Vashisht</b></p>
	</footer>
	