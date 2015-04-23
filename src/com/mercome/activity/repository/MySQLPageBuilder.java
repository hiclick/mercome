/**
 * READONLY
 */
package com.mercome.activity.repository;

/**
 * Maintained by: 4what
 *
 * @author xhchen
 */
public class MySQLPageBuilder implements SqlPageBuilder {
	@Override
	public String buildPageSql(String sql, int pageNo, int pageSize) {
		return sql + " LIMIT " + (pageNo - 1) * pageSize + "," + pageSize;
	}
}
