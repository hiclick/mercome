/**
 * READONLY
 */
package com.mercome.activity.repository;

import com.mercome.activity.Config;
import com.mercome.activity.cache.CacheClient;
import com.mercome.activity.util.JsonUtils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.BeanPropertySqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Maintained by: 4what
 *
 * @author xhchen
 */
@Repository
public class GenericRepository {
	@Autowired
	private SimpleJdbcTemplate simpleJdbcTemplate;

	@Autowired
	private CacheClient cacheClient;

	@Autowired
	private IdGenerator idGenerator;

	private String database = Config.DATABASE;

	private String tablePrefix = Config.TABLE_PREFIX;

	private ORMHelper orm = new ORMHelper(tablePrefix);

	private MySQLPageBuilder mySQLPageBuilder = new MySQLPageBuilder();

	private OraclePageBuilder oraclePageBuilder = new OraclePageBuilder();

	public static RowMapper<Long> idRowMapper = new RowMapper<Long>() {
		@Override
		public Long mapRow(ResultSet rs, int i) throws SQLException {
			return rs.getLong(1);
		}
	};

	public static RowMapper<Timestamp> tsRowMapper = new RowMapper<Timestamp>() {
		@Override
		public Timestamp mapRow(ResultSet rs, int i) throws SQLException {
			return rs.getTimestamp(1);
		}
	};

	public long create(Object obj) {
		String table = orm.getTableName(obj.getClass());
		String key = orm.getKey(obj.getClass());
		long id = getObjectId(obj);
		if (id == 0) { // 如果主键已经存在，不需要自动生成
			id = idGenerator.generate(table, key);
		}
		simpleJdbcTemplate.update(orm.getCreateSql(obj.getClass(), id), new BeanPropertySqlParameterSource(obj));
		return id;
	}

	public void delete(Object obj) {
		simpleJdbcTemplate.update(orm.getDeleteSql(obj.getClass()), new BeanPropertySqlParameterSource(obj));
		if (orm.needCache(obj.getClass())) {
			removeFromCache(obj, getObjectId(obj));
		}
	}

	public <T> void delete(long id, Class<T> type) {
		String sql = "DELETE FROM " + orm.getTableName(type) + " WHERE " + orm.getKey(type) + " = ?";
		simpleJdbcTemplate.update(sql, id);
		if (orm.needCache(type)) {
			String key = Config.APP_NAME + "-" + type.getSimpleName() + "-" + id;
			removeFromCache(key);
		}
	}

	public void update(Object obj) {
		simpleJdbcTemplate.update(orm.getUpdateSql(obj.getClass()), new BeanPropertySqlParameterSource(obj));
		if (orm.needCache(obj.getClass())) {
			removeFromCache(obj, getObjectId(obj));
		}
	}

	public <T> T find(long id, Class<T> type) {
		T obj = null;
		boolean needCache = orm.needCache(type);
		if (needCache) {
			obj = findFromCache(id, type);
		}
		if (obj == null) {
			obj = findFromDb(id, type);
			if (needCache) {
				putToCache(obj, type, id);
			}
		}
		return obj;
	}

	public int count(String sql, Map<String, Object> params) {
		return simpleJdbcTemplate.queryForInt(sql, params);
	}

	public int count(String sql, Object... args) {
		return simpleJdbcTemplate.queryForInt(sql, args);
	}

	public <T> List<T> list(Class<T> type, String sql, Map<String, Object> params) {
		if (orm.needCache(type)) {
			List<Long> idList = simpleJdbcTemplate.query(sql, idRowMapper, params);
			List<T> result = new ArrayList<T>();
			for (Long id : idList) {
				result.add(find(id, type));
			}
			return result;
		} else {
			BeanPropertyRowMapper<T> rm = new BeanPropertyRowMapper<T>(type);
			rm.setPrimitivesDefaultedForNullValue(true);
			return simpleJdbcTemplate.query(sql, rm, params);
		}
	}

	public <T> List<T> list(Class<T> type, String sql, Object... args) {
		if (orm.needCache(type)) {
			List<Long> idList = simpleJdbcTemplate.query(sql, idRowMapper, args);
			List<T> result = new ArrayList<T>();
			for (Long id : idList) {
				result.add(find(id, type));
			}
			return result;
		} else {
			BeanPropertyRowMapper<T> rm = new BeanPropertyRowMapper<T>(type);
			rm.setPrimitivesDefaultedForNullValue(true);
			return simpleJdbcTemplate.query(sql, rm, args);
		}
	}

	public <T> List<T> page(Class<T> type, String sql, int pageNo, int pageSize, Map<String, Object> params) {
		SqlPageBuilder pageBuilder = mySQLPageBuilder;
		if (database.equalsIgnoreCase("Oracle")) {
			pageBuilder = oraclePageBuilder;
		}
		if (orm.needCache(type)) {
			List<Long> idList = simpleJdbcTemplate.query(pageBuilder.buildPageSql(sql, pageNo, pageSize), idRowMapper, params);
			List<T> result = new ArrayList<T>();
			for (Long id : idList) {
				result.add(find(id, type));
			}
			return result;
		} else {
			BeanPropertyRowMapper<T> rm = new BeanPropertyRowMapper<T>(type);
			rm.setPrimitivesDefaultedForNullValue(true);
			return simpleJdbcTemplate.query(pageBuilder.buildPageSql(sql, pageNo, pageSize), rm, params);
		}
	}

	public <T> List<T> page(Class<T> type, String sql, int pageNo, int pageSize, Object... args) {
		SqlPageBuilder pageBuilder = mySQLPageBuilder;
		if (database.equalsIgnoreCase("Oracle")) {
			pageBuilder = oraclePageBuilder;
		}
		if (orm.needCache(type)) {
			List<Long> idList = simpleJdbcTemplate.query(pageBuilder.buildPageSql(sql, pageNo, pageSize), idRowMapper, args);
			List<T> result = new ArrayList<T>();
			for (Long id : idList) {
				result.add(find(id, type));
			}
			return result;
		} else {
			BeanPropertyRowMapper<T> rm = new BeanPropertyRowMapper<T>(type);
			rm.setPrimitivesDefaultedForNullValue(true);
			return simpleJdbcTemplate.query(pageBuilder.buildPageSql(sql, pageNo, pageSize), rm, args);
		}
	}

	public <T> T findFirst(Class<T> type, String sql, Object... args) {
		BeanPropertyRowMapper<T> rm = new BeanPropertyRowMapper<T>(type);
		rm.setPrimitivesDefaultedForNullValue(true);
		if (database.equalsIgnoreCase("MySQL")) {
			String _sql = sql + " LIMIT 1";
			try {
				return simpleJdbcTemplate.queryForObject(_sql, rm, args);
			} catch (EmptyResultDataAccessException e) {
				return null;
			}
		}
		if (database.equalsIgnoreCase("Oracle")) {
			String _sql =
				"SELECT * FROM (SELECT A.*, ROWNUM AS r__n FROM ( "
					+ sql
					+ ") A) B WHERE B.r__n = 1";
			try {
				return simpleJdbcTemplate.queryForObject(_sql, rm, args);
			} catch (EmptyResultDataAccessException e) {
				return null;
			}
		}
		throw new IllegalStateException("database not supported" + database);
	}

	public <T> T findFromCache(long id, Class<T> type) {
		String key = Config.APP_NAME + "-" + type.getSimpleName() + "-" + id;
		String v = (String) cacheClient.get(key);
		if (v != null) {
			return JsonUtils.fromJson(v, type);
		}
		return null;
	}

	public <T> T findFromDb(long id, Class<T> type) {
		BeanPropertyRowMapper<T> rm = new BeanPropertyRowMapper<T>(type);
		rm.setPrimitivesDefaultedForNullValue(true);
		String sql = "SELECT * FROM " + tablePrefix + type.getSimpleName().toLowerCase() + " WHERE " + type.getSimpleName().toLowerCase() + "id = ?";
		return simpleJdbcTemplate.queryForObject(sql, rm, id);
	}

	public long getDBTimestamp() {
		if (database.equalsIgnoreCase("Oracle")) {
			String sql = "SELECT sysdate FROM dual";
			List<Timestamp> list = simpleJdbcTemplate.query(sql, tsRowMapper);
			return list.get(0).getTime();
		} else {
			return 0;
		}
	}

	public long getObjectId(Object obj) {
		long id;
		try {
			id = orm.getObjectId(obj);
		} catch (Exception e) {
			throw new RuntimeException("get id of object error", e);
		}
		return id;
	}

	public <T> void putToCache(T obj, Class<T> type, long id) {
		String key = Config.APP_NAME + "-" + type.getSimpleName() + "-" + id;
		cacheClient.set(key, JsonUtils.toJson(obj));
	}

	public void removeFromCache(String key) {
		cacheClient.delete(key);
	}

	public void removeFromCache(Object obj, long id) {
		String key = Config.APP_NAME + "-" + obj.getClass().getSimpleName() + "-" + id;
		cacheClient.delete(key);
	}

/*
	public int update(String sql, Map<String, Object> params) {
		return simpleJdbcTemplate.update(sql, params);
	}

	public int update(String sql, Object... args) {
		return simpleJdbcTemplate.update(sql, args);
	}
*/
}
