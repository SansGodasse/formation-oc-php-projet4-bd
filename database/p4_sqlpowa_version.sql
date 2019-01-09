
CREATE TABLE ef_user (
                u_email VARCHAR(100) NOT NULL,
                u_password VARCHAR(100) NOT NULL,
                u_name VARCHAR(100) NOT NULL,
                u_surname VARCHAR(100) NOT NULL,
                PRIMARY KEY (u_email)
);


CREATE TABLE ef_address (
                a_id INT AUTO_INCREMENT NOT NULL,
                a_user_email VARCHAR(100) NOT NULL,
                a_street VARCHAR(100) NOT NULL,
                a_zip_code NUMERIC(5) NOT NULL,
                a_city VARCHAR(100) NOT NULL,
                a_complement VARCHAR(500) NOT NULL,
                PRIMARY KEY (a_id)
);


CREATE TABLE ef_telephone (
                tel_id INT AUTO_INCREMENT NOT NULL,
                tel_user_email VARCHAR(100) NOT NULL,
                tel_number VARCHAR(20) NOT NULL,
                PRIMARY KEY (tel_id)
);


CREATE TABLE ef_client (
                cl_id INT AUTO_INCREMENT NOT NULL,
                cl_user_email VARCHAR(100) NOT NULL,
                PRIMARY KEY (cl_id)
);


CREATE TABLE ef_employee (
                em_id INT AUTO_INCREMENT NOT NULL,
                em_user_email VARCHAR(100) NOT NULL,
                PRIMARY KEY (em_id)
);


CREATE TABLE ef_cook (
                co_employee_id INT NOT NULL,
                PRIMARY KEY (co_employee_id)
);


CREATE TABLE ef_delivery_guy (
                dg_employee_id INT NOT NULL,
                dg_status VARCHAR(20) NOT NULL,
                dg_position_latitude DECIMAL(6,4) NOT NULL,
                dg_position_longitude DECIMAL(5,4) NOT NULL,
                PRIMARY KEY (dg_employee_id)
);


CREATE TABLE ef_daily_list (
                dl_date DATE NOT NULL,
                dl_cook_id INT NOT NULL,
                PRIMARY KEY (dl_date)
);


CREATE TABLE ef_plate (
                pl_name VARCHAR(100) NOT NULL,
                pl_type VARCHAR(20) NOT NULL,
                pl_available BOOLEAN NOT NULL,
                pl_price NUMERIC(5,2) NOT NULL,
                PRIMARY KEY (pl_name)
);


CREATE TABLE ef_daily_list_content (
                dlc_plate_name VARCHAR(100) NOT NULL,
                dlc_list_date DATE NOT NULL,
                PRIMARY KEY (dlc_plate_name, dlc_list_date)
);


CREATE TABLE ef_order (
                o_id INT AUTO_INCREMENT NOT NULL,
                o_delivery_guy_id INT NOT NULL,
                o_client_id INT NOT NULL,
                o_date DATE NOT NULL,
                o_status VARCHAR(20) NOT NULL,
                PRIMARY KEY (o_id)
);


CREATE TABLE ef_order_content (
                oc_plate_name VARCHAR(100) NOT NULL,
                o_order_id INT NOT NULL,
                oc_quantity INT NOT NULL,
                PRIMARY KEY (oc_plate_name, o_order_id)
);


ALTER TABLE ef_employee ADD CONSTRAINT ef_user_ef_employee_fk
FOREIGN KEY (em_user_email)
REFERENCES ef_user (u_email)
ON DELETE SET NULL
ON UPDATE CASCADE;

ALTER TABLE ef_client ADD CONSTRAINT ef_user_ef_client_fk
FOREIGN KEY (cl_user_email)
REFERENCES ef_user (u_email)
ON DELETE SET NULL
ON UPDATE CASCADE;

ALTER TABLE ef_telephone ADD CONSTRAINT ef_user_ef_telephone_fk
FOREIGN KEY (tel_user_email)
REFERENCES ef_user (u_email)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE ef_address ADD CONSTRAINT ef_user_ef_address_fk
FOREIGN KEY (a_user_email)
REFERENCES ef_user (u_email)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE ef_order ADD CONSTRAINT ef_client_ef_order_fk
FOREIGN KEY (o_client_id)
REFERENCES ef_client (cl_id)
ON DELETE SET NULL
ON UPDATE CASCADE;

ALTER TABLE ef_delivery_guy ADD CONSTRAINT ef_employee_ef_delivery_guy_fk
FOREIGN KEY (dg_employee_id)
REFERENCES ef_employee (em_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE ef_cook ADD CONSTRAINT ef_employee_ef_cook_fk
FOREIGN KEY (co_employee_id)
REFERENCES ef_employee (em_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE ef_daily_list ADD CONSTRAINT ef_cook_ef_daily_list_fk
FOREIGN KEY (dl_cook_id)
REFERENCES ef_cook (co_employee_id)
ON DELETE SET NULL
ON UPDATE CASCADE;

ALTER TABLE ef_order ADD CONSTRAINT ef_delivery_guy_ef_order_fk
FOREIGN KEY (o_delivery_guy_id)
REFERENCES ef_delivery_guy (dg_employee_id)
ON DELETE SET NULL
ON UPDATE CASCADE;

ALTER TABLE ef_daily_list_content ADD CONSTRAINT ef_daily_list_ef_daily_list_content_fk
FOREIGN KEY (dlc_list_date)
REFERENCES ef_daily_list (dl_date)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE ef_daily_list_content ADD CONSTRAINT ef_plate_ef_daily_list_content_fk
FOREIGN KEY (dlc_plate_name)
REFERENCES ef_plate (pl_name)
ON DELETE SET NULL
ON UPDATE CASCADE;

ALTER TABLE ef_order_content ADD CONSTRAINT ef_plate_ef_order_content_fk
FOREIGN KEY (oc_plate_name)
REFERENCES ef_plate (pl_name)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE ef_order_content ADD CONSTRAINT ef_order_ef_order_content_fk
FOREIGN KEY (o_order_id)
REFERENCES ef_order (o_id)
ON DELETE CASCADE
ON UPDATE CASCADE;