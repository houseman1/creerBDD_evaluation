CREATE DATABASE IF NOT EXISTS my_gescom;

USE my_gescom;


--Les tables sans clés étrangères sont créées en premier pour éviter les erreurs.
--La clé primaire doit être déclarée avant sa clé étrangère.
CREATE TABLE IF NOT EXISTS suppliers(
   --L'incrémentation automatique permet de générer automatiquement un numéro unique lorsqu'un
   --nouvel enregistrement est inséré dans une table.
   Id_suppliers INT AUTO_INCREMENT NOT NULL,
   sup_nom VARCHAR(50),--varchar pour une chaîne de caractères
   sup_address VARCHAR(255),--varchar(255) pour une chaîne en cas où l'adresse serait longue
   sup_tel INT,--entier de taille normale
   sup_contact VARCHAR(50),--varchar pour une chaîne de caractères
   --la clé primaire est id_suppliers (auto_increment) parce que je souhaite la créer automatiquement
   --à chaque fois qu'un nouvel enregistrement est inséré.
   --Elle doit être unique à chaque fois.
   PRIMARY KEY  (Id_suppliers)
);

CREATE TABLE IF NOT EXISTS customers(
   Id_customers INT AUTO_INCREMENT NOT NULL,
   cus_name VARCHAR(50),
   cus_fir_name VARCHAR(50),
   cus_address VARCHAR(255),
   PRIMARY KEY(Id_customers)
);

CREATE TABLE IF NOT EXISTS orders(
   --Cette table est separée de la table details, parce que les valeurs de cette table sont fixés.
   --Les valeurs de la tables detailed peuvent changer avec chaque commande.
   Id_orders INT AUTO_INCREMENT NOT NULL,
   ord_date DATE,--Date sous la forme "AAAA-MM-JJ"
   shp_date DATE,
   del_date DATE,
   shp_name VARCHAR(50),
   shp_address VARCHAR(255),
   Id_customers INT NOT NULL,--NOT NULL parce que les clés étrangères doivent avoir une valeur
   PRIMARY KEY(Id_orders),
   FOREIGN KEY(Id_customers) REFERENCES customers(Id_customers)--La clé étrangère qui me permet de joindre les tables orders, customers et detailed.
);

CREATE TABLE IF NOT EXISTS employees(
   Id_employees INT AUTO_INCREMENT NOT NULL,
   emp_name VARCHAR(50),
   emp_fir_name VARCHAR(50),
   emp_address VARCHAR(255),
   emp_pos VARCHAR(50),
   emp_shop VARCHAR(50),
   emp_dept VARCHAR(50),
   gro_sal DECIMAL,--décimal pour une valeur monétaire
   emp_yos INT,
   emp_sex VARCHAR(50),
   emp_chi INT,
   PRIMARY KEY(Id_employees)
);

CREATE TABLE IF NOT EXISTS sales_rep(
   Id_sales_rep INT AUTO_INCREMENT NOT NULL,
   rep_name VARCHAR(50),
   rep_fir_name VARCHAR(50),
   rep_tel INT,
   PRIMARY KEY(Id_sales_rep)
);

CREATE TABLE IF NOT EXISTS categories(
   Id_categories INT AUTO_INCREMENT NOT NULL,
   cat_name VARCHAR(50),
   Id_categories_1 INT NOT NULL,-- catégorie parent
   PRIMARY KEY(Id_categories),
   --Une auto-jointure est une jointure régulière, mais la table est jointe à elle-même.
   --C'est utilisé quand une table lie des informations avec des enregistrements de la même table.
   --Dans ce cas, id_categories est lie au id_categories1.
   --Comme ça, on peut trouver la catégorie parent est la sous-catégorie de chaque produit
   FOREIGN KEY(Id_categories_1) REFERENCES categories(Id_categories)
);

CREATE TABLE IF NOT EXISTS products(
   Id_products INT AUTO_INCREMENT NOT NULL,
   pro_cat VARCHAR(50),
   pro_int_ref VARCHAR(50),
   pro_bar INT,
   pro_cur_stk INT,
   pro_stk_ale INT,
   pro_col VARCHAR(50),
   pro_lib VARCHAR(50),
   pro_des VARCHAR(255),
   --Un booléen est un type de variable à deux états: vrai ou faux.
   --Je l'ai utilisé pour dire si le produit est vendu ou pas.
   --Dans la formulaire il y aurait une case à cocher.
   pro_for_sale BOOLEAN,
   Id_categories INT NOT NULL,
   Id_suppliers INT NOT NULL,
   PRIMARY KEY(Id_products),
   --Les clés étrangères qui me permet de joindre les tables products, categories et suppliers. 
   FOREIGN KEY(Id_categories) REFERENCES categories(Id_categories),
   FOREIGN KEY(Id_suppliers) REFERENCES suppliers(Id_suppliers)
);

CREATE TABLE IF NOT EXISTS passwords(
   Id_passwords INT AUTO_INCREMENT NOT NULL,
   pass_password VARCHAR(50),
   pass_date_add DATE,
   pass_date_mod DATE,
   Id_employees INT NOT NULL,
   Id_customers INT NOT NULL,
   PRIMARY KEY(Id_passwords),
   --Les clés étrangères qui me permet de joindre les tables passwords, employees et customers.
   FOREIGN KEY(Id_employees) REFERENCES employees(Id_employees),
   FOREIGN KEY(Id_customers) REFERENCES customers(Id_customers)
);

CREATE TABLE IF NOT EXISTS detailed(
   --Cette table est separée de la table orders, parce que la quantité, discount et prix des commandes peuvent changer
   --à chaque commande.
   Id_products INT,
   Id_orders INT,
   qty_ord INT,
   pro_pri DECIMAL,
   discount DECIMAL,
   ,--J'ai utilisé une clé primaire composite parce que deux attributs (id_products et id_orders) de deux tables
   --différentes (products et orders) sont utilisées pour récupérer les informations uniques.
   --La clé composite se compose de deux attributs (colonnes de table) qui, ensemble, identifient de manière unique une ligne de la table.
   PRIMARY KEY(Id_products, Id_orders),
   --Les clés étrangères doivent contenir les attributs de la clé primaire composite.
   --Il faut savoir id_products et id_orders pour obtenir la quantité, prix et discount.
   --Ses clés étrangères me permet de joindre les tables details, products et orders.
   FOREIGN KEY(Id_products) REFERENCES products(Id_products),
   FOREIGN KEY(Id_orders) REFERENCES orders(Id_orders)
);

CREATE TABLE IF NOT EXISTS add_modify(
   Id_products INT,
   Id_employees INT,
   pro_date_add DATE,
   pro_date_mod DATE,
   PRIMARY KEY(Id_products, Id_employees),--Une clé primaire composite, comme expliquer au-dessus (table detailed)
   --Les clés étrangères qui me permet de joindre les tables add_modify, products et employees.
   FOREIGN KEY(Id_products) REFERENCES products(Id_products),
   FOREIGN KEY(Id_employees) REFERENCES employees(Id_employees)
);

CREATE TABLE IF NOT EXISTS represent(
   Id_suppliers INT,
   Id_sales_rep INT,
   PRIMARY KEY(Id_suppliers, Id_sales_rep),--Une clé primaire composite, comme expliquer au-dessus (table detailed)
   --Les clés étrangères qui me permet de joindre les tables represent, suppliers et sales_rep.
   FOREIGN KEY(Id_suppliers) REFERENCES suppliers(Id_suppliers),
   FOREIGN KEY(Id_sales_rep) REFERENCES sales_rep(Id_sales_rep)
);
