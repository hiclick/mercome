<%@ tag pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="url" value='<%= request.getContextPath() + request.getServletPath() + "?" + (request.getQueryString() != null ? request.getQueryString() : "").replaceAll("&*(pageNo)=[^&]*", "") %>' />
<c:set var="numbers"><jsp:doBody /></c:set>
<c:set var="numbers" value="${fn:split(numbers, ',')}" />
<c:set var="pageNo" value="${1 * numbers[0]}" />
<c:set var="pageSize" value="${1 * numbers[1]}" />
<c:set var="total" value="${1 * numbers[2]}" />
<c:set var="pageTotal">${(total - 1) / pageSize + 1}</c:set>
<c:set var="pageTotal" value="${fn:substring(pageTotal, 0, fn:indexOf(pageTotal, '.'))}" />
<c:set var="begin" value="${pageNo - 3 > 0 ? pageNo - 3 : 1}" />
<c:set var="end" value="${pageTotal - pageNo > 3 ? pageNo + 3 : pageTotal}" />

<c:forEach var="x" begin="1" end="${3 - (pageNo - begin)}">
	<c:if test="${end < pageTotal}">
		<c:set var="end" value="${end + 1}" />
	</c:if>
</c:forEach>
<c:forEach var="x" begin="1" end="${3 - (end - pageNo)}">
	<c:if test="${begin > 1}">
		<c:set var="begin" value="${begin - 1}" />
	</c:if>
</c:forEach>
<c:if test="${pageNo > 1}">
	<a href="${url}&pageNo=${pageNo > 1 ? pageNo-1 : 1}" class="pageUp">上一页</a>
</c:if>
<c:if test="${pageNo > 4 && pageTotal > 7}">
	<a href="${url}" class="pageCon">1</a>...
</c:if>
<c:forEach var="n" begin="${begin}" end="${end}">
	<c:if test="${n != pageNo}">
		<a href="${url}&pageNo=${n}" class="pageCon">${n}</a>
	</c:if>
	<c:if test="${n == pageNo}">
		<a href="#" class="pageCon">${n}</a>
	</c:if>
</c:forEach>
<c:if test="${pageNo < pageTotal - 3 && pageTotal > 7}">
	...
	<a href="${url}&pageNo=${pageTotal}" class="pageCon">${pageTotal}</a>
</c:if>
<c:if test="${pageNo < pageTotal}">
	<a href="${url}&pageNo=${pageNo < pageTotal ? pageNo+1 : pageTotal}" class="pageDown">下一页</a>
</c:if>
