<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ include file="/admin/_auth.jspf" %>

<%@ page import="$java.jsonlib.DateJsonValueProcessorImpl" %>

<%@ page import="com.mercome.activity.domain.Log" %>
<%@ page import="com.mercome.activity.domain.Pager" %>
<%@ page import="com.mercome.activity.service.GenericService" %>
<%@ page import="com.mercome.activity.util.EnvUtils" %>

<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JsonConfig" %>
<%@ page import="org.apache.commons.codec.digest.DigestUtils" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.apache.commons.lang.math.NumberUtils" %>
<%@ page import="org.springframework.transaction.TransactionStatus" %>
<%@ page import="org.springframework.transaction.support.TransactionCallbackWithoutResult" %>
<%@ page import="org.springframework.transaction.support.TransactionTemplate" %>

<%@ page import="java.util.Date" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

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

	// ip
	final String ip = EnvUtils.getEnv().getIp();

	// log
	final Log log = new Log();
	log.setAdminId(adminId);
	log.setIp(ip);

	// params
	Map<String, Object> params = new HashMap<String, Object>();

	// ...
	final HttpServletRequest _request = request;

	TransactionTemplate transactionTemplate = EnvUtils.getEnv().getTransactionTemplate();

	final GenericService genericService = EnvUtils.getEnv().getBean(GenericService.class);

	if (method.equals("list")) {
		List list;

		String query = StringUtils.defaultString(request.getParameter("query"));
		if (StringUtils.isNotBlank(query)) {
			// 自定义
			params.put("adminid", query);

			query = "AND adminid = :adminid";
			query += " ";
		}

		String id = request.getParameter("id");
		if (StringUtils.isNotBlank(id)) {
			params.put("adminid", id);

			query += "AND adminid = :adminid";
			query += " ";
		}

		query = "WHERE 1 = 1 " + query + "ORDER BY createdate DESC";

		int limit = NumberUtils.toInt(request.getParameter("limit"));
		int start = NumberUtils.toInt(request.getParameter("start"));

		if (limit > 0) {
			int pageNo = start > 0 ? (start / limit + 1) : 1;
			int pageSize = limit;

			Pager<Admin> pager = genericService.pager(Admin.class, query, pageNo, pageSize, params);
			list = pager.getResultList();

			results.element("total", pager.getTotal());
		} else {
			list = genericService.list(Admin.class, query, params);
		}

		JSONArray rows = new JSONArray();

		for (Object o : list) {
			rows.add(o, jsonConfig);
		}

		results.element("rows", rows);
	} else if (method.equals("form")) {
		long id = Long.parseLong(request.getParameter("id"));

		Admin admin = genericService.find(Admin.class, id);

		results.element("success", true);
		results.element("data", admin, jsonConfig);
	} else if (method.equals("save")) {
		try {
			transactionTemplate.execute(new TransactionCallbackWithoutResult() {
				@Override
				protected void doInTransactionWithoutResult(TransactionStatus transactionStatus) {
					long id = NumberUtils.toLong(_request.getParameter("adminId"));

					String data = _request.getParameter("data");

					if (id > 0) { // update

					} else if (StringUtils.isNotBlank(data)) { // update
						JSONArray items = JSONArray.fromObject(data);

						for (Object o : items) {
							JSONObject item = JSONObject.fromObject(o);

							long adminId = item.getLong("adminId");

							Admin admin = genericService.find(Admin.class, adminId);

							// 自定义
							admin.setPassword(DigestUtils.sha1Hex(item.getString("password")));

							genericService.update(admin);

							log.setAction("Update");
							log.setDetail("id: " + adminId); // 自定义
							log.setModule(Admin.class.getSimpleName());

							log.setCreateDate(new Date());

							genericService.create(log);
						}
					} else { // create
						Admin admin = new Admin();

						// 自定义
						String username = _request.getParameter("username");

						if (genericService.count(Admin.class, "WHERE username = ?", username) > 0) {
							throw new RuntimeException("重复提交");
						}

						admin.setUsername(username);
						admin.setPassword(DigestUtils.sha1Hex(_request.getParameter("password")));

						admin.setCreateDate(new Date());

						long adminId = genericService.create(admin);

						log.setAction("Create");
						log.setDetail("id: " + adminId); // 自定义
						log.setModule(Admin.class.getSimpleName());

						log.setCreateDate(new Date());

						genericService.create(log);
					}

					results.element("success", true);
				}
			});
		} catch (Exception e) {
			e.printStackTrace();

			results.element("msg", e.getMessage());
		}
	} else if (method.equals("delete")) {
		try {
			transactionTemplate.execute(new TransactionCallbackWithoutResult() {
				@Override
				protected void doInTransactionWithoutResult(TransactionStatus transactionStatus) {
					String[] ids = _request.getParameterValues("id");

					for (int i = 0, l = ids.length; i < l; i++) {
						long id = Long.parseLong(ids[i]);

						//genericService.delete(Admin.class, id);

						Admin admin = genericService.find(Admin.class, id);

						admin.setStatus(-1);

						genericService.update(admin);

						log.setAction("Delete");
						log.setDetail("id: " + id);
						log.setModule(Admin.class.getSimpleName());

						log.setCreateDate(new Date());

						genericService.create(log);
					}

					results.element("success", true);
				}
			});
		} catch (Exception e) {
			e.printStackTrace();

			results.element("msg", e.getMessage());
		}
	}

	out.println(results);
%>
