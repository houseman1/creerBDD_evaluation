CREATE DATABASE IF NOT EXISTS my_gescom;

USE my_gescom;

CREATE TABLE IF NOT EXISTS suppliers(
   Id_suppliers INT AUTO_INCREMENT NOT NULL,
   sup_nom VARCHAR(50),
   sup_address VARCHAR(255),
   sup_tel INT,
   sup_contact VARCHAR(50),
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
   Id_orders INT AUTO_INCREMENT NOT NULL,
   ord_date DATE,
   shp_date DATE,
   del_date DATE,
   shp_name VARCHAR(50),
   shp_address VARCHAR(255),
   Id_customers INT NOT NULL,
   PRIMARY KEY(Id_orders),
   FOREIGN KEY(Id_customers) REFERENCES customers(Id_customers)
);

CREATE TABLE IF NOT EXISTS employees(
   Id_employees INT AUTO_INCREMENT NOT NULL,
   emp_name VARCHAR(50),
   emp_fir_name VARCHAR(50),
   emp_address VARCHAR(255),
   emp_pos VARCHAR(50),
   emp_shop VARCHAR(50),
   emp_dept VARCHAR(50),
   gro_sal DECIMAL,
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
   Id_categories_1 INT NOT NULL,
   PRIMARY KEY(Id_categories),
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
   pro_for_sale BOOLEAN,
   Id_categories INT NOT NULL,
   Id_suppliers INT NOT NULL,
   PRIMARY KEY(Id_products), 
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
   FOREIGN KEY(Id_employees) REFERENCES employees(Id_employees),
   FOREIGN KEY(Id_customers) REFERENCES customers(Id_customers)
);

CREATE TABLE IF NOT EXISTS detailed(
   Id_products INT,
   Id_orders INT,
   qty_ord INT,
   pro_pri DECIMAL,
   discount DECIMAL,
   PRIMARY KEY(Id_products, Id_orders),
   FOREIGN KEY(Id_products) REFERENCES products(Id_products),
   FOREIGN KEY(Id_orders) REFERENCES orders(Id_orders)
);

CREATE TABLE IF NOT EXISTS add_modify(
   Id_products INT,
   Id_employees INT,
   pro_date_add DATE,
   pro_date_mod DATE,
   PRIMARY KEY(Id_products, Id_employees),
   FOREIGN KEY(Id_products) REFERENCES products(Id_products),
   FOREIGN KEY(Id_employees) REFERENCES employees(Id_employees)
);

CREATE TABLE IF NOT EXISTS represent(
   Id_suppliers INT,
   Id_sales_rep INT,
   PRIMARY KEY(Id_suppliers, Id_sales_rep),
   FOREIGN KEY(Id_suppliers) REFERENCES suppliers(Id_suppliers),
   FOREIGN KEY(Id_sales_rep) REFERENCES sales_rep(Id_sales_rep)
);
