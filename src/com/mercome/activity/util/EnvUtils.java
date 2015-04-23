/**
 * READONLY
 */
package com.mercome.activity.util;

/**
 * Maintained by: 4what
 *
 * @author xhchen
 */
public class EnvUtils {
	private static ThreadLocal<Env> threadLocal = new ThreadLocal<Env>() {
		@Override
		protected Env initialValue() {
			return new Env();
		}
	};

	public static Env getEnv() {
		return threadLocal.get();
	}

	public static void removeEnv() {
		threadLocal.remove();
	}
}
