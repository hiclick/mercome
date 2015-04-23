<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ page import="$java.jsonlib.DateJsonValueProcessorImpl" %>

<%@ page import="com.mercome.activity.domain.Proxy" %>
<%@ page import="com.mercome.activity.service.GenericService" %>
<%@ page import="com.mercome.activity.util.EnvUtils" %>

<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JsonConfig" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.springframework.transaction.TransactionStatus" %>
<%@ page import="org.springframework.transaction.support.TransactionCallbackWithoutResult" %>
<%@ page import="org.springframework.transaction.support.TransactionTemplate" %>

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
	final HttpServletRequest _request = request;

	TransactionTemplate transactionTemplate = EnvUtils.getEnv().getTransactionTemplate();

	final GenericService genericService = EnvUtils.getEnv().getBean(GenericService.class);

	if (method.equals("insert")) {
		try {
			transactionTemplate.execute(new TransactionCallbackWithoutResult() {
				@Override
				protected void doInTransactionWithoutResult(TransactionStatus transactionStatus) {
					String mobile = _request.getParameter("mobile");

					if (genericService.count(Proxy.class, "WHERE mobile = ?", mobile) > 0) {
						results.element("msg", "exist");

						return;
					}

					Proxy proxy = new Proxy();

					proxy.setName(_request.getParameter("name"));

					proxy.setAddress(_request.getParameter("address"));
					proxy.setEmail(_request.getParameter("email"));
					proxy.setGender(Integer.parseInt(_request.getParameter("gender")));
					proxy.setMobile(mobile);
					proxy.setTel(_request.getParameter("tel"));

					proxy.setBrand(_request.getParameter("brand"));

					proxy.setCreateDate(new Date());

					long postId = genericService.create(proxy);

					results.element("id", postId);

					results.element("msg", "success");
				}
			});
		} catch (Exception e) {
			e.printStackTrace();

			results.element("msg", e.getMessage());
		}
	}

	out.println(results);
%>
