<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ include file="/WEB-INF/jsp/_import.jspf" %>
<%@ include file="/admin/_auth.jspf" %>

<%@ page import="java.util.Date" %>

<%

%>

<!--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">-->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<meta name="author" content="4what" />

<%--<link rel="shortcut icon" href="favicon.ico" />--%>

<%@ include file="_script.jspf" %>

<script type="text/javascript">
Ext.onReady(function() {

	// nav
	var _nav = new Ext.Panel({
		region: "west",
		title: "后台管理系统",
		collapseMode: "mini",
		collapsible: true,
		//iconCls: "icon-logo",
		layout: {
			type: "accordion",
			animate: true
		},
		split: true,
		width: 200,
		defaults: {
			xtype: "treepanel",
			autoScroll: true,
			border: false,
			containerScroll: true,
			rootVisible: false,
			useArrows: true,
			listeners: {
				click: function(node, e) {
					$ext.tab.loadOnClickLeaf(node, e, _main, {
						iconCls: "icon-grid"
					});
				}
			}
		},
		items: [
			// 自定义
			{
				title: "控制面板",
				iconCls: "icon-ctrl",
				root: {
					expanded: true,
					children: [
						{
							text: "网站管理",
							iconCls: "icon-component",
							expanded: true,
							singleClickExpand: true,
							children: [
								{
									text: "产品",
									leaf: true,
									href: "product.jsp"
								},
								{
									text: "文章",
									leaf: true,
									href: "article.jsp"
								},
								{
									text: "电商",
									leaf: true,
									href: "b2c.jsp"
								},
								{
									text: "实体店",
									leaf: true,
									href: "store.jsp"
								},
								{
									text: "代理",
									leaf: true,
									href: "proxy.jsp"
								},
							]
						},
						{
							text: "系统配置",
							iconCls: "icon-folder-setting",
							singleClickExpand: true,
							children: [
								{
									text: "设置管理",
									leaf: true,
									href: "setting.jsp"
								},
								{
									text: "系统日志",
									leaf: true,
									href: "log.jsp"
								},
								{
									text: "调试日志",
									leaf: true,
									href: "debug.jsp"
								}
							]
						},
						{
							text: "帐户管理",
							iconCls: "icon-group",
							leaf: true,
							href: "admin.jsp"
						}
					]
				}
			},
			{
				title: "帮助文档",
				iconCls: "icon-doc",
				root: {}
			}
		],
		tbar: {
			items: [
				{
					text: '<span title="${_admin.username}">' + Ext.util.Format.ellipsis("${_admin.username}", 20) + '</span>',
					xtype: "tbtext",
					cls: "icon-user icon-text"
				},
				"->",
				{
					text: "退出",
					xtype: "button",
					iconCls: "icon-logout",
					handler: function(button, e) {
						// 自定义
						window.location.href = "logout.jsp";
					}
				}
			]
		},
		bbar: {
			buttonAlign: "right",
			items: [
				{
					xtype: "button",
					iconCls: "icon-expand",
					handler: function(button, e) {
						$ext.tree.toggle(_nav, true);
					}
				},
				"-",
				{
					xtype: "button",
					iconCls: "icon-collapse",
					handler: function(button, e) {
						$ext.tree.toggle(_nav, false);
					}
				}
			]
		}
	});


	// main
	var _main = new Ext.TabPanel({
		region: "center",
		id: "main",
		activeTab: 0,
		border: false,
		enableTabScroll: true,
		plugins: new Ext.ux.TabCloseMenu(),
		items: [
			{
				title: "Welcome!",
				//closable: true,
				contentEl: "welcome",
				frame: true,
				iconCls: "icon-tab"
			}
		]
	});


	// viewport
	var _viewport = new Ext.Viewport({
		layout: "border",
		items: [
			_nav,
			_main
		]
	});


/*
	// homepage
	// 自定义
	$ext.tab.load(_main, {
		title: "主页",
		src: ".jsp",
		iconCls: "icon-grid"
	});
*/

});
</script>
</head>

<body>

<div style="display: none;">

<div id="welcome">
	<p>
		<fmt:formatDate value="<%= new Date() %>" pattern="yyyy-MM-dd HH:mm:ss" />
	</p>
</div>

</div>

</body>
</html>
