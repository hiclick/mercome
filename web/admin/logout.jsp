<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%
	session.removeAttribute("_admin_id");

	//String returnUrl = request.getParameter("return");

	response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
%>
