<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ page import="$java.jsonlib.DateJsonValueProcessorImpl" %>

<%@ page import="com.mercome.activity.service.GenericService" %>
<%@ page import="com.mercome.activity.service.PlayService" %>
<%@ page import="com.mercome.activity.util.EnvUtils" %>

<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JsonConfig" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.springframework.transaction.TransactionStatus" %>
<%@ page import="org.springframework.transaction.support.TransactionCallbackWithoutResult" %>
<%@ page import="org.springframework.transaction.support.TransactionTemplate" %>

<%@ page import="java.util.Date" %>
<%@ page import="com.mercome.activity.domain.Proxy" %>
<%@ page import="java.util.List" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="com.mercome.activity.domain.Store" %>
<%@ page import="com.mercome.activity.domain.City" %>
<%@ page import="org.apache.commons.lang.math.NumberUtils" %>

<%
	out.clear();

	// encode
	request.setCharacterEncoding("UTF-8");

	// method
	String method = request.getParameter("method");
	if (StringUtils.isBlank(method)) {
		return;
	}

	// results
	final JSONObject results = new JSONObject();

	// JsonConfig
	JsonConfig jsonConfig = new JsonConfig();
	jsonConfig.registerJsonValueProcessor(Date.class, new DateJsonValueProcessorImpl());

	// ...
	final HttpServletRequest _request = request;

	TransactionTemplate transactionTemplate = EnvUtils.getEnv().getTransactionTemplate();

	final GenericService genericService = EnvUtils.getEnv().getBean(GenericService.class);

	if (method.equals("search")) {
		long cityId = NumberUtils.toLong(request.getParameter("cityId"));

		List list = genericService.list(Store.class, "WHERE " + (cityId > 0 ? "cityid" : "provinceid") + " = ? AND address LIKE ?", cityId > 0 ? cityId : request.getParameter("provinceId"), "%" + request.getParameter("keyword") + "%");

		results.element("rows", JSONArray.fromObject(list));
	} else if (method.equals("city")) {
		List list = genericService.list(City.class, "WHERE provinceid = ?", request.getParameter("provinceId"));

		results.element("rows", JSONArray.fromObject(list));
	}

	out.println(results);
%>
