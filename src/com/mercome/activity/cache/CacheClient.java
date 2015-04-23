/**
 * READONLY
 */
package com.mercome.activity.cache;

import com.danga.MemCached.MemCachedClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.Map;

/**
 * Maintained by: 4what
 */
@Component
public class CacheClient {
	@Autowired
	@Qualifier("memCachedClient")
	private MemCachedClient mcc;

	public long addOrIncr(String key, long count) {
		return mcc.addOrIncr(key, count);
	}

	public boolean delete(String key) {
		return mcc.delete(key);
	}

	public Object get(String key) {
		return mcc.get(key);
	}

	public long getCounter(String key) {
		return mcc.getCounter(key);
	}

	public Map<String, Object> getMulti(String[] keys) {
		return mcc.getMulti(keys);
	}

	public Object[] getMultiArray(String[] keys) {
		return mcc.getMultiArray(keys);
	}

	public Object[] getMultiArray(String[] keys, Integer[] hashCodes, boolean asString) {
		return mcc.getMultiArray(keys, hashCodes, asString);
	}

	public boolean set(String key, Object value) {
		return mcc.set(key, value);
	}

	public boolean set(String key, Object value, Date expiryAt) {
		return mcc.set(key, value, expiryAt);
	}

	public boolean set(String key, String value, Date expiryAt) {
		return mcc.set(key, value, expiryAt);
	}

	public boolean storeCounter(String key, long count) {
		return mcc.storeCounter(key, count);
	}


	/* Modified by: 4what */
	public long addOrDecr(String key) {
		return mcc.addOrDecr(key);
	}

	public long addOrDecr(String key, long inc) {
		return mcc.addOrDecr(key, inc);
	}

	public long addOrIncr(String key) {
		return mcc.addOrIncr(key);
	}

	public boolean keyExists(String key) {
		return mcc.keyExists(key);
	}
}
