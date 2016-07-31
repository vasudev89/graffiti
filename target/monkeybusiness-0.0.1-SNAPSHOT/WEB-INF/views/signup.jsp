<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

	<div style="font: 28px/50px Calibri, sans-serif;" >

		<div class="container center">
		
			<div class="row">
				<div class="col-lg-12" style="font: small-caps 28px/50px Calibri, sans-serif; color: rgba(28,181,223,0.8); background-color: rgba(255,255,255,1.0); border-bottom: 1px solid rgb(128,0,0); text-align: left; padding-left: 15px; ">
					Sign-Up
				</div>
			</div>
			
			<div class="row">
			
				<div class="col-lg-12">
					
					<form:form action="InsertProfile" method="POST" modelAttribute="addProfile">
						<table class="table center login">
							
							<br>
							
							<c:if test="${success != null}">
								<tr>
									<td class="text-success error-font">${success}</td>							  		
								</tr>
							</c:if>
							
							<c:if test="${error != null}">
								<tr>
									<td class="text-danger error-font">${error}</td>							  		
								</tr>
							</c:if>
							
							<tr>
								<td><form:input path="email" type="email" class="form-control form-input" id="email" placeholder="Enter Email"/></td>
							</tr>
							<c:if test="${binderror != null}">
								<tr>
									<td class="text-danger error-font"><form:errors path="email"/></td>							  		
								</tr>
							</c:if>
							
							<tr>
								<td><form:input path="username" type="text" class="form-control form-input" id="username" placeholder="Enter Username" autofocus="autofocus"/></td>
							</tr>
							<c:if test="${binderror != null}">
								<tr>
									<td class="text-danger error-font"><form:errors path="username"/></td>							  		
								</tr>
							</c:if>
										  	
							<tr>
								<td><form:input path="password" type="password" class="form-control form-input" id="password" placeholder="Enter Password"/></td>								
							</tr>
							<c:if test="${binderror != null}">
								<tr>
									<td class="text-danger error-font"><form:errors path="password"/></td>							  		
								</tr>
							</c:if>
							
							<tr>
								<td><form:input path="cPassword" type="password" class="form-control form-input" id="cpassword" placeholder="Confirm Password"/></td>								
							</tr>
							
							<tr>
								<td><form:input path="phone" type="number" class="form-control form-input" id="phone" placeholder="Enter Phone No."/></td>
							</tr>
							<c:if test="${binderror != null}">
								<tr>
									<td class="text-danger error-font"><form:errors path="phone"/></td>							  		
								</tr>
							</c:if>
							
							<tr>
								<td>
								<form:select path="gender" class="form-control select-menu">
								  <option value="Male">Male</option>
								  <option value="Female">Female</option>								  
								</form:select>
								</td>
							</tr>
							
							<tr>
								<td><form:textarea style="resize: none;" path="location" class="form-control form-input" id="address" placeholder="Enter Location"></form:textarea></td>								
							</tr>
							<c:if test="${binderror != null}">
								<tr>
									<td class="text-danger error-font"><form:errors path="location"/></td>
								</tr>
							</c:if>
							
							<tr>
								<td><form:textarea style="resize: none;" path="basicInfo" class="form-control form-input" id="basicinfo" placeholder="About Yourself"></form:textarea></td>
							</tr>
							<c:if test="${binderror != null}">
								<tr>
									<td class="text-danger error-font"><form:errors path="basicInfo"/></td>
								</tr>
							</c:if>
							
							<tr>
								<td colspan="2" >
								<div class="row">
									<div class="col-md-2 col-md-offset-5"> <button type="submit" class="btn btn-success">Submit</button> </div>
								</div>
								</td>
							</tr>
										  	
						</table>
					</form:form>
				
				</div>
			
			</div>
		
		</div>
		
		</div>
	
	