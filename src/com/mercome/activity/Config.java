package com.mercome.activity;

import java.util.Map;

public class Config {
	public static final String APP_NAME = "mercome";

	public static final String DATABASE = "MYSQL"; // MYSQL|ORACLE

	public static final String TABLE_PREFIX = APP_NAME + "_";

	// map
	public static Map<String, Object> map;

	public Map<String, Object> getMap() {
		return map;
	}

	public void setMap(Map<String, Object> map) {
		Config.map = map;
	}

	// proxy
	private String proxyHost;
	private String proxyPort;


	/* getter & setter */
	public String getProxyHost() {
		return proxyHost;
	}

	public void setProxyHost(String proxyHost) {
		this.proxyHost = proxyHost;
	}

	public String getProxyPort() {
		return proxyPort;
	}

	public void setProxyPort(String proxyPort) {
		this.proxyPort = proxyPort;
	}
}
