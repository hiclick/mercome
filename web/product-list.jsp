<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ include file="/WEB-INF/jsp/_import.jspf" %>

<%@ page import="com.mercome.activity.domain.Pager" %>
<%@ page import="com.mercome.activity.domain.Product" %>
<%@ page import="com.mercome.activity.domain.ProductCategory" %>
<%@ page import="com.mercome.activity.service.GenericService" %>
<%@ page import="com.mercome.activity.util.EnvUtils" %>

<%@ page import="org.apache.commons.lang.math.NumberUtils" %>

<%@ page import="java.util.List" %>

<%
	/* ... */
	GenericService genericService = EnvUtils.getEnv().getBean(GenericService.class);
	request.setAttribute("genericService", genericService);

	/* productcategory */
	List<ProductCategory> productCategory_list = genericService.list(ProductCategory.class, "");
	request.setAttribute("productCategory_list", productCategory_list);

	ProductCategory productCategory = genericService.find(ProductCategory.class, Long.parseLong(request.getParameter("productCategoryId")));
	request.setAttribute("productCategory", productCategory);

	/* product */
	Pager<Product> product_pager = genericService.pager(
		Product.class,
		"WHERE productcategoryid = ? ORDER BY createdate DESC",
		NumberUtils.toInt(request.getParameter("pageNo"), 1),
		6,
		request.getParameter("productCategoryId")
	);
	request.setAttribute("product_pager", product_pager);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<%@ include file="/_seo.jspf" %>

<link rel="stylesheet" type="text/css" href="<c:url value='/css/style.css' />" />

<script type="text/javascript">
var _nav_index = 1;
</script>
</head>

<body>
<div id="main">
<div id="container">

<%@ include file="/_header.jspf" %>
<%@ include file="/_navbar.jspf" %>

<div class="banner">
	<ul>
		<li style="background-image: url(<c:url value='' />${productCategory.banner});"></li>
	</ul>
</div>

<div id="content">
	<ul class="menu">
		<c:forEach var="item" items="${productCategory_list}" varStatus="status">
			<li><a href="<c:url value='/product-list.jsp' />?productCategoryId=${item.productCategoryId}"<c:if test="${item.productCategoryId == param.productCategoryId}"> class="current"</c:if>>${item.name}</a></li>
		</c:forEach>
	</ul>

	<div class="platform">
		<div class="breadcrumb"></div>
		<ul class="product-list">
			<c:forEach var="item" items="${product_pager.resultList}" varStatus="status">
				<li>
					<div class="item">
						<a href="<c:url value='/product.jsp' />?productId=${item.productId}" title="${item.name}"><img src="<c:url value='' />${item.pic}" alt="" class="pic" /></a>
						<div class="prop">
							<h3><a href="<c:url value='/product.jsp' />?productId=${item.productId}" title="${item.name}">${item.name}</a></h3>
							<p>规格：${item.spec}</p>
							<p>香型：${item.odor}</p>
							<p>价格：${item.price}</p>
						</div>
					</div>
				</li>
			</c:forEach>
		</ul>
		<div id="paging"></div>
	</div>
</div>

<%@ include file="/_footer.jspf" %>

</div>
</div>

<%@ include file="/_script.jspf" %>

<script type="text/javascript">
// page
$jq.paginator($("#paging"), {
	param: "pageNo",
	current: ${product_pager.pageNo},
	pages: 5,
	records: ${product_pager.total},
	rows: ${product_pager.pageSize},
	previous: "上一页",
	next: "下一页"
});
</script>
</body>
</html>
