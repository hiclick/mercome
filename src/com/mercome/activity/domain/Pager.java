/**
 * READONLY
 */
package com.mercome.activity.domain;

import java.util.List;

/**
 * Maintained by: 4what
 *
 * @param <T>
 */
public class Pager<T> {
	private int pageNo;

	private int pageSize;

	private List<T> resultList;

	private int total;


	public int getPageCount() {
		return total / pageSize + (total % pageSize == 0 ? 0 : 1);
	}


	/* getter & setter */
	public int getPageNo() {
		return pageNo;
	}

	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}

	public List<T> getResultList() {
		return resultList;
	}

	public void setResultList(List<T> resultList) {
		this.resultList = resultList;
	}
}
