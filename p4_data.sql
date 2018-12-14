-- Jeu de données exemple

-- On vide les tables
DELETE FROM ef_plate;
DELETE FROM ef_daily_list;
DELETE FROM ef_contact;
DELETE FROM ef_employee;
DELETE FROM ef_cook;
DELETE FROM ef_delivery_guy;
DELETE FROM ef_client;
DELETE FROM ef_order;
DELETE FROM ef_order_content;
DELETE FROM ef_daily_list_content;

-- On passe en utf-8
SET NAMES utf8;

-- On insère les données

-- Plats
INSERT INTO ef_plate(pl_name, pl_type)
VALUES
-- Plats
	('Tartiflette', 'plat'),
	('Poëlée montagnarde', 'plat'),
	('Burger vosgien', 'plat'),
	('Salade vosgienne', 'plat'),
	('Aligot', 'plat'),
	('Carottes rapées', 'plat'),
	('Betteraves rouges', 'plat'),
	('Gratin dauphinois', 'plat'),
	('Gratin de choux-fleurs', 'plat'),
	('Gratin de brocolis', 'plat'),
	('Salade niçoise', 'plat'),
	('Coquilles saint Jacques', 'plat'),
	('Nems au poulet', 'plat'),
	('Pizza 4 fromages', 'plat'),
	('Riz cantonnais', 'plat'),
	('Omelette aux olives', 'plat'),
	('Quiche lorraine', 'plat'),
	('Pot au feu', 'plat'),
	('Pizza reine', 'plat'),
	('Risotto aux olives', 'plat'),
	('Croques monsieur', 'plat'),
	('Soupe aux légumes', 'plat'),
	('Tomates farcies', 'plat'),
	('Poivrons farcis', 'plat'),
	('Aubergines farcies', 'plat'),
-- Desserts
	('Crumble aux pommes', 'dessert'),
	('Clafoutis aux pommes', 'dessert'),
	('Tarte aux pommes', 'dessert'),
	('Compote de pommes', 'dessert'),
	('Crumble aux poires', 'dessert'),
	('Clafoutis aux poires', 'dessert'),
	('Tarte aux poires', 'dessert'),
	('Compote de poires', 'dessert'),
	('Crumble aux prunes', 'dessert'),
	('Clafoutis aux prunes', 'dessert'),
	('Tarte aux prunes', 'dessert'),
	('Compote de prunes', 'dessert'),
	('Crumble aux cerises', 'dessert'),
	('Clafoutis aux cerises', 'dessert'),
	('Tarte aux cerises', 'dessert'),
	('Compote de cerises', 'dessert'),
	('Mousse au chocolat', 'dessert'),
	('Brownie au chocolat', 'dessert'),
	('Charlotte aux framboises', 'dessert'),
	('Paris Brest', 'dessert'),
	('Crèpes au nutella', 'dessert');

-- Listes journalières
INSERT INTO ef_daily_list(dl_date)
VALUES
	('2018-05-15'),
	('2018-05-16'),
	('2018-05-17'),
	('2018-05-18'),
	('2018-05-19'),
	('2018-05-20'),
	('2018-05-21'),
	('2018-05-22'),
	('2018-05-23'),
	('2018-05-24'),
	('2018-05-25'),
	('2018-05-26'),
	('2018-05-27'),
	('2018-05-28'),
	('2018-05-29'),
	('2018-05-30'),
	('2018-05-31');

