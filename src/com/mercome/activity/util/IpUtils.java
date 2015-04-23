/**
 * READONLY
 */
package com.mercome.activity.util;

import javax.servlet.http.HttpServletRequest;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Enumeration;

/**
 * Maintained by: 4what
 */
public class IpUtils {
	private static String localIp;

	static {
		localIp = getLocalAddress();
	}

	public static String getIp() {
		return localIp;
	}

	public static String getIp(HttpServletRequest request) {
		String ip;
		String forwarded = request.getHeader("X-Forwarded-For");
		String realIp = request.getHeader("X-Real-IP");
		String remoteAddr = request.getRemoteAddr();
		if (realIp == null) {
			if (forwarded == null) {
				ip = remoteAddr;
			} else {
				ip = remoteAddr + "/" + forwarded;
			}
		} else {
			if (realIp.equals(forwarded)) {
				ip = realIp;
			} else {
				ip = realIp + "/" + forwarded.replaceAll(", " + realIp, "");
			}
		}
		return ip;
	}

	public static String getLocalAddress() {
		String result = null;
		Enumeration enu;
		try {
			enu = NetworkInterface.getNetworkInterfaces();
		} catch (SocketException e) {
			return "localhost";
		}
		while (enu.hasMoreElements()) {
			NetworkInterface ni = (NetworkInterface) enu.nextElement();
			Enumeration ias = ni.getInetAddresses();
			while (ias.hasMoreElements()) {
				InetAddress i = (InetAddress) ias.nextElement();
				String addr = i.getHostAddress();
				if (addr.startsWith("192.")) {
					return addr;
				}
			}
		}
		return result;
	}
}
