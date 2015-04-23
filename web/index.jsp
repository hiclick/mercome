<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ include file="/WEB-INF/jsp/_import.jspf" %>

<%@ page import="com.mercome.activity.domain.ProductCategory" %>
<%@ page import="com.mercome.activity.service.GenericService" %>
<%@ page import="com.mercome.activity.util.EnvUtils" %>

<%@ page import="java.util.List" %>

<%
	/* ... */
	GenericService genericService = EnvUtils.getEnv().getBean(GenericService.class);
	request.setAttribute("genericService", genericService);

	/* productcategory */
	List<ProductCategory> productCategory_list = genericService.list(ProductCategory.class, "");
	request.setAttribute("productCategory_list", productCategory_list);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<%@ include file="/_seo.jspf" %>

<link rel="stylesheet" type="text/css" href="<c:url value='/css/style.css' />" />

<script type="text/javascript">
var _nav_index = 0;
</script>
</head>

<body>
<div id="main">
<div id="container">

<%@ include file="/_header.jspf" %>
<%@ include file="/_navbar.jspf" %>

<div class="banner">
	<ul class="slider" style="height: 500px;">
		<li style="background-image: url(images/1920x500-1.jpg);"></li>
		<li style="background-image: url(images/1920x500-2.jpg);"></li>
		<li style="background-image: url(images/1920x500-3.jpg);"></li>
	</ul>
	<a href="#" class="arrows-prev"></a>
	<a href="#" class="arrows-next"></a>
</div>

<div id="content">
	<div class="category">
		<div class="slider">
			<ul>
				<c:forEach var="item" items="${productCategory_list}" varStatus="status">
					<li><a href="<c:url value='/product-list.jsp' />?productCategoryId=${item.productCategoryId}" title="${item.name}"><img src="<c:url value='' />${item.pic}" alt="" /></a></li>
				</c:forEach>
			</ul>
		</div>
		<a href="#" class="arrows-prev"></a>
		<a href="#" class="arrows-next"></a>
	</div>
</div>

<%@ include file="/_footer.jspf" %>

</div>
</div>

<%@ include file="/_script.jspf" %>

<script type="text/javascript">
$(function() {

	$(".banner").mouseenter(function() {
		$("[class^='arrows-']", this).fadeIn();
	}).mouseleave(function() {
		$("[class^='arrows-']", this).fadeOut();
	}).find(".slider").cycle({
		prev: ".banner .arrows-prev",
		next: '.banner .arrows-next',
		//speed: 1000,
		timeout: 3000
	});

	$(".category").mouseenter(function() {
		$("[class^='arrows-']", this).fadeIn();
	}).mouseleave(function() {
		$("[class^='arrows-']", this).fadeOut();
	}).find(".slider").jCarouselLite({
		auto: 3000,
		btnPrev: ".category .arrows-prev",
		btnNext: ".category .arrows-next",
		speed: 800,
		visible: 3
	});

});
</script>
</body>
</html>
