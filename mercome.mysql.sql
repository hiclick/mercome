/* mercome */


/* MySQL */

--
CREATE DATABASE mercome;

USE mercome;


--
CREATE TABLE mercome_keygen (
	table_name VARCHAR(255) NOT NULL,
	last_used_id INT NOT NULL,

	--
	PRIMARY KEY (table_name)
) ENGINE = InnoDB;


--
CREATE TABLE mercome_admin (
	adminid INT NOT NULL,

	username VARCHAR(255),
	password VARCHAR(255),

	status INT,

	createdate DATETIME,

	--
	PRIMARY KEY (adminid)
) ENGINE = InnoDB;


--
CREATE TABLE mercome_log (
	logid INT NOT NULL,

	adminid INT,

	action VARCHAR(255),
	detail VARCHAR(4000),
	module VARCHAR(255),

	ip VARCHAR(255),

	status INT,

	createdate DATETIME,

	--
	PRIMARY KEY (logid)
) ENGINE = InnoDB;

CREATE TABLE mercome_setting (
	settingid INT NOT NULL,

	name VARCHAR(255),
	value VARCHAR(255),

	status INT,

	createdate DATETIME,

	--
	PRIMARY KEY (settingid)
) ENGINE = InnoDB;


--
CREATE TABLE mercome_product (
	productid INT NOT NULL,

	productcategoryid INT NOT NULL,

	name VARCHAR(255),

	cmp VARCHAR(4000),
	feature TEXT,
	odor VARCHAR(255),
	people VARCHAR(255),
	pic VARCHAR(4000),
	price VARCHAR(255),
	spec VARCHAR(4000),

	status INT,

	createdate DATETIME,

	--
	PRIMARY KEY (productid)
) ENGINE = InnoDB;

CREATE TABLE mercome_productcategory (
	productcategoryid INT NOT NULL,

	name VARCHAR(255),

	banner VARCHAR(4000),
	pic VARCHAR(4000),

	status INT,

	createdate DATETIME,

	--
	PRIMARY KEY (productcategoryid)
) ENGINE = InnoDB;


--
CREATE TABLE mercome_b2c (
	b2cid INT NOT NULL,

	name VARCHAR(255),

	logo VARCHAR(4000),
	website VARCHAR(4000),

	status INT,

	createdate DATETIME,

	--
	PRIMARY KEY (b2cid)
) ENGINE = InnoDB;

CREATE TABLE mercome_store (
	storeid INT NOT NULL,

	cityid INT,
	provinceid INT,

	name VARCHAR(255),

	address VARCHAR(4000),
	tel VARCHAR(255),

	status INT,

	createdate DATETIME,

	--
	PRIMARY KEY (storeid)
) ENGINE = InnoDB;

CREATE TABLE mercome_province (
	provinceid INT NOT NULL,

	name VARCHAR(255),

	status INT,

	createdate DATETIME,

	--
	PRIMARY KEY (provinceId)
) ENGINE = InnoDB;

CREATE TABLE mercome_city (
	cityid INT NOT NULL,

	provinceid INT,

	name VARCHAR(255),

	status INT,

	createdate DATETIME,

	--
	PRIMARY KEY (cityid)
) ENGINE = InnoDB;


--
CREATE TABLE mercome_article (
	articleid INT NOT NULL,

	articlecategoryid INT,

	content TEXT,
	title VARCHAR(255),

	pic VARCHAR(4000),

	status INT,

	createdate DATETIME,

	--
	PRIMARY KEY (articleid)
) ENGINE = InnoDB;

CREATE TABLE mercome_articlecategory (
	articlecategoryid INT NOT NULL,

	name VARCHAR(255),

	status INT,

	createdate DATETIME,

	--
	PRIMARY KEY (articlecategoryid)
) ENGINE = InnoDB;


--
CREATE TABLE mercome_proxy (
	proxyid INT NOT NULL,

	name VARCHAR(255),

	address VARCHAR(4000),
	email VARCHAR(255),
	gender INT,
	mobile VARCHAR(255),
	tel VARCHAR(255),

	brand VARCHAR(255),

	status INT,

	createdate DATETIME,

	--
	PRIMARY KEY (proxyid)
) ENGINE = InnoDB;


-- init
INSERT INTO mercome_admin VALUES (1, 'admin', 'd033e22ae348aeb5660fc2140aec35850c4da997', 0, '2014-01-01 00:00:00');
/*
INSERT INTO mercome_articlecategory VALUES (1, '文章分类', 0, '2014-01-01 00:00:00');
INSERT INTO mercome_productcategory VALUES (1, '产品分类', NULL, NULL, 0, '2014-01-01 00:00:00');
*/
