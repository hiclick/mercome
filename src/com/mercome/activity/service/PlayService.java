package com.mercome.activity.service;

import com.mercome.activity.Config;
import com.mercome.activity.cache.CacheClient;
import com.mercome.activity.domain.Admin;
import com.mercome.activity.domain.Setting;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @author 4what
 */
@Service
public class PlayService {
	@Autowired
	private CacheClient cacheClient;

	@Autowired
	private Config config;

	@Autowired
	private GenericService genericService;

	/**
	 * @param id
	 * @return
	 */
	public Admin findAdmin(long id) {
		return genericService.find(Admin.class, id);
	}

	/**
	 * @param name
	 * @return
	 */
	public Setting getSetting(String name) {
		Setting setting = null;

		for (Setting item : genericService.list(Setting.class, "WHERE name = ?", name)) {
			setting = item;
		}

		if (setting == null) {
			setting = new Setting();

			setting.setName(name);

			setting.setSettingId(genericService.create(setting));
		}

		return setting;
	}

	/**
	 * @return
	 */
	public boolean isOffline() {
		try {
			Setting expiry = getSetting("expiry");

			if (StringUtils.isNotBlank(expiry.getValue())) {
				return new Date().after(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(expiry.getValue()));
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}

		return false;
	}
}
