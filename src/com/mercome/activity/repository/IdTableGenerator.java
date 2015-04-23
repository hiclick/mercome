/**
 * READONLY
 */
package com.mercome.activity.repository;

import com.mercome.activity.Config;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;

/**
 * Maintained by: 4what
 */
public class IdTableGenerator implements IdGenerator {
	private DataSource idGenDataSource;

	public void setIdDataSource(DataSource idGenDataSource) {
		this.idGenDataSource = idGenDataSource;
	}

	private static String tablePrefix = Config.TABLE_PREFIX;

	private Map<String, IdHolder> holderMap = new java.util.concurrent.ConcurrentHashMap<String, IdHolder>();

	private int size = 10;

	public long alloc(String tableName, String columnName, int size) {
		long result = 0;
		Connection con = null;
		boolean oldAutoCommit = false;
		try {
			con = idGenDataSource.getConnection();
			oldAutoCommit = con.getAutoCommit();
			con.setAutoCommit(false);
			int updateCount = updateLastUsedId(con, tableName, columnName, size);
			if (updateCount == 0) {
				initIdTable(con, tableName, columnName);
				//updateLastUsedId(con, tableName, columnName);
			}
			result = getLastUsedId(con, tableName, columnName);
			con.commit();
		} catch (Exception e) {
			try {
				con.rollback();
			} catch (Exception ex) {
				ex.printStackTrace();
			}
			throw new RuntimeException(e);
		} finally {
			if (con != null) {
				try {
					con.setAutoCommit(oldAutoCommit);
					con.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		return result;
	}

	@Override
	public long generate(String tableName, String columnName) {
		IdHolder holder = holderMap.get(tableName);
		if (holder == null) {
			holder = new IdHolder();
			holderMap.put(tableName, holder);
		}
		synchronized (holder) {
			if (holder.needAlloc()) {
				long lastUsedId = alloc(tableName, columnName, size);
				holder.currentId = lastUsedId + 1;
				holder.limit = lastUsedId + size;
			} else {
				holder.currentId++;
			}
			return holder.currentId;
		}
	}

	public static long getLastUsedId(Connection con, String tableName, String columnName) throws SQLException {
		PreparedStatement ps = con.prepareStatement("SELECT last_used_id FROM " + tablePrefix + "keygen WHERE table_name = ?");
		ps.setString(1, tableName);
		ResultSet rs = ps.executeQuery();
		rs.next();
		long result = rs.getLong(1);
		rs.close();
		ps.close();
		return result;
	}

	public static void initIdTable(Connection con, String tableName, String columnName) throws SQLException {
		PreparedStatement ps = con.prepareStatement("SELECT MAX(" + columnName + ") FROM " + tableName);
		ResultSet rs = ps.executeQuery();
		rs.next();
		long maxId = rs.getLong(1);
		rs.close();
		ps.close();
		ps = con.prepareStatement("INSERT INTO " + tablePrefix + "keygen (table_name, last_used_id) VALUES (?, ?)");
		ps.setString(1, tableName);
		ps.setLong(2, maxId);
		ps.executeUpdate();
		ps.close();
	}

	public static int updateLastUsedId(Connection con, String tableName, String columnName, int size) throws SQLException {
		PreparedStatement ps = con.prepareStatement("UPDATE " + tablePrefix + "keygen SET last_used_id = last_used_id + ? WHERE table_name = ?");
		ps.setInt(1, size);
		ps.setString(2, tableName);
		int result = ps.executeUpdate();
		ps.close();
		return result;
	}

	public static class IdHolder {
		private long currentId;
		private long limit;

		boolean needAlloc() {
			return currentId >= limit;
		}
	}
}
