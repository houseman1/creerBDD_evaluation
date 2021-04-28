--Q1. Afficher dans l'ordre alphabétique et sur une seule colonne les noms et prénoms des employés qui ont des enfants,
--présenter d'abord ceux qui en ont le plus.
SELECT CONCAT(emp_lastname, ' ', emp_firstname), emp_children
FROM employees
WHERE emp_children > 0
ORDER BY emp_children DESC

--Q2. Y-a-t-il des clients étrangers ? Afficher leur nom, prénom et pays de résidence.
SELECT cus_lastname, cus_firstname, cus_countries_id
FROM customers
WHERE cus_countries_id != 'FR';

--Q3. Afficher par ordre alphabétique les villes de résidence des clients ainsi que le code (ou le nom) du pays.
SELECT cus_city, cus_countries_id, cou_name
FROM customers c
JOIN countries ON cus_countries_id = cou_id
ORDER BY cus_city

--Q4. Afficher le nom des clients dont les fiches ont été modifiées
SELECT cus_lastname, cus_update_date
FROM customers
WHERE cus_update_date IS NOT NULL;

--Q5. La commerciale Coco Merce veut consulter la fiche d'un client, 
--mais la seule chose dont elle se souvienne est qu'il habite une ville genre 'divos'. Pouvez-vous l'aider ?
SELECT cus_lastname, cus_firstname, cus_address, cus_city, cus_zipcode, cus_mail, cus_phone
FROM customers
WHERE cus_city LIKE '%divos%';

--Q6. Quel est le produit vendu le moins cher ? Afficher le prix, l'id et le nom du produit.
SELECT pro_id, pro_name, MIN(pro_price) AS 'pro_price'
FROM products
GROUP BY pro_id, pro_name
HAVING MIN(pro_price)
ORDER BY MIN(pro_price)
LIMIT 1;

--Q7. Lister les produits qui n'ont jamais été vendus
SELECT pro_id, pro_ref, pro_name
FROM products
LEFT JOIN orders_details ON pro_id = ode_pro_id
WHERE ode_pro_id IS NULL;

--Q8. Afficher les produits commandés par Madame Pikatchien.
SELECT pro_id, pro_ref, pro_name, cus_id, ord_id, ode_pro_id
FROM products
JOIN orders_details ON pro_id = ode_pro_id
JOIN orders ON ode_ord_id = ord_id
JOIN customers ON ord_cus_id = cus_id
WHERE cus_lastname = 'Pikatchien';

--Q9. Afficher le catalogue des produits par catégorie, le nom des produits et de la catégorie doivent être affichés.
SELECT cat_id, cat_name, pro_name
FROM products
LEFT JOIN categories ON pro_cat_id = cat_id
GROUP BY pro_name
ORDER BY cat_name;

--Q10. Afficher l'organigramme hiérarchique (nom et prénom et poste des employés) du magasin de Compiègne, 
--classer par ordre alphabétique. Afficher le nom et prénom des employés, éventuellement le poste (si vous y parvenez).
SELECT CONCAT(e.emp_lastname, ' ', e.emp_firstname),  CONCAT(s.emp_lastname, ' ', s.emp_firstname)
FROM  employees e
JOIN employees s ON e.emp_superior_id = s.emp_id
JOIN shops ON sho_id = e.emp_sho_id
JOIN posts p ON p.pos_id = e.emp_pos_id
WHERE sho_city = 'Compiègne'
ORDER BY e.emp_lastname;

--Q11. Quel produit a été vendu avec la remise la plus élevée ? Afficher le montant de la remise, 
--le numéro et le nom du produit, le numéro de commande et de ligne de commande.
--Résultat : il s'agit du produit 13 (brouette Green), commande 43, ligne de commande 85.
SELECT ode_id, ode_ord_id, pro_id, pro_name, ode_discount
FROM products
JOIN orders_details ON pro_id = ode_pro_id
WHERE ode_discount = (
    SELECT MAX(ode_discount)
    FROM orders_details);

