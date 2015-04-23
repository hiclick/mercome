<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ page import="$java.jsonlib.DateJsonValueProcessorImpl" %>

<%@ page import="com.mercome.activity.domain.Admin" %>
<%@ page import="com.mercome.activity.service.GenericService" %>
<%@ page import="com.mercome.activity.util.EnvUtils" %>

<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JsonConfig" %>
<%@ page import="org.apache.commons.codec.digest.DigestUtils" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>

<%@ page import="java.util.Date" %>

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
	final GenericService genericService = EnvUtils.getEnv().getBean(GenericService.class);

	if (method.equals("login")) {
		String username = request.getParameter("username");
		String password = request.getParameter("password");

		results.element("msg", "用户名或密码错误");

		for (Admin admin : genericService.list(Admin.class, "WHERE username = ? AND password = ?", username, DigestUtils.sha1Hex(password))) {
			session.setAttribute("_admin_id", admin.getAdminId());

			results.element("success", true);
		}
	}

	out.println(results);
%>
