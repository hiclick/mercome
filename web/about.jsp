<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ include file="/WEB-INF/jsp/_import.jspf" %>

<%

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<%@ include file="/_seo.jspf" %>

<link rel="stylesheet" type="text/css" href="<c:url value='/css/style.css' />" />

<script type="text/javascript">
var _nav_index = 5;
</script>
</head>

<body>
<div id="main">
<div id="container">

<%@ include file="/_header.jspf" %>
<%@ include file="/_navbar.jspf" %>

<div class="banner">
	<ul>
		<li style="background-image: url(images/1920x370-1.jpg);"></li>
	</ul>
</div>

<div id="content">
	<ul class="menu">
		<li><a href="<c:url value='/about.jsp' />" class="current">品牌介绍</a></li>
	</ul>

	<div class="platform">
		<div class="breadcrumb"></div>
		<div class="about">
			<!-- 自定义 -->
		</div>
	</div>
</div>

<%@ include file="/_footer.jspf" %>

</div>
</div>

<%@ include file="/_script.jspf" %>



<script type="text/javascript">

</script>
</body>
</html>
