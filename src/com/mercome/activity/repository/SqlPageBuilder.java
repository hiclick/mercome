/**
 * READONLY
 */
package com.mercome.activity.repository;

/**
 * Maintained by: 4what
 *
 * @author xhchen
 */
public interface SqlPageBuilder {
	String buildPageSql(String sql, int pageNo, int pageSize);
}
