<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ include file="/WEB-INF/jsp/_import.jspf" %>

<%@ page import="com.mercome.activity.domain.Article" %>
<%@ page import="com.mercome.activity.domain.ArticleCategory" %>
<%@ page import="com.mercome.activity.domain.Pager" %>
<%@ page import="com.mercome.activity.service.GenericService" %>
<%@ page import="com.mercome.activity.util.EnvUtils" %>

<%@ page import="org.apache.commons.lang.math.NumberUtils" %>

<%@ page import="java.util.List" %>

<%
	/* ... */
	GenericService genericService = EnvUtils.getEnv().getBean(GenericService.class);
	request.setAttribute("genericService", genericService);

	/* articlecategory */
	List<ArticleCategory> articleCategory_list = genericService.list(ArticleCategory.class, "");
	request.setAttribute("articleCategory_list", articleCategory_list);

	/* article */
	Pager<Article> article_pager = genericService.pager(
		Article.class,
		"WHERE articlecategoryid = ? ORDER BY createdate DESC",
		NumberUtils.toInt(request.getParameter("pageNo"), 1),
		5,
		request.getParameter("articleCategoryId")
	);
	request.setAttribute("article_pager", article_pager);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<%@ include file="/_seo.jspf" %>

<link rel="stylesheet" type="text/css" href="<c:url value='/css/style.css' />" />

<script type="text/javascript">
var _nav_index = 4;
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
		<c:forEach var="item" items="${articleCategory_list}" varStatus="status">
			<li><a href="<c:url value='/article-list.jsp' />?articleCategoryId=${item.articleCategoryId}"<c:if test="${item.articleCategoryId == param.articleCategoryId}"> class="current"</c:if>>${item.name}</a></li>
		</c:forEach>
	</ul>

	<div class="platform">
		<div class="breadcrumb"></div>
		<ul class="article-list">
			<c:forEach var="item" items="${article_pager.resultList}" varStatus="status">
				<li>
					<div class="item">
						<h3><a href="<c:url value='/article.jsp' />?articleId=${item.articleId}">${item.title}</a></h3>
						<p>
							<c:set var="content" value="${fn:escapeXml(func:stripHtml(item.content))}" />
							<c:choose>
								<c:when test="${fn:length(content) > 50}">
									${fn:substring(content, 0, 90)}…
								</c:when>
								<c:otherwise>
									${content}
								</c:otherwise>
							</c:choose>
						</p>
					</div>
					<a href="<c:url value='/article.jsp' />?articleId=${item.articleId}" class="read">阅读详情</a>
					<span class="date"><fmt:formatDate value="${item.createDate}" pattern="yyyy.MM.dd" /></span>
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
	current: ${article_pager.pageNo},
	pages: 5,
	records: ${article_pager.total},
	rows: ${article_pager.pageSize},
	previous: "上一页",
	next: "下一页"
});
</script>
</body>
</html>
