<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ include file="/admin/_auth.jspf" %>

<%@ page import="$java.CommonsFileUpload" %>
<%@ page import="$java.jsonlib.DateJsonValueProcessorImpl" %>

<%@ page import="com.mercome.activity.domain.Log" %>
<%@ page import="com.mercome.activity.service.GenericService" %>
<%@ page import="com.mercome.activity.util.EnvUtils" %>

<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JsonConfig" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>

<%@ page import="java.util.Date" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>

<%
	out.clear();

	// encode
	request.setCharacterEncoding("UTF-8");

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

	// ...
	final GenericService genericService = EnvUtils.getEnv().getBean(GenericService.class);

	// for ExtJS 3.x
	response.setContentType("text/html");

	// upload
	Map params = CommonsFileUpload.getParams(request);

	FileItem fileItem = (FileItem) params.get("file");

	Pattern pattern = Pattern.compile("gif|jpg|png");
	Matcher matcher = pattern.matcher(CommonsFileUpload.getExt(fileItem.getName()));

	if (matcher.find()) {
		String pathname = CommonsFileUpload.write(application, fileItem, "upload/image/", String.valueOf(adminId + "_" + new Date().getTime()));

		log.setAction("Upload");
		log.setDetail("file: " + pathname); // 自定义
		log.setModule("Upload");

		log.setCreateDate(new Date());

		genericService.create(log);

		results.element("success", true);
		results.element("pathname", pathname);
	} else {
		results.element("msg", "format");
	}

	out.println(results);
%>
