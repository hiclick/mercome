/**
 * READONLY
 */
package com.mercome.activity.repository;

import com.mercome.activity.Config;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Maintained by: 4what
 *
 * @author xhchen
 */
public class ORMHelper {
	private String tablePrefix = Config.TABLE_PREFIX;

	private ConcurrentHashMap<Class, List<String>> metaMap = new ConcurrentHashMap<Class, List<String>>();

	private ConcurrentHashMap<Class, Method> methodMap = new ConcurrentHashMap<Class, Method>();

	public ORMHelper(String tablePrefix) {
		this.tablePrefix = tablePrefix;
	}

	public String getCreateSql(Class type, long id) {
		String key = getKey(type);
		StringBuilder sb = new StringBuilder();
		sb.append("INSERT INTO ").append(getTableName(type)).append(" (");
		List<String> fieldList = getFieldList(type);
		for (String field : fieldList) {
			sb.append(field).append(",");
		}
		sb.setCharAt(sb.length() - 1, ')');
		sb.append(" VALUES (");
		for (String field : fieldList) {
			if (key.equalsIgnoreCase(field)) {
				sb.append(id).append(",");
			} else {
				sb.append(":").append(field).append(",");
			}
		}
		sb.setCharAt(sb.length() - 1, ')');
		return sb.toString();
	}

	public String getDeleteSql(Class type) {
		String key = getKey(type);
		StringBuilder sb = new StringBuilder();
		sb.append("DELETE FROM ").append(getTableName(type));
		List<String> fieldList = getFieldList(type);
		for (String field : fieldList) {
			if (key.equalsIgnoreCase(field)) {
				key = field;
				break;
			}
		}
		sb.append(" WHERE ").append(key).append("=:").append(key);
		return sb.toString();
	}

	public List<String> getFieldList(Class type) {
		List<String> result = metaMap.get(type);
		if (result == null) {
			result = new ArrayList<String>();
			Field[] fields = type.getDeclaredFields();
			for (Field field : fields) {
				if (!Modifier.isTransient(field.getModifiers())) {
					result.add(field.getName());
				}
			}
			metaMap.put(type, result);
		}
		return result;
	}

	public String getKey(Class type) {
		return type.getSimpleName().toLowerCase() + "Id";
	}

	public long getObjectId(Object obj) throws Exception {
		Method method = methodMap.get(obj.getClass());
		if (method == null) {
			String methodName = "get" + obj.getClass().getSimpleName() + "Id";
			method = obj.getClass().getMethod(methodName);
			methodMap.put(obj.getClass(), method);
		}
		return (Long) method.invoke(obj);
	}

	public String getTableName(Class type) {
		return tablePrefix + type.getSimpleName().toLowerCase();
	}

	public String getUpdateSql(Class type) {
		String key = getKey(type);
		StringBuilder sb = new StringBuilder();
		sb.append("UPDATE ").append(getTableName(type));
		sb.append(" SET ");
		List<String> fieldList = getFieldList(type);
		for (String field : fieldList) {
			if (!key.equalsIgnoreCase(field)) {
				sb.append(field).append("=:").append(field).append(",");
			} else {
				key = field;
			}
		}
		sb.setCharAt(sb.length() - 1, ' ');
		sb.append("WHERE ").append(key).append("=:").append(key);
		return sb.toString();
	}

	public boolean needCache(Class type) {
		try {
			return (Boolean) type.getMethod("needCache").invoke(null);
		} catch (Exception e) {
			return false;
		}
	}
}
