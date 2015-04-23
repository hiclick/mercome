/**
 * READONLY
 */
package com.mercome.activity.util;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Maintained by: 4what
 *
 * @author xhchen
 */
public class EnvFilter implements Filter {
	private static final Log LOG = LogFactory.getLog(EnvFilter.class);

	private Map<Env, String> envMap = new ConcurrentHashMap<Env, String>();

	private ServletContext servletContext;

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		servletContext = filterConfig.getServletContext();
		servletContext.setAttribute("_envSet", envMap.keySet());
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		Env env = EnvUtils.getEnv();
		envMap.put(env, "");
		try {
			env.setRequest((HttpServletRequest) request);
			env.setResponse((HttpServletResponse) response);
			env.setServletContext(servletContext);
			request.setAttribute("env", env);
			chain.doFilter(request, response);
		} finally {
			LOG.info(env.getLogString());
			envMap.remove(env);
			EnvUtils.removeEnv();
		}
	}

	@Override
	public void destroy() {
		servletContext.removeAttribute("_envSet");
		servletContext = null;
		envMap.clear();
		envMap = null;
	}
}
