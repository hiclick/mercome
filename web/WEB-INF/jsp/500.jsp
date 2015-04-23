<%@ page contentType="text/html; charset=GBK" language="java" isErrorPage="true" %>

<%--<%@ page session="false" %>--%>

<%@ page import="$java.util.Functions" %>

<%@ page import="org.apache.commons.lang.math.NumberUtils" %>

<%@ page import="java.io.IOException" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.StringWriter" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Map" %>

<%--
	��ҳ��ר����������JSPҳ��Ĵ�����ҳ���ã���������ҳ�濪ʼ���룺
	<%@ page errorPage="/errorPage.jsp" ...
	��ҳ�潫��ҳ������쳣ʱ��ʾ���쳣����Ϣ���ݺ��쳣������
	����ͨ������`��������ʾ�쳣��stackTrace��
	��Resin�������У���errorPage��������ʾ�������쳣��ҳ��ĳ����кţ�����ԭҳ����һ��Ҫ��
	��JSP��ͷ��Ҫ����һ�У�
	request.setAttribute("_SOURCE_PAGE_", this);
	һ����һ�д������ͨ��һ�������İ���ҳ������ɡ�
	�����д��һ�У�����ԭ���ķ�ʽ��ʾ�쳣��StackTrace��������ʾJSPҳ��ĳ����к�
	ע�⣺�˹��ܽ���Resin��������Ч��
	���Ҫ��WebӦ�����Զ���ĳ���쳣�ľ�����ʾ���ݣ�
	�����ڱ�Ŀ¼�½�һ��<�쳣��ȫ��>.jsp��errorPageҳ�棬���и���exception������ʾ��Ӧ���ݡ�
	��ҳ������ڵ�һ��ʹ��
	exception = request.getAttribute("exception")
	�ķ�ʽ����ȡ��Ҫ������쳣
	��ע�⣬���쳣�������ĳ������ڲ���Ļ�������.�ָ����ƶ���ʹ��$��
	�Է�ֹLinux�²��ܶ�ȡ��$�ַ����ļ�����
	���磺����ҳ�����java.lang.NullPointerExceptionʱ��ʾ�ض������ݣ��ɱ�дһ��
	./java.lang.NullPointerException.jsp
	����ʾ���ɼ��ϸ������û�����ͼƬ��ɫ�ʵȵȡ�
	���쳣�ļ̳в���ϣ�Խ����Ĵ���ҳ��Խ���ȡ�
	���磺./Ŀ¼����java.lang.Exception.jsp��java.lang.RuntimeException.jsp����ҳ�棬
	����һ����̬�쳣����java.lang.NullPointerException������ʱ��
	����ʹ��java.lang.RuntimeException.jsp���������java.lang.Exception.jsp��

	�������ĳ�쳣��ҳ�淢��Ӧ��תΪ������һ���쳣
	�����类һЩ�����쳣��װ����ԭʼ�쳣���������°�װΪ��һ�쳣����
	�ٶ�Ϊ anotherException
	�������ӻش�exception֮ǰ����request�ġ�exception�����ԣ��磺
	request.setAttribute("exception", anotherException);
	throw exception; //����errorPage��������鴦��anotherException

	��ʾһ�����ʹ��һ��./java.lang.Exception.jspҳ�棬����ȫ���α�ҳ���Ĭ����ʾ��
	��Ϊ���е��쳣�඼��java.lang.Throwable�����ࡣ��Ҫ�Ļ�����������дһ��java.lang.Error.jsp��
	��ʾ�������ĳ�������쳣��ҳ������������쳣���򱾻��ƽ��ں�̨��ӡ�����쳣��
	�����Ҹ����쳣�Ĵ���ҳ�棬ֱ�����յ��ﱾҳ��
	��ʾ������������ض��쳣��ҳ�治�봦����쳣�������ӳ�ԭ�쳣����ҳ�����ճ���������
	��ʾ�ģ������ض��쳣��ҳ���ʹ������requestScope���ԣ�exception��stackTrace
--%>

<%
	System.out.println("\n");
	System.out.println("---------- START OF \"Error Page\" ----------");


	if (exception == null) {
		exception = (Throwable) request.getAttribute("exception");
	}

	if (exception == null) {
		exception = new Throwable("No errors.");

		request.setAttribute("_SOURCE_PAGE_", this);
	}


	// ��̨��ӡ���ò���
	System.out.println("***** Parameter: *****");

	for (Iterator iterator = request.getParameterMap().entrySet().iterator(); iterator.hasNext(); ) {
		Map.Entry entry = (Map.Entry) iterator.next();

		System.out.println(entry.getKey() + "=" + Arrays.asList(((String[]) entry.getValue())));
	}


	// ����stackTrace���ַ���������������resin�Զ�ת��JSP�к�
	System.out.println("");
	System.out.println("***** Stack Trace: *****");

	Object srcPage = request.getAttribute("_SOURCE_PAGE_");

	System.out.println("srcPage: " + srcPage);

	StringWriter stringWriter = new StringWriter();
	PrintWriter printWriter = new PrintWriter(stringWriter, true);

	exception.printStackTrace();

	if (srcPage == null) {
		exception.printStackTrace(printWriter);
	} else {
		try {
			//com.caucho.java.ScriptStackTrace.printStackTrace(exception,pw); // Resin-3.0.4

			Method method = srcPage.getClass().getMethod("_caucho_getLineMap", new Class[]{});

			Object lineMap = method.invoke(srcPage, new Object[]{});

			method = lineMap.getClass().getMethod("printStackTrace", new Class[]{Throwable.class, PrintWriter.class});

			method.invoke(lineMap, new Object[]{exception, printWriter});
		} catch (Exception e) { // Resin�к�ת�����ɹ���ֱ�Ӵ�stackTrace
			exception.printStackTrace(printWriter);
		}
	}

	String stackTrace = stringWriter.toString();

	request.setAttribute("stackTrace", stackTrace);

	request.setAttribute("exception", exception);

	Class cls = exception.getClass();

	Throwable originalException = exception;

	while (cls != null && cls != Throwable.class) { // �ݹ����Ƿ��к��ʵ��쳣����ҳ��
		String s = cls.getName();

		//System.out.println("errorPage: checking " + s);

		s = s.replace('$', '.'); // ����Linux�²��ܶ�ȡ��'$'���ŵ��ļ���

		s = "/WEB-INF/jsp/" + s + ".jsp";

		if (application.getResource(s) != null) {
			try { // ��ҳ�����
				response.setStatus(200);

				pageContext.include(s);

				return;
			} catch (IOException e) {
			} catch (Throwable e) {
				Throwable cause = e;

				if (e instanceof ServletException) {
					cause = ((ServletException) e).getRootCause();
				}

				if (e != exception && cause != exception) {
					try {
						out.clearBuffer();
					} catch (IOException ex2) {
						ex2.printStackTrace();
					}

					System.err.println("�����쳣��ҳ�� [" + s + "] �������쳣��");
					System.err.println(cause);

					cause.printStackTrace();
				} else { // ����Ƿ����쳣�ض���
					Throwable redirectEx = (Throwable) request.getAttribute("exception");

					if (redirectEx != null && redirectEx != exception) { // ���쳣ҳ��������쳣ת������
						exception = redirectEx;

						cls = redirectEx.getClass();

						continue;
					}
				}
			}
		}

		cls = cls.getSuperclass();
	}


	// �Ҳ������ʵĴ���ҳ�棬��������ı�׼����

	// ������û���δ��ʾ��ҳ��ʱ��ת�������쳣�������
	if ((exception instanceof IOException) && (0 <= stackTrace.indexOf("java.net.SocketOutputStream.socketWrtite("))) {
		return;
	}

	// �������RuntimeException��ֱ���ӳ���Exception��ʾ��Ϣ���ں�̨��ӡ��־���Ա����
	cls = exception.getClass();

	if (cls != Exception.class && cls != Throwable.class && !(exception instanceof RuntimeException)) {
		response.setStatus(500);

		System.out.println("EXCEPTION! " + new Timestamp(System.currentTimeMillis()) + " "
			+ request.getAttribute("javax.servlet.forward.request_uri") + "?" + request.getAttribute("javax.servlet.forward.query_string")
			+ ": " + exception
			+ "\nReferer=" + request.getHeader("Referer")
			+ "\nIP=" + request.getHeader("X-Forward-For") + "/" + request.getRemoteAddr()
		);

		System.err.println(stackTrace);
	}


	// ������Ĭ�ϵ���ʾ������Ϣ�Ľ���
	if (exception.getClass().equals(Exception.class) || exception.getClass().equals(RuntimeException.class)) {
		response.setDateHeader("Expires", 0);

		//Ӧ����ʾ��ʹ�õ�������
		//ǰ���˫б����Ϊ����ʹ��javascript��ʽ����ʱҲ����ʾ��ʾ������javascript����
%>

<script type="text/javascript">
	//window.history.back(); // ҳ���ִ�з��أ���javascript���ò����أ���ע�ͣ�

	alert("<%= exception.getMessage().replaceAll("\"", "\\\\\"").replaceAll("[\\n]", "\\\\n").replaceAll("<", "<\"+\"") %>");
</script>

<%
		return;
	}


	System.out.println("---------- END OF   \"Error Page\" ----------");
	System.out.println("\n");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB2312" />
<title>����</title>
<meta name="description" content="" />
<meta name="keywords" content="" />
</head>

<body>

500

<%--
<%
	// debug
	if (
		//NumberUtils.toLong(String.valueOf(session.getAttribute("_admin_id"))) > 0
		Functions.cookie("_st_", request) != null
	) {
%>

<pre><%= originalException.getMessage() %></pre>

<pre><%= "(" + originalException.getClass().getName() + " @ " + new Timestamp(System.currentTimeMillis()) + ")" %></pre>

<pre><%= stackTrace %></pre>

<%
	}
%>
--%>

</body>
</html>
