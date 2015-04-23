/**
 * READONLY
 */
package com.mercome.activity.service;

import com.mercome.activity.Config;
import com.mercome.activity.domain.Pager;
import com.mercome.activity.repository.GenericRepository;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @author 4what
 */
@Service
public class GenericService {
	@Autowired
	private GenericRepository genericRepository;

	/**
	 * @param t
	 * @param <T>
	 * @return
	 */
	public <T> long create(T t) {
		return genericRepository.create(t);
	}

	/**
	 * @param t
	 * @param <T>
	 */
	public <T> void delete(T t) {
		genericRepository.delete(t);
	}

	/**
	 * @param cls
	 * @param id
	 */
	public <T> void delete(Class<T> cls, long id) {
		genericRepository.delete(id, cls);
	}

	/**
	 * @param t
	 * @param <T>
	 */
	public <T> void update(T t) {
		genericRepository.update(t);
	}

	/**
	 * @param cls
	 * @param id
	 * @return
	 */
	public <T> T find(Class<T> cls, long id) {
		return genericRepository.find(id, cls);
	}

	/**
	 * TODO: DRY
	 *
	 * @param cls
	 * @param query
	 * @param params
	 * @param <T>
	 * @return
	 */
	public <T> int count(Class<T> cls, String query, Map<String, Object> params) {
		String className = cls.getSimpleName().toLowerCase();
		String table = Config.TABLE_PREFIX + className;

		return genericRepository.count("SELECT COUNT(*) FROM " + table + (StringUtils.isNotBlank(query) ? (" " + query) : ""), params);
	}

	/**
	 * TODO: DRY
	 *
	 * @param cls
	 * @param query
	 * @param args
	 * @param <T>
	 * @return
	 */
	public <T> int count(Class<T> cls, String query, Object... args) {
		String className = cls.getSimpleName().toLowerCase();
		String table = Config.TABLE_PREFIX + className;

		return genericRepository.count("SELECT COUNT(*) FROM " + table + (StringUtils.isNotBlank(query) ? (" " + query) : ""), args);
	}

	/**
	 * TODO: DRY
	 *
	 * @param cls
	 * @param query
	 * @param params
	 * @param <T>
	 * @return
	 */
	public <T> List<T> list(Class<T> cls, String query, Map<String, Object> params) {
		String className = cls.getSimpleName().toLowerCase();
		String table = Config.TABLE_PREFIX + className;

		query = StringUtils.isNotBlank(query) ? (" " + query) : (" ORDER BY " + className + "id ASC");

		return genericRepository.list(cls, "SELECT * FROM " + table + query, params);
	}

	/**
	 * TODO: DRY
	 *
	 * @param cls
	 * @param query
	 * @param args
	 * @param <T>
	 * @return
	 */
	public <T> List<T> list(Class<T> cls, String query, Object... args) {
		String className = cls.getSimpleName().toLowerCase();
		String table = Config.TABLE_PREFIX + className;

		query = StringUtils.isNotBlank(query) ? (" " + query) : (" ORDER BY " + className + "id ASC");

		return genericRepository.list(cls, "SELECT * FROM " + table + query, args);
	}

	/**
	 * TODO: DRY
	 *
	 * @param cls
	 * @param query
	 * @param pageNo
	 * @param pageSize
	 * @param params
	 * @param <T>
	 * @return
	 */
	public <T> Pager<T> pager(Class<T> cls, String query, int pageNo, int pageSize, Map<String, Object> params) {
		String className = cls.getSimpleName().toLowerCase();
		String table = Config.TABLE_PREFIX + className;

		query = StringUtils.isNotBlank(query) ? (" " + query) : (" ORDER BY " + className + "id ASC");

		Pager<T> pager = new Pager<T>();
		pager.setPageNo(pageNo);
		pager.setPageSize(pageSize);
		pager.setResultList(genericRepository.page(cls, "SELECT * FROM " + table + query, pageNo, pageSize, params));
		pager.setTotal(genericRepository.count("SELECT COUNT(*) FROM " + table + query, params));

		return pager;
	}

	/**
	 * TODO: DRY
	 *
	 * @param cls
	 * @param query
	 * @param pageNo
	 * @param pageSize
	 * @param args
	 * @param <T>
	 * @return
	 */
	public <T> Pager<T> pager(Class<T> cls, String query, int pageNo, int pageSize, Object... args) {
		String className = cls.getSimpleName().toLowerCase();
		String table = Config.TABLE_PREFIX + className;

		query = StringUtils.isNotBlank(query) ? (" " + query) : (" ORDER BY " + className + "id ASC");

		Pager<T> pager = new Pager<T>();
		pager.setPageNo(pageNo);
		pager.setPageSize(pageSize);
		pager.setResultList(genericRepository.page(cls, "SELECT * FROM " + table + query, pageNo, pageSize, args));
		pager.setTotal(genericRepository.count("SELECT COUNT(*) FROM " + table + query, args));

		return pager;
	}
}
