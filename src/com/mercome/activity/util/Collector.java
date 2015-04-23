/**
 * READONLY
 */
package com.mercome.activity.util;

import java.util.ArrayList;
import java.util.List;

/**
 * Maintained by: 4what
 */
public class Collector {
	private CollectItem item;

	private List<CollectItem> items = new ArrayList<CollectItem>();

	private long start;

	public void start(String string) {
		start = System.currentTimeMillis();
		item = new CollectItem(string);
	}

	public void stop() {
		item.usedMillis = System.currentTimeMillis() - start;
		items.add(item);
		item = null;
	}

	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder();
		for (int i = 0, c = items.size(); i < c; ++i) {
			sb.append(items.get(i).toString());
			if (i < c - 1) sb.append("\n");
		}
		return sb.toString();
	}

	public static class CollectItem {
		private String key;

		private long usedMillis;

		public CollectItem(String key) {
			this.key = key;
		}

		@Override
		public String toString() {
			StringBuilder sb = new StringBuilder();
			sb.append(" ").append("+");
			sb.append(usedMillis).append(",");
			sb.append(key);
			return sb.toString();
		}
	}
}
