/**
 * READONLY
 */
package com.mercome.activity.service;

import $java.CommonsHttpClient;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.NameValuePair;

import java.util.HashMap;
import java.util.Map;

/**
 * @author 4what
 */
public class CommonsHttpClientService {
	private String proxyHost;
	private int proxyPort;

	public int getProxyPort() {
		return proxyPort;
	}

	public void setProxyPort(int proxyPort) {
		this.proxyPort = proxyPort;
	}

	public String getProxyHost() {
		return proxyHost;
	}

	public void setProxyHost(String proxyHost) {
		this.proxyHost = proxyHost;
	}

	/**
	 * @return
	 */
	public HttpClient getHttpClient() {
		Map proxy = new HashMap() {
			{
				put("host", proxyHost);
				put("port", proxyPort);
			}
		};

		return CommonsHttpClient.getHttpClient(proxy);
	}

	/**
	 * @param charset @Nullable
	 * @param header  @Nullable
	 * @param type
	 * @param url
	 * @param data
	 * @return
	 */
	public String request(String charset, HashMap<String, String> header, String type, String url, NameValuePair[] data) {
		Map proxy = new HashMap() {
			{
				put("host", proxyHost);
				put("port", proxyPort);
			}
		};

		String result = CommonsHttpClient.request(proxy, charset, header, type, url, data);

		return result;
	}
}
