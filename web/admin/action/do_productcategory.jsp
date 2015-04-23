f<%@ page contentType="text/html; charset=UTF-8" language="java" %>

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

<%@ page import="java.text.ParseException" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
			params.put("productcategoryid", query);

			query = "AND productcategoryid = :productcategoryid";
			query += " ";
		}

		String id = request.getParameter("id");
		if (StringUtils.isNotBlank(id)) {
			params.put("productcategoryid", id);

			query += "AND productcategoryid = :productcategoryid";
			query += " ";
		}

		String startdate = request.getParameter("startdate");
		String enddate = request.getParameter("enddate");
		if (StringUtils.isNotBlank(startdate) && StringUtils.isNotBlank(enddate)) {
			try {
				startdate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(startdate));
				enddate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(enddate));

				params.put("startdate", startdate);
				params.put("enddate", enddate);

				query += "AND (createdate BETWEEN :startdate AND :enddate)";
				query += " ";
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}

		query = "WHERE 1 = 1 " + query + "ORDER BY createdate DESC";

		int limit = NumberUtils.toInt(request.getParameter("limit"));
		int start = NumberUtils.toInt(request.getParameter("start"));

		if (limit > 0) {
			int pageNo = start > 0 ? (start / limit + 1) : 1;
			int pageSize = limit;

			Pager<ProductCategory> pager = genericService.pager(ProductCategory.class, query, pageNo, pageSize, params);
			list = pager.getResultList();

			results.element("total", pager.getTotal());
		} else {
			list = genericService.list(ProductCategory.class, query, params);
		}

		JSONArray rows = new JSONArray();

		for (Object o : list) {
			rows.add(o, jsonConfig);
		}

		results.element("rows", rows);
	} else if (method.equals("form")) {
		long id = Long.parseLong(request.getParameter("id"));

		ProductCategory productCategory = genericService.find(ProductCategory.class, id);

		results.element("success", true);
		results.element("data", productCategory, jsonConfig);
	} else if (method.equals("save")) {
		try {
			transactionTemplate.execute(new TransactionCallbackWithoutResult() {
				@Override
				protected void doInTransactionWithoutResult(TransactionStatus transactionStatus) {
					long id = NumberUtils.toLong(_request.getParameter("productCategoryId"));

					String data = _request.getParameter("data");

					if (id > 0) { // update
						ProductCategory productCategory = genericService.find(ProductCategory.class, id);

						// 自定义
						productCategory.setName(_request.getParameter("name"));

						productCategory.setBanner(_request.getParameter("banner"));
						productCategory.setPic(_request.getParameter("pic"));

						genericService.update(productCategory);

						log.setAction("Update");
						log.setDetail("id: " + id); // 自定义
						log.setModule(ProductCategory.class.getSimpleName());

						log.setCreateDate(new Date());

						genericService.create(log);
					} else if (StringUtils.isNotBlank(data)) { // update

					} else { // create
						ProductCategory productCategory = new ProductCategory();

						// 自定义
						productCategory.setName(_request.getParameter("name"));

						productCategory.setBanner(_request.getParameter("banner"));
						productCategory.setPic(_request.getParameter("pic"));

						productCategory.setCreateDate(new Date());

						long productCategoryId = genericService.create(productCategory);

						log.setAction("Create");
						log.setDetail("id: " + productCategoryId); // 自定义
						log.setModule(ProductCategory.class.getSimpleName());

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

						genericService.delete(ProductCategory.class, id);

/*
						ProductCategory productCategory = genericService.find(ProductCategory.class, id);

						productCategory.setStatus(-1);

						genericService.update(productCategory);
*/

						for (Product product : genericService.list(Product.class, "WHERE productcategoryid = ?", id)) {
							genericService.delete(product);
						}

						log.setAction("Delete");
						log.setDetail("id: " + id);
						log.setModule(ProductCategory.class.getSimpleName());

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
