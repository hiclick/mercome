/**
 * READONLY
 */
package com.mercome.activity.util;

/*
import cn.pconline.passport2.Account;
import cn.pconline.passport2.Passport;
import cn.pconline.passport2.Session;
import cn.pconline.security2.authentication.Client;
import cn.pconline.security2.authentication.UserInfo;
import cn.pconline.security2.authorization.AdminSession;
import cn.pconline.security2.authorization.Facade;
*/

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.simple.SimpleJdbcTemplate;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.PageContext;

/**
 * Maintained by: 4what
 *
 * @author xhchen
 */
public class Env {
	/*
	 * servlet
	 */
	private PageContext pageContext;

	private HttpServletRequest request;

	private HttpServletResponse response;

	private ServletContext servletContext;

	public PageContext getPageContext() {
		return pageContext;
	}

	public void setPageContext(PageContext pageContext) {
		this.pageContext = pageContext;
	}

	public HttpServletRequest getRequest() {
		return request;
	}

	public void setRequest(HttpServletRequest request) {
		this.request = request;
	}

	public HttpServletResponse getResponse() {
		return response;
	}

	public void setResponse(HttpServletResponse response) {
		this.response = response;
	}

	public ServletContext getServletContext() {
		return servletContext;
	}

	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;
	}


	/*
	 * log
	 */
	private Collector collector = new Collector();

	private long startTime = System.currentTimeMillis();

	private int databaseReadTimes = 0;

	private int databaseUpdateTimes = 0;

	private int cacheReadTimes = 0;

	private int cacheUpdateTimes = 0;

	public int getDbRead() {
		return databaseReadTimes;
	}

	public int getDbUpdate() {
		return databaseUpdateTimes;
	}

	public void startDatabaseRead(String sql) {
		databaseReadTimes++;
		collector.start("DR:" + sql);
	}

	public void startDatabaseUpdate(String sql) {
		databaseUpdateTimes++;
		collector.start("DU:" + sql);
	}

	public void stopDatabaseOperation() {
		collector.stop();
	}

	public int getCacheRead() {
		return cacheReadTimes;
	}

	public int getCacheUpdate() {
		return cacheUpdateTimes;
	}

	public void startCacheRead(String key) {
		cacheReadTimes++;
		collector.start("CR:" + key);
	}

	public void startCacheUpdate(String key) {
		cacheUpdateTimes++;
		collector.start("CU:" + key);
	}

	public void stopCacheOperation() {
		collector.stop();
	}

	public String getLogString() {
		StringBuilder sb = new StringBuilder();
		sb.append(request.getRequestURI()).append(",");
		sb.append(System.currentTimeMillis() - startTime).append(",");
		sb.append("DR").append(databaseReadTimes);
		sb.append("DU").append(databaseUpdateTimes);
		sb.append("CR").append(cacheReadTimes);
		sb.append("CU").append(cacheUpdateTimes).append(",");
		sb.append(request.getRemoteAddr()).append("\n");
		sb.append(collector.toString());
		return sb.toString();
	}


	/*
	 * Spring
	 */
	public WebApplicationContext getApplicationContext() {
		if (request != null) {
			return WebApplicationContextUtils.getWebApplicationContext(servletContext);
		} else {
			return null;
		}
	}

	public <T> T getBean(Class<T> type) {
		return getApplicationContext().getBean(type);
	}

	public <T> T getBean(String beanName, Class<T> type) {
		return getApplicationContext().getBean(beanName, type);
	}

	public JdbcTemplate getJdbcTemplate() {
		WebApplicationContext ctx = getApplicationContext();
		return (JdbcTemplate) ctx.getBean("jdbcTemplate");
	}

	public SimpleJdbcTemplate getSimpleJdbcTemplate() {
		WebApplicationContext ctx = getApplicationContext();
		return (SimpleJdbcTemplate) ctx.getBean("simpleJdbcTemplate");
	}

	public TransactionTemplate getTransactionTemplate() {
		WebApplicationContext ctx = getApplicationContext();
		PlatformTransactionManager transactionManager = (PlatformTransactionManager) ctx.getBean("transactionManager");
		return new TransactionTemplate(transactionManager);
	}


	/*
	 * admin
	 */
/*
	private Admin admin;

	private boolean adminLoaded = false;

	public Admin getAdmin() {
		if (admin == null && !adminLoaded) {
			adminLoaded = true;
			AdminSession session = Facade.recognize(request);
			if (session != null) {
				GenericRepository genericRepository = getBean(GenericRepository.class);
				String id = session.getUserId();
				try {
					admin = genericRepository.find(Long.parseLong(id), Admin.class);
				} catch (EmptyResultDataAccessException e) {
					UserInfo userInfo = Client.getUser(id);
					admin = new Admin();
					admin.setAdminId(Long.parseLong(id));
					admin.setAccount(userInfo.getAccount());
					admin.setName(userInfo.getName());
					admin.setCreateDate(new Date());
					genericRepository.create(admin);
				}
			} else {
				admin = Admin.EMPTY_ADMIN;
			}
		}
		return admin;
	}
*/


	/*
	 * user
	 */
/*
	private User user;

	private boolean userLoaded = false;

	public User getUser() {
		if (user == null && !userLoaded) {
			userLoaded = true;
			Passport passport = getBean(Passport.class);
			Session session = passport.recognize(request, response);
			if (session != null) {
				GenericRepository genericRepository = getBean(GenericRepository.class);
				long id = session.getAccountId();
				try {
					user = genericRepository.find(id, User.class);
				} catch (EmptyResultDataAccessException e) {
					Account account = passport.getAccount(id);
					user = new User();
					user.setUserId(id);
					user.setUsername(account.getAccountName());
					user.setEmail(account.getEmail());
					user.setIp(getIp());
					user.setCreateDate(new Date());
					genericRepository.create(user);
				}
			} else {
				user = User.EMPTY_USER;
			}
		}
		return user;
	}
*/


	/*
	 * ip
	 */
	private String ip = null;

	public String getIp() {
		if (ip == null) {
			ip = IpUtils.getIp(request);
		}
		return ip;
	}


	/*
	 * root
	 */
	public String getRoot() {
		return "http://" + getRequest().getHeader("host") + getRequest().getContextPath();
	}
}
