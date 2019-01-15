-- Création de la base de données MySQL

DROP DATABASE IF EXISTS oc_projet4_expressfood;

CREATE DATABASE oc_projet4_expressfood CHARACTER SET "utf8";

USE oc_projet4_expressfood;

CREATE TABLE ef_user(
	-- PK
	u_email VARCHAR(100),
	-- attributes
	u_password VARCHAR(100) NOT NULL,
	u_name VARCHAR(100) NOT NULL,
	u_surname VARCHAR(100) NOT NULL,

	PRIMARY KEY (u_email)
)
ENGINE = InnoDB;

CREATE TABLE ef_telephone(
	-- PK
	tel_id INT UNSIGNED AUTO_INCREMENT,
	-- FK
	tel_user_email VARCHAR(100),
	-- attributes
	tel_number VARCHAR(20) NOT NULL,

	PRIMARY KEY (tel_id),

	CONSTRAINT fk_tel_user_email_u_email
		FOREIGN KEY (tel_user_email)
			REFERENCES ef_user(u_email)
			ON UPDATE CASCADE
			ON DELETE CASCADE
)
ENGINE = InnoDB;

CREATE TABLE ef_address(
	-- PK
	a_id INT UNSIGNED AUTO_INCREMENT,
	-- FK
	a_user_email VARCHAR(100),
	-- attributes
	a_street VARCHAR(100) NOT NULL,
	a_zip_code NUMERIC(5) NOT NULL,
	a_city VARCHAR(100) NOT NULL,
	a_complement VARCHAR(100),

	PRIMARY KEY (a_id),

	CONSTRAINT fk_a_user_email_u_email
		FOREIGN KEY (a_user_email)
			REFERENCES ef_user(u_email)
			ON UPDATE CASCADE
			ON DELETE CASCADE
)
ENGINE = InnoDB;

CREATE TABLE ef_employee(
	-- PK
	em_id INT UNSIGNED AUTO_INCREMENT,
	-- FK
	em_user_email VARCHAR(100),

	PRIMARY KEY (em_id),

	CONSTRAINT fk_em_user_email_u_email
		FOREIGN KEY (em_user_email)
			REFERENCES ef_user(u_email)
			ON DELETE SET NULL
			ON UPDATE CASCADE
)
ENGINE = InnoDB;

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
ENGINE = InnoDB;

CREATE TABLE ef_delivery_guy(
	-- PFK
	dg_employee_id INT UNSIGNED,
	-- attributes
	dg_status VARCHAR(100) NOT NULL,
	dg_position_latitude DECIMAL(6, 4),
	dg_position_longitude DECIMAL(5, 4),

	PRIMARY KEY (dg_employee_id),

	CONSTRAINT fk_dg_employee_id_em_id
		FOREIGN KEY (dg_employee_id)
			REFERENCES ef_employee(em_id)
			ON DELETE CASCADE
			ON UPDATE CASCADE
)
ENGINE = InnoDB;

CREATE TABLE ef_client(
	-- PK
	cl_id INT UNSIGNED AUTO_INCREMENT,
	-- FK
	cl_user_email VARCHAR(100),

	PRIMARY KEY (cl_id),

	CONSTRAINT fk_cl_user_email_u_email
		FOREIGN KEY (cl_user_email)
			REFERENCES ef_user(u_email)
			ON DELETE SET NULL
			ON UPDATE CASCADE
)
ENGINE = InnoDB;

CREATE TABLE ef_plate(
	-- PK
	pl_name VARCHAR(100),
	-- attributes
	pl_type VARCHAR(20) NOT NULL,
	pl_available BOOLEAN NOT NULL,
	pl_price NUMERIC(5, 2) NOT NULL,

	PRIMARY KEY (pl_name)
)
ENGINE = InnoDB;

CREATE TABLE ef_order(
	-- PK
	o_id INT UNSIGNED AUTO_INCREMENT,
	-- FK
	o_client_id INT UNSIGNED,
	o_delivery_guy_id INT UNSIGNED,
	-- attributes
	o_date DATETIME NOT NULL,
	o_status VARCHAR(100) NOT NULL,
	o_price NUMERIC(7, 2),

	PRIMARY KEY (o_id),

	CONSTRAINT fk_o_delivery_guy_id_dg_employee_id
		FOREIGN KEY (o_delivery_guy_id)
			REFERENCES ef_delivery_guy(dg_employee_id)
			ON DELETE SET NULL
			ON UPDATE CASCADE,

	CONSTRAINT fk_o_client_id_cl_id
		FOREIGN KEY (o_client_id)
			REFERENCES ef_client(cl_id)
			ON DELETE SET NULL
			ON UPDATE CASCADE
)
ENGINE = InnoDB;

