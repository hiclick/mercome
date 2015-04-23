<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ include file="/WEB-INF/jsp/_import.jspf" %>

<%@ page import="com.mercome.activity.domain.Product" %>
<%@ page import="com.mercome.activity.domain.ProductCategory" %>
<%@ page import="com.mercome.activity.service.GenericService" %>
<%@ page import="com.mercome.activity.util.EnvUtils" %>

<%@ page import="java.util.List" %>

<%
	/* ... */
	GenericService genericService = EnvUtils.getEnv().getBean(GenericService.class);
	request.setAttribute("genericService", genericService);

	/* product */
	Product product = genericService.find(Product.class, Long.parseLong(request.getParameter("productId")));
	request.setAttribute("product", product);

	/* productcategory */
	List<ProductCategory> productCategory_list = genericService.list(ProductCategory.class, "");
	request.setAttribute("productCategory_list", productCategory_list);

	ProductCategory productCategory = genericService.find(ProductCategory.class, product.getProductCategoryId());
	request.setAttribute("productCategory", productCategory);
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
			<li><a href="<c:url value='/product-list.jsp' />?productCategoryId=${item.productCategoryId}"<c:if test="${item.productCategoryId == product.productCategoryId}"> class="current"</c:if>>${item.name}</a></li>
		</c:forEach>
	</ul>

	<div class="platform">
		<div class="breadcrumb"></div>
		<div class="product">
			<div class="pic">
				<img src="<c:url value='${product.pic}' /> " alt="" />
			</div>
			<%
				List<Product> product_list = genericService.list(Product.class, "WHERE productid > ? AND productcategoryid = ? ORDER BY productid ASC LIMIT 0, 1", product.getProductId(), product.getProductCategoryId());

				if (!product_list.isEmpty()) {
					Product previous = product_list.get(0);
			%>
			<a href="<c:url value='/product.jsp' />?productId=<%= previous.getProductId() %>" class="arrows-prev"></a>
			<%
				}

				product_list = genericService.list(Product.class, "WHERE productid < ? AND productcategoryid = ? ORDER BY productid DESC LIMIT 0, 1", product.getProductId(), product.getProductCategoryId());

				if (!product_list.isEmpty()) {
					Product next = product_list.get(0);
			%>
			<a href="<c:url value='/product.jsp' />?productId=<%= next.getProductId() %>" class="arrows-next"></a>
			<%
				}
			%>
			<h3>${product.name}</h3>
			<div class="prop">
				<dl style="width: 15%;">
					<dt>产品规格</dt>
					<dd>${product.spec}</dd>
				</dl>
				<dl style="width: 15%;">
					<dt>适用人群</dt>
					<dd>${product.people}</dd>
				</dl>
				<dl style="width: 55%;">
					<dt>主要成分</dt>
					<dd>${product.cmp}</dd>
				</dl>
				<dl>
					<dt>产品香型</dt>
					<dd>${product.odor}</dd>
				</dl>
				<dl style="width: 100%;">
					<dt>产品特点</dt>
					<dd class="htmleditor">${product.feature}</dd>
				</dl>
			</div>
			<div class="buy">
				<a href="#">立即购买</a>
			</div>
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
