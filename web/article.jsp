<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ include file="/WEB-INF/jsp/_import.jspf" %>

<%@ page import="com.mercome.activity.domain.Article" %>
<%@ page import="com.mercome.activity.domain.ArticleCategory" %>
<%@ page import="com.mercome.activity.service.GenericService" %>
<%@ page import="com.mercome.activity.util.EnvUtils" %>

<%@ page import="java.util.List" %>

<%
	/* ... */
	GenericService genericService = EnvUtils.getEnv().getBean(GenericService.class);
	request.setAttribute("genericService", genericService);

	/* articlecategory */
	List<ArticleCategory> articleCategory_list = genericService.list(ArticleCategory.class, "");
	request.setAttribute("articleCategory_list", articleCategory_list);

	/* article */
	Article article = genericService.find(Article.class, Long.parseLong(request.getParameter("articleId")));
	request.setAttribute("article", article);
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
			<li><a href="<c:url value='/article-list.jsp' />?articleCategoryId=${item.articleCategoryId}"<c:if test="${item.articleCategoryId == article.articleCategoryId}"> class="current"</c:if>>${item.name}</a></li>
		</c:forEach>
	</ul>

	<div class="platform">
		<div class="breadcrumb"></div>
		<div class="article">
			<h3>${article.title}</h3>
			<div class="date"><fmt:formatDate value="${article.createDate}" pattern="yyyy.MM.dd" /></div>
			<%--<div class="share">分享到：</div>--%>
			<div class="pic"><img src="<c:url value='' />${article.pic}" alt="" /></div>
			<div class="content htmleditor">${article.content}</div>
			<%
				List<Article> article_list = genericService.list(Article.class, "WHERE articleid > ? AND articlecategoryid = ? ORDER BY articleid ASC LIMIT 0, 1", article.getArticleId(), article.getArticleCategoryId());

				if (!article_list.isEmpty()) {
					Article previous = article_list.get(0);
			%>
			<a href="<c:url value='/article.jsp' />?articleId=<%= previous.getArticleId() %>" class="previous">上一条</a>
			<%
				}

				article_list = genericService.list(Article.class, "WHERE articleid < ? AND articlecategoryid = ? ORDER BY articleid DESC LIMIT 0, 1", article.getArticleId(), article.getArticleCategoryId());

				if (!article_list.isEmpty()) {
					Article next = article_list.get(0);
			%>
			<a href="<c:url value='/article.jsp' />?articleId=<%= next.getArticleId() %>" class="next">下一条</a>
			<%
				}
			%>
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
