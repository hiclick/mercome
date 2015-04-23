<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ include file="/WEB-INF/jsp/_import.jspf" %>

<%

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<%@ include file="/_seo.jspf" %>

<link rel="stylesheet" type="text/css" href="<c:url value='/css/style.css' />" />

<script type="text/javascript">
var _nav_index = 3;
</script>
</head>

<body>
<div id="main">
<div id="container">

<%@ include file="/_header.jspf" %>
<%@ include file="/_navbar.jspf" %>

<div id="content">
	<div class="proxy">
		<img src="images/320x240.jpg" alt="" class
			="pic" />
		<dl>
			<dt>
				<span>
					1 认识苗蔻
				</span>
			</dt>
			<dd>
				苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻
			</dd>
		</dl>
		<dl>
			<dt>
				<span>
					2 如何加盟代理
				</span>
			</dt>
			<dd>
				苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻
				苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻苗蔻
			</dd>
		</dl>
		<div class="tip">
			* 请填写如下基本信息
		</div>
		<form action="" method="post" id="proxy-frm">
			<p>
				<label>姓名：</label><input type="text" name="name" value="" class="text" />
			</p>
			<p>
				<label>座机电话：</label><input type="text" name="tel" value="" class="text" />
			</p>
			<p>
				<label>邮箱：</label><input type="text" name="email" value="" class="text" />
			</p>
			<p>
				<label>目前代理品牌：</label><input type="text" name="brand" value="" class="text" />
			</p>
			<p>
				<label>性别：</label>
				<select name="gender" class="select">
					<option value="1" selected="selected">男</option>
					<option value="0">女</option>
				</select>
			</p>
			<p>
				<label>手机：</label><input type="text" name="mobile" value="" class="text" />
			</p>
			<p>
				<label>地址：</label><input type="text" name="address" value="" class="text" style="width: 30em;" />
			</p>
			<p>
				<label>&nbsp;</label><span class="submit" id="proxy-submit">提交</span>
				<img src="images/loading.gif" alt="" class="loading" />
			</p>
		</form>
	</div></div>

<%@ include file="/_footer.jspf" %>

</div>
</div>

<%@ include file="/_script.jspf" %>

<script type="text/javascript">
$(function() {

	// proxy
	var _proxy = {
		form: $("#proxy-frm"),
		submit: $("#proxy-submit")
	};

	_proxy.submit.click(function() {
		_proxy.form.submit();
	});

	_proxy.form.resetForm().validate({
		rules: {
			"name": {
				required: true,
				isChinese: true
			},
			"address": {
				required: true
			},
			"email": {
				required: true,
				email: true
			},
			"gender": {
				required: true
			},
			"mobile": {
				required: true,
				isMobile: true
			},
			"tel": {
				required: true,
				isTel: true
			},
			"brand": {
				required: true
			}
		},
		submitHandler: function(form) {
			$(form).ajaxSubmit({
				type: "POST",
				url: "action/do_proxy.jsp",
				data: {
					method: "insert"
				},
				dataType: "json",
				beforeSend: function() {
					//$jq.disableSubmit(form, true);

					$(".loading").show();
					_proxy.submit.unbind("click").addClass("disable");
				},
				complete: function() {
					//$jq.disableSubmit(form, false);

					$(".loading").hide();
					_proxy.submit.click(function() {
						_proxy.form.submit();
					}).removeClass("disable");
				},
				success: function(data) {
					var msg = data.msg;
					switch (msg) {
						case "success":
							alert("操作成功");
							window.location.reload();
							break;
						case "exist":
							alert("重复提交");
							break;
						default:
							alert(msg);
							break;
					}
				},
				error: function(xhr) {
					alert("错误：" + xhr.status + " " + xhr.statusText);
				}
			});
		}
	});

});
</script>
</body>
</html>