-- Contenu des listes journalières
INSERT INTO ef_daily_list_content(dlc_list_date, dlc_plate_name)
VALUES
	('2018-05-15', 'Tartiflette'),
	('2018-05-15', 'Pot au feu'),
	('2018-05-15', 'Crèpes au nutella'),
	('2018-05-15', 'Brownie au chocolat'),
	('2018-05-16', 'Poëlée montagnarde'),
	('2018-05-16', 'Aubergines farcies'),
	('2018-05-16', 'Mousse au chocolat'),
	('2018-05-16', 'Compote de cerises'),
	('2018-05-17', 'Burger vosgien'),
	('2018-05-17', 'Poivrons farcis'),
	('2018-05-17', 'Clafoutis aux cerises'),
	('2018-05-17', 'Tarte aux cerises'),
	('2018-05-18', 'Salade vosgienne'),
	('2018-05-18', 'Tomates farcies'),
	('2018-05-18', 'Clafoutis aux cerises'),
	('2018-05-18', 'Crumble aux pommes'),
	('2018-05-19', 'Aligot'),
	('2018-05-19', 'Soupe aux légumes'),
	('2018-05-19', 'Crumble aux cerises'),
	('2018-05-19', 'Clafoutis aux pommes'),
	('2018-05-20', 'Carottes rapées'),
	('2018-05-20', 'Croques monsieur'),
	('2018-05-20', 'Compote de prunes'),
	('2018-05-20', 'Tarte aux pommes'),
	('2018-05-21', 'Betteraves rouges'),
	('2018-05-21', 'Risotto aux olives'),
	('2018-05-21', 'Tarte aux prunes'),
	('2018-05-21', 'Compote de pommes'),
	('2018-05-22', 'Gratin dauphinois'),
	('2018-05-22', 'Pizza reine'),
	('2018-05-22', 'Clafoutis aux prunes'),
	('2018-05-22', 'Crumble aux poires'),
	('2018-05-23', 'Gratin de choux-fleurs'),
	('2018-05-23', 'Pot au feu'),
	('2018-05-23', 'Crumble aux prunes'),
	('2018-05-23', 'Clafoutis aux prunes'),
	('2018-05-24', 'Gratin de brocolis'),
	('2018-05-24', 'Quiche lorraine'),
	('2018-05-24', 'Clafoutis aux prunes'),
	('2018-05-24', 'Mousse au chocolat'),
	('2018-05-25', 'Salade niçoise'),
	('2018-05-25', 'Omelette aux olives'),
	('2018-05-25', 'Compote de poires'),
	('2018-05-25', 'Crumble aux poires'),
	('2018-05-26', 'Coquilles saint Jacques'),
	('2018-05-26', 'Riz cantonnais'),
	('2018-05-26', 'Tarte aux poires'),
	('2018-05-26', 'Paris Brest'),
	('2018-05-27', 'Nems au poulet'),
	('2018-05-27', 'Pizza 4 fromages'),
	('2018-05-27', 'Clafoutis aux poires'),
	('2018-05-27', 'Charlotte aux framboises'),
	('2018-05-28', 'Poëlée montagnarde'),
	('2018-05-28', 'Quiche lorraine'),
	('2018-05-28', 'Crumble aux poires'),
	('2018-05-28', 'Tarte aux cerises'),
	('2018-05-29', 'Salade niçoise'),
	('2018-05-29', 'Salade vosgienne'),
	('2018-05-29', 'Compote de pommes'),
	('2018-05-29', 'Crèpes au nutella'),
	('2018-05-30', 'Omelette aux olives'),
	('2018-05-30', 'Burger vosgien'),
	('2018-05-30', 'Tarte aux pommes'),
	('2018-05-30', 'Brownie au chocolat'),
	('2018-05-31', 'Quiche lorraine'),
	('2018-05-31', 'Gratin de choux-fleurs'),
	('2018-05-31', 'Clafoutis aux pommes'),
	('2018-05-31', 'Compote de cerises');

-- Coordonnées
INSERT INTO ef_contact(con_name, con_surname, con_phone_number, con_email, con_street, con_zip_code, con_city)
VALUES
	('Gilbert', 'Muda', '01.13.10.04.87', 'gilbert.muda@gmail.com', '59, rue Marguerite', '94300', 'VINCENNES'),
	('Hector', 'Gnol', '04.15.48.91.63', 'hector.gnol@gmail.com',  '51, rue Gustave Eiffel', '69140', 'RILLIEUX-LA-PAPE'),
	('Jim', 'Agine', '03.83.85.75.91', 'jim.agine@gmail.com', '80, place Maurice-Charretier', '08000', 'CHARLEVILLE-MÉZIÈRES'),
	('Amélie', 'Ksir', '04.62.70.99.71', 'amelie.ksir@gmail.com', '71, rue Reine Elisabeth', '06500', 'MENTON'),
	('Eva', 'Kué', '04.19.34.91.56', 'eva.kue@gmail.com', '42, rue des Soeurs', '13600', 'LA CIOTAT'),
	('Alex', 'Ception', '03.37.17.87.86', 'alex.ception@gmail.com', '32, rue Pierre Motte', '88100', 'SAINT-DIÉ'),
	('Lenny', 'Bards', '04.87.96.32.43', 'lenny.bards@gmail.com', '30, rue Grande Fusterie', '69006', 'LYON');

-- Clients
INSERT INTO ef_client(cl_contact_id)
VALUES
	(1),
	(2),
	(3),
	(4);

-- Employés
INSERT INTO ef_employee(em_contact_id)
VALUES
	(5),
	(6),
	(7);
	
-- Cuisiniers
INSERT INTO ef_cook(co_employee_id)
VALUES
	(1);

-- Livreurs
INSERT INTO ef_delivery_guy(dg_employee_id, dg_status, dg_position_latitude, dg_position_longitude)
VALUES
	(2, 'attente', 45.7669, 4.7896),
	(3, 'en livraison', 45.7863, 4.8253);

-- Commandes
INSERT INTO ef_order(o_date, o_status, o_delivery_guy_id)
VALUES
	('2018-05-15 12:10:53', 'livrée', 2),
	('2018-05-15 13:10:53', 'livrée', 2),
	('2018-05-16 12:30:53', 'livrée', 2),
	('2018-05-16 12:30:53', 'annulée', NULL),
	('2018-05-16 12:30:53', 'livrée', 3),
	('2018-05-17 12:30:53', 'livrée', 2),
	('2018-05-17 12:30:53', 'livrée', 3),
	('2018-05-18 12:30:53', 'annulée', NULL),
	('2018-05-18 12:30:53', 'livrée', 3),
	('2018-05-18 17:26:00', 'livrée', 2);

-- Contenu des commandes
INSERT INTO ef_order_content(oc_plate_name, oc_order_id, oc_quantity)
VALUES
	('Tartiflette', 1, 2),
	('Crèpes au nutella', 1, 2);