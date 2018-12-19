-- Création de la base de données MySQL

DROP DATABASE IF EXISTS oc_projet4_expressfood;

CREATE DATABASE oc_projet4_expressfood CHARACTER SET "utf8";

USE oc_projet4_expressfood;

CREATE TABLE ef_plate(
	-- PK
	pl_name VARCHAR(100),
	-- attributes
	pl_type VARCHAR(20) NOT NULL,
	pl_available BOOLEAN NOT NULL,

	PRIMARY KEY (pl_name)
)
ENGINE=InnoDB;

CREATE TABLE ef_daily_list(
	-- PK
	dl_date DATE,

	PRIMARY KEY (dl_date)
)
ENGINE=InnoDB;

CREATE TABLE ef_daily_list_content(
	-- PFK
	dlc_list_date DATE,
	dlc_plate_name VARCHAR(100),

	PRIMARY KEY (dlc_list_date, dlc_plate_name),
	CONSTRAINT fk_dlc_list_date_dl_date
		FOREIGN KEY (dlc_list_date)
			REFERENCES ef_daily_list(dl_date)
				ON DELETE CASCADE
				ON UPDATE CASCADE,
	CONSTRAINT fk_dlc_plate_name_pl_name
		FOREIGN KEY (dlc_plate_name)
			REFERENCES ef_plate(pl_name)
				ON DELETE CASCADE
				ON UPDATE CASCADE
)
ENGINE=InnoDB;

CREATE TABLE ef_user(
	-- PK
	u_email VARCHAR(50),
	-- attributes
	u_password VARCHAR(100) NOT NULL,

	PRIMARY KEY (u_email)
)
ENGINE=InnoDB;

CREATE TABLE ef_telephone(
	-- PK
	tel_id INT UNSIGNED AUTO_INCREMENT,
	-- FK
	tel_u_email VARCHAR(50),
	-- attributes
	tel_number VARCHAR(20) NOT NULL,

	PRIMARY KEY (tel_id),
	CONSTRAINT fk_tel_u_email_u_email
		FOREIGN KEY (tel_u_email)
			REFERENCES ef_user(u_email)
			ON UPDATE CASCADE
			ON DELETE CASCADE
)
ENGINE=InnoDB;

CREATE TABLE ef_address(
	-- PK
	a_id INT UNSIGNED AUTO_INCREMENT,
	-- FK
	a_u_email VARCHAR(50),
	-- attributes
	a_name VARCHAR(100) NOT NULL,
	a_surname VARCHAR(100) NOT NULL,
	a_street VARCHAR(100) NOT NULL,
	a_zip_code NUMERIC(5) NOT NULL,
	a_city VARCHAR(100) NOT NULL,
	a_complement VARCHAR(100),

	PRIMARY KEY (a_id),
	CONSTRAINT fk_a_u_email_u_email
		FOREIGN KEY (a_u_email)
			REFERENCES ef_user(u_email)
			ON UPDATE CASCADE
			ON DELETE CASCADE
)
ENGINE=InnoDB;

CREATE TABLE ef_employee(
	-- PK
	em_id INT UNSIGNED AUTO_INCREMENT,
	-- FK
	em_u_email VARCHAR(50),

	PRIMARY KEY (em_id),
	CONSTRAINT fk_em_u_email_u_email
		FOREIGN KEY (em_u_email)
			REFERENCES ef_user(u_email)
			ON DELETE SET NULL
			ON UPDATE CASCADE
)
ENGINE=InnoDB;

CREATE TABLE ef_cook(
	-- PFK
	co_employee_id INT UNSIGNED,

	PRIMARY KEY (co_employee_id),
	CONSTRAINT fk_co_employee_id_em_id
		FOREIGN KEY (co_employee_id)
			REFERENCES ef_employee(em_id)
			ON DELETE CASCADE
			ON UPDATE CASCADE
)
ENGINE=InnoDB;

CREATE TABLE ef_delivery_guy(
	-- PFK
	dg_employee_id INT UNSIGNED,
	-- attributes
	dg_status VARCHAR(50),
	dg_position_latitude DECIMAL(6, 4),
	dg_position_longitude DECIMAL(5, 4),

	PRIMARY KEY (dg_employee_id),
	CONSTRAINT fk_dg_employee_id_em_id
		FOREIGN KEY (dg_employee_id)
			REFERENCES ef_employee(em_id)
			ON DELETE CASCADE
			ON UPDATE CASCADE
)
ENGINE=InnoDB;

CREATE TABLE ef_client(
	-- PK
	cl_id INT UNSIGNED AUTO_INCREMENT,
	-- FK
	cl_u_email VARCHAR(50),

	PRIMARY KEY (cl_id),
	CONSTRAINT fk_cl_u_email_u_email
		FOREIGN KEY (cl_u_email)
			REFERENCES ef_user(u_email)
			ON DELETE SET NULL
			ON UPDATE CASCADE
)
ENGINE=InnoDB;

CREATE TABLE ef_order(
	-- PK
	o_id INT UNSIGNED AUTO_INCREMENT,
	-- FK
	o_delivery_guy_id INT UNSIGNED,
	-- attributes
	o_date DATETIME,
	o_status VARCHAR(50),

	PRIMARY KEY (o_id),
	CONSTRAINT fk_o_delivery_guy_id_dg_employee_id
		FOREIGN KEY (o_delivery_guy_id)
			REFERENCES ef_delivery_guy(dg_employee_id)
			ON DELETE SET NULL
			ON UPDATE CASCADE
)
ENGINE=InnoDB;

CREATE TABLE ef_order_content(
	-- PFK
	oc_plate_name VARCHAR(100),
	oc_order_id INT UNSIGNED,
	-- attributes
	oc_quantity SMALLINT UNSIGNED NOT NULL,

	PRIMARY KEY (oc_plate_name, oc_order_id),
	CONSTRAINT fk_oc_plate_name_pl_name
		FOREIGN KEY (oc_plate_name)
			REFERENCES ef_plate(pl_name)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
	CONSTRAINT fk_oc_order_id_o_id
		FOREIGN KEY (oc_order_id)
			REFERENCES ef_order(o_id)
			ON DELETE CASCADE
			ON UPDATE CASCADE
)
ENGINE=InnoDB;
