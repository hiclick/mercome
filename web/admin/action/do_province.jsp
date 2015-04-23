<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ include file="/admin/_auth.jspf" %>

<%@ page import="$java.jsonlib.DateJsonValueProcessorImpl" %>

<%@ page import="com.mercome.activity.service.GenericService" %>
<%@ page import="com.mercome.activity.util.EnvUtils" %>

<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JsonConfig" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.apache.commons.lang.math.NumberUtils" %>
<%@ page import="org.springframework.transaction.TransactionStatus" %>
<%@ page import="org.springframework.transaction.support.TransactionCallbackWithoutResult" %>
<%@ page import="org.springframework.transaction.support.TransactionTemplate" %>

<%@ page import="java.util.Date" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.mercome.activity.domain.*" %>

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
			params.put("provinceid", query);

			query = "AND provinceid = :provinceid";
			query += " ";
		}

		String id = request.getParameter("id");
		if (StringUtils.isNotBlank(id)) {
			params.put("provinceid", id);

			query += "AND provinceid = :provinceid";
			query += " ";
		}

		query = "WHERE 1 = 1 " + query + "ORDER BY createdate DESC";

		int limit = NumberUtils.toInt(request.getParameter("limit"));
		int start = NumberUtils.toInt(request.getParameter("start"));

		if (limit > 0) {
			int pageNo = start > 0 ? (start / limit + 1) : 1;
			int pageSize = limit;

			Pager<Province> pager = genericService.pager(Province.class, query, pageNo, pageSize, params);
			list = pager.getResultList();

			results.element("total", pager.getTotal());
		} else {
			list = genericService.list(Province.class, query, params);
		}

		JSONArray rows = new JSONArray();

		for (Object o : list) {
			rows.add(o, jsonConfig);
		}

		results.element("rows", rows);
	} else if (method.equals("form")) {
		long id = Long.parseLong(request.getParameter("id"));

		Province province = genericService.find(Province.class, id);

		results.element("success", true);
		results.element("data", province, jsonConfig);
	} else if (method.equals("save")) {
		try {
			transactionTemplate.execute(new TransactionCallbackWithoutResult() {
				@Override
				protected void doInTransactionWithoutResult(TransactionStatus transactionStatus) {
					long id = NumberUtils.toLong(_request.getParameter("provinceId"));

					String data = _request.getParameter("data");

					if (id > 0) { // update

					} else if (StringUtils.isNotBlank(data)) { // update
						JSONArray items = JSONArray.fromObject(data);

						for (Object o : items) {
							JSONObject item = JSONObject.fromObject(o);

							long provinceId = item.getLong("provinceId");

							Province province = genericService.find(Province.class, provinceId);

							// 自定义
							province.setName(item.getString("name"));

							genericService.update(province);

							log.setAction("Update");
							log.setDetail("id: " + provinceId); // 自定义
							log.setModule(Province.class.getSimpleName());

							log.setCreateDate(new Date());

							genericService.create(log);
						}
					} else { // create
						Province province = new Province();

						// 自定义
						province.setName(_request.getParameter("name"));

						province.setCreateDate(new Date());

						long provinceId = genericService.create(province);

						log.setAction("Create");
						log.setDetail("id: " + provinceId); // 自定义
						log.setModule(Province.class.getSimpleName());

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

						genericService.delete(Province.class, id);

/*
						Province province = genericService.find(Province.class, id);

						province.setStatus(-1);

						genericService.update(province);
*/

						for (City city : genericService.list(City.class, "WHERE provinceid = ?", id)) {
							genericService.delete(city);
						}

						log.setAction("Delete");
						log.setDetail("id: " + id);
						log.setModule(Province.class.getSimpleName());

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
