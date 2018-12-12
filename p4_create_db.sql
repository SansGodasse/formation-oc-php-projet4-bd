-- Création de la base de données MySQL

DROP DATABASE IF EXISTS oc_projet4_expressfood;

CREATE DATABASE oc_projet4_expressfood CHARACTER SET "utf8";

USE oc_projet4_expressfood;

CREATE TABLE ef_plate(
	pl_name VARCHAR(100),
	pl_type CHAR(1) NOT NULL,
	PRIMARY KEY (pl_name)
)
ENGINE=InnoDB;

CREATE TABLE ef_daily_list(
	dl_date DATE,
	PRIMARY KEY (dl_date)
)
ENGINE=InnoDB;

CREATE TABLE ef_contact(
	con_id INT UNSIGNED AUTO_INCREMENT,
	con_number VARCHAR(10),
	con_street VARCHAR(100),
	con_city VARCHAR(100),
	con_zip_code NUMERIC(5),
	con_complement VARCHAR(100),
	con_phone_number VARCHAR(20),
	PRIMARY KEY (con_id)
)
ENGINE=InnoDB;

CREATE TABLE ef_employee(
	em_id INT UNSIGNED AUTO_INCREMENT,
	em_name VARCHAR(100) NOT NULL,
	em_first_name VARCHAR(100) NOT NULL,
	em_contact_id INT UNSIGNED,
	PRIMARY KEY (em_id),
	CONSTRAINT fk_em_contact_id_con_id
		FOREIGN KEY (em_contact_id)
			REFERENCES ef_contact(con_id)
			ON DELETE SET NULL
			ON UPDATE CASCADE
)
ENGINE=InnoDB;

CREATE TABLE ef_cook(
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
	dg_employee_id INT UNSIGNED,
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
	cl_id INT UNSIGNED AUTO_INCREMENT,
	cl_name VARCHAR(100) NOT NULL,
	cl_first_name VARCHAR(100) NOT NULL,
	cl_email VARCHAR(100) NOT NULL,
	cl_contact_id INT UNSIGNED,
	PRIMARY KEY (cl_id),
	CONSTRAINT fk_cl_contact_id_con_id
		FOREIGN KEY (cl_contact_id)
			REFERENCES ef_contact(con_id)
			ON DELETE SET NULL
			ON UPDATE CASCADE
)
ENGINE=InnoDB;

CREATE TABLE ef_order(
	o_id INT UNSIGNED AUTO_INCREMENT,
	o_date DATETIME,
	o_status VARCHAR(50),
	o_delivery_guy_id INT UNSIGNED,
	PRIMARY KEY (o_id),
	CONSTRAINT fk_o_delivery_guy_id_dg_employee_id
		FOREIGN KEY (o_delivery_guy_id)
			REFERENCES ef_delivery_guy(dg_employee_id)
			ON DELETE SET NULL
			ON UPDATE CASCADE
)
ENGINE=InnoDB;

CREATE TABLE ef_order_content(
	oc_plate_name VARCHAR(100),
	oc_order_id INT UNSIGNED,
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

CREATE TABLE ef_daily_list_content(
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