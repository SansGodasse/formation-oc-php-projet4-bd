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
INSERT INTO ef_plate VALUES ('Tartiflette', 'plat', true, 13), ('Poëlée montagnarde', 'plat', false, 6), ('Burger vosgien', 'plat', false, 12), ('Salade vosgienne', 'plat', false, 13), ('Aligot', 'plat', false, 13), ('Carottes rapées', 'plat', true, 3), ('Betteraves rouges', 'plat', true, 2), ('Gratin dauphinois', 'plat', true, 7), ('Gratin de choux-fleurs', 'plat', true, 15), ('Gratin de brocolis', 'plat', true, 2), ('Salade niçoise', 'plat', true, 5), ('Coquilles saint Jacques', 'plat', true, 2), ('Nems au poulet', 'plat', true, 4), ('Pizza 4 fromages', 'plat', true, 14), ('Riz cantonnais', 'plat', true, 15), ('Omelette aux olives', 'plat', true, 11), ('Quiche lorraine', 'plat', true, 15), ('Pot au feu', 'plat', false, 12), ('Pizza reine', 'plat', true, 15), ('Risotto aux olives', 'plat', false, 4), ('Croques monsieur', 'plat', true, 5), ('Soupe aux légumes', 'plat', true, 13), ('Tomates farcies', 'plat', true, 6), ('Poivrons farcis', 'plat', true, 14), ('Aubergines farcies', 'plat', false, 4), ('Crumble aux pommes', 'dessert', true, 9), ('Clafoutis aux pommes', 'dessert', true, 12), ('Tarte aux pommes', 'dessert', true, 8), ('Compote de pommes', 'dessert', false, 9), ('Crumble aux poires', 'dessert', true, 13), ('Clafoutis aux poires', 'dessert', true, 11), ('Tarte aux poires', 'dessert', true, 6), ('Compote de poires', 'dessert', true, 15), ('Crumble aux prunes', 'dessert', false, 12), ('Clafoutis aux prunes', 'dessert', true, 11), ('Tarte aux prunes', 'dessert', true, 3), ('Compote de prunes', 'dessert', true, 11), ('Crumble aux cerises', 'dessert', true, 6), ('Clafoutis aux cerises', 'dessert', true, 14), ('Tarte aux cerises', 'dessert', true, 4), ('Compote de cerises', 'dessert', true, 4), ('Mousse au chocolat', 'dessert', true, 6), ('Brownie au chocolat', 'dessert', true, 13), ('Charlotte aux framboises', 'dessert', true, 13), ('Paris Brest', 'dessert', true, 10);

