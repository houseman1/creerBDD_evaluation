--Créez un groupe marketing qui peut ajouter, modifier et supprimer des produits et des catégories, 
--consulter des commandes, leur détails et les clients. Ce groupe ne peut rien faire sur les autres tables.
--i.e.  role1 = SELECT, INSERT, UPDATE, DELETE on products and categories
--      role2 = SELECT on orders, order details and customers

USE afpa_gescom;

--Creating roles
CREATE ROLE IF NOT EXISTS
    'r_afpa_gescom_role1'@'%',
    'r_afpa_gescom_role2'@'%';

--Granting privileges to roles
--role1 = SELECT, INSERT, UPDATE, DELETE on tables: products and categories
GRANT SELECT, INSERT, UPDATE, DELETE
    ON TABLE afpa_gescom.products
    TO 'r_afpa_gescom_role1'@'%';

GRANT SELECT, INSERT, UPDATE, DELETE
    ON TABLE afpa_gescom.categories
    TO 'r_afpa_gescom_role1'@'%';

--role2 = SELECT on tables: orders, order details and customers
GRANT SELECT 
    ON TABLE afpa_gescom.orders
    TO 'r_afpa_gescom_role2'@'%';

GRANT SELECT
    ON TABLE afpa_gescom.orders_details 
    TO 'r_afpa_gescom_role2'@'%';

GRANT SELECT
    ON TABLE afpa_gescom.customers 
    TO 'r_afpa_gescom_role2'@'%';

--Creating 'marketing' user accounts with passwords
CREATE USER 'marketing1'@'%' IDENTIFIED BY 'pass1';
CREATE USER 'marketing2'@'%' IDENTIFIED BY 'pass2';
CREATE USER 'marketing3'@'%' IDENTIFIED BY 'pass3';

--Assigning roles to user accounts
GRANT 'r_afpa_gescom_role1'@'%',
      'r_afpa_gescom_role2'@'%'
    TO 'marketing1'@'%',
       'marketing2'@'%',
       'marketing3'@'%';

--Setting default roles to make them active when the user connects to the server
SET DEFAULT ROLE 'r_afpa_gescom_role1'@'%',
                 'r_afpa_gescom_role2'@'%'   
    TO 'marketing1'@'%',
       'marketing2'@'%',
       'marketing3'@'%';

--Displaying privileges that roles represent
SHOW GRANTS FOR 'marketing1'@'%'
    USING 'r_afpa_gescom_role1'@'%',
          'r_afpa_gescom_role2'@'%';

SHOW GRANTS FOR 'marketing2'@'%'
    USING 'r_afpa_gescom_role1'@'%',
          'r_afpa_gescom_role2'@'%';

SHOW GRANTS FOR 'marketing3'@'%'
    USING 'r_afpa_gescom_role1'@'%',
          'r_afpa_gescom_role2'@'%';
