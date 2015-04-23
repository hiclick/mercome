/**
 * READONLY
 */
/*
 * Copyright 1997-2012
 *
 * http://www.pconline.com.cn
 *
 */
//package org.gelivable.dao;
package com.mercome.activity.repository;

import java.util.ArrayList;
import java.util.List;

/**
 * @author chenxiaohu
 */
public class SqlBuilder {
	protected StringBuilder sqlBuf = new StringBuilder();
	protected List values = new ArrayList();

	public SqlBuilder appendSql(String sql) {
		sqlBuf.append(sql);
		return this;
	}

	public SqlBuilder appendValue(Object value) {
		sqlBuf.append('?');
		values.add(value);
		return this;
	}

	public SqlBuilder appendValues(Object[] values) {
		sqlBuf.append('(');
		for (int i = 0, c = values.length; i < c; ++i) {
			sqlBuf.append('?').append(',');
			this.values.add(values[i]);
		}
		int last = sqlBuf.length() - 1;
		if (last > 0 && sqlBuf.charAt(last) == ',') {
			sqlBuf.setCharAt(last, ')');
		}

		return this;
	}

	public String getSql() {
		return sqlBuf.toString();
	}

	public Object[] getValues() {
		return values.toArray();
	}

	public boolean hasValue() {
		return !values.isEmpty();
	}
}