-- ef_user
INSERT INTO ef_user VALUES ('Mehdi.Zan@gmail.com', '$2y$10$rdNBdlbR1yZDgyl6eD.ac.20uEk.x9jKrdMKTP5YDrEqt838a8v5W', 'Mehdi', 'Zan'), ('Théo.Jasmin@live.fr', '$2y$10$9.obxp20Osxd2p4qaq7KPebjvgs7Qj.krfgl904QI/MFyWs0r9NJC', 'Théo', 'Jasmin'), ('jimmy.Lesbieraufrai@live.fr', '$2y$10$THPmYnqeLBAt6MTRaOuEneUYKTB4Lf.WqbaJmCvGClhKUuhuZnRC.', 'jimmy', 'Lesbieraufrai'), ('Alan.Haliz@gmail.com', '$2y$10$BGZjS4TGuXTpB2u7CywGsu5f2aWBjMA4dFDR24lTcOVdezpngd3lq', 'Alan', 'Haliz'), ('Anne.Onyme@gmail.com', '$2y$10$Bfa/XCmqnkk37SEzeIcHjus5zDJ3kAlbloK/Zl86.aNq6sDDOlg66', 'Anne', 'Onyme'), ('Jean-Paul.Iglotte@gmail.com', '$2y$10$0qO61NvyzvGJv/3UlXn4Y.noSGAye4vvyDnpWK82AJq6sghO0342a', 'Jean-Paul', 'Iglotte'), ('Laurent.Bar@live.fr', '$2y$10$8AyDXsMXvrp0f0alSN0c0eYfP1YyBnzLPxefkh4LsZWugJkD29e/i', 'Laurent', 'Bar'), ('Maude.Cologne@gmail.com', '$2y$10$eDnnxgFugoK3jZ8KJ0jHy.IqEJVqFMH3yWUTGdenHVHzxwV/0Gw9q', 'Maude', 'Cologne'), ('Octave.Ergébel@orange.fr', '$2y$10$uYwdcxrRR2mjT2awEBynpuJtWKApBl7Y0vgwuSWA8mRymcZeanoue', 'Octave', 'Ergébel'), ('Tanguy.Rlandé@orange.fr', '$2y$10$Iejmdta5dh2xrObcELFZf.Ppp5n1Yu4SMt62Bdu/ibnMUBeUS7APy', 'Tanguy', 'Rlandé'), ('Julie.Bellule@live.fr', '$2y$10$.VXHU.Jq3izps9zyPXdg0eYdJ.pmf1S4RbzfWGgfL5IHpXSuGCwZ2', 'Julie', 'Bellule'), ('Edmond.Prochain@orange.fr', '$2y$10$r2FSqrNsDeqSLOFP0AkV2uRAMreg1Uj9vejHBK3j0ZqS3I9CIgYry', 'Edmond', 'Prochain'), ('Tom.Béllachemiz@orange.fr', '$2y$10$BD0uz6oH5VZjaDJPvfdLgOSFlO2sOODWS1zxMkfb/LFOo5ZLZD65a', 'Tom', 'Béllachemiz'), ('Mouss.Tique@gmail.com', '$2y$10$6D.uzEISeEcGaFJXJg/Xe..pJmt.bv4JW4qW2zBEwFcxtSFLXPCkO', 'Mouss', 'Tique'), ('Anne.Ivérsaire@live.fr', '$2y$10$u0EbpSxNZ2BzdQkbGB9BVujaIrYReEt29ECf9AFQ90Fe3PW..a74O', 'Anne', 'Ivérsaire'), ('Marie.Vaudage@orange.fr', '$2y$10$dc4..reHhlp7yXG5LE/OWOM3S7bWnJCT9xo0DgBsPmE5yVnSQs35q', 'Marie', 'Vaudage'), ('Lara.Clure@orange.fr', '$2y$10$pwwOVJzG/IrjmeuX8xBr1.tAswCY9swaeoJsLXrB1Lzo4BS7GaiTu', 'Lara', 'Clure'), ('Cécile.Anssieux@orange.fr', '$2y$10$VnIAojBPLTy2BKb/LWvVMu1niE3/QppuWZ5p36fjK/8XYG/uSXTie', 'Cécile', 'Anssieux'), ('Kelly.Bellule@live.fr', '$2y$10$/TfHiq2DzsoipSMgYCNpvejsVB/LZoh/O7utVgo1fePhBlO6cz.Ka', 'Kelly', 'Bellule'), ('Al.Batrosse@gmail.com', '$2y$10$eMEDf4Kc8tSNnqIxmioojuFvyreu6dNBMZT2AkxVqrS.0GqHaQAZu', 'Al', 'Batrosse'), ('Maude.Zarela@orange.fr', '$2y$10$ZXrz3.q/MyeIKck/5Pd9h.hDYPWM2.gIq8DpMwgM8.JECkQNTTXZ.', 'Maude', 'Zarela'), ('Jean.Benbois@gmail.com', '$2y$10$ulIPsa8p/78wOITcTNZ8ieRSF3pOcY.M5oiUlJl5TiNn7MQ9SMVhe', 'Jean', 'Benbois'), ('Paul.Tergeist@orange.fr', '$2y$10$PcJt0WszlMxaDZuLASEyd.pOpUuGunC3sEKamjdsPxSUp0VZ8z8li', 'Paul', 'Tergeist'), ('Henri.Chie@orange.fr', '$2y$10$g7ACI.JpWpiUgeqyB9R83ObclebPzsI3FfU9q5Jr/CWwKr.PmyCjW', 'Henri', 'Chie'), ('Mandy.Paplusse@gmail.com', '$2y$10$80K3AZOgtaYXsAB1ie9m/ONzYxSxXbC3JEHl7uYCT5YGuuQiWAYLe', 'Mandy', 'Paplusse'), ('Alex.Ception@gmail.com', '$2y$10$kxhTvcPxUbU3CZmW93kwIeLAftUrIUHdSGehpGmSELkjuUGYdImV6', 'Alex', 'Ception'), ('Marty.Ni@gmail.com', '$2y$10$l93wDXjJp/eJTsuIw5.O3eWcfITsSawBRO.n1PUUCTn3PnwFuDwwy', 'Marty', 'Ni'), ('Otto.Psie@gmail.com', '$2y$10$qDRHHHvuqt3vTcaDfN4na.4sGhkxp92mD.sObwC8zZ3cDO8qnhTEq', 'Otto', 'Psie'), ('Oscar.Ibou@live.fr', '$2y$10$KccXuZBsJy/cB.MURPZiS.gmfsDqR1rxPTzKXarZ0U9hzvyzvochi', 'Oscar', 'Ibou'), ('Paul.Emploi@gmail.com', '$2y$10$2MtSwvskf/DobjZIVEgZ2eurHVsPNzNEI7TIidgIrHadx34LhXque', 'Paul', 'Emploi'), ('Léo.Desseine@orange.fr', '$2y$10$NTcXrrJpdKvmg/oRLPohfOqDTRI1/yFRQgGIXW5kV7mVLCPiC3Voy', 'Léo', 'Desseine'), ('Jean.Peuplu@live.fr', '$2y$10$W501jHAkAgmmUfZ8HiGcuOnvQX.ac6WHP/zG7eVCJ/Aecaf78qYHi', 'Jean', 'Peuplu'), ('Abel.Igérant@orange.fr', '$2y$10$UPXk5UovSMoBZELSnniJQeaVRTdksnUSPJmZxgVcQPX93SsABVkV2', 'Abel', 'Igérant'), ('Anna.Tomie@orange.fr', '$2y$10$XytQk7WJNTfs7JKp9Vb.ZuUT4xCXkYg4t3mNO5tfWFLfJ2xatrQM6', 'Anna', 'Tomie'), ('Adam.Desemène@live.fr', '$2y$10$tED0vpl4i.n4qLEdS9czjej2d7Gf8q69Wlp1GJhUm/kKT9jICBnOq', 'Adam', 'Desemène'), ('Théo.Courant@gmail.com', '$2y$10$V.4Y7wqZ36Zx4Un5GeRON.NwSH2GKSZzyG95tCtCYyALL.PVclazy', 'Théo', 'Courant'), ('Claude.Cologne@gmail.com', '$2y$10$0RR3yXd/ACatpXoTD0dt6Oa7cLIoCK4l9XtaA1NZr2K.nL2S0MV4O', 'Claude', 'Cologne'), ('Jim.Agine@orange.fr', '$2y$10$ikF6OlAnasJxeUUk.oJ3IexXgVi7jwTUcr.HnucPwCIZUFKXc4ZeK', 'Jim', 'Agine'), ('Ève.Anoui@orange.fr', '$2y$10$Ux62zbjpIAcePUerKm0X1.gBiW8xx3cX4DLlC643VYmOcPQuI3jNm', 'Ève', 'Anoui'), ('Edgard.Ogorille@live.fr', '$2y$10$RY/S/cK/Lh6SgZyczyod2ui1s2XMp8nUj58sZZJO.3k2Ahr21No9y', 'Edgard', 'Ogorille'), ('Mouss.Quetaire@live.fr', '$2y$10$6UgPOgD1wdEB7GndqRv4IO3b8NyI8GvZwm7wsWaUNhnKkgFsKOGDi', 'Mouss', 'Quetaire'), ('Jean.Tube@gmail.com', '$2y$10$qyn4brvyKX5uKFC.wRRqDOJyVXC9QWm8t6Z4z3PBpALXGSTe1x8.S', 'Jean', 'Tube'), ('Bernard.Guilé@live.fr', '$2y$10$KerSpb8Hxky9t.RggZbR1uTabdFH6K4vGXtPUG60Rb.ynVWlKA4zW', 'Bernard', 'Guilé'), ('Yann.Erie@orange.fr', '$2y$10$e522t389.laZg8Abv1yS4ewYsv6buznlFU48GNkGdsesMiOScgyxa', 'Yann', 'Erie'), ('Clément.Tyne@gmail.com', '$2y$10$Qd001S.qbEz6XjlsW1VrbuOH8PyzcoJ.ul1uUWoAUlbTw0NQsax8m', 'Clément', 'Tyne'), ('Jordy.Nateur@orange.fr', '$2y$10$RgAGaBWyqUYkktEyrNtZAei5JX.KWuF0ur6Zoup6LAswBST2dQzSi', 'Jordy', 'Nateur'), ('Didier.Tétique@gmail.com', '$2y$10$Qg9U/vaarW5sVHz6JDWAb.a00uIdYZzZnhQVzbIf35pXcv6SFF2jW', 'Didier', 'Tétique'), ('Abel.Védaire@gmail.com', '$2y$10$OpUBOXV5MFeykeW9TEMQkOL0EGagLic78Pkc0LJAOYGU/xBRSqzkq', 'Abel', 'Védaire'), ('Tarik.Ané@gmail.com', '$2y$10$yMYx5Xed.QplMt./Zw.rk.RzHPyfItcPrZyy1IFO3TcCx..RFdb5C', 'Tarik', 'Ané'), ('Tony.Truand@orange.fr', '$2y$10$7ZoVuJ7rCWMOHwcbhsQ9kepdO.4P7Mon58wZSVke.MpDiIFxl1brq', 'Tony', 'Truand');