--Q12. Combien y-a-t-il de clients canadiens ? Afficher dans une colonne intitulée 'Nb clients Canada'
--Résultat : 2 clients
SELECT COUNT(cus_countries_id) AS 'Nb clients Canada'
FROM customers
JOIN countries ON cou_id = cus_countries_id
WHERE cou_id = 'CA';

--Q13. Afficher le détail des commandes de 2020.
SELECT ode_id, ode_unit_price, ode_discount, ode_quantity, ode_ord_id, ode_pro_id, ord_order_date
FROM orders_details 
JOIN orders ON ord_id = ode_ord_id
WHERE YEAR(ord_order_date)=2020;

--Q14. Afficher les coordonnées des fournisseurs pour lesquels des commandes ont été passées.
--Résultat : les 4 premiers fournisseurs de la table suppliers; 
--seul le fournisseur n°5, FOURNIRIEN, n'a pas vendu de produits.
SELECT sup_name, sup_city, sup_address, sup_zipcode, sup_phone, sup_mail
FROM suppliers
JOIN products ON pro_sup_id = sup_id
JOIN orders_details ON pro_id = ode_pro_id
GROUP BY sup_name
HAVING COUNT(ode_quantity)>0
ORDER BY sup_name;

--Q15. Quel est le chiffre d'affaires de 2020 ?
--Résultat : 1720.83 €
SELECT ROUND(SUM((ode_unit_price-(ode_unit_price*ode_discount/100))*ode_quantity)2) AS chiffre_aff FROM orders_details
JOIN orders ON ode_ord_id = ord_id 
WHERE YEAR(ord_order_date)=2020;


--Q16. Quel est le panier moyen ?
--Résultat : 234.29 €
SELECT ROUND((SUM((ode_unit_price-(ode_unit_price*ode_discount/100))*ode_quantity))/(COUNT(DISTINCT ode_ord_id)),2)
FROM orders_details;


--Q17. Lister le total de chaque commande par total décroissant 
--(Afficher numéro de commande, date, total et nom du client).
--10 premiers résultats (68 au total)
SELECT ord_id, cus_lastname, ord_order_date, ode_quantity, SUM(ode_unit_price*ode_quantity) AS Total
FROM orders_details
JOIN orders ON ord_id = ode_ord_id
JOIN customers ON ord_cus_id = cus_id
GROUP BY ord_id
ORDER BY Total DESC;


--Q18. La version 2020 du produit barb004 s'appelle désormais Camper et, bonne nouvelle, son prix subit 
--une baisse de 10%.
--Produit 12, prix d'origine = 100 €, le prix après réduction doit être de 90 €.
UPDATE products
SET 
    pro_name = 'Camper',
    pro_price = pro_price * .9,
WHERE 
    pro_id = 12;

--Q19. L'inflation en France en 2019 a été de 1,1%, appliquer cette augmentation à la gamme de parasols.
--Les produits 25 à 27 sont concernés. Prix d'origine du produit 25 : 100 €, prix après augmentation : 101,10 €.
UPDATE products
JOIN categories ON cat_id = pro_cat_id
SET pro_price = pro_price + (pro_price * 1.011) 
WHERE cat_name = 'Parasols' AND pro_id BETWEEN 25 AND 27;

--Q20. Supprimer les produits non vendus de la catégorie "Tondeuses électriques". 
--Vous devez utiliser une sous-requête sans indiquer de valeurs de clés.

--phase one
--SELECT pro_name, pro_id
--FROM products
--JOIN categories ON pro_cat_id = cat_id
--WHERE cat_id = 9;

--phase two
--SELECT pro_id, pro_name, cat_id, cat_name
--FROM categories
--JOIN products ON pro_cat_id = cat_id
--WHERE pro_cat_id = 
    --(SELECT cat_id 
    --FROM categories
    --WHERE cat_name = 'Tondeuses électriques');

--final answer
DELETE FROM products
WHERE pro_cat_id = 
    (SELECT cat_id
    FROM categories 
    WHERE cat_name="Tondeuses électriques")  
    AND pro_id NOT IN 
        (SELECT ode_pro_id
        FROM orders_details);
