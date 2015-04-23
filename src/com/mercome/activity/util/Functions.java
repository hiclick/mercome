package com.mercome.activity.util;

import com.mercome.activity.service.CommonsHttpClientService;

import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.lang.time.DurationFormatUtils;

import java.util.Date;
import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Functions {
	/**
	 * @author 4what
	 * @param birthday
	 * @return
	 */
	public static String age(long birthday) {
		return DurationFormatUtils.formatPeriod(birthday, new Date().getTime(), "y'岁'M'个月'");
	}

	/**
	 * @author 4what
	 * @return
	 */
	public static String domain() {
		return EnvUtils.getEnv().getRequest().getServerName().replaceFirst(".+?\\.(pc.+?\\.com\\.cn)$", "$1");
	}

	/**
	 * @author 4what
	 * @param url
	 * @return
	 */
	public static String httpclient(String url) {
		String charset = "GBK";

		HashMap<String, String> header = null;

		String type = "GET";

		url += (!url.contains("?") ? "?" : "&") + "timestamp=" + new Date().getTime();

		NameValuePair[] data = null;

		CommonsHttpClientService commonsHttpClientService = EnvUtils.getEnv().getBean(CommonsHttpClientService.class);

		String result = commonsHttpClientService.request(charset, header, type, url, data);

		return result;
	}

	/**
	 * @author 4what
	 * @return
	 */
	public static String href() {
		return $java.util.Functions.href(EnvUtils.getEnv().getRequest());
	}

	/**
	 * @author 4what
	 * @return
	 */
	public static String root() {
		return $java.util.Functions.root(EnvUtils.getEnv().getRequest());
	}

	/**
	 * @author 4what
	 * @return
	 */
	public static String site() {
		return EnvUtils.getEnv().getRequest().getServerName().replaceFirst(".+?\\.pc(.+?)\\.com\\.cn$", "$1");
	}

	/**
	 * @author 4what
	 * @return
	 */
	public static String stripHtml(String text) {
		return text.replaceAll("<.[^<>]*?>", "").replaceAll(" | ", "");
	}


	/**
	 * @param userId
	 * @param size
	 * @return
	 */
	public static String face(long userId, String size) {
		String url = "http://i(?).3conline.com/images/upload/upc/face/";
		String id = String.valueOf(userId);
		long no = userId % 5;
		if (no == 0) {
			no = 5;
		}
		StringBuilder result = new StringBuilder(url.replace("(?)", String.valueOf(no)));
		for (int i = 0, l = id.length(); i < l; i += 2) {
			result.append(id.charAt(i));
			if (i < l - 1) {
				result.append(id.charAt(i + 1));
			}
			result.append("/");
		}
		return result.append(id).append("_").append(size).toString();
	}
}
