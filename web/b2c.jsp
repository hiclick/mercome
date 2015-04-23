<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ include file="/WEB-INF/jsp/_import.jspf" %>

<%@ page import="com.mercome.activity.domain.B2c" %>
<%@ page import="com.mercome.activity.service.GenericService" %>
<%@ page import="com.mercome.activity.util.EnvUtils" %>

<%@ page import="java.util.List" %>

<%
	/* ... */
	GenericService genericService = EnvUtils.getEnv().getBean(GenericService.class);
	request.setAttribute("genericService", genericService);

	/* b2c */
	List<B2c> b2c_list = genericService.list(B2c.class, "");
	request.setAttribute("b2c_list", b2c_list);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<%@ include file="/_seo.jspf" %>

<link rel="stylesheet" type="text/css" href="<c:url value='/css/style.css' />" />

<script type="text/javascript">
var _nav_index = 2;
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
		<li><a href="<c:url value='/b2c.jsp' />" class="current">电商</a></li>
		<li><a href="<c:url value='/store.jsp' />">实体店</a></li>
	</ul>

	<div class="platform">
		<div class="breadcrumb"></div>
		<div class="b2c">
			<div class="tip">您可在下列电商平台选购苗蔻商品</div>
			<ul>
				<c:forEach var="item" items="${b2c_list}" varStatus="status">
					<li>
						<a href="${item.website}" title="${item.name}"><img src="<c:url value='' />${item.logo}" alt="" /></a>
					</li>
				</c:forEach>
			</ul>
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
