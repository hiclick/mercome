/**
 * READONLY
 */
package com.mercome.activity.repository;

/**
 * Maintained by: 4what
 */
public interface IdGenerator {
	long generate(String tableName, String columnName);
}
