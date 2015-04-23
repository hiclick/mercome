<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ include file="/admin/_auth.jspf" %>

<%@ page import="$java.jsonlib.DateJsonValueProcessorImpl" %>

<%@ page import="com.mercome.activity.domain.Log" %>
<%@ page import="com.mercome.activity.domain.Pager" %>
<%@ page import="com.mercome.activity.domain.Product" %>
<%@ page import="com.mercome.activity.domain.ProductCategory" %>
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
			params.put("productid", query);

			query = "AND productid = :productid";
			query += " ";
		}

		String id = request.getParameter("id");
		if (StringUtils.isNotBlank(id)) {
			params.put("productid", id);

			query += "AND productid = :productid";
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

			Pager<Product> pager = genericService.pager(Product.class, query, pageNo, pageSize, params);
			list = pager.getResultList();

			results.element("total", pager.getTotal());
		} else {
			list = genericService.list(Product.class, query, params);
		}

		JSONArray rows = new JSONArray();

		for (Object o : list) {
			JSONObject item = JSONObject.fromObject(o, jsonConfig);

			// 自定义
			String productCategory_name = null;
			try {
				ProductCategory item_productCategory = genericService.find(ProductCategory.class, item.getLong("productCategoryId"));

				productCategory_name = item_productCategory.getName();
			} catch (Exception e) {
				//e.printStackTrace();
			}
			item.element("productCategory_name", productCategory_name);

			rows.add(item, jsonConfig);
		}

		results.element("rows", rows);
	} else if (method.equals("form")) {
		long id = Long.parseLong(request.getParameter("id"));

		Product product = genericService.find(Product.class, id);

		results.element("success", true);
		results.element("data", product, jsonConfig);
	} else if (method.equals("save")) {
		try {
			transactionTemplate.execute(new TransactionCallbackWithoutResult() {
				@Override
				protected void doInTransactionWithoutResult(TransactionStatus transactionStatus) {
					long id = NumberUtils.toLong(_request.getParameter("productId"));

					String data = _request.getParameter("data");

					if (id > 0) { // update
						Product product = genericService.find(Product.class, id);

						// 自定义
						product.setProductCategoryId(Long.parseLong(_request.getParameter("productCategoryId")));

						product.setName(_request.getParameter("name"));
						product.setPrice(_request.getParameter("price"));

						product.setCmp(_request.getParameter("cmp"));
						product.setFeature(_request.getParameter("feature"));
						product.setOdor(_request.getParameter("odor"));
						product.setPeople(_request.getParameter("people"));
						product.setPic(_request.getParameter("pic"));
						product.setSpec(_request.getParameter("spec"));

						genericService.update(product);

						log.setAction("Update");
						log.setDetail("id: " + id); // 自定义
						log.setModule(Product.class.getSimpleName());

						log.setCreateDate(new Date());

						genericService.create(log);
					} else if (StringUtils.isNotBlank(data)) { // update

					} else { // create
						Product product = new Product();

						// 自定义
						product.setProductCategoryId(Long.parseLong(_request.getParameter("productCategoryId")));

						product.setName(_request.getParameter("name"));
						product.setPrice(_request.getParameter("price"));

						product.setCmp(_request.getParameter("cmp"));
						product.setFeature(_request.getParameter("feature"));
						product.setOdor(_request.getParameter("odor"));
						product.setPeople(_request.getParameter("people"));
						product.setPic(_request.getParameter("pic"));
						product.setSpec(_request.getParameter("spec"));

						product.setCreateDate(new Date());

						long productId = genericService.create(product);

						log.setAction("Create");
						log.setDetail("id: " + productId); // 自定义
						log.setModule(Product.class.getSimpleName());

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

						genericService.delete(Product.class, id);

/*
						Product product = genericService.find(Product.class, id);

						product.setStatus(-1);

						genericService.update(product);
*/

						log.setAction("Delete");
						log.setDetail("id: " + id);
						log.setModule(Product.class.getSimpleName());

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
