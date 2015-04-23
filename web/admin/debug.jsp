<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ include file="/WEB-INF/jsp/_import.jspf" %>
<%@ include file="/admin/_auth.jspf" %>

<%@ page import="org.apache.commons.io.FileUtils" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>

<%@ page import="java.io.File" %>

<%

%>

<!--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">-->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>

<%@ include file="_script.jspf" %>

<script type="text/javascript">

</script>
</head>

<body style="padding: 10px;">

	<ol style="list-style: decimal-leading-zero inside;">
		<%
			String path = application.getRealPath("/") + "WEB-INF/log/";
			//System.out.println("path: " + path);

			String filename = request.getParameter("filename");

			if (StringUtils.isBlank(filename)) {
				for (File file : new File(path).listFiles()) {
		%>
		<li><a href="?filename=<%= file.getName() %>"><%= file.getName() %></a></li>
		<%
				}
			} else {
				for (String line : FileUtils.readLines(new File(path + filename))) {
		%>
			<li><%= line %></li>
		<%
				}
			}
		%>
	</ol>

</body>
</html>
