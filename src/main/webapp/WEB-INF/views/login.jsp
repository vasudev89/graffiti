<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

	<div style="font: 28px/50px Calibri, sans-serif;" >
		
		<div class="container center">
		
			<div class="row">
				<div class="col-lg-12" style="font: small-caps 28px/50px Calibri, sans-serif; color: rgba(28,181,223,0.8); background-color: rgba(255,255,255,1.0); border-bottom: 1px solid rgb(128,0,0); text-align: left; padding-left: 15px; ">
					Log-In
				</div>
			</div>
			
			<div class="row">
			
				<div class="col-lg-12">
				
					<c:url var="loginUrl" value="/login" />
					<form action="${loginUrl}" method="post">
				
					<table  class="table center login">
							
							<br>
							
							<!--  -->
					    	<c:if test="${param.loginerror != null}">
	                        	<tr>
									<td class="text-danger error-font">Invalid Username or Password</td>							  		
								</tr>									
	                        </c:if>
	                        <!--  -->
							
							<tr>
								<td><input name="username" path="username" type="text" class="form-control form-input" id="email" placeholder="Enter Email" autofocus="autofocus"/></td>							  		
							</tr>
										  	
							<tr>
								<td><input name="password" path="password" type="password" class="form-control form-input" id="password" placeholder="Enter Password"/></td>
							</tr>
							
							<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
							
							<tr>
								<td colspan="2" >
								<div class="row">
									<div class="col-md-2 col-md-offset-5"> <button type="submit" class="btn btn-primary">Go</button> </div>
								</div>
								</td>
							</tr>
										  	
						</table>
					</form>
				
				</div>
			
			</div>
		
		</div>
		
	</div>
	