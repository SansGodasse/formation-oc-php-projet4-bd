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
INSERT INTO ef_plate VALUES ('Tartiflette', 'plat', true, 13.63), ('Poëlée montagnarde', 'plat', true, 11.45), ('Burger vosgien', 'plat', true, 11.98), ('Salade vosgienne', 'plat', true, 10.8), ('Aligot', 'plat', true, 8.9), ('Carottes rapées', 'plat', true, 6.97), ('Betteraves rouges', 'plat', false, 7.21), ('Gratin dauphinois', 'plat', true, 10.4), ('Gratin de choux-fleurs', 'plat', true, 9.66), ('Gratin de brocolis', 'plat', true, 7.01), ('Salade niçoise', 'plat', true, 8.63), ('Coquilles saint Jacques', 'plat', false, 11.78), ('Nems au poulet', 'plat', true, 4.74), ('Pizza 4 fromages', 'plat', true, 14.13), ('Riz cantonnais', 'plat', true, 3.15), ('Omelette aux olives', 'plat', true, 6.45), ('Quiche lorraine', 'plat', false, 3.89), ('Pot au feu', 'plat', true, 12.33), ('Pizza reine', 'plat', true, 7.02), ('Risotto aux olives', 'plat', true, 9.65), ('Croques monsieur', 'plat', true, 7.91), ('Soupe aux légumes', 'plat', true, 14.35), ('Tomates farcies', 'plat', true, 2.14), ('Poivrons farcis', 'plat', false, 13.26), ('Aubergines farcies', 'plat', true, 13.26), ('Crumble aux pommes', 'dessert', true, 13.85), ('Clafoutis aux pommes', 'dessert', true, 5.63), ('Tarte aux pommes', 'dessert', true, 13.73), ('Compote de pommes', 'dessert', true, 5.8), ('Crumble aux poires', 'dessert', true, 13.14), ('Clafoutis aux poires', 'dessert', true, 8.8), ('Tarte aux poires', 'dessert', true, 6.4), ('Compote de poires', 'dessert', true, 2.12), ('Crumble aux prunes', 'dessert', true, 9.11), ('Clafoutis aux prunes', 'dessert', true, 8.51), ('Tarte aux prunes', 'dessert', true, 5.44), ('Compote de prunes', 'dessert', true, 6.23), ('Crumble aux cerises', 'dessert', true, 4.82), ('Clafoutis aux cerises', 'dessert', true, 5.62), ('Tarte aux cerises', 'dessert', true, 9.84), ('Compote de cerises', 'dessert', true, 5.55), ('Mousse au chocolat', 'dessert', false, 7.27), ('Brownie au chocolat', 'dessert', false, 13.86), ('Charlotte aux framboises', 'dessert', false, 12.8), ('Paris Brest', 'dessert', true, 8.69);

-- ef_user
INSERT INTO ef_user VALUES ('jean.benbois@gmail.com', '$2y$10$UrKugEMT1kPQOE15.5WTVeBF6Mh8xS2R4X0qxc9nyjRWP6sf7PImO', 'Jean', 'Benbois'), ('laure.ambar@gmail.com', '$2y$10$wtz1UO8MyUCVkeIz7QeCF.gYCM.KBWRJYGZsp4GGhIkOwPPwAUStO', 'Laure', 'Ambar'), ('clément.tyne@gmail.com', '$2y$10$W.q1WzIK.AHh6WgU0ErdO.jFG/Ca71LSWubVBiPt4g4N/MueobAwe', 'Clément', 'Tyne'), ('ivan.odin@live.fr', '$2y$10$JllqtEopzvuL6hHAo7Ywluc8RM7y35um1X9lWMXbdDKewhU82PEIK', 'Ivan', 'Odin'), ('marty.ni@orange.fr', '$2y$10$zu0zfbjC2Bvl9ajx8tiGXus.dKjXP7cEqxK9DkVeFhSINuOBobY/y', 'Marty', 'Ni'), ('adam.desemène@orange.fr', '$2y$10$jlf4aBs2jUHb.oHY.dY3Du1npSdqmhxLB9VJY9MGFJvgAHNPyfOFq', 'Adam', 'Desemène'), ('jean.peuplu@gmail.com', '$2y$10$u3XEQ3hDcbwX3II2qjYWL.DrwL5PWQ4ieScGl/.a0ldJbueWjkWhK', 'Jean', 'Peuplu'), ('abel.védaire@gmail.com', '$2y$10$KE.IQUXpeMDycNnAkiIxH.MIpANAM9ku3atcSXEsjj1spjmretxI.', 'Abel', 'Védaire'), ('luc.harne@orange.fr', '$2y$10$Nuhc.EBaQ8Z1NZpDmxnpJ.oAYWyeVUOsv20cWEVqF0TqrvSxWcPTK', 'Luc', 'Harne'), ('omar.tinais@gmail.com', '$2y$10$iTY.jYZCb3/Hj54gRtDKgeqeoPU4wsmX59GRB78DvYeQNxDxI8pca', 'Omar', 'Tinais'), ('emmy.sphère@orange.fr', '$2y$10$qLNup/Z/7ZIg1lArEhL3Z.B2ypUCDNKo3/vkPQorBCJRN1jt5OGbm', 'Emmy', 'Sphère'), ('hector.ticolis@live.fr', '$2y$10$2bK2dwvZxKTu1Z8lhjkX2uLDdRIgsQQk39aUJ3S.bD1ZdXAaFQy8y', 'Hector', 'Ticolis'), ('ève.aporation@orange.fr', '$2y$10$1UX1tQ8aRvXqCndLMVXHGOk88Qc10NBeW4I5rCRPm/tw1c9rR6dma', 'Ève', 'Aporation'), ('adam.main@live.fr', '$2y$10$8iGNoTnFBsMMaHSJIAVp2uTCL8Uz1X3jspIPuJKF4plyIyOVZ8Pom', 'Adam', 'Main'), ('omar.ionlait@live.fr', '$2y$10$bCrcxMTml.YPAkAmMov8OOrPHaPNSvvnmfOCXeLdutrHrNug7bOLm', 'Omar', 'Ionlait'), ('louis.fine@live.fr', '$2y$10$CekktjHkhVZc./L8SO1lvu8YsNuxsm1LEgMoPh7QMQPbYYFs5oWne', 'Louis', 'Fine'), ('edmond.prochain@live.fr', '$2y$10$a8P4bsv0AZ08UDSjAm4oE.j1TnhQxn5gdMFPARhAFsgcUkwP0.P46', 'Edmond', 'Prochain'), ('al.batrosse@gmail.com', '$2y$10$pgRcy92aOBqB8jrFuGo5YufPtbYDsvKy2PYui2JxH4aPkWyeRXJEq', 'Al', 'Batrosse'), ('aude.vessel@orange.fr', '$2y$10$q4ozlo1wh73zgFh//ILAueN24V1Vbs/bT2FR3EwGEjkeRZdQn.xY6', 'Aude', 'Vessel'), ('bernard.guilé@live.fr', '$2y$10$e7KZ9kqOZ3yY/e5q1U/WwutNzsvYhxDwwywaY.uvLskyLWSPi1RcS', 'Bernard', 'Guilé'), ('yann.odin@orange.fr', '$2y$10$IDyZwfpLeXr9NdLLWFcabuPak95C/RdX1uKOjlkeV7FWQ81WofEoq', 'Yann', 'Odin'), ('maude.vessel@gmail.com', '$2y$10$/qa/I4gjVXETdvNiGfjKYuYkPBkqY2dU22F74AmAx2oXR2Rf9TbW.', 'Maude', 'Vessel'), ('jimmy.lesbieraufrai@gmail.com', '$2y$10$LS1VEpGqwwUgtkwZoHssLOuoQbtALVB7uCvVUdrkTUAcR8..kZ0EC', 'jimmy', 'Lesbieraufrai'), ('terry.dicule@orange.fr', '$2y$10$m5d7h8gpOEzdWEs8KI7cjeHvAD4vOG.VOIIvjwkLismqJyH5QuRGy', 'Terry', 'Dicule'), ('dick.sionnaire@gmail.com', '$2y$10$VqCbYtepiKOIfwkA2NsKYOJXW.trbC0wlY5muJd1FTT/paUitVmA.', 'Dick', 'Sionnaire'), ('tarik.ané@live.fr', '$2y$10$vVieB5gjThBH1HgLM/nnJeXKPjIVzVQIVslMBrwgJ/czKF2u/Q8YC', 'Tarik', 'Ané'), ('lami.depain@gmail.com', '$2y$10$YvkQLb0fx5j0qPv5yeVll.Evxhqq7tTBCOmSq3rcB2/262AnNq5u2', 'Lami', 'Depain'), ('roger.trobu@live.fr', '$2y$10$WTPE2CRIHn22ahGHZeceIui6xsdV45J4961wlOdr7nvpFst0aavA6', 'Roger', 'Trobu'), ('kelly.bellule@orange.fr', '$2y$10$9PwELCjf.N0rehWVz92JEebd41qcRTvFKdlyTWOZCLuu6FI0vKDQO', 'Kelly', 'Bellule'), ('yves.egée@orange.fr', '$2y$10$n5VA1CWUy0ouGbXpkHTn6eacrGVr4Ctol8aFD3XWQx6dGXtZrfSYy', 'Yves', 'Egée'), ('laure.angoutan@live.fr', '$2y$10$oohmRmxMaNcSdFXAyhsfqueozyI.smdYYDnDivLxLWGTxIilwqbau', 'Laure', 'Angoutan'), ('mandy.capé@live.fr', '$2y$10$nBge1QPJRORLxfXKSAVcOej9xue4uYbSL7uEeXyATMaf/8rDGmgxy', 'Mandy', 'Capé'), ('homer.dalors@orange.fr', '$2y$10$CTaiD3pEujZc5aKjOKowMeUoy/odXClxv/Of3UqjGexr8c6Dw/A.u', 'Homer', 'Dalors'), ('mehdi.zan@orange.fr', '$2y$10$I2UqSbsB3hnz3CLm/k9m4.vzIn7EwuZAgb.vLOxN/uIanvi7f5n5G', 'Mehdi', 'Zan'), ('sam.irouate@live.fr', '$2y$10$bDG/PaqDTJxqNytujEXDluFJ6kV8mif8rs33/jRt0pf9.1qETXU/y', 'Sam', 'Irouate'), ('judas.sperge@orange.fr', '$2y$10$b8l/wxqcWMw5mV0yzMGcA.T3i8m0Fvn9k6rkQOvn8S6EUPrDyWXsO', 'Judas', 'Sperge'), ('lami.molette@orange.fr', '$2y$10$kdOhDioTIcCM8gaxESDaJ.g3h8PhM6i5xG3yOEzTnCktYb2D8Vcrm', 'Lami', 'Molette'), ('aubin.gladesh@orange.fr', '$2y$10$N.t6uoXTjabs5wQYH13V3uqzmiB10gU0YGlF8dR/A/M4IkOYf9yMC', 'Aubin', 'Gladesh'), ('jerry.kahn@gmail.com', '$2y$10$eJ.nz284CjKwLMsvPdy.Ae6a1jL8MVt1k.RIddf1ONEKdiDGuzT1S', 'Jerry', 'Kahn'), ('edgard.ogorille@gmail.com', '$2y$10$eqO/QxXHlOMjOXQodaJbEeFgDsp1dlp8zi/ZMZIpIuLQO24yLnzgS', 'Edgard', 'Ogorille'), ('moussah.razeh@gmail.com', '$2y$10$Hd0zAnQXHY9lh/J7Zzs5/u3NzSEN1Ivbc.dIRMzzevx91FO2Qc01.', 'Moussah', 'Razeh'), ('gilbert.muda@gmail.com', '$2y$10$Kz4ou1bzM5CW5WxUUN2ZteXxpq084wcoV0prc8QJtOCRkRc8Q4PCW', 'Gilbert', 'Muda'), ('paul.ochon@live.fr', '$2y$10$.ScB6iPZSWMg65TqvkD.XesTvyM5Jj9unxwA.oIxxJw6yTM7XkBnS', 'Paul', 'Ochon'), ('jean.ticipe@gmail.com', '$2y$10$gdjT.9Iu6qowkCeQLVPSXeRI1w4sSwHbkqJWRO2v3mVQ.AReqaomK', 'Jean', 'Ticipe'), ('céline.évitable@live.fr', '$2y$10$/trkqpaLDQzO.EswF60Z9.3mToOAFYANHPRKayEc0wzbOhtoVVbci', 'Céline', 'Évitable'), ('abel.igérant@orange.fr', '$2y$10$0OX//dRfg3NnJ9Tv.wg4PuaMZ6eEfT4ETtWEiZp.IP3FR8q16xFvC', 'Abel', 'Igérant'), ('tess.tostérone@gmail.com', '$2y$10$9UtWy1j0AP3yWXvY1SJsguUTupvD4pquo5YaQMpxQBaQTxPpNmMAa', 'Tess', 'Tostérone'), ('alain.connu@live.fr', '$2y$10$MGHCaPkHJfHluVe9Xfhw1eWf/DoUD4BwBApTjZHGl9dsnsDHr.rwy', 'Alain', 'Connu'), ('pennie.ciline@gmail.com', '$2y$10$NxXDWDJK8LyDcEnBxPFJVuA6FUlSCxpMSG5q1NQnq8cARyAqiPvc2', 'Pennie', 'Ciline'), ('lara.pafromage@gmail.com', '$2y$10$23pXPTxYYV/AgfjaCqHgeuixg0lDYnlKSTIOMLviHgw6OEiCJF8RO', 'Lara', 'Pafromage');

-- ef_telephone
INSERT INTO ef_telephone VALUES (0, 'jean.benbois@gmail.com', '0690163895'), (1, 'laure.ambar@gmail.com', '0695621030'), (2, 'clément.tyne@gmail.com', '0679652589'), (3, 'ivan.odin@live.fr', '0616533283'), (4, 'marty.ni@orange.fr', '0651269831'), (5, 'adam.desemène@orange.fr', '0649073672'), (6, 'jean.peuplu@gmail.com', '0653337775'), (7, 'abel.védaire@gmail.com', '0677545107'), (8, 'luc.harne@orange.fr', '0656122978'), (9, 'omar.tinais@gmail.com', '0647804692'), (10, 'emmy.sphère@orange.fr', '0676362037'), (11, 'hector.ticolis@live.fr', '0672029659'), (12, 'ève.aporation@orange.fr', '0671223212'), (13, 'adam.main@live.fr', '0629349174'), (14, 'omar.ionlait@live.fr', '0649028139'), (15, 'louis.fine@live.fr', '0615695352'), (16, 'edmond.prochain@live.fr', '0632206644'), (17, 'al.batrosse@gmail.com', '0658925948'), (18, 'aude.vessel@orange.fr', '0666454757'), (19, 'bernard.guilé@live.fr', '0646036779'), (20, 'yann.odin@orange.fr', '0699046021'), (21, 'maude.vessel@gmail.com', '0632475280'), (22, 'jimmy.lesbieraufrai@gmail.com', '0631519363'), (23, 'terry.dicule@orange.fr', '0647405672'), (24, 'dick.sionnaire@gmail.com', '0645826030'), (25, 'tarik.ané@live.fr', '0651554769'), (26, 'lami.depain@gmail.com', '0649870028'), (27, 'roger.trobu@live.fr', '0625659708'), (28, 'kelly.bellule@orange.fr', '0621325669'), (29, 'yves.egée@orange.fr', '0632479328'), (30, 'laure.angoutan@live.fr', '0693304087'), (31, 'mandy.capé@live.fr', '0660802967'), (32, 'homer.dalors@orange.fr', '0618745411'), (33, 'mehdi.zan@orange.fr', '0648419322'), (34, 'sam.irouate@live.fr', '0696118387'), (35, 'judas.sperge@orange.fr', '0610749429'), (36, 'lami.molette@orange.fr', '0623177195'), (37, 'aubin.gladesh@orange.fr', '0675891330'), (38, 'jerry.kahn@gmail.com', '0633463830'), (39, 'edgard.ogorille@gmail.com', '0649653628'), (40, 'moussah.razeh@gmail.com', '0659998174'), (41, 'gilbert.muda@gmail.com', '0684445930'), (42, 'paul.ochon@live.fr', '0693891362'), (43, 'jean.ticipe@gmail.com', '0611213059'), (44, 'céline.évitable@live.fr', '0656290531'), (45, 'abel.igérant@orange.fr', '0658319108'), (46, 'tess.tostérone@gmail.com', '0628261025'), (47, 'alain.connu@live.fr', '064968727'), (48, 'pennie.ciline@gmail.com', '0631734033'), (49, 'lara.pafromage@gmail.com', '0666354038');

-- ef_address
INSERT INTO ef_address VALUES (0, 'jean.benbois@gmail.com', '10 Rue d\'Algérie', '69001', 'Lyon', NULL), (1, 'laure.ambar@gmail.com', '15 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (2, 'clément.tyne@gmail.com', '11 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (3, 'ivan.odin@live.fr', '17 Rue Alsace Lorraine', '69001', 'Lyon', NULL), (4, 'marty.ni@orange.fr', '8 Rue de l\'Alma', '69001', 'Lyon', NULL), (5, 'adam.desemène@orange.fr', '10 Quai André Lassagne', '69001', 'Lyon', NULL), (6, 'jean.peuplu@gmail.com', '17 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (7, 'abel.védaire@gmail.com', '12 Rue de l\'Arbre Sec', '69001', 'Lyon', NULL), (8, 'luc.harne@orange.fr', '20 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (9, 'omar.tinais@gmail.com', '9 Rue de l\'Alma', '69001', 'Lyon', NULL), (10, 'emmy.sphère@orange.fr', '5 Rue de l\'Alma', '69001', 'Lyon', NULL), (11, 'hector.ticolis@live.fr', '6 Quai André Lassagne', '69001', 'Lyon', NULL), (12, 'ève.aporation@orange.fr', '3 Rue d\'Algérie', '69001', 'Lyon', NULL), (13, 'adam.main@live.fr', '13 Rue de l\'Arbre Sec', '69001', 'Lyon', NULL), (14, 'omar.ionlait@live.fr', '19 Rue d\'Algérie', '69001', 'Lyon', NULL), (15, 'louis.fine@live.fr', '2 Rue de l\'Alma', '69001', 'Lyon', NULL), (16, 'edmond.prochain@live.fr', '18 Rue d\'Algérie', '69001', 'Lyon', NULL), (17, 'al.batrosse@gmail.com', '17 Quai André Lassagne', '69001', 'Lyon', NULL), (18, 'aude.vessel@orange.fr', '7 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (19, 'bernard.guilé@live.fr', '11 Rue d\'Algérie', '69001', 'Lyon', NULL), (20, 'yann.odin@orange.fr', '14 Rue d\'Algérie', '69001', 'Lyon', NULL), (21, 'maude.vessel@gmail.com', '2 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (22, 'jimmy.lesbieraufrai@gmail.com', '9 Rue Alsace Lorraine', '69001', 'Lyon', NULL), (23, 'terry.dicule@orange.fr', '15 Quai André Lassagne', '69001', 'Lyon', NULL), (24, 'dick.sionnaire@gmail.com', '23 Rue d\'Algérie', '69001', 'Lyon', NULL), (25, 'tarik.ané@live.fr', '6 Rue Alsace Lorraine', '69001', 'Lyon', NULL), (26, 'lami.depain@gmail.com', '4 Rue de l\'Alma', '69001', 'Lyon', NULL), (27, 'roger.trobu@live.fr', '20 Rue de l\'Arbre Sec', '69001', 'Lyon', NULL), (28, 'kelly.bellule@orange.fr', '22 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (29, 'yves.egée@orange.fr', '7 Quai André Lassagne', '69001', 'Lyon', NULL), (30, 'laure.angoutan@live.fr', '11 Rue de l\'Alma', '69001', 'Lyon', NULL), (31, 'mandy.capé@live.fr', '16 Rue de l\'Arbre Sec', '69001', 'Lyon', NULL), (32, 'homer.dalors@orange.fr', '2 Place d\'Albon', '69001', 'Lyon', NULL), (33, 'mehdi.zan@orange.fr', '18 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (34, 'sam.irouate@live.fr', '13 Rue de l\'Alma', '69001', 'Lyon', NULL), (35, 'judas.sperge@orange.fr', '9 Quai André Lassagne', '69001', 'Lyon', NULL), (36, 'lami.molette@orange.fr', '3 Rue Adamoli', '69001', 'Lyon', NULL), (37, 'aubin.gladesh@orange.fr', '6 Rue de l\'Alma', '69001', 'Lyon', NULL), (38, 'jerry.kahn@gmail.com', '1 Rue Alexandre Luigini', '69001', 'Lyon', NULL), (39, 'edgard.ogorille@gmail.com', '16 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (40, 'moussah.razeh@gmail.com', '6 Rue d\'Algérie', '69001', 'Lyon', NULL), (41, 'gilbert.muda@gmail.com', '20 Rue d\'Algérie', '69001', 'Lyon', NULL), (42, 'paul.ochon@live.fr', '6 Rue de l\'Annonciade', '69001', 'Lyon', NULL), (43, 'jean.ticipe@gmail.com', '11 Rue Alsace Lorraine', '69001', 'Lyon', NULL), (44, 'céline.évitable@live.fr', '7 Rue de l\'Alma', '69001', 'Lyon', NULL), (45, 'abel.igérant@orange.fr', '13 Rue d\'Algérie', '69001', 'Lyon', NULL), (46, 'tess.tostérone@gmail.com', '1 Place d\'Albon', '69001', 'Lyon', NULL), (47, 'alain.connu@live.fr', '19 Rue de l\'Arbre Sec', '69001', 'Lyon', NULL), (48, 'pennie.ciline@gmail.com', '15 Rue de l\'Arbre Sec', '69001', 'Lyon', NULL), (49, 'lara.pafromage@gmail.com', '10 Rue de l\'Arbre Sec', '69001', 'Lyon', NULL);

-- ef_employee
INSERT INTO ef_employee VALUES (0, 'jean.benbois@gmail.com'), (1, 'laure.ambar@gmail.com'), (2, 'clément.tyne@gmail.com'), (3, 'ivan.odin@live.fr'), (4, 'marty.ni@orange.fr'), (5, 'adam.desemène@orange.fr'), (6, 'jean.peuplu@gmail.com'), (7, 'abel.védaire@gmail.com'), (8, 'luc.harne@orange.fr'), (9, 'omar.tinais@gmail.com'), (10, 'emmy.sphère@orange.fr'), (11, 'hector.ticolis@live.fr'), (12, 'ève.aporation@orange.fr'), (13, 'adam.main@live.fr'), (14, 'omar.ionlait@live.fr'), (15, 'louis.fine@live.fr'), (16, 'edmond.prochain@live.fr'), (17, 'al.batrosse@gmail.com'), (18, 'aude.vessel@orange.fr'), (19, 'bernard.guilé@live.fr');

-- ef_client
INSERT INTO ef_client VALUES (0, 'yann.odin@orange.fr'), (1, 'maude.vessel@gmail.com'), (2, 'jimmy.lesbieraufrai@gmail.com'), (3, 'terry.dicule@orange.fr'), (4, 'dick.sionnaire@gmail.com'), (5, 'tarik.ané@live.fr'), (6, 'lami.depain@gmail.com'), (7, 'roger.trobu@live.fr'), (8, 'kelly.bellule@orange.fr'), (9, 'yves.egée@orange.fr'), (10, 'laure.angoutan@live.fr'), (11, 'mandy.capé@live.fr'), (12, 'homer.dalors@orange.fr'), (13, 'mehdi.zan@orange.fr'), (14, 'sam.irouate@live.fr'), (15, 'judas.sperge@orange.fr'), (16, 'lami.molette@orange.fr'), (17, 'aubin.gladesh@orange.fr'), (18, 'jerry.kahn@gmail.com'), (19, 'edgard.ogorille@gmail.com'), (20, 'moussah.razeh@gmail.com'), (21, 'gilbert.muda@gmail.com'), (22, 'paul.ochon@live.fr'), (23, 'jean.ticipe@gmail.com'), (24, 'céline.évitable@live.fr'), (25, 'abel.igérant@orange.fr'), (26, 'tess.tostérone@gmail.com'), (27, 'alain.connu@live.fr'), (28, 'pennie.ciline@gmail.com'), (29, 'lara.pafromage@gmail.com');

-- ef_delivery_guy
INSERT INTO ef_delivery_guy VALUES (0, 'Hors connexion', '45.7637', '4.7672'), (1, 'Disponible', '45.7708', '4.7740'), (2, 'Disponible', '45.7800', '4.7651'), (3, 'Hors connexion', '45.7643', '4.7766'), (4, 'En livraison', '45.7736', '4.7624'), (5, 'En livraison', '45.7735', '4.7626'), (6, 'Hors connexion', '45.7644', '4.7702'), (7, 'En livraison', '45.7685', '4.7641'), (8, 'Disponible', '45.7714', '4.7695'), (9, 'En livraison', '45.7773', '4.7675');

-- ef_cook
INSERT INTO ef_cook VALUES (10), (11), (12), (13), (14), (15), (16), (17), (18), (19);

-- ef_order
INSERT INTO ef_order VALUES (0, 21, 6, '2018-05-07 13:11:30', 'Payée', 11.67), (1, 3, 7, '2018-05-17 16:09:42', 'En attente', 7), (2, 1, 4, '2018-05-03 11:15:15', 'En attente', 79.28), (3, 29, 7, '2018-05-22 12:15:30', 'Livrée', 6.91), (4, 13, 4, '2018-05-07 16:02:02', 'Annulée', 13.45), (5, 28, 9, '2018-05-24 12:46:35', 'Payée', 68.32), (6, 11, 4, '2018-05-07 12:19:51', 'En attente', 78.15), (7, 6, 0, '2018-05-22 15:26:46', 'En attente', 43.22), (8, 22, 0, '2018-05-18 20:45:51', 'En attente', 39.26), (9, 20, 9, '2018-05-08 17:54:48', 'En attente', 41.23), (10, 20, 1, '2018-05-21 12:32:23', 'Annulée', 10.41), (11, 14, 1, '2018-05-09 14:56:40', 'Annulée', 63.94), (12, 4, 1, '2018-05-22 20:49:46', 'Livrée', 72.34), (13, 10, 7, '2018-05-22 17:44:52', 'Annulée', 61.83), (14, 4, 2, '2018-05-18 19:16:39', 'Payée', 38.27), (15, 2, 1, '2018-05-22 15:31:04', 'Payée', 77.19), (16, 16, 4, '2018-05-07 11:14:50', 'Annulée', 77.41), (17, 12, 2, '2018-05-01 14:51:38', 'En attente', 60.88), (18, 10, 2, '2018-05-23 12:24:09', 'Livrée', 17.09), (19, 9, 7, '2018-05-20 19:13:47', 'Livrée', 73.26), (20, 14, 8, '2018-05-20 17:33:39', 'En attente', 47.23), (21, 5, 3, '2018-05-01 13:01:21', 'Annulée', 33.75), (22, 28, 7, '2018-05-13 15:11:44', 'Annulée', 57.76), (23, 24, 9, '2018-05-21 18:25:32', 'Payée', 35.38), (24, 16, 5, '2018-05-02 11:07:42', 'Livrée', 8.29), (25, 25, 6, '2018-05-12 20:11:14', 'Annulée', 33.9), (26, 9, 0, '2018-05-28 14:17:52', 'Livrée', 12.75), (27, 22, 5, '2018-05-11 17:22:52', 'Annulée', 64.46), (28, 4, 8, '2018-05-03 13:40:11', 'En attente', 37.51), (29, 24, 8, '2018-05-09 12:17:05', 'Livrée', 12.65), (30, 22, 0, '2018-05-14 15:39:18', 'En attente', 27.99), (31, 7, 1, '2018-05-17 12:55:01', 'Payée', 26.01), (32, 7, 1, '2018-05-17 20:33:51', 'Payée', 91.13), (33, 10, 7, '2018-05-26 14:26:29', 'Payée', 71.24), (34, 21, 2, '2018-05-23 18:34:07', 'Payée', 50.58), (35, 3, 3, '2018-05-24 20:57:52', 'Payée', 37.77), (36, 13, 3, '2018-05-08 19:11:59', 'Annulée', 15), (37, 6, 2, '2018-05-28 14:08:55', 'Annulée', 83.97), (38, 18, 5, '2018-05-12 16:52:48', 'En attente', 39.94), (39, 10, 1, '2018-05-08 19:36:36', 'Livrée', 47.5), (40, 21, 4, '2018-05-16 19:45:32', 'En attente', 53.97), (41, 18, 5, '2018-05-07 13:46:27', 'Annulée', 31.19), (42, 3, 6, '2018-05-01 13:03:56', 'Livrée', 79.51), (43, 13, 5, '2018-05-13 13:03:49', 'Payée', 20.11), (44, 21, 7, '2018-05-22 11:58:17', 'Payée', 74.56), (45, 11, 6, '2018-05-13 19:05:46', 'Annulée', 13.47), (46, 2, 3, '2018-05-28 14:20:29', 'En attente', 91.81), (47, 23, 5, '2018-05-10 18:56:53', 'Livrée', 47.05), (48, 18, 4, '2018-05-14 18:47:24', 'Livrée', 13.79), (49, 7, 3, '2018-05-18 19:09:03', 'En attente', 98.13), (50, 26, 4, '2018-05-28 13:39:57', 'Livrée', 17.58), (51, 14, 7, '2018-05-06 19:18:24', 'Payée', 95.56), (52, 24, 0, '2018-05-18 18:18:20', 'Payée', 32.07), (53, 11, 0, '2018-05-22 14:37:12', 'Payée', 16.56), (54, 13, 2, '2018-05-15 17:12:52', 'En attente', 75.73), (55, 14, 8, '2018-05-04 14:57:34', 'Livrée', 86.38), (56, 12, 0, '2018-05-05 16:11:19', 'Livrée', 83.34), (57, 18, 7, '2018-05-09 14:15:48', 'En attente', 36.15), (58, 4, 8, '2018-05-09 15:42:11', 'Livrée', 21.38), (59, 8, 9, '2018-05-10 13:51:06', 'Payée', 42.92), (60, 22, 8, '2018-05-04 18:43:24', 'Annulée', 38.94), (61, 18, 7, '2018-05-14 18:55:10', 'Payée', 15.15), (62, 20, 5, '2018-05-25 17:52:41', 'Livrée', 98.83), (63, 9, 0, '2018-05-15 15:40:57', 'Payée', 95.51), (64, 27, 1, '2018-05-12 14:28:02', 'Payée', 7.17), (65, 18, 5, '2018-05-05 12:11:23', 'En attente', 95.46), (66, 16, 9, '2018-05-19 11:57:55', 'Payée', 70.28), (67, 1, 1, '2018-05-02 17:52:02', 'En attente', 36.38), (68, 5, 6, '2018-05-23 18:40:13', 'Livrée', 45.93), (69, 7, 2, '2018-05-01 13:54:54', 'En attente', 60.39), (70, 22, 5, '2018-05-19 18:13:44', 'En attente', 22.31), (71, 7, 7, '2018-05-19 12:39:46', 'Annulée', 30.71), (72, 29, 6, '2018-05-10 18:30:34', 'Livrée', 48.32), (73, 22, 8, '2018-05-24 15:54:46', 'Annulée', 17.33), (74, 0, 3, '2018-05-18 19:50:34', 'Annulée', 30.26), (75, 10, 7, '2018-05-06 13:48:47', 'Annulée', 94.16), (76, 20, 9, '2018-05-09 11:31:59', 'Payée', 87.91), (77, 14, 8, '2018-05-13 13:54:14', 'En attente', 47.95), (78, 24, 6, '2018-05-12 14:58:29', 'En attente', 53.27), (79, 16, 1, '2018-05-19 13:52:23', 'En attente', 93.63), (80, 24, 0, '2018-05-27 18:45:24', 'Annulée', 82.73), (81, 1, 2, '2018-05-10 14:59:55', 'Annulée', 42), (82, 7, 3, '2018-05-28 17:30:33', 'Annulée', 19.03), (83, 25, 6, '2018-05-17 14:45:05', 'Payée', 51.59), (84, 28, 4, '2018-05-21 14:38:08', 'En attente', 45.51), (85, 4, 4, '2018-05-06 12:45:34', 'Livrée', 65.6), (86, 1, 8, '2018-05-23 19:22:38', 'En attente', 52.37), (87, 2, 5, '2018-05-11 17:03:50', 'Payée', 40.51), (88, 9, 5, '2018-05-20 18:49:23', 'Payée', 93.29), (89, 11, 4, '2018-05-01 17:48:43', 'Payée', 53.61), (90, 25, 1, '2018-05-14 13:04:40', 'Payée', 21.1), (91, 1, 9, '2018-05-09 13:53:36', 'Payée', 65.34), (92, 12, 8, '2018-05-21 15:58:58', 'Livrée', 79.76), (93, 16, 3, '2018-05-03 12:10:48', 'Annulée', 50.54), (94, 8, 7, '2018-05-07 12:30:40', 'Annulée', 53.64), (95, 4, 2, '2018-05-28 15:09:20', 'Livrée', 43.33), (96, 29, 6, '2018-05-02 20:59:01', 'Payée', 36.81), (97, 0, 6, '2018-05-12 11:26:41', 'En attente', 14.61), (98, 8, 8, '2018-05-20 13:43:21', 'Annulée', 94.35), (99, 25, 1, '2018-05-05 18:34:58', 'En attente', 45.38);

-- ef_daily_list
INSERT INTO ef_daily_list VALUES ('2018-05-1', 19), ('2018-05-2', 17), ('2018-05-3', 14), ('2018-05-4', 10), ('2018-05-5', 10), ('2018-05-6', 12), ('2018-05-7', 17), ('2018-05-8', 12), ('2018-05-9', 14), ('2018-05-10', 10);

-- ef_daily_list_content
INSERT INTO ef_daily_list_content VALUES ('2018-05-1', 'Tartiflette'), ('2018-05-1', 'Crumble aux pommes'), ('2018-05-1', 'Poëlée montagnarde'), ('2018-05-1', 'Clafoutis aux pommes'), ('2018-05-2', 'Burger vosgien'), ('2018-05-2', 'Tarte aux pommes'), ('2018-05-2', 'Salade vosgienne'), ('2018-05-2', 'Compote de pommes'), ('2018-05-3', 'Aligot'), ('2018-05-3', 'Crumble aux poires'), ('2018-05-3', 'Carottes rapées'), ('2018-05-3', 'Clafoutis aux poires'), ('2018-05-4', 'Betteraves rouges'), ('2018-05-4', 'Tarte aux poires'), ('2018-05-4', 'Gratin dauphinois'), ('2018-05-4', 'Compote de poires'), ('2018-05-5', 'Gratin de choux-fleurs'), ('2018-05-5', 'Crumble aux prunes'), ('2018-05-5', 'Gratin de brocolis'), ('2018-05-5', 'Clafoutis aux prunes'), ('2018-05-6', 'Salade niçoise'), ('2018-05-6', 'Tarte aux prunes'), ('2018-05-6', 'Coquilles saint Jacques'), ('2018-05-6', 'Compote de prunes'), ('2018-05-7', 'Nems au poulet'), ('2018-05-7', 'Crumble aux cerises'), ('2018-05-7', 'Pizza 4 fromages'), ('2018-05-7', 'Clafoutis aux cerises'), ('2018-05-8', 'Riz cantonnais'), ('2018-05-8', 'Tarte aux cerises'), ('2018-05-8', 'Omelette aux olives'), ('2018-05-8', 'Compote de cerises'), ('2018-05-9', 'Quiche lorraine'), ('2018-05-9', 'Mousse au chocolat'), ('2018-05-9', 'Pot au feu'), ('2018-05-9', 'Brownie au chocolat'), ('2018-05-10', 'Pizza reine'), ('2018-05-10', 'Charlotte aux framboises'), ('2018-05-10', 'Risotto aux olives'), ('2018-05-10', 'Paris Brest');

-- ef_order_content
INSERT INTO ef_order_content VALUES (0, 'Risotto aux olives', 3), (1, 'Pot au feu', 3), (2, 'Tarte aux pommes', 1), (2, 'Crumble aux poires', 1), (3, 'Gratin dauphinois', 2), (4, 'Charlotte aux framboises', 2), (4, 'Tarte aux pommes', 4), (5, 'Croques monsieur', 2), (5, 'Poëlée montagnarde', 1), (5, 'Risotto aux olives', 1), (6, 'Compote de cerises', 3), (6, 'Gratin de brocolis', 2), (6, 'Carottes rapées', 2), (7, 'Clafoutis aux prunes', 2), (7, 'Compote de cerises', 2), (7, 'Salade niçoise', 3), (8, 'Tarte aux poires', 4), (9, 'Tartiflette', 1), (9, 'Tarte aux pommes', 2), (10, 'Crumble aux pommes', 3), (10, 'Compote de prunes', 4), (10, 'Risotto aux olives', 3), (10, 'Poëlée montagnarde', 1), (11, 'Tarte aux prunes', 1), (11, 'Gratin de choux-fleurs', 2), (11, 'Risotto aux olives', 1), (12, 'Croques monsieur', 4), (12, 'Clafoutis aux poires', 2), (13, 'Clafoutis aux poires', 3), (13, 'Omelette aux olives', 3), (13, 'Paris Brest', 2), (14, 'Nems au poulet', 3), (15, 'Pot au feu', 3), (16, 'Compote de cerises', 1), (16, 'Riz cantonnais', 3), (17, 'Tomates farcies', 2), (17, 'Coquilles saint Jacques', 4), (18, 'Gratin dauphinois', 4), (18, 'Poivrons farcis', 1), (19, 'Risotto aux olives', 4), (20, 'Brownie au chocolat', 3), (20, 'Croques monsieur', 1), (21, 'Betteraves rouges', 3), (21, 'Brownie au chocolat', 1), (21, 'Soupe aux légumes', 4), (21, 'Clafoutis aux cerises', 4), (22, 'Tomates farcies', 2), (22, 'Poivrons farcis', 1), (22, 'Quiche lorraine', 1), (23, 'Mousse au chocolat', 2), (23, 'Crumble aux poires', 1), (23, 'Croques monsieur', 1), (24, 'Salade niçoise', 4), (24, 'Clafoutis aux pommes', 2), (24, 'Brownie au chocolat', 1), (25, 'Paris Brest', 1), (25, 'Betteraves rouges', 1), (25, 'Croques monsieur', 1), (25, 'Tarte aux pommes', 2), (26, 'Aligot', 2), (27, 'Poivrons farcis', 4), (28, 'Crumble aux cerises', 2), (28, 'Croques monsieur', 2), (29, 'Compote de poires', 2), (29, 'Tarte aux cerises', 3), (29, 'Quiche lorraine', 4), (30, 'Aligot', 4), (30, 'Omelette aux olives', 1), (31, 'Gratin dauphinois', 4), (31, 'Croques monsieur', 4), (32, 'Clafoutis aux prunes', 1), (33, 'Paris Brest', 2), (33, 'Crumble aux pommes', 4), (33, 'Pizza reine', 3), (34, 'Aligot', 2), (35, 'Mousse au chocolat', 3), (36, 'Omelette aux olives', 3), (37, 'Omelette aux olives', 3), (37, 'Tartiflette', 2), (38, 'Omelette aux olives', 2), (39, 'Clafoutis aux poires', 4), (40, 'Coquilles saint Jacques', 2), (40, 'Gratin de brocolis', 2), (41, 'Charlotte aux framboises', 1), (41, 'Gratin dauphinois', 3), (41, 'Poëlée montagnarde', 1), (41, 'Compote de pommes', 1), (42, 'Compote de prunes', 4), (42, 'Gratin dauphinois', 3), (43, 'Compote de pommes', 2), (43, 'Risotto aux olives', 4), (44, 'Clafoutis aux cerises', 2), (45, 'Tarte aux cerises', 1), (45, 'Tarte aux prunes', 2), (46, 'Croques monsieur', 4), (46, 'Tartiflette', 4), (47, 'Poëlée montagnarde', 2), (47, 'Coquilles saint Jacques', 4), (47, 'Pizza 4 fromages', 3), (48, 'Salade niçoise', 3), (49, 'Clafoutis aux cerises', 3), (49, 'Poëlée montagnarde', 2), (49, 'Gratin de brocolis', 4), (50, 'Pizza 4 fromages', 2), (51, 'Betteraves rouges', 4), (51, 'Pot au feu', 4), (51, 'Tarte aux poires', 3), (52, 'Tarte aux poires', 4), (52, 'Gratin de choux-fleurs', 3), (52, 'Compote de poires', 2), (53, 'Gratin dauphinois', 4), (53, 'Clafoutis aux cerises', 4), (53, 'Crumble aux pommes', 2), (54, 'Tarte aux poires', 2), (54, 'Mousse au chocolat', 3), (55, 'Betteraves rouges', 4), (55, 'Compote de poires', 3), (56, 'Tarte aux cerises', 2), (57, 'Compote de prunes', 3), (57, 'Burger vosgien', 4), (57, 'Gratin de brocolis', 3), (58, 'Tarte aux pommes', 1), (59, 'Salade vosgienne', 1), (59, 'Clafoutis aux pommes', 3), (60, 'Pizza 4 fromages', 3), (60, 'Carottes rapées', 4), (60, 'Clafoutis aux cerises', 1), (61, 'Clafoutis aux pommes', 1), (62, 'Crumble aux poires', 2), (62, 'Clafoutis aux pommes', 1), (63, 'Compote de prunes', 3), (63, 'Gratin de brocolis', 3), (63, 'Tarte aux poires', 1), (64, 'Betteraves rouges', 3), (64, 'Crumble aux pommes', 3), (64, 'Gratin de brocolis', 4), (64, 'Pizza reine', 1), (65, 'Pizza reine', 4), (65, 'Aubergines farcies', 2), (66, 'Compote de pommes', 1), (66, 'Crumble aux poires', 2), (67, 'Clafoutis aux poires', 1), (67, 'Aligot', 4), (67, 'Riz cantonnais', 1), (68, 'Nems au poulet', 3), (68, 'Gratin de choux-fleurs', 4), (68, 'Riz cantonnais', 4), (69, 'Clafoutis aux prunes', 4), (69, 'Carottes rapées', 2), (70, 'Tartiflette', 2), (70, 'Quiche lorraine', 3), (70, 'Gratin de choux-fleurs', 2), (71, 'Coquilles saint Jacques', 3), (71, 'Tarte aux prunes', 4), (72, 'Gratin de choux-fleurs', 3), (72, 'Betteraves rouges', 1), (72, 'Tartiflette', 1), (73, 'Clafoutis aux prunes', 3), (74, 'Tarte aux cerises', 1), (74, 'Clafoutis aux poires', 2), (74, 'Tomates farcies', 3), (75, 'Gratin dauphinois', 3), (76, 'Paris Brest', 2), (76, 'Gratin de brocolis', 4), (76, 'Pot au feu', 3), (77, 'Carottes rapées', 3), (78, 'Tomates farcies', 3), (78, 'Pot au feu', 4), (78, 'Clafoutis aux cerises', 3), (79, 'Riz cantonnais', 4), (79, 'Tartiflette', 1), (80, 'Nems au poulet', 4), (81, 'Crumble aux pommes', 2), (81, 'Burger vosgien', 3), (82, 'Compote de prunes', 4), (82, 'Charlotte aux framboises', 4), (82, 'Betteraves rouges', 4), (83, 'Poivrons farcis', 3), (84, 'Gratin de brocolis', 1), (84, 'Gratin dauphinois', 2), (84, 'Pizza 4 fromages', 3), (84, 'Crumble aux prunes', 3), (85, 'Salade vosgienne', 4), (86, 'Clafoutis aux poires', 1), (87, 'Salade vosgienne', 2), (87, 'Nems au poulet', 1), (87, 'Compote de poires', 1), (88, 'Tarte aux cerises', 2), (89, 'Nems au poulet', 3), (89, 'Coquilles saint Jacques', 3), (90, 'Crumble aux prunes', 1), (90, 'Risotto aux olives', 2), (91, 'Aligot', 4), (92, 'Paris Brest', 3), (92, 'Compote de pommes', 4), (93, 'Gratin de brocolis', 4), (93, 'Pizza reine', 2), (93, 'Tarte aux poires', 1), (94, 'Charlotte aux framboises', 1), (94, 'Tarte aux prunes', 4), (94, 'Compote de cerises', 1), (95, 'Tarte aux cerises', 3), (95, 'Charlotte aux framboises', 3), (95, 'Quiche lorraine', 4), (96, 'Mousse au chocolat', 1), (96, 'Compote de prunes', 2), (96, 'Omelette aux olives', 1), (97, 'Omelette aux olives', 4), (98, 'Risotto aux olives', 4), (98, 'Crumble aux pommes', 3), (99, 'Brownie au chocolat', 3), (99, 'Crumble aux prunes', 4), (99, 'Carottes rapées', 1);