CREATE TABLE ef_order_content(
	-- PFK
	oc_order_id INT UNSIGNED,
	oc_plate_name VARCHAR(100),
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
ENGINE = InnoDB;


CREATE TABLE ef_daily_list(
	-- PK
	dl_date DATE,
	-- FK
	dl_cook_id INT UNSIGNED,

	PRIMARY KEY (dl_date),

	CONSTRAINT fk_dl_cook_id_co_employee_id
		FOREIGN KEY (dl_cook_id)
			REFERENCES ef_cook(co_employee_id)
			ON DELETE SET NULL
			ON UPDATE CASCADE
)
ENGINE = InnoDB;

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
ENGINE = InnoDB;

-- On insert les données

-- ef_plate
INSERT INTO ef_plate VALUES ('Tartiflette', 'plat', true, 8.05), ('Poëlée montagnarde', 'plat', false, 8.97), ('Burger vosgien', 'plat', false, 6.42), ('Salade vosgienne', 'plat', true, 5.56), ('Aligot', 'plat', false, 5.38), ('Carottes rapées', 'plat', false, 13.27), ('Betteraves rouges', 'plat', false, 8.34), ('Gratin dauphinois', 'plat', true, 2.7), ('Gratin de choux-fleurs', 'plat', false, 7.07), ('Gratin de brocolis', 'plat', true, 14.63), ('Salade niçoise', 'plat', true, 6.85), ('Coquilles saint Jacques', 'plat', false, 3.59), ('Nems au poulet', 'plat', false, 11.25), ('Pizza 4 fromages', 'plat', true, 4.44), ('Riz cantonnais', 'plat', false, 2.29), ('Omelette aux olives', 'plat', false, 6.54), ('Quiche lorraine', 'plat', false, 12.14), ('Pot au feu', 'plat', true, 4.17), ('Pizza reine', 'plat', true, 9.62), ('Risotto aux olives', 'plat', true, 13.24), ('Croques monsieur', 'plat', true, 12.14), ('Soupe aux légumes', 'plat', false, 11.49), ('Tomates farcies', 'plat', true, 13.1), ('Poivrons farcis', 'plat', false, 3.53), ('Aubergines farcies', 'plat', true, 8.38), ('Crumble aux pommes', 'dessert', true, 13.49), ('Clafoutis aux pommes', 'dessert', true, 12.84), ('Tarte aux pommes', 'dessert', true, 5.21), ('Compote de pommes', 'dessert', true, 7.72), ('Crumble aux poires', 'dessert', true, 4.97), ('Clafoutis aux poires', 'dessert', true, 7.31), ('Tarte aux poires', 'dessert', false, 10.76), ('Compote de poires', 'dessert', true, 12.09), ('Crumble aux prunes', 'dessert', true, 3.04), ('Clafoutis aux prunes', 'dessert', true, 14.12), ('Tarte aux prunes', 'dessert', false, 12.63), ('Compote de prunes', 'dessert', true, 3.25), ('Crumble aux cerises', 'dessert', true, 13.04), ('Clafoutis aux cerises', 'dessert', true, 2.91), ('Tarte aux cerises', 'dessert', true, 4), ('Compote de cerises', 'dessert', false, 7.35), ('Mousse au chocolat', 'dessert', true, 2.11), ('Brownie au chocolat', 'dessert', true, 13.98), ('Charlotte aux framboises', 'dessert', true, 5.01), ('Paris Brest', 'dessert', true, 10.74);

-- ef_user
INSERT INTO ef_user VALUES ('Octave.Ergébel@live.fr', '$2y$10$gSz7bZXnTrBSQnVv049.iubaB/FlCh591GYZ0Pg.2I5B81i5Q4H06', 'Octave', 'Ergébel'), ('Mouss.Quetaire@orange.fr', '$2y$10$hYRBQoSL2WXpfNj56Y05PuUu.hyeQ/iOgCmuCqz7grI22BCWjBPv2', 'Mouss', 'Quetaire'), ('Oscar.Ibou@gmail.com', '$2y$10$JCu.eztN.Oa701ADtZ2pLuRHdL3yuaHg49.Ns7I2svtIUKNgc3o82', 'Oscar', 'Ibou'), ('Moussah.Razeh@gmail.com', '$2y$10$06lET.gaRLfgbgJQ81gfz.UqBQ4UhcqPYGdTeDnZnvG7AccjkGBCy', 'Moussah', 'Razeh'), ('Louis.Fine@orange.fr', '$2y$10$1q.eeAFg6s3WypOBvEOVSel4sbIK85nTCfQxurTvnGKdCPCmBNAYy', 'Louis', 'Fine'), ('Jean.Peuplu@gmail.com', '$2y$10$wlpwwx4ZYLEfCwB/u6OlYuoMVZyAaYhvs0BLJJrwbKFKQFsns9n7K', 'Jean', 'Peuplu'), ('Luc.Sembourg@live.fr', '$2y$10$lsXjlZSXtvdKY6DQJJtT6eTtSjQ3ii3tanzcZkq9UmaDsOkLtrT3.', 'Luc', 'Sembourg'), ('Jean.Tenbien@orange.fr', '$2y$10$Qzzdh29NiaVB1XKL.VaJjuNvQrb4xxc53Z6ttRWAZcXc8onBIiqHG', 'Jean', 'Tenbien'), ('Tara.Clure@orange.fr', '$2y$10$bZb5SfiHVl0G64DSp5o1TOuXpmjaJU1bodu254apul/I.4SLnqEyS', 'Tara', 'Clure'), ('Léo.Pard@live.fr', '$2y$10$/IgmSHg8rEeCgkV4zg2Ol.GflQOEYj3VYc/2UBosg1rV.OIfibZui', 'Léo', 'Pard'), ('Omar.Tinais@orange.fr', '$2y$10$kfDIF3QV0XfkRPwd/4xaO.oHf4eXncBMMfrFW8uIAbxSr2Ot8eQqS', 'Omar', 'Tinais'), ('Yann.Erie@gmail.com', '$2y$10$SUU0Zn8XqakDgLYnvh5CKe.NXXtUG5SaJOSwuaur1ga/hYN.IMFz2', 'Yann', 'Erie'), ('Alex.Andry@gmail.com', '$2y$10$vDOiH3N/3LbkBE5rl8l3DOVXgwWqlx9F0wQImEsO7uyj11YpdEh0a', 'Alex', 'Andry'), ('Anna.Tomie@orange.fr', '$2y$10$Cr60r9cq1hdX155IlStHIeGp8Pwnnarz33cvRB5jCWQQHkpyCiQxq', 'Anna', 'Tomie'), ('Claude.Cologne@orange.fr', '$2y$10$Z0eT.8M1Ci4keKTagEqS2.hogm8uHAxgzMQ20nAceUKUnCBZ.bVZW', 'Claude', 'Cologne'), ('Laure.Angoutan@orange.fr', '$2y$10$zpGCNr1Uz4ThYo3QXMrq7uMVQD8S8unVAnYo3gYUniWQ1pzKnLaKa', 'Laure', 'Angoutan'), ('Jenny.Fraireniseur@orange.fr', '$2y$10$YeWOJBRN.GAnKe94GHeCT.URnBVUz1SiWp.MYDQchrxdgfORgsHy2', 'Jenny', 'Fraireniseur'), ('Roger.Trobu@gmail.com', '$2y$10$Iq.mOItmQ6hATTbtQ27Iw.VmAOcO33ylQustNVUPYFbf7VNwR9vkG', 'Roger', 'Trobu'), ('Claire.Delune@live.fr', '$2y$10$lUdf5w4XoH75W5IZ7RRRie0HwDEMOj.yNP9ZrT2/kQH3JplNRmnaG', 'Claire', 'Delune'), ('Terry.Chmonfils@gmail.com', '$2y$10$bufk6j/UBNNHdMx.speBfuUbKbcc.WoMIFFIyaQphP8Qt9rc59JgC', 'Terry', 'Chmonfils'), ('jimmy.Lesbieraufrai@orange.fr', '$2y$10$Vj7VLQZBMupJ/BJw2uNjn.RzGcm4.ngdrOQJoESjhib0sgi0qFMLO', 'jimmy', 'Lesbieraufrai'), ('Yann.Orak@orange.fr', '$2y$10$RjRlW8JDQAld6PBMYdqCa.6i/pT3GZ4sN9zQwbCJrWv0UkBlQO9ZW', 'Yann', 'Orak'), ('Jean-Paul.Iglotte@gmail.com', '$2y$10$HsbWYdFRVvIvG5ADc9E4IO.RFQCTW6q.MGnDOovpxrfl1ooOmeiSy', 'Jean-Paul', 'Iglotte'), ('Ève.Aporation@gmail.com', '$2y$10$6F.YsgYPus52txJgeWcmeO.UgX5/sb2C7dHp2no1j3NVoOrgcMy4G', 'Ève', 'Aporation'), ('Jean-Paul.Ochon@gmail.com', '$2y$10$hrkSxBfJ8V8XRdP5SJgOfOAALdR05PfNMBZ8fOe0dmSLfvcYZuxbO', 'Jean-Paul', 'Ochon'), ('Julie.Bellule@gmail.com', '$2y$10$dfiJQpmcWbUwjI0bJ0cGhOR0f2zz2FPejgpuaqQIZAKERMNqo1ocO', 'Julie', 'Bellule'), ('Sam.Estegal@orange.fr', '$2y$10$b1R2zUld6N0rCtqu6PgQCO4toRlYeDWFdXnp2a0db88EarbVs8fNm', 'Sam', 'Estegal'), ('Abel.Védaire@live.fr', '$2y$10$jWDn0wk29xTYrYs5bdIZcugC0LzWaXqzAi/mlsEhFlpnMDNa/sCka', 'Abel', 'Védaire'), ('Adam.Main@gmail.com', '$2y$10$Mj5RiUr/.HShZ0EXL3RALOR5RMtpHnvQhl9INY8Er7YnIg9FyHlcu', 'Adam', 'Main'), ('Phil.Moilesel@gmail.com', '$2y$10$fV6KP.E7YzFx7C2/txK1T.932N2N5D0z3o9/qleBpk3miHtU8wy1q', 'Phil', 'Moilesel'), ('Gaspard.Tame@gmail.com', '$2y$10$8Px7Co4ZvYhuysBeSPUQOO5GLj7qwRJe4lmRPRzuJOSPBLm/eQbjC', 'Gaspard', 'Tame'), ('Judas.Bricot@gmail.com', '$2y$10$pmYzn1M0gwE.E1gYSfzYxOtd9zQuWXrjk8nQiH1B0KXQR0kPmPGzW', 'Judas', 'Bricot'), ('Adam.Desemène@live.fr', '$2y$10$GJw7E3Ip9./Mnkr4MIJC/uG0tLKFXMGjOpDJg2clbNTykj3vjHomS', 'Adam', 'Desemène'), ('Mehdi.Zan@gmail.com', '$2y$10$7PEBxDEU8f3gvLFhD4z.QekPrVUfjB.6Q/PXnxFEunFbNSvzU8ke.', 'Mehdi', 'Zan'), ('Pat.Ate@orange.fr', '$2y$10$PHawy1jBmAP0E9GMe8lxCe8NV0OC2nnjnFN4wqLWT8EwQYi4SEevi', 'Pat', 'Ate'), ('Omar.Khé-Ting@gmail.com', '$2y$10$rOuHueXvwK192Oyi6rIc0ug.gWT.YIJsGgIm2pPSju9wMAMnKczaW', 'Omar', 'Khé-Ting'), ('Al.Pagué@live.fr', '$2y$10$wUkwAwX472VL31SbxR0rdeKRrh6DG4vK5Imq0haK.0X17Myc5djlW', 'Al', 'Pagué'), ('Judas.Sperge@gmail.com', '$2y$10$gYiu.19fRK3hWzYZPpACYeCSOLiTpO/VRPHetwLP4q7gan7Y3XvI6', 'Judas', 'Sperge'), ('Théo.Jasmin@live.fr', '$2y$10$/.YjULBpFO1VEXQLji9OMOhNQNBht5woLtVOXtKbuIWgrzzPvmjQu', 'Théo', 'Jasmin'), ('Al.Idantic@orange.fr', '$2y$10$7YL2y8IrLaqpkBwoNpWXSeA8iebdvrnI.rB0/s.XiDMosCsD9s.Du', 'Al', 'Idantic'), ('Dick.Sionnaire@gmail.com', '$2y$10$EglKAP8cycNHjEhbltIXU.7Q7uhO51joNkM8U/uRn6fEeZ2OayGHO', 'Dick', 'Sionnaire'), ('Edgard.Ogorille@gmail.com', '$2y$10$jvUaZpvaCFwx58iNdZ7zLOVIc8XiaaEJOzloxDo31bkWogZlvdX4G', 'Edgard', 'Ogorille'), ('Tony.Truand@live.fr', '$2y$10$gnrufax/n7Ytay6XQGCBYeouaVJjQLGm7VBlrUPZYuKPLuPJK4h3.', 'Tony', 'Truand'), ('Lucie.Soussette@orange.fr', '$2y$10$WoBmZ9tiFvgM4tLMqqiKgu81Mq5YSHnkPUl/czkVM5doTijcYXEIa', 'Lucie', 'Soussette'), ('Jean.Tube@live.fr', '$2y$10$XYkp74SdmMPWSqHpJScs3uzzuPtwXHUWP5sC6SlgpZoz2dG/e7etm', 'Jean', 'Tube'), ('Lara.Pafromage@live.fr', '$2y$10$pD7PIDefj3wFPoymzD03.O0etQdWNlYFhgioGgb8l62ZGmFhvWtcS', 'Lara', 'Pafromage'), ('Guy.De demontagne@live.fr', '$2y$10$iOCSgKaOx6DVdL/eyV1XNeZxzAfDFPOACZ7f.6BiAWwILO16mhuR2', 'Guy', 'De demontagne'), ('Larry.Vière@gmail.com', '$2y$10$tFsTZttn2i3q2/1YMca36.0jpKzVMprHBfXjxnIUtXknF2yWhW6mq', 'Larry', 'Vière'), ('Sandra.Nicouette@gmail.com', '$2y$10$WKIPzSTLt/QoM8fD0P661O3sj1y6uzfejics92w2uIZxM9MrYYDfi', 'Sandra', 'Nicouette'), ('Laurent.Bar@orange.fr', '$2y$10$cXKsVx1cSoSDf4RFWGhAX.d5.VfZz2ZWeEzdngbobSu0BMgw7DvJW', 'Laurent', 'Bar');

-- ef_telephone
INSERT INTO ef_telephone VALUES (0, 'Octave.Ergébel@live.fr', '0691922289'), (1, 'Mouss.Quetaire@orange.fr', '0626684755'), (2, 'Oscar.Ibou@gmail.com', '0681504368'), (3, 'Moussah.Razeh@gmail.com', '0665770279'), (4, 'Louis.Fine@orange.fr', '0642723089'), (5, 'Jean.Peuplu@gmail.com', '0624600884'), (6, 'Luc.Sembourg@live.fr', '0648420983'), (7, 'Jean.Tenbien@orange.fr', '0644262343'), (8, 'Tara.Clure@orange.fr', '0617632296'), (9, 'Léo.Pard@live.fr', '0657001405'), (10, 'Omar.Tinais@orange.fr', '0661352165'), (11, 'Yann.Erie@gmail.com', '063355330'), (12, 'Alex.Andry@gmail.com', '0635142683'), (13, 'Anna.Tomie@orange.fr', '0625304217'), (14, 'Claude.Cologne@orange.fr', '0626512464'), (15, 'Laure.Angoutan@orange.fr', '0665721596'), (16, 'Jenny.Fraireniseur@orange.fr', '0617070380'), (17, 'Roger.Trobu@gmail.com', '0698597972'), (18, 'Claire.Delune@live.fr', '0696719634'), (19, 'Terry.Chmonfils@gmail.com', '0640005147'), (20, 'jimmy.Lesbieraufrai@orange.fr', '0658566003'), (21, 'Yann.Orak@orange.fr', '0632160047'), (22, 'Jean-Paul.Iglotte@gmail.com', '0621901221'), (23, 'Ève.Aporation@gmail.com', '0663917883'), (24, 'Jean-Paul.Ochon@gmail.com', '0634735914'), (25, 'Julie.Bellule@gmail.com', '064785715'), (26, 'Sam.Estegal@orange.fr', '0625763328'), (27, 'Abel.Védaire@live.fr', '061564617'), (28, 'Adam.Main@gmail.com', '0629334164'), (29, 'Phil.Moilesel@gmail.com', '0697320687'), (30, 'Gaspard.Tame@gmail.com', '06371295'), (31, 'Judas.Bricot@gmail.com', '067238800'), (32, 'Adam.Desemène@live.fr', '0642000239'), (33, 'Mehdi.Zan@gmail.com', '0646495251'), (34, 'Pat.Ate@orange.fr', '0636336387'), (35, 'Omar.Khé-Ting@gmail.com', '0610685705'), (36, 'Al.Pagué@live.fr', '0615160578'), (37, 'Judas.Sperge@gmail.com', '0652293539'), (38, 'Théo.Jasmin@live.fr', '0646478063'), (39, 'Al.Idantic@orange.fr', '0636037684'), (40, 'Dick.Sionnaire@gmail.com', '0671901448'), (41, 'Edgard.Ogorille@gmail.com', '0610633378'), (42, 'Tony.Truand@live.fr', '0697018971'), (43, 'Lucie.Soussette@orange.fr', '066722358'), (44, 'Jean.Tube@live.fr', '0697783208'), (45, 'Lara.Pafromage@live.fr', '067784496'), (46, 'Guy.De demontagne@live.fr', '0616593032'), (47, 'Larry.Vière@gmail.com', '0688268070'), (48, 'Sandra.Nicouette@gmail.com', '0642049004'), (49, 'Laurent.Bar@orange.fr', '0667566185');

-- ef_address
INSERT INTO ef_address VALUES (0, 'Octave.Ergébel@live.fr', '21 Rue d\'Algérie', '69001', 'Lyon', NULL), (1, 'Mouss.Quetaire@orange.fr', '12 Quai André Lassagne', '69001', 'Lyon', NULL), (2, 'Oscar.Ibou@gmail.com', '2 Rue d\'Algérie', '69001', 'Lyon', NULL), (3, 'Moussah.Razeh@gmail.com', '20 Rue de l\'Arbre Sec', '69001', 'Lyon', NULL), (4, 'Louis.Fine@orange.fr', '14 Quai André Lassagne', '69001', 'Lyon', NULL), (5, 'Jean.Peuplu@gmail.com', '19 Rue d\'Algérie', '69001', 'Lyon', NULL), (6, 'Luc.Sembourg@live.fr', '5 Rue Alsace Lorraine', '69001', 'Lyon', NULL), (7, 'Jean.Tenbien@orange.fr', '13 Rue Alsace Lorraine', '69001', 'Lyon', NULL), (8, 'Tara.Clure@orange.fr', '3 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (9, 'Léo.Pard@live.fr', '3 Rue de l\'Alma', '69001', 'Lyon', NULL), (10, 'Omar.Tinais@orange.fr', '9 Rue d\'Algérie', '69001', 'Lyon', NULL), (11, 'Yann.Erie@gmail.com', '6 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (12, 'Alex.Andry@gmail.com', '1 Rue Alsace Lorraine', '69001', 'Lyon', NULL), (13, 'Anna.Tomie@orange.fr', '11 Rue de l\'Alma', '69001', 'Lyon', NULL), (14, 'Claude.Cologne@orange.fr', '11 Rue de l\'Arbre Sec', '69001', 'Lyon', NULL), (15, 'Laure.Angoutan@orange.fr', '10 Rue de l\'Alma', '69001', 'Lyon', NULL), (16, 'Jenny.Fraireniseur@orange.fr', '12 Rue de l\'Alma', '69001', 'Lyon', NULL), (17, 'Roger.Trobu@gmail.com', '7 Rue de l\'Alma', '69001', 'Lyon', NULL), (18, 'Claire.Delune@live.fr', '13 Rue de l\'Arbre Sec', '69001', 'Lyon', NULL), (19, 'Terry.Chmonfils@gmail.com', '4 Rue de l\'Alma', '69001', 'Lyon', NULL), (20, 'jimmy.Lesbieraufrai@orange.fr', '4 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (21, 'Yann.Orak@orange.fr', '17 Quai André Lassagne', '69001', 'Lyon', NULL), (22, 'Jean-Paul.Iglotte@gmail.com', '6 Rue d\'Algérie', '69001', 'Lyon', NULL), (23, 'Ève.Aporation@gmail.com', '2 Rue Alsace Lorraine', '69001', 'Lyon', NULL), (24, 'Jean-Paul.Ochon@gmail.com', '18 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (25, 'Julie.Bellule@gmail.com', '26 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (26, 'Sam.Estegal@orange.fr', '22 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (27, 'Abel.Védaire@live.fr', '3 Rue d\'Algérie', '69001', 'Lyon', NULL), (28, 'Adam.Main@gmail.com', '20 Rue d\'Algérie', '69001', 'Lyon', NULL), (29, 'Phil.Moilesel@gmail.com', '10 Rue d\'Algérie', '69001', 'Lyon', NULL), (30, 'Gaspard.Tame@gmail.com', '8 Quai André Lassagne', '69001', 'Lyon', NULL), (31, 'Judas.Bricot@gmail.com', '9 Quai André Lassagne', '69001', 'Lyon', NULL), (32, 'Adam.Desemène@live.fr', '8 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (33, 'Mehdi.Zan@gmail.com', '12 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (34, 'Pat.Ate@orange.fr', '17 Rue d\'Algérie', '69001', 'Lyon', NULL), (35, 'Omar.Khé-Ting@gmail.com', '18 Rue d\'Algérie', '69001', 'Lyon', NULL), (36, 'Al.Pagué@live.fr', '1 Rue Alexandre Luigini', '69001', 'Lyon', NULL), (37, 'Judas.Sperge@gmail.com', '21 Rue Alsace Lorraine', '69001', 'Lyon', NULL), (38, 'Théo.Jasmin@live.fr', '13 Quai André Lassagne', '69001', 'Lyon', NULL), (39, 'Al.Idantic@orange.fr', '5 Quai André Lassagne', '69001', 'Lyon', NULL), (40, 'Dick.Sionnaire@gmail.com', '1 Place d\'Albon', '69001', 'Lyon', NULL), (41, 'Edgard.Ogorille@gmail.com', '12 Rue d\'Algérie', '69001', 'Lyon', NULL), (42, 'Tony.Truand@live.fr', '4 Rue Alsace Lorraine', '69001', 'Lyon', NULL), (43, 'Lucie.Soussette@orange.fr', '7 Quai André Lassagne', '69001', 'Lyon', NULL), (44, 'Jean.Tube@live.fr', '3 Rue Adamoli', '69001', 'Lyon', NULL), (45, 'Lara.Pafromage@live.fr', '4 Quai André Lassagne', '69001', 'Lyon', NULL), (46, 'Guy.De demontagne@live.fr', '13 Rue d\'Algérie', '69001', 'Lyon', NULL), (47, 'Larry.Vière@gmail.com', '10 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (48, 'Sandra.Nicouette@gmail.com', '9 Rue de l\'Alma', '69001', 'Lyon', NULL), (49, 'Laurent.Bar@orange.fr', '14 Rue de l\'Alma', '69001', 'Lyon', NULL);

-- ef_employee
INSERT INTO ef_employee VALUES (0, 'Octave.Ergébel@live.fr'), (1, 'Mouss.Quetaire@orange.fr'), (2, 'Oscar.Ibou@gmail.com'), (3, 'Moussah.Razeh@gmail.com'), (4, 'Louis.Fine@orange.fr'), (5, 'Jean.Peuplu@gmail.com'), (6, 'Luc.Sembourg@live.fr'), (7, 'Jean.Tenbien@orange.fr'), (8, 'Tara.Clure@orange.fr'), (9, 'Léo.Pard@live.fr'), (10, 'Omar.Tinais@orange.fr'), (11, 'Yann.Erie@gmail.com'), (12, 'Alex.Andry@gmail.com'), (13, 'Anna.Tomie@orange.fr'), (14, 'Claude.Cologne@orange.fr'), (15, 'Laure.Angoutan@orange.fr'), (16, 'Jenny.Fraireniseur@orange.fr'), (17, 'Roger.Trobu@gmail.com'), (18, 'Claire.Delune@live.fr'), (19, 'Terry.Chmonfils@gmail.com');

-- ef_client
INSERT INTO ef_client VALUES (0, 'jimmy.Lesbieraufrai@orange.fr'), (1, 'Yann.Orak@orange.fr'), (2, 'Jean-Paul.Iglotte@gmail.com'), (3, 'Ève.Aporation@gmail.com'), (4, 'Jean-Paul.Ochon@gmail.com'), (5, 'Julie.Bellule@gmail.com'), (6, 'Sam.Estegal@orange.fr'), (7, 'Abel.Védaire@live.fr'), (8, 'Adam.Main@gmail.com'), (9, 'Phil.Moilesel@gmail.com'), (10, 'Gaspard.Tame@gmail.com'), (11, 'Judas.Bricot@gmail.com'), (12, 'Adam.Desemène@live.fr'), (13, 'Mehdi.Zan@gmail.com'), (14, 'Pat.Ate@orange.fr'), (15, 'Omar.Khé-Ting@gmail.com'), (16, 'Al.Pagué@live.fr'), (17, 'Judas.Sperge@gmail.com'), (18, 'Théo.Jasmin@live.fr'), (19, 'Al.Idantic@orange.fr'), (20, 'Dick.Sionnaire@gmail.com'), (21, 'Edgard.Ogorille@gmail.com'), (22, 'Tony.Truand@live.fr'), (23, 'Lucie.Soussette@orange.fr'), (24, 'Jean.Tube@live.fr'), (25, 'Lara.Pafromage@live.fr'), (26, 'Guy.De demontagne@live.fr'), (27, 'Larry.Vière@gmail.com'), (28, 'Sandra.Nicouette@gmail.com'), (29, 'Laurent.Bar@orange.fr');

-- ef_delivery_guy
INSERT INTO ef_delivery_guy VALUES (0, 'Disponible', '45.7718', '4.7665'), (1, 'En livraison', '45.7648', '4.7749'), (2, 'En livraison', '45.7739', '4.7713'), (3, 'En livraison', '45.7636', '4.7634'), (4, 'En livraison', '45.7659', '4.7627'), (5, 'En livraison', '45.7637', '4.7691'), (6, 'En livraison', '45.7681', '4.7709'), (7, 'En livraison', '45.7641', '4.7734'), (8, 'Disponible', '45.7772', '4.7645'), (9, 'Hors connexion', '45.7779', '4.7744');

-- ef_cook
INSERT INTO ef_cook VALUES (10), (11), (12), (13), (14), (15), (16), (17), (18), (19);

-- ef_order
INSERT INTO ef_order VALUES (0, 23, 1, '2018-05-10 12:14:50', 'En attente', 33.54), (1, 29, 2, '2018-05-17 18:32:13', 'En attente', 31.02), (2, 1, 5, '2018-05-15 20:37:20', 'En attente', 85.61), (3, 7, 3, '2018-05-02 19:52:35', 'En attente', 54.37), (4, 16, 4, '2018-05-15 18:57:17', 'Payée', 6.39), (5, 3, 3, '2018-05-03 12:55:16', 'Livrée', 32.18), (6, 15, 3, '2018-05-25 20:53:31', 'Livrée', 41.85), (7, 3, 6, '2018-05-19 15:43:26', 'Annulée', 65.55), (8, 3, 8, '2018-05-19 20:41:21', 'Payée', 98.82), (9, 17, 3, '2018-05-08 20:13:00', 'Annulée', 28.88), (10, 14, 5, '2018-05-28 13:45:17', 'Annulée', 21.62), (11, 5, 9, '2018-05-26 15:22:07', 'Payée', 98.9), (12, 18, 0, '2018-05-07 19:33:53', 'Annulée', 86.09), (13, 20, 7, '2018-05-22 16:14:04', 'En attente', 62.25), (14, 6, 1, '2018-05-03 13:00:07', 'Livrée', 12.84), (15, 7, 6, '2018-05-25 20:28:10', 'Payée', 91.27), (16, 13, 1, '2018-05-05 13:04:10', 'Annulée', 62.75), (17, 10, 5, '2018-05-18 14:45:20', 'Annulée', 11), (18, 24, 7, '2018-05-22 12:10:04', 'Annulée', 30.95), (19, 26, 0, '2018-05-25 15:42:09', 'Annulée', 92.97), (20, 16, 0, '2018-05-28 20:14:46', 'Livrée', 43.13), (21, 2, 8, '2018-05-19 19:55:59', 'En attente', 87.34), (22, 12, 8, '2018-05-18 11:59:33', 'Annulée', 29.51), (23, 27, 1, '2018-05-13 18:30:34', 'Annulée', 57.79), (24, 14, 0, '2018-05-25 20:11:05', 'En attente', 50.9), (25, 0, 8, '2018-05-09 19:02:36', 'Annulée', 15.94), (26, 12, 2, '2018-05-11 17:58:31', 'Payée', 56.82), (27, 25, 7, '2018-05-20 19:48:29', 'Payée', 61.77), (28, 15, 6, '2018-05-11 15:30:54', 'Livrée', 20.6), (29, 24, 9, '2018-05-19 20:16:55', 'Annulée', 68.34), (30, 20, 6, '2018-05-18 20:17:26', 'Payée', 60.56), (31, 16, 5, '2018-05-05 15:23:45', 'Livrée', 74.03), (32, 9, 7, '2018-05-06 12:42:02', 'Livrée', 17.89), (33, 10, 0, '2018-05-21 19:54:12', 'Livrée', 37.27), (34, 17, 3, '2018-05-28 13:32:08', 'Annulée', 84.96), (35, 2, 1, '2018-05-11 13:26:51', 'Livrée', 37.47), (36, 25, 8, '2018-05-10 18:09:16', 'Livrée', 29.61), (37, 8, 2, '2018-05-25 11:55:40', 'Livrée', 9.61), (38, 11, 4, '2018-05-19 11:38:39', 'En attente', 35.16), (39, 25, 3, '2018-05-02 12:25:30', 'Payée', 44.92), (40, 21, 0, '2018-05-17 12:32:30', 'Livrée', 25.57), (41, 13, 3, '2018-05-12 11:48:13', 'Annulée', 78.05), (42, 9, 1, '2018-05-12 17:38:56', 'Payée', 57.1), (43, 6, 5, '2018-05-08 16:42:56', 'Payée', 56.85), (44, 18, 6, '2018-05-24 12:13:16', 'Payée', 17.16), (45, 10, 2, '2018-05-13 16:57:15', 'Payée', 55.48), (46, 18, 6, '2018-05-08 17:00:48', 'Livrée', 56.15), (47, 24, 2, '2018-05-22 16:32:49', 'En attente', 80.65), (48, 8, 4, '2018-05-13 12:34:16', 'Payée', 90.86), (49, 5, 8, '2018-05-07 18:27:26', 'Annulée', 55.29), (50, 21, 5, '2018-05-25 18:28:03', 'Annulée', 36.45), (51, 26, 6, '2018-05-01 19:24:18', 'En attente', 68.38), (52, 6, 6, '2018-05-18 17:02:50', 'Livrée', 35.7), (53, 18, 0, '2018-05-17 13:13:40', 'Annulée', 72.85), (54, 20, 2, '2018-05-23 18:37:24', 'Livrée', 77.4), (55, 12, 0, '2018-05-18 19:58:59', 'En attente', 51.75), (56, 12, 9, '2018-05-16 17:24:45', 'En attente', 74.79), (57, 6, 4, '2018-05-12 11:33:53', 'En attente', 82.77), (58, 28, 5, '2018-05-10 12:45:47', 'En attente', 52.35), (59, 26, 6, '2018-05-08 20:44:51', 'Livrée', 81.61), (60, 22, 3, '2018-05-11 18:14:59', 'Livrée', 44.05), (61, 9, 4, '2018-05-22 12:36:59', 'Annulée', 20.05), (62, 17, 5, '2018-05-16 18:20:30', 'En attente', 80.8), (63, 10, 2, '2018-05-10 11:23:43', 'Annulée', 85.65), (64, 29, 2, '2018-05-25 16:16:24', 'En attente', 58.87), (65, 4, 8, '2018-05-20 20:14:31', 'Livrée', 90.25), (66, 10, 8, '2018-05-19 12:08:27', 'En attente', 9.9), (67, 13, 9, '2018-05-14 11:40:37', 'Payée', 76.41), (68, 15, 6, '2018-05-05 20:14:21', 'Livrée', 22.91), (69, 4, 2, '2018-05-04 20:04:11', 'Annulée', 16), (70, 23, 9, '2018-05-14 19:35:37', 'En attente', 43.84), (71, 15, 5, '2018-05-16 14:15:49', 'Annulée', 69.1), (72, 27, 7, '2018-05-25 15:17:27', 'Payée', 24.48), (73, 22, 7, '2018-05-21 15:01:07', 'Payée', 33.87), (74, 13, 5, '2018-05-07 14:20:09', 'En attente', 97.25), (75, 0, 4, '2018-05-15 19:17:07', 'En attente', 60.21), (76, 15, 0, '2018-05-14 16:09:48', 'Payée', 58.45), (77, 17, 8, '2018-05-25 19:01:06', 'Livrée', 57.41), (78, 7, 9, '2018-05-12 13:46:42', 'Annulée', 23.46), (79, 8, 8, '2018-05-10 19:37:49', 'Payée', 46), (80, 23, 5, '2018-05-18 17:07:41', 'Annulée', 38.18), (81, 26, 5, '2018-05-19 11:21:11', 'Livrée', 39.54), (82, 4, 4, '2018-05-17 19:10:19', 'Annulée', 51.68), (83, 13, 3, '2018-05-22 15:02:32', 'En attente', 6.28), (84, 27, 4, '2018-05-08 19:07:42', 'Payée', 84.25), (85, 27, 0, '2018-05-09 18:21:32', 'Livrée', 18.66), (86, 29, 5, '2018-05-27 16:53:11', 'En attente', 92.61), (87, 2, 7, '2018-05-26 18:29:11', 'En attente', 27.63), (88, 3, 5, '2018-05-28 13:02:17', 'Payée', 33.37), (89, 17, 6, '2018-05-16 18:40:06', 'Payée', 97.82), (90, 14, 9, '2018-05-28 18:05:08', 'Livrée', 18.36), (91, 20, 1, '2018-05-17 16:13:37', 'Annulée', 26.71), (92, 19, 4, '2018-05-22 19:31:07', 'Livrée', 69.69), (93, 2, 8, '2018-05-16 15:56:40', 'Payée', 72.63), (94, 0, 0, '2018-05-05 16:25:33', 'En attente', 28.42), (95, 1, 7, '2018-05-07 12:45:12', 'Payée', 83.67), (96, 5, 2, '2018-05-13 20:56:04', 'Payée', 24.42), (97, 25, 1, '2018-05-07 18:48:22', 'Livrée', 12.15), (98, 20, 9, '2018-05-23 19:31:31', 'Livrée', 27.57), (99, 14, 3, '2018-05-13 15:11:07', 'Livrée', 59.48);

-- ef_daily_list
INSERT INTO ef_daily_list VALUES ('2018-05-1', 15), ('2018-05-2', 19), ('2018-05-3', 16), ('2018-05-4', 10), ('2018-05-5', 13), ('2018-05-6', 12), ('2018-05-7', 11), ('2018-05-8', 15), ('2018-05-9', 10), ('2018-05-10', 15);

-- ef_daily_list_content
INSERT INTO ef_daily_list_content VALUES ('2018-05-1', 'Tartiflette'), ('2018-05-1', 'Crumble aux pommes'), ('2018-05-1', 'Poëlée montagnarde'), ('2018-05-1', 'Clafoutis aux pommes'), ('2018-05-2', 'Burger vosgien'), ('2018-05-2', 'Tarte aux pommes'), ('2018-05-2', 'Salade vosgienne'), ('2018-05-2', 'Compote de pommes'), ('2018-05-3', 'Aligot'), ('2018-05-3', 'Crumble aux poires'), ('2018-05-3', 'Carottes rapées'), ('2018-05-3', 'Clafoutis aux poires'), ('2018-05-4', 'Betteraves rouges'), ('2018-05-4', 'Tarte aux poires'), ('2018-05-4', 'Gratin dauphinois'), ('2018-05-4', 'Compote de poires'), ('2018-05-5', 'Gratin de choux-fleurs'), ('2018-05-5', 'Crumble aux prunes'), ('2018-05-5', 'Gratin de brocolis'), ('2018-05-5', 'Clafoutis aux prunes'), ('2018-05-6', 'Salade niçoise'), ('2018-05-6', 'Tarte aux prunes'), ('2018-05-6', 'Coquilles saint Jacques'), ('2018-05-6', 'Compote de prunes'), ('2018-05-7', 'Nems au poulet'), ('2018-05-7', 'Crumble aux cerises'), ('2018-05-7', 'Pizza 4 fromages'), ('2018-05-7', 'Clafoutis aux cerises'), ('2018-05-8', 'Riz cantonnais'), ('2018-05-8', 'Tarte aux cerises'), ('2018-05-8', 'Omelette aux olives'), ('2018-05-8', 'Compote de cerises'), ('2018-05-9', 'Quiche lorraine'), ('2018-05-9', 'Mousse au chocolat'), ('2018-05-9', 'Pot au feu'), ('2018-05-9', 'Brownie au chocolat'), ('2018-05-10', 'Pizza reine'), ('2018-05-10', 'Charlotte aux framboises'), ('2018-05-10', 'Risotto aux olives'), ('2018-05-10', 'Paris Brest');

-- ef_order_content
INSERT INTO ef_order_content VALUES (0, 'Quiche lorraine', 4), (0, 'Aligot', 4), (1, 'Pot au feu', 1), (1, 'Compote de prunes', 4), (2, 'Gratin de choux-fleurs', 4), (3, 'Paris Brest', 4), (4, 'Soupe aux légumes', 1), (4, 'Clafoutis aux cerises', 3), (5, 'Risotto aux olives', 2), (6, 'Gratin de choux-fleurs', 4), (6, 'Tarte aux poires', 3), (7, 'Salade niçoise', 4), (7, 'Aubergines farcies', 2), (8, 'Quiche lorraine', 4), (8, 'Gratin de choux-fleurs', 3), (9, 'Pot au feu', 3), (10, 'Risotto aux olives', 3), (11, 'Coquilles saint Jacques', 2), (11, 'Crumble aux cerises', 3), (12, 'Poivrons farcis', 2), (13, 'Brownie au chocolat', 3), (14, 'Risotto aux olives', 3), (15, 'Pizza reine', 3), (16, 'Tarte aux pommes', 2), (16, 'Soupe aux légumes', 4), (17, 'Pizza 4 fromages', 4), (17, 'Crumble aux prunes', 4), (17, 'Brownie au chocolat', 2), (18, 'Compote de poires', 4), (18, 'Pizza reine', 1), (19, 'Coquilles saint Jacques', 1), (19, 'Crumble aux poires', 2), (19, 'Soupe aux légumes', 2), (19, 'Crumble aux pommes', 4), (20, 'Salade niçoise', 4), (21, 'Brownie au chocolat', 2), (22, 'Tarte aux poires', 4), (22, 'Crumble aux pommes', 2), (22, 'Clafoutis aux pommes', 1), (22, 'Aligot', 4), (23, 'Tarte aux pommes', 1), (23, 'Crumble aux cerises', 4), (23, 'Pot au feu', 1), (24, 'Omelette aux olives', 3), (25, 'Charlotte aux framboises', 3), (26, 'Poëlée montagnarde', 3), (27, 'Salade niçoise', 1), (27, 'Crumble aux poires', 1), (28, 'Crumble aux poires', 3), (29, 'Quiche lorraine', 4), (29, 'Carottes rapées', 3), (30, 'Tarte aux poires', 2), (30, 'Clafoutis aux pommes', 3), (30, 'Clafoutis aux poires', 4), (31, 'Tartiflette', 3), (31, 'Salade niçoise', 3), (32, 'Compote de poires', 2), (32, 'Aubergines farcies', 3), (32, 'Tomates farcies', 4), (33, 'Gratin de brocolis', 2), (33, 'Tarte aux cerises', 4), (33, 'Tarte aux poires', 2), (33, 'Aubergines farcies', 4), (34, 'Pizza reine', 1), (34, 'Clafoutis aux poires', 1), (35, 'Paris Brest', 4), (35, 'Soupe aux légumes', 3), (36, 'Riz cantonnais', 2), (36, 'Poëlée montagnarde', 2), (36, 'Crumble aux pommes', 3), (37, 'Tomates farcies', 4), (37, 'Crumble aux cerises', 3), (38, 'Charlotte aux framboises', 2), (38, 'Riz cantonnais', 1), (38, 'Tarte aux pommes', 4), (39, 'Compote de cerises', 4), (39, 'Omelette aux olives', 4), (39, 'Aligot', 1), (40, 'Paris Brest', 4), (41, 'Croques monsieur', 4), (41, 'Tarte aux pommes', 2), (41, 'Omelette aux olives', 3), (42, 'Pot au feu', 2), (42, 'Aligot', 4), (42, 'Paris Brest', 1), (43, 'Gratin dauphinois', 4), (43, 'Clafoutis aux prunes', 2), (43, 'Charlotte aux framboises', 4), (43, 'Salade niçoise', 4), (44, 'Salade vosgienne', 4), (45, 'Coquilles saint Jacques', 3), (45, 'Poivrons farcis', 3), (45, 'Gratin de choux-fleurs', 3), (46, 'Betteraves rouges', 4), (47, 'Paris Brest', 4), (47, 'Clafoutis aux cerises', 4), (48, 'Poivrons farcis', 2), (48, 'Gratin dauphinois', 1), (49, 'Coquilles saint Jacques', 1), (49, 'Carottes rapées', 2), (50, 'Salade niçoise', 4), (50, 'Omelette aux olives', 2), (51, 'Gratin de brocolis', 1), (52, 'Pizza reine', 2), (52, 'Crumble aux prunes', 4), (53, 'Crumble aux pommes', 2), (53, 'Soupe aux légumes', 4), (54, 'Aligot', 4), (54, 'Tarte aux cerises', 1), (54, 'Gratin de choux-fleurs', 4), (54, 'Gratin dauphinois', 1), (55, 'Pizza reine', 4), (56, 'Tarte aux prunes', 2), (56, 'Coquilles saint Jacques', 3), (56, 'Aubergines farcies', 2), (57, 'Soupe aux légumes', 4), (57, 'Pizza 4 fromages', 4), (58, 'Omelette aux olives', 4), (59, 'Poëlée montagnarde', 3), (59, 'Burger vosgien', 1), (59, 'Tarte aux prunes', 4), (59, 'Compote de pommes', 2), (60, 'Soupe aux légumes', 3), (60, 'Salade niçoise', 4), (60, 'Compote de prunes', 3), (61, 'Clafoutis aux pommes', 1), (62, 'Nems au poulet', 3), (62, 'Croques monsieur', 4), (63, 'Poëlée montagnarde', 4), (63, 'Poivrons farcis', 2), (63, 'Crumble aux cerises', 3), (64, 'Compote de pommes', 3), (64, 'Poëlée montagnarde', 2), (64, 'Crumble aux prunes', 4), (64, 'Soupe aux légumes', 3), (65, 'Pizza reine', 1), (65, 'Poivrons farcis', 3), (65, 'Burger vosgien', 1), (66, 'Gratin de choux-fleurs', 2), (66, 'Crumble aux poires', 3), (67, 'Tarte aux poires', 4), (67, 'Carottes rapées', 1), (68, 'Charlotte aux framboises', 3), (69, 'Omelette aux olives', 2), (69, 'Paris Brest', 3), (70, 'Risotto aux olives', 4), (71, 'Carottes rapées', 1), (71, 'Clafoutis aux cerises', 1), (72, 'Soupe aux légumes', 2), (72, 'Compote de pommes', 4), (73, 'Mousse au chocolat', 2), (73, 'Tarte aux poires', 2), (74, 'Aubergines farcies', 3), (74, 'Croques monsieur', 2), (74, 'Clafoutis aux prunes', 2), (75, 'Poivrons farcis', 1), (76, 'Burger vosgien', 3), (76, 'Carottes rapées', 2), (77, 'Tomates farcies', 3), (77, 'Compote de poires', 4), (77, 'Omelette aux olives', 1), (78, 'Clafoutis aux prunes', 2), (78, 'Tarte aux pommes', 2), (78, 'Clafoutis aux poires', 3), (78, 'Omelette aux olives', 2), (79, 'Omelette aux olives', 2), (79, 'Salade niçoise', 2), (80, 'Aubergines farcies', 2), (80, 'Compote de poires', 4), (80, 'Compote de cerises', 3), (81, 'Riz cantonnais', 3), (81, 'Crumble aux pommes', 2), (82, 'Burger vosgien', 3), (82, 'Betteraves rouges', 1), (83, 'Salade vosgienne', 1), (83, 'Poëlée montagnarde', 3), (83, 'Soupe aux légumes', 2), (84, 'Crumble aux poires', 3), (85, 'Pizza reine', 3), (85, 'Pot au feu', 1), (85, 'Carottes rapées', 1), (85, 'Crumble aux cerises', 4), (86, 'Gratin dauphinois', 3), (86, 'Clafoutis aux pommes', 4), (86, 'Risotto aux olives', 1), (86, 'Soupe aux légumes', 4), (87, 'Crumble aux poires', 4), (87, 'Riz cantonnais', 4), (88, 'Soupe aux légumes', 4), (89, 'Gratin dauphinois', 4), (90, 'Crumble aux cerises', 1), (90, 'Quiche lorraine', 2), (91, 'Tartiflette', 3), (92, 'Charlotte aux framboises', 3), (93, 'Clafoutis aux poires', 2), (93, 'Poivrons farcis', 3), (93, 'Clafoutis aux prunes', 3), (93, 'Gratin de choux-fleurs', 2), (94, 'Crumble aux prunes', 2), (94, 'Poëlée montagnarde', 1), (94, 'Clafoutis aux prunes', 4), (95, 'Poëlée montagnarde', 3), (95, 'Burger vosgien', 1), (95, 'Betteraves rouges', 3), (96, 'Charlotte aux framboises', 2), (97, 'Coquilles saint Jacques', 4), (97, 'Croques monsieur', 3), (97, 'Paris Brest', 1), (98, 'Poëlée montagnarde', 3), (98, 'Omelette aux olives', 4), (98, 'Tartiflette', 1), (99, 'Compote de cerises', 4), (99, 'Tarte aux prunes', 3);
