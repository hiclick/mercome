f<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ include file="/admin/_auth.jspf" %>

<%@ page import="$java.jsonlib.DateJsonValueProcessorImpl" %>

<%@ page import="com.mercome.activity.domain.Log" %>
<%@ page import="com.mercome.activity.domain.Pager" %>
<%@ page import="com.mercome.activity.domain.Proxy" %>
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
<%@ page import="$java.poi.Excel" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="org.apache.poi.ss.usermodel.*" %>

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
			params.put("proxyid", query);

			query = "AND proxyid = :proxyid";
			query += " ";
		}

		String id = request.getParameter("id");
		if (StringUtils.isNotBlank(id)) {
			params.put("proxyid", id);

			query += "AND proxyid = :proxyid";
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

			Pager<Proxy> pager = genericService.pager(Proxy.class, query, pageNo, pageSize, params);
			list = pager.getResultList();

			results.element("total", pager.getTotal());
		} else {
			list = genericService.list(Proxy.class, query, params);
		}

		JSONArray rows = new JSONArray();

		for (Object o : list) {
			rows.add(o, jsonConfig);
		}

		results.element("rows", rows);
	} else if (method.equals("form")) {
		long id = Long.parseLong(request.getParameter("id"));

		Proxy proxy = genericService.find(Proxy.class, id);

		results.element("success", true);
		results.element("data", proxy, jsonConfig);
	} else if (method.equals("save")) {
		try {
			transactionTemplate.execute(new TransactionCallbackWithoutResult() {
				@Override
				protected void doInTransactionWithoutResult(TransactionStatus transactionStatus) {
					long id = NumberUtils.toLong(_request.getParameter("proxyId"));

					String data = _request.getParameter("data");

					if (id > 0) { // update

					} else if (StringUtils.isNotBlank(data)) { // update

					} else { // create

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

						//genericService.delete(Proxy.class, id);

						Proxy proxy = genericService.find(Proxy.class, id);

						proxy.setStatus(-1);

						genericService.update(proxy);

						log.setAction("Delete");
						log.setDetail("id: " + id);
						log.setModule(Proxy.class.getSimpleName());

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
	} else if (method.equals("export")) {
		String filename = "workbook.xls";

		response.reset();
		response.setContentType("application/vnd.ms-excel");
		response.setHeader("Content-Disposition", "attachment; filename=" + filename + ";");

		OutputStream output = response.getOutputStream();

		Workbook wb = Excel.getWorkbook(new String[]{"姓名", "地址", "邮箱", "性别", "手机", "座机", "品牌", "创建日期"});

		try {
			CreationHelper creationHelper = wb.getCreationHelper();

			CellStyle style_date = wb.createCellStyle();
			style_date.setDataFormat(creationHelper.createDataFormat().getFormat("yyyy-MM-dd HH:mm:ss"));

			Sheet sheet = wb.getSheetAt(0);

			// tbody
			List<Proxy> list = genericService.list(Proxy.class, "ORDER BY createDate DESC");

			for (int i = 0, l = list.size(); i < l; i++) {
				Proxy proxy = list.get(i);

				Row row = sheet.createRow(i + 1);
				row.setHeightInPoints(15);

				Cell cell = row.createCell(0);
				cell.setCellValue(proxy.getName());

				cell = row.createCell(1);
				cell.setCellValue(proxy.getAddress());

				cell = row.createCell(2);
				cell.setCellValue(proxy.getEmail());

				cell = row.createCell(3);
				cell.setCellValue(proxy.getGender() == 0 ? "女" : "男");

				cell = row.createCell(4);
				cell.setCellValue(proxy.getMobile());

				cell = row.createCell(5);
				cell.setCellValue(proxy.getTel());

				cell = row.createCell(6);
				cell.setCellValue(proxy.getBrand());

				cell = row.createCell(7);
				cell.setCellValue(proxy.getCreateDate());
				cell.setCellStyle(style_date);
			}

			wb.write(output);

			output.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	out.println(results);
%>