-- ef_telephone
INSERT INTO ef_telephone VALUES (0, 'Mehdi.Zan@gmail.com', '0624516192'), (1, 'Théo.Jasmin@live.fr', '0699889408'), (2, 'jimmy.Lesbieraufrai@live.fr', '0640863929'), (3, 'Alan.Haliz@gmail.com', '0676514683'), (4, 'Anne.Onyme@gmail.com', '0691540409'), (5, 'Jean-Paul.Iglotte@gmail.com', '0647507894'), (6, 'Laurent.Bar@live.fr', '0615441496'), (7, 'Maude.Cologne@gmail.com', '0616014715'), (8, 'Octave.Ergébel@orange.fr', '0613416253'), (9, 'Tanguy.Rlandé@orange.fr', '068572106'), (10, 'Julie.Bellule@live.fr', '0678704445'), (11, 'Edmond.Prochain@orange.fr', '0629727853'), (12, 'Tom.Béllachemiz@orange.fr', '066730906'), (13, 'Mouss.Tique@gmail.com', '0627000744'), (14, 'Anne.Ivérsaire@live.fr', '0616612713'), (15, 'Marie.Vaudage@orange.fr', '0689031290'), (16, 'Lara.Clure@orange.fr', '0656628123'), (17, 'Cécile.Anssieux@orange.fr', '0698375280'), (18, 'Kelly.Bellule@live.fr', '0666454845'), (19, 'Al.Batrosse@gmail.com', '0673638403'), (20, 'Maude.Zarela@orange.fr', '0650226517'), (21, 'Jean.Benbois@gmail.com', '0672797372'), (22, 'Paul.Tergeist@orange.fr', '0617659780'), (23, 'Henri.Chie@orange.fr', '0637771899'), (24, 'Mandy.Paplusse@gmail.com', '0666719559'), (25, 'Alex.Ception@gmail.com', '0672728207'), (26, 'Marty.Ni@gmail.com', '0670324485'), (27, 'Otto.Psie@gmail.com', '0679018949'), (28, 'Oscar.Ibou@live.fr', '0687061991'), (29, 'Paul.Emploi@gmail.com', '066353056'), (30, 'Léo.Desseine@orange.fr', '0654399319'), (31, 'Jean.Peuplu@live.fr', '0664776792'), (32, 'Abel.Igérant@orange.fr', '0642456468'), (33, 'Anna.Tomie@orange.fr', '0630578128'), (34, 'Adam.Desemène@live.fr', '0631693821'), (35, 'Théo.Courant@gmail.com', '0693277936'), (36, 'Claude.Cologne@gmail.com', '0639677930'), (37, 'Jim.Agine@orange.fr', '0667603050'), (38, 'Ève.Anoui@orange.fr', '0648978630'), (39, 'Edgard.Ogorille@live.fr', '0612438883'), (40, 'Mouss.Quetaire@live.fr', '0680362761'), (41, 'Jean.Tube@gmail.com', '0653473926'), (42, 'Bernard.Guilé@live.fr', '0620651046'), (43, 'Yann.Erie@orange.fr', '0672015022'), (44, 'Clément.Tyne@gmail.com', '0685557282'), (45, 'Jordy.Nateur@orange.fr', '0684289810'), (46, 'Didier.Tétique@gmail.com', '0656300883'), (47, 'Abel.Védaire@gmail.com', '0673039609'), (48, 'Tarik.Ané@gmail.com', '0632417209'), (49, 'Tony.Truand@orange.fr', '0680014259');

-- ef_address
INSERT INTO ef_address VALUES (0, 'Mehdi.Zan@gmail.com', '19 Rue de l\'Arbre Sec', '69001', 'Lyon', NULL), (1, 'Théo.Jasmin@live.fr', '4 Rue Alsace Lorraine', '69001', 'Lyon', NULL), (2, 'jimmy.Lesbieraufrai@live.fr', '2 Rue d\'Algérie', '69001', 'Lyon', NULL), (3, 'Alan.Haliz@gmail.com', '16 Rue d\'Algérie', '69001', 'Lyon', NULL), (4, 'Anne.Onyme@gmail.com', '11 Quai André Lassagne', '69001', 'Lyon', NULL), (5, 'Jean-Paul.Iglotte@gmail.com', '22 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (6, 'Laurent.Bar@live.fr', '9 Quai André Lassagne', '69001', 'Lyon', NULL), (7, 'Maude.Cologne@gmail.com', '8 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (8, 'Octave.Ergébel@orange.fr', '2 Rue de l\'Alma', '69001', 'Lyon', NULL), (9, 'Tanguy.Rlandé@orange.fr', '13 Quai André Lassagne', '69001', 'Lyon', NULL), (10, 'Julie.Bellule@live.fr', '5 Quai André Lassagne', '69001', 'Lyon', NULL), (11, 'Edmond.Prochain@orange.fr', '10 Quai André Lassagne', '69001', 'Lyon', NULL), (12, 'Tom.Béllachemiz@orange.fr', '7 Rue de l\'Alma', '69001', 'Lyon', NULL), (13, 'Mouss.Tique@gmail.com', '10 Rue de l\'Alma', '69001', 'Lyon', NULL), (14, 'Anne.Ivérsaire@live.fr', '11 Rue d\'Algérie', '69001', 'Lyon', NULL), (15, 'Marie.Vaudage@orange.fr', '9 Rue de l\'Alma', '69001', 'Lyon', NULL), (16, 'Lara.Clure@orange.fr', '5 Rue Alsace Lorraine', '69001', 'Lyon', NULL), (17, 'Cécile.Anssieux@orange.fr', '17 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (18, 'Kelly.Bellule@live.fr', '3 Rue Alsace Lorraine', '69001', 'Lyon', NULL), (19, 'Al.Batrosse@gmail.com', '26 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (20, 'Maude.Zarela@orange.fr', '15 Rue d\'Algérie', '69001', 'Lyon', NULL), (21, 'Jean.Benbois@gmail.com', '21 Rue d\'Algérie', '69001', 'Lyon', NULL), (22, 'Paul.Tergeist@orange.fr', '9 Rue Alsace Lorraine', '69001', 'Lyon', NULL), (23, 'Henri.Chie@orange.fr', '8 Rue d\'Algérie', '69001', 'Lyon', NULL), (24, 'Mandy.Paplusse@gmail.com', '2 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (25, 'Alex.Ception@gmail.com', '14 Rue de l\'Arbre Sec', '69001', 'Lyon', NULL), (26, 'Marty.Ni@gmail.com', '5 Rue de l\'Alma', '69001', 'Lyon', NULL), (27, 'Otto.Psie@gmail.com', '7 Rue Alsace Lorraine', '69001', 'Lyon', NULL), (28, 'Oscar.Ibou@live.fr', '5 Rue Adamoli', '69001', 'Lyon', NULL), (29, 'Paul.Emploi@gmail.com', '10 Rue d\'Algérie', '69001', 'Lyon', NULL), (30, 'Léo.Desseine@orange.fr', '28 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (31, 'Jean.Peuplu@live.fr', '12 Quai André Lassagne', '69001', 'Lyon', NULL), (32, 'Abel.Igérant@orange.fr', '20 Rue d\'Algérie', '69001', 'Lyon', NULL), (33, 'Anna.Tomie@orange.fr', '10 Rue de l\'Arbre Sec', '69001', 'Lyon', NULL), (34, 'Adam.Desemène@live.fr', '21 Rue Alsace Lorraine', '69001', 'Lyon', NULL), (35, 'Théo.Courant@gmail.com', '13 Rue de l\'Arbre Sec', '69001', 'Lyon', NULL), (36, 'Claude.Cologne@gmail.com', '3 Rue de l\'Alma', '69001', 'Lyon', NULL), (37, 'Jim.Agine@orange.fr', '20 Rue de l\'Arbre Sec', '69001', 'Lyon', NULL), (38, 'Ève.Anoui@orange.fr', '14 Quai André Lassagne', '69001', 'Lyon', NULL), (39, 'Edgard.Ogorille@live.fr', '4 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (40, 'Mouss.Quetaire@live.fr', '2 Rue Alsace Lorraine', '69001', 'Lyon', NULL), (41, 'Jean.Tube@gmail.com', '13 Rue de l\'Alma', '69001', 'Lyon', NULL), (42, 'Bernard.Guilé@live.fr', '8 Rue de l\'Alma', '69001', 'Lyon', NULL), (43, 'Yann.Erie@orange.fr', '9 Rue d\'Algérie', '69001', 'Lyon', NULL), (44, 'Clément.Tyne@gmail.com', '3 Quai André Lassagne', '69001', 'Lyon', NULL), (45, 'Jordy.Nateur@orange.fr', '17 Rue Alsace Lorraine', '69001', 'Lyon', NULL), (46, 'Didier.Tétique@gmail.com', '23 Rue d\'Algérie', '69001', 'Lyon', NULL), (47, 'Abel.Védaire@gmail.com', '15 Rue de l\'Alma', '69001', 'Lyon', NULL), (48, 'Tarik.Ané@gmail.com', '16 Quai André Lassagne', '69001', 'Lyon', NULL), (49, 'Tony.Truand@orange.fr', '6 Rue Alsace Lorraine', '69001', 'Lyon', NULL);

-- ef_employee
INSERT INTO ef_employee VALUES (0, 'Mehdi.Zan@gmail.com'), (1, 'Théo.Jasmin@live.fr'), (2, 'jimmy.Lesbieraufrai@live.fr'), (3, 'Alan.Haliz@gmail.com'), (4, 'Anne.Onyme@gmail.com'), (5, 'Jean-Paul.Iglotte@gmail.com'), (6, 'Laurent.Bar@live.fr'), (7, 'Maude.Cologne@gmail.com'), (8, 'Octave.Ergébel@orange.fr'), (9, 'Tanguy.Rlandé@orange.fr'), (10, 'Julie.Bellule@live.fr'), (11, 'Edmond.Prochain@orange.fr'), (12, 'Tom.Béllachemiz@orange.fr'), (13, 'Mouss.Tique@gmail.com'), (14, 'Anne.Ivérsaire@live.fr'), (15, 'Marie.Vaudage@orange.fr'), (16, 'Lara.Clure@orange.fr'), (17, 'Cécile.Anssieux@orange.fr'), (18, 'Kelly.Bellule@live.fr'), (19, 'Al.Batrosse@gmail.com');

-- ef_client
INSERT INTO ef_client VALUES (0, 'Maude.Zarela@orange.fr'), (1, 'Jean.Benbois@gmail.com'), (2, 'Paul.Tergeist@orange.fr'), (3, 'Henri.Chie@orange.fr'), (4, 'Mandy.Paplusse@gmail.com'), (5, 'Alex.Ception@gmail.com'), (6, 'Marty.Ni@gmail.com'), (7, 'Otto.Psie@gmail.com'), (8, 'Oscar.Ibou@live.fr'), (9, 'Paul.Emploi@gmail.com'), (10, 'Léo.Desseine@orange.fr'), (11, 'Jean.Peuplu@live.fr'), (12, 'Abel.Igérant@orange.fr'), (13, 'Anna.Tomie@orange.fr'), (14, 'Adam.Desemène@live.fr'), (15, 'Théo.Courant@gmail.com'), (16, 'Claude.Cologne@gmail.com'), (17, 'Jim.Agine@orange.fr'), (18, 'Ève.Anoui@orange.fr'), (19, 'Edgard.Ogorille@live.fr'), (20, 'Mouss.Quetaire@live.fr'), (21, 'Jean.Tube@gmail.com'), (22, 'Bernard.Guilé@live.fr'), (23, 'Yann.Erie@orange.fr'), (24, 'Clément.Tyne@gmail.com'), (25, 'Jordy.Nateur@orange.fr'), (26, 'Didier.Tétique@gmail.com'), (27, 'Abel.Védaire@gmail.com'), (28, 'Tarik.Ané@gmail.com'), (29, 'Tony.Truand@orange.fr');

-- ef_delivery_guy
INSERT INTO ef_delivery_guy VALUES (0, 'Disponible', '45.7616', '4.7612'), (1, 'Disponible', '45.7698', '4.7624'), (2, 'Disponible', '45.7693', '4.7779'), (3, 'Hors connexion', '45.7774', '4.7747'), (4, 'En livraison', '45.7721', '4.7672'), (5, 'Disponible', '45.7736', '4.7650'), (6, 'Hors connexion', '45.7717', '4.7692'), (7, 'En livraison', '45.7692', '4.7756'), (8, 'Hors connexion', '45.7603', '4.7696'), (9, 'Hors connexion', '45.7719', '4.7742');

-- ef_cook
INSERT INTO ef_cook VALUES (10), (11), (12), (13), (14), (15), (16), (17), (18), (19);

-- ef_order
INSERT INTO ef_order VALUES (0, 15, 3, '2018-05-27 12:07:41', 'En attente'), (1, 10, 6, '2018-05-19 16:23:13', 'Annulée'), (2, 23, 8, '2018-05-14 13:15:29', 'En attente'), (3, 9, 3, '2018-05-22 11:47:11', 'En attente'), (4, 11, 3, '2018-05-05 11:52:22', 'Payée'), (5, 6, 4, '2018-05-22 12:07:52', 'Payée'), (6, 1, 5, '2018-05-06 17:17:16', 'Payée'), (7, 13, 4, '2018-05-16 14:58:31', 'Annulée'), (8, 16, 4, '2018-05-01 20:09:36', 'En attente'), (9, 12, 2, '2018-05-25 17:54:15', 'Annulée'), (10, 12, 0, '2018-05-15 13:13:47', 'Payée'), (11, 6, 7, '2018-05-16 15:47:49', 'Payée'), (12, 28, 9, '2018-05-18 17:22:11', 'Annulée'), (13, 29, 6, '2018-05-14 13:50:31', 'Annulée'), (14, 15, 8, '2018-05-06 16:27:10', 'En attente'), (15, 3, 2, '2018-05-22 11:10:33', 'En attente'), (16, 4, 0, '2018-05-15 16:56:50', 'Payée'), (17, 9, 1, '2018-05-19 14:45:24', 'En attente'), (18, 16, 1, '2018-05-06 13:47:30', 'En attente'), (19, 1, 6, '2018-05-26 12:01:29', 'Livrée'), (20, 4, 0, '2018-05-23 18:41:36', 'Annulée'), (21, 18, 8, '2018-05-19 13:24:09', 'Livrée'), (22, 26, 1, '2018-05-13 20:12:41', 'Payée'), (23, 22, 7, '2018-05-06 14:40:43', 'Payée'), (24, 19, 8, '2018-05-22 16:00:56', 'Payée'), (25, 10, 2, '2018-05-18 20:40:16', 'En attente'), (26, 26, 8, '2018-05-07 16:51:31', 'Livrée'), (27, 4, 0, '2018-05-09 15:00:20', 'Payée'), (28, 22, 1, '2018-05-19 19:43:35', 'Payée'), (29, 7, 5, '2018-05-09 17:06:14', 'En attente'), (30, 12, 0, '2018-05-21 16:20:45', 'Livrée'), (31, 20, 5, '2018-05-28 18:45:02', 'Payée'), (32, 18, 9, '2018-05-02 16:12:41', 'En attente'), (33, 21, 8, '2018-05-11 17:34:02', 'Livrée'), (34, 18, 4, '2018-05-05 15:07:21', 'Livrée'), (35, 19, 2, '2018-05-12 13:47:03', 'Annulée'), (36, 11, 3, '2018-05-19 18:51:01', 'Payée'), (37, 24, 5, '2018-05-05 11:30:46', 'En attente'), (38, 27, 3, '2018-05-04 18:58:52', 'Payée'), (39, 4, 2, '2018-05-01 12:24:57', 'Livrée'), (40, 27, 5, '2018-05-03 11:56:46', 'Payée'), (41, 27, 5, '2018-05-24 15:28:56', 'Payée'), (42, 18, 3, '2018-05-13 14:06:15', 'En attente'), (43, 20, 8, '2018-05-11 12:17:25', 'En attente'), (44, 8, 0, '2018-05-04 11:46:14', 'Annulée'), (45, 21, 0, '2018-05-02 17:11:55', 'En attente'), (46, 26, 6, '2018-05-24 18:09:51', 'Livrée'), (47, 22, 5, '2018-05-15 12:29:49', 'Annulée'), (48, 4, 0, '2018-05-06 13:39:01', 'Payée'), (49, 26, 5, '2018-05-08 18:59:04', 'Annulée'), (50, 27, 5, '2018-05-02 12:58:49', 'Payée'), (51, 11, 4, '2018-05-04 20:31:40', 'Payée'), (52, 0, 8, '2018-05-13 20:01:56', 'Livrée'), (53, 18, 6, '2018-05-12 19:47:54', 'Annulée'), (54, 0, 0, '2018-05-15 15:48:01', 'Livrée'), (55, 17, 8, '2018-05-02 12:20:29', 'Payée'), (56, 19, 0, '2018-05-05 14:21:07', 'En attente'), (57, 18, 2, '2018-05-23 14:01:36', 'Payée'), (58, 5, 0, '2018-05-18 14:01:03', 'En attente'), (59, 5, 0, '2018-05-10 17:58:49', 'En attente'), (60, 24, 7, '2018-05-08 13:57:05', 'En attente'), (61, 12, 4, '2018-05-22 15:43:04', 'En attente'), (62, 29, 3, '2018-05-10 11:03:25', 'En attente'), (63, 26, 3, '2018-05-22 16:26:56', 'Payée'), (64, 27, 3, '2018-05-21 14:47:37', 'Annulée'), (65, 8, 7, '2018-05-07 19:02:08', 'Livrée'), (66, 18, 9, '2018-05-22 20:42:58', 'Annulée'), (67, 14, 7, '2018-05-22 18:31:35', 'Livrée'), (68, 4, 8, '2018-05-19 20:47:02', 'Annulée'), (69, 22, 6, '2018-05-12 11:33:16', 'En attente'), (70, 10, 0, '2018-05-27 17:33:31', 'Annulée'), (71, 24, 6, '2018-05-07 17:51:40', 'Livrée'), (72, 15, 7, '2018-05-12 18:08:39', 'Annulée'), (73, 4, 1, '2018-05-02 15:51:07', 'En attente'), (74, 9, 9, '2018-05-23 11:06:19', 'En attente'), (75, 16, 7, '2018-05-03 12:57:51', 'Annulée'), (76, 0, 8, '2018-05-24 11:10:42', 'Livrée'), (77, 26, 3, '2018-05-12 19:57:08', 'Livrée'), (78, 2, 3, '2018-05-07 18:24:40', 'En attente'), (79, 12, 6, '2018-05-10 12:27:53', 'En attente'), (80, 16, 7, '2018-05-15 19:20:58', 'Livrée'), (81, 6, 8, '2018-05-06 16:08:22', 'Annulée'), (82, 11, 0, '2018-05-16 17:21:22', 'Livrée'), (83, 25, 6, '2018-05-22 13:56:37', 'Payée'), (84, 24, 4, '2018-05-23 18:21:51', 'Annulée'), (85, 24, 9, '2018-05-06 18:26:36', 'Annulée'), (86, 26, 1, '2018-05-14 12:50:03', 'En attente'), (87, 19, 9, '2018-05-21 12:37:54', 'Annulée'), (88, 16, 9, '2018-05-02 20:57:11', 'En attente'), (89, 26, 7, '2018-05-07 16:22:54', 'Payée'), (90, 3, 2, '2018-05-22 11:53:11', 'En attente'), (91, 2, 9, '2018-05-03 17:13:30', 'En attente'), (92, 16, 7, '2018-05-21 16:05:55', 'Payée'), (93, 10, 0, '2018-05-15 14:21:28', 'Annulée'), (94, 14, 0, '2018-05-16 16:17:15', 'Payée'), (95, 22, 9, '2018-05-26 17:38:19', 'Payée'), (96, 22, 8, '2018-05-13 13:50:09', 'Payée'), (97, 12, 9, '2018-05-05 14:14:44', 'Annulée'), (98, 25, 8, '2018-05-21 17:36:01', 'En attente'), (99, 0, 4, '2018-05-24 11:52:09', 'En attente');

-- ef_daily_list
INSERT INTO ef_daily_list VALUES ('2018-05-1', 18), ('2018-05-2', 14), ('2018-05-3', 11), ('2018-05-4', 17), ('2018-05-5', 16), ('2018-05-6', 16), ('2018-05-7', 14), ('2018-05-8', 19), ('2018-05-9', 10), ('2018-05-10', 18);

-- ef_daily_list_content
INSERT INTO ef_daily_list_content VALUES ('2018-05-1', 'Tartiflette'), ('2018-05-1', 'Crumble aux pommes'), ('2018-05-1', 'Poëlée montagnarde'), ('2018-05-1', 'Clafoutis aux pommes'), ('2018-05-2', 'Burger vosgien'), ('2018-05-2', 'Tarte aux pommes'), ('2018-05-2', 'Salade vosgienne'), ('2018-05-2', 'Compote de pommes'), ('2018-05-3', 'Aligot'), ('2018-05-3', 'Crumble aux poires'), ('2018-05-3', 'Carottes rapées'), ('2018-05-3', 'Clafoutis aux poires'), ('2018-05-4', 'Betteraves rouges'), ('2018-05-4', 'Tarte aux poires'), ('2018-05-4', 'Gratin dauphinois'), ('2018-05-4', 'Compote de poires'), ('2018-05-5', 'Gratin de choux-fleurs'), ('2018-05-5', 'Crumble aux prunes'), ('2018-05-5', 'Gratin de brocolis'), ('2018-05-5', 'Clafoutis aux prunes'), ('2018-05-6', 'Salade niçoise'), ('2018-05-6', 'Tarte aux prunes'), ('2018-05-6', 'Coquilles saint Jacques'), ('2018-05-6', 'Compote de prunes'), ('2018-05-7', 'Nems au poulet'), ('2018-05-7', 'Crumble aux cerises'), ('2018-05-7', 'Pizza 4 fromages'), ('2018-05-7', 'Clafoutis aux cerises'), ('2018-05-8', 'Riz cantonnais'), ('2018-05-8', 'Tarte aux cerises'), ('2018-05-8', 'Omelette aux olives'), ('2018-05-8', 'Compote de cerises'), ('2018-05-9', 'Quiche lorraine'), ('2018-05-9', 'Mousse au chocolat'), ('2018-05-9', 'Pot au feu'), ('2018-05-9', 'Brownie au chocolat'), ('2018-05-10', 'Pizza reine'), ('2018-05-10', 'Charlotte aux framboises'), ('2018-05-10', 'Risotto aux olives'), ('2018-05-10', 'Paris Brest');

-- ef_order_content
INSERT INTO ef_order_content VALUES (0, 'Brownie au chocolat', 4), (1, 'Carottes rapées', 4), (1, 'Compote de pommes', 1), (1, 'Brownie au chocolat', 3), (1, 'Gratin dauphinois', 1), (2, 'Quiche lorraine', 1), (2, 'Risotto aux olives', 3), (2, 'Paris Brest', 2), (3, 'Salade niçoise', 4), (4, 'Crumble aux pommes', 4), (5, 'Crumble aux prunes', 2), (5, 'Pizza 4 fromages', 2), (6, 'Compote de poires', 2), (6, 'Paris Brest', 2), (6, 'Risotto aux olives', 2), (6, 'Soupe aux légumes', 2), (7, 'Brownie au chocolat', 2), (7, 'Tarte aux poires', 2), (8, 'Salade niçoise', 2), (8, 'Gratin de brocolis', 1), (8, 'Pizza reine', 1), (9, 'Compote de pommes', 3), (10, 'Clafoutis aux poires', 3), (10, 'Salade vosgienne', 3), (10, 'Pizza 4 fromages', 2), (11, 'Soupe aux légumes', 3), (12, 'Clafoutis aux cerises', 4), (12, 'Crumble aux prunes', 2), (12, 'Paris Brest', 2), (13, 'Tarte aux pommes', 1), (13, 'Gratin de choux-fleurs', 3), (14, 'Poivrons farcis', 2), (15, 'Tartiflette', 1), (15, 'Aubergines farcies', 4), (16, 'Clafoutis aux poires', 2), (16, 'Crumble aux poires', 3), (16, 'Betteraves rouges', 2), (17, 'Betteraves rouges', 1), (17, 'Tartiflette', 4), (17, 'Nems au poulet', 3), (18, 'Pizza reine', 4), (18, 'Paris Brest', 1), (18, 'Clafoutis aux cerises', 4), (19, 'Pizza 4 fromages', 4), (20, 'Crumble aux pommes', 2), (20, 'Crumble aux cerises', 4), (20, 'Salade vosgienne', 2), (21, 'Compote de poires', 2), (22, 'Crumble aux cerises', 3), (22, 'Tarte aux cerises', 3), (23, 'Tarte aux pommes', 3), (23, 'Omelette aux olives', 3), (23, 'Poëlée montagnarde', 2), (24, 'Riz cantonnais', 2), (24, 'Tarte aux prunes', 1), (25, 'Paris Brest', 3), (25, 'Tartiflette', 3), (26, 'Tomates farcies', 1), (27, 'Crumble aux prunes', 4), (27, 'Crumble aux poires', 2), (27, 'Clafoutis aux prunes', 2), (28, 'Tartiflette', 4), (29, 'Crumble aux prunes', 2), (29, 'Clafoutis aux cerises', 4), (30, 'Burger vosgien', 2), (30, 'Salade vosgienne', 4), (30, 'Paris Brest', 4), (31, 'Croques monsieur', 2), (31, 'Salade vosgienne', 2), (31, 'Tomates farcies', 2), (32, 'Soupe aux légumes', 4), (32, 'Brownie au chocolat', 3), (32, 'Coquilles saint Jacques', 1), (33, 'Carottes rapées', 4), (33, 'Omelette aux olives', 3), (33, 'Brownie au chocolat', 3), (33, 'Salade niçoise', 4), (34, 'Poëlée montagnarde', 2), (34, 'Compote de pommes', 2), (35, 'Risotto aux olives', 4), (35, 'Salade niçoise', 1), (36, 'Compote de prunes', 1), (36, 'Mousse au chocolat', 4), (37, 'Risotto aux olives', 4), (38, 'Riz cantonnais', 2), (38, 'Pizza 4 fromages', 1), (39, 'Clafoutis aux pommes', 1), (40, 'Pot au feu', 2), (40, 'Mousse au chocolat', 2), (40, 'Compote de prunes', 4), (41, 'Nems au poulet', 1), (42, 'Pot au feu', 4), (43, 'Croques monsieur', 2), (44, 'Aligot', 2), (44, 'Croques monsieur', 3), (45, 'Paris Brest', 2), (46, 'Paris Brest', 3), (46, 'Crumble aux poires', 2), (47, 'Crumble aux poires', 2), (48, 'Quiche lorraine', 3), (48, 'Gratin de brocolis', 4), (49, 'Salade vosgienne', 4), (50, 'Omelette aux olives', 4), (51, 'Coquilles saint Jacques', 2), (51, 'Compote de prunes', 3), (51, 'Poivrons farcis', 2), (52, 'Compote de pommes', 2), (52, 'Tomates farcies', 3), (52, 'Pot au feu', 2), (53, 'Pot au feu', 2), (53, 'Mousse au chocolat', 3), (53, 'Crumble aux prunes', 1), (53, 'Tomates farcies', 2), (54, 'Mousse au chocolat', 3), (54, 'Aubergines farcies', 3), (54, 'Compote de pommes', 2), (54, 'Burger vosgien', 1), (55, 'Poivrons farcis', 4), (55, 'Clafoutis aux poires', 3), (56, 'Nems au poulet', 1), (56, 'Tarte aux prunes', 3), (57, 'Crumble aux pommes', 4), (57, 'Tomates farcies', 1), (57, 'Aligot', 2), (58, 'Tarte aux pommes', 1), (59, 'Burger vosgien', 3), (59, 'Carottes rapées', 2), (60, 'Tarte aux prunes', 4), (60, 'Coquilles saint Jacques', 4), (60, 'Aubergines farcies', 4), (60, 'Clafoutis aux prunes', 3), (61, 'Pot au feu', 4), (61, 'Tarte aux prunes', 1), (61, 'Tartiflette', 2), (62, 'Brownie au chocolat', 4), (62, 'Burger vosgien', 1), (62, 'Tartiflette', 4), (63, 'Crumble aux pommes', 3), (63, 'Pizza reine', 4), (63, 'Coquilles saint Jacques', 3), (63, 'Poivrons farcis', 2), (64, 'Tomates farcies', 1), (64, 'Salade niçoise', 3), (64, 'Compote de pommes', 2), (65, 'Compote de prunes', 2), (65, 'Tartiflette', 2), (66, 'Gratin de brocolis', 3), (66, 'Crumble aux pommes', 3), (67, 'Compote de prunes', 3), (67, 'Soupe aux légumes', 3), (67, 'Nems au poulet', 4), (68, 'Crumble aux cerises', 4), (68, 'Compote de poires', 1), (68, 'Compote de prunes', 3), (68, 'Nems au poulet', 1), (69, 'Clafoutis aux poires', 2), (70, 'Crumble aux poires', 4), (70, 'Clafoutis aux cerises', 4), (70, 'Tarte aux cerises', 4), (71, 'Burger vosgien', 4), (71, 'Clafoutis aux pommes', 2), (71, 'Clafoutis aux cerises', 4), (71, 'Paris Brest', 3), (72, 'Carottes rapées', 1), (73, 'Clafoutis aux cerises', 1), (73, 'Tarte aux pommes', 2), (74, 'Pizza 4 fromages', 1), (74, 'Clafoutis aux pommes', 3), (75, 'Croques monsieur', 4), (75, 'Compote de prunes', 1), (75, 'Poëlée montagnarde', 1), (76, 'Gratin de choux-fleurs', 2), (76, 'Brownie au chocolat', 3), (77, 'Pot au feu', 2), (77, 'Paris Brest', 2), (78, 'Poëlée montagnarde', 3), (78, 'Clafoutis aux cerises', 3), (79, 'Pizza 4 fromages', 1), (79, 'Carottes rapées', 1), (79, 'Risotto aux olives', 1), (80, 'Pot au feu', 2), (80, 'Risotto aux olives', 4), (81, 'Tarte aux poires', 4), (81, 'Omelette aux olives', 2), (81, 'Aligot', 4), (82, 'Burger vosgien', 1), (82, 'Aubergines farcies', 3), (82, 'Salade niçoise', 3), (83, 'Quiche lorraine', 4), (83, 'Tarte aux poires', 4), (84, 'Pizza 4 fromages', 3), (84, 'Omelette aux olives', 2), (85, 'Clafoutis aux poires', 2), (85, 'Nems au poulet', 4), (86, 'Nems au poulet', 1), (87, 'Gratin de choux-fleurs', 1), (88, 'Tarte aux pommes', 1), (88, 'Mousse au chocolat', 1), (88, 'Pot au feu', 2), (89, 'Omelette aux olives', 2), (89, 'Pizza reine', 1), (90, 'Tarte aux prunes', 3), (90, 'Carottes rapées', 2), (90, 'Risotto aux olives', 4), (91, 'Clafoutis aux poires', 2), (92, 'Clafoutis aux pommes', 2), (92, 'Paris Brest', 1), (92, 'Soupe aux légumes', 1), (93, 'Risotto aux olives', 2), (93, 'Tarte aux cerises', 1), (94, 'Soupe aux légumes', 4), (94, 'Carottes rapées', 3), (95, 'Riz cantonnais', 2), (95, 'Aubergines farcies', 2), (96, 'Aligot', 4), (96, 'Soupe aux légumes', 4), (96, 'Pot au feu', 1), (97, 'Clafoutis aux prunes', 4), (97, 'Tarte aux cerises', 2), (97, 'Compote de poires', 3), (98, 'Compote de pommes', 2), (98, 'Crumble aux pommes', 1), (98, 'Nems au poulet', 1), (99, 'Compote de poires', 1), (99, 'Aligot', 4);
