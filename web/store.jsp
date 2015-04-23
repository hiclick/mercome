<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ include file="/WEB-INF/jsp/_import.jspf" %>

<%@ page import="com.mercome.activity.domain.Province" %>
<%@ page import="com.mercome.activity.service.GenericService" %>
<%@ page import="com.mercome.activity.util.EnvUtils" %>

<%@ page import="java.util.List" %>

<%
	/* ... */
	GenericService genericService = EnvUtils.getEnv().getBean(GenericService.class);
	request.setAttribute("genericService", genericService);

	/* province */
	List<Province> province_list = genericService.list(Province.class, "");
	request.setAttribute("province_list", province_list);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<%@ include file="/_seo.jspf" %>

<link rel="stylesheet" type="text/css" href="<c:url value='/css/style.css' />" />

<script type="text/javascript">
var _nav_index = 2;
</script>
</head>

<body>
<div id="main">
<div id="container">

<%@ include file="/_header.jspf" %>
<%@ include file="/_navbar.jspf" %>

<div class="banner">
	<ul>
		<li style="background-image: url(images/1920x370-1.jpg);"></li>
	</ul>
</div>

<div id="content">
	<ul class="menu">
		<li><a href="<c:url value='/b2c.jsp' />">电商</a></li>
		<li><a href="<c:url value='/store.jsp' />" class="current">实体店</a></li>
	</ul>

	<div class="platform">
		<div class="breadcrumb"></div>
		<div class="store">
			<div class="tip">请在搜索框选择需要查询苗蔻实体店或柜台的地区</div>
			<form action="" method="post" class="search" id="search-frm">
				<select name="provinceId" class="select" id="search-province">
					<option value="" selected="selected">省份/直辖市</option>
					<c:forEach var="item" items="${province_list}" varStatus="status">
						<option value="${item.provinceId}">${item.name}</option>
					</c:forEach>
				</select>
				<select name="cityId" class="select" id="search-city">
					<option value="" selected="selected">城市/地区</option>
				</select>
				<input type="text" name="keyword" value="" class="text" />
				<span class="submit" id="search-submit">查询</span>
			</form>
			<img src="images/loading.gif" alt="" class="loading" />
			<ul class="error"></ul>
			<div class="result"></div>
			<div id="map"></div>
		</div>
	</div>
</div>

<%@ include file="/_footer.jspf" %>

</div>
</div>

<%@ include file="/_script.jspf" %>

<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=79158eadd1989145aa6c192476ecc5bc"></script>

<script type="text/javascript">


$(function() {

	// 百度地图
	var _map = new BMap.Map("map");

	//_map.addControl(new BMap.CopyrightControl());
	//_map.addControl(new BMap.GeolocationControl());
	_map.addControl(new BMap.MapTypeControl({type: BMAP_MAPTYPE_CONTROL_MAP}));
	_map.addControl(new BMap.NavigationControl());
	_map.addControl(new BMap.OverviewMapControl());
	//_map.addControl(new BMap.PanoramaControl());
	_map.addControl(new BMap.ScaleControl());

	_map.centerAndZoom("北京");
	_map.enableScrollWheelZoom();

	var _local = new BMap.LocalSearch(_map, {
		renderOptions: {map: _map}
	});
	//_local.search("上海");


	//
	var
	_result = $("div.result");


	// cascade
	$("#search-province").change(function() {
		$.ajax({
			type: "POST",
			url: "action/do_store.jsp",
			data: {
				method: "city",
				provinceId: $(this).val()
			},
			dataType: "json",
			success: function(data) {
				var
				data = data.rows,
				html = "";
				for (var i = 0, item; i < data.length; i++) {
					item = data[i];
					html += '<option value="' + item["cityId"] + '">' + item["name"] + '</option>';
				}
				$("#search-city").find("option:gt(0)").remove().end().append(html);
			},
			error: function(xhr) {
				//alert("错误：" + xhr.status + " " + xhr.statusText);
			}
		});
	});


	// search
	var _search = {
		form: $("#search-frm"),
		submit: $("#search-submit")
	};

	_search.submit.click(function() {
		_search.form.submit();
	});

	_search.form.resetForm().validate({
		onclick: false,
		onfocusout: false,
		onkeyup: false,
		errorLabelContainer: "ul.error",
		wrapper: "li",
/*
		showErrors: function(errorMap, errorList) {
			//this.defaultShowErrors();
			var msg = "";
			if (errorList.length > 0) {
				for (var key in errorMap) {
					msg += errorMap[key] + '\n';
				}
				alert(msg)
			}
		},
*/
		rules: {
			"provinceId": {
				required: true
			},
			"cityId": {
				//required: true
			},
			"keyword": {
				//required: true
			}
		},
		messages: {
			"provinceId": {
				required: "请选择省份/直辖市"
			},
			"cityId": {
				required: ""
			},
			"keyword": {
				required: ""
			}
		},
		submitHandler: function(form) {
			$(form).ajaxSubmit({
				type: "POST",
				url: "action/do_store.jsp",
				data: {
					method: "search"
				},
				dataType: "json",
				beforeSend: function() {
					//$jq.disableSubmit(form, true);

					_result.empty();
					$("#map").css("visibility", "hidden");
					$(".loading").show();
					_search.submit.unbind("click").addClass("disable");
				},
				complete: function() {
					//$jq.disableSubmit(form, false);

					$(".loading").hide();
					_search.submit.click(function() {
						_search.form.submit();
					}).removeClass("disable");
				},
				success: function(data) {
					var
					data = data.rows,
					html= "";
					if (data.length > 0) {
						for (var i = 0, item; i < data.length; i++) {
							item = data[i];
							html += '<dl><dt>· ' + item["name"] + '</dt><dd>&nbsp;&nbsp;' + item["address"] + '</dd></dl>';
						}
					} else {
						html= '<div style="margin-top: 20px;">暂无</div>';
					}
					_result.empty().append(html);
				},
				error: function(xhr) {
					//alert("错误：" + xhr.status + " " + xhr.statusText);
				}
			});
		}
	});

	$("dt", _result).live("click", function() {
		$("#map").css("visibility", "visible");
		_local.search($(this).next("dd").text());
	});

});
</script>
</body>
</html>
