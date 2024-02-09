/*====================*/
/* Sous-requête en SQL*/
/*====================*/
-- Liste des clients qui n'ont réalisé aucun achat

SELECT *
FROM Clients
WHERE ClientID NOT IN (SELECT ClientID FROM Ventes);

-- Liste des employés au moins une vente
SELECT *
FROM Employes
WHERE EmployeID IN (SELECT EmployeID FROM Ventes);

-- Exercice: Écrire une requête qui permet de donner pour chaque client son nom, son prénom, la somme des achats ainsi que la moyenne annuelle des achats



/* Comprendre les sous requêtes */

/* Utilisation des sous requêtes dans la clause WHERE */

/*======================================================================
Utilisation de sous-requêtes dans la clause WHERE pour des filtres avancés
SELECT colonne1, colonne2, ...
FROM table1
WHERE colonneX [NOT] IN (SELECT colonneY FROM table2 WHERE condition);

Explication:
- La clause WHERE avec sous-requête permet de filtrer les enregistrements de la requête principale en fonction des résultats de la sous-requête.
- L'opérateur [NOT] IN est utilisé pour inclure ou exclure les enregistrements correspondant aux valeurs retournées par la sous-requête.

Conseil:
- Utilisez des sous-requêtes dans WHERE pour des comparaisons qui nécessitent des ensembles de valeurs ou des conditions complexes.
- Assurez-vous que les sous-requêtes sont bien indexées pour éviter les performances lentes sur de grandes bases de données.
======================================================================*/


-- Donner la listes des produits qui n'ont pas été vendu en 2023
SELECT *
FROM Produits
WHERE ProduitID NOT IN (SELECT ProduitID FROM Ventes WHERE YEAR(dateVente)=2023);


SELECT ProduitID
FROM Ventes
WHERE YEAR(dateVente)=2023;


-- Quels clients ont un historique d'achat supérieur à la moyenne des achats ?
SELECT *
FROM Clients
         LEFT JOIN Ventes USING (ClientID)
WHERE MontantTotal > (SELECT AVG(MontantTotal) FROM Ventes);


-- Quels sont les noms des produits qui ont un prix unitaire supérieur
-- à la moyenne des prix de tous les produits ?
SELECT *
FROM Produits
WHERE PrixUnitaire > (SELECT AVG(PrixUnitaire) FROM Produits);


-- Donner la liste des employés qui n'ont réalisé aucune vente durant le mois de décembre 2022
SELECT EmployeID, Nom, Prenom
FROM Employes
         LEFT JOIN Ventes USING(EmployeID)
WHERE EmployeID NOT IN (SELECT EmployeID FROM Ventes WHERE YEAR(DateVente)=2022 AND MONTH(DateVente)=12);


-- employes ayant réalisé des ventes durant le mois de déc 2022
SELECT EmployeID
FROM Ventes
WHERE YEAR(DateVente)=2022 AND MONTH(DateVente)=12;



-- Exercice: Ecrire une requête qui permet de lister les clients qui n'ont jamais réalisé d'achat
SELECT *
FROM Clients
WHERE ClientID NOT IN (SELECT ClientID FROM Ventes);

/* Utilisation des sous requêtes dans la clause FROM */

/*======================================================================
Utilisation de sous-requêtes dans la clause FROM pour créer des tables temporaires
SELECT colonne1, colonne2, ...
FROM (SELECT colonneA, colonneB FROM table2 WHERE condition) AS sub_table
WHERE sub_table.colonneA = condition;

Explication:
- La clause FROM avec sous-requête crée une vue temporaire 'sub_table' qui peut être utilisée comme n'importe quelle autre table dans la requête principale.
- La sous-requête dans FROM est souvent utilisée pour simplifier des requêtes complexes ou pour effectuer des pré-filtrages.

Conseil:
- Donnez des alias clairs aux sous-tables pour améliorer la lisibilité de vos requêtes.
- Préfiltrez autant que possible dans la sous-requête pour réduire la charge de traitement dans la requête principale.
======================================================================*/


-- Donner pour chaque employé, le nom, le prénom et la moyenne des ventes annuelle
SELECT EmployeID,YEAR(DateVente) as Annee, SUM(MontantTotal) as CA
FROM Ventes
GROUP BY EmployeID,YEAR(DateVente);


-- La moyenne annuelle de ventes de chaque employe
SELECT EmployeID, AVG(CA) as MeanCA
FROM
    (SELECT EmployeID,YEAR(DateVente) as Annee, SUM(MontantTotal) as CA
     FROM Ventes
     GROUP BY EmployeID,YEAR(DateVente)) AS temp
GROUP BY EmployeID;


-- OU ENCORE on cree une vue et on l'a reutilise dans notre requette.
CREATE VIEW VenteTotalAnnuel AS
SELECT EmployeID,YEAR(DateVente) as Annee, SUM(MontantTotal) as CA
        FROM Ventes
        GROUP BY EmployeID,YEAR(DateVente));

SELECT EmployeID, AVG(CA) as MeanCA
FROM VenteTotalAnnuel AS temp
GROUP BY EmployeID;


-- Quelle est le taux de croissance du chiffre d'affaire entre 2021 et 2022?
SELECT SUM(MontantTotal) AS CA2021
FROM Ventes
WHERE YEAR(DateVente)=2021;

SELECT SUM(MontantTotal) AS CA2022
FROM Ventes
WHERE YEAR(DateVente)=2022;


SELECT (CA2022-CA2021)/CA2021 AS TxCroissance
FROM
    (SELECT SUM(MontantTotal) AS CA2022
     FROM Ventes
     WHERE YEAR(DateVente)=2022) AS temp,

    (SELECT SUM(MontantTotal) AS CA2021
     FROM Ventes
     WHERE YEAR(DateVente)=2021) AS temp2
;


-- Exercice:  Donner la liste des 10 clients dont la moyenne du nombre d'achat annuelle
-- le plus élevé
SELECT ClientID,Nom, Prenom, AVG(nbachat) as moyenne
FROM
    (SELECT ClientID,YEAR(dateVente) AS annee, COUNT(VenteID) AS nbachat
     FROM Ventes
     GROUP BY ClientID,YEAR(dateVente)) AS temp
        JOIN Clients USING(ClientID)
GROUP BY ClientID, Nom, Prenom
ORDER BY moyenne DESC
    LIMIT 10;





/* Utilisation des sous requête dans la clause SELECT*/

/*======================================================================
Utilisation de sous-requêtes dans la clause SELECT pour des calculs par ligne
SELECT colonne1, (SELECT COUNT(*) FROM table2 WHERE table2.colonneY = table1.colonneX) AS count_colonne
FROM table1;

Explication:
- La sous-requête dans SELECT permet de retourner des valeurs calculées pour chaque ligne de la table principale, idéal pour des agrégations ou des calculs conditionnels.
- Ces sous-requêtes sont souvent corrélées, c'est-à-dire qu'elles font référence à des colonnes de la requête principale.

Conseil:
- Utilisez les sous-requêtes dans SELECT pour des calculs détaillés ou des conditions qui varient par ligne.
- Veillez à ce que les requêtes soient optimisées pour éviter un impact négatif sur les performances, surtout avec des sous-requêtes corrélées dans des tables volumineuses.
======================================================================*/


-- Quels sont les produits qui ont un prix unitaire supérieur à la moyenne des prix unitaires de tous les produits vendus,
-- et combien de fois ont-ils été vendus?

SELECT
    P.NomProduit,
    P.PrixUnitaire,
    (SELECT COUNT(*) FROM Ventes WHERE ProduitID = P.ProduitID) AS NombreDeVentes
FROM
    Produits P
WHERE
        P.PrixUnitaire > (SELECT AVG(PrixUnitaire) FROM Produits)





/*Joindre plusieurs table*/

-- Lister les noms des employés avec le détail des produits et les informations sur
-- les clients ayant réalisé la

SELECT *
FROM Employes em
         LEFT JOIN Ventes ve USING(EmployeID)
         LEFT JOIN Produits pr USING(ProduitID);

-- Donner la liste des nom de fournisseur, le nom de produit et
-- les noms des clients pour tous les produits
-- qui ont été acheté plus de 2 fois
SELECT *
FROM
    (SELECT ProduitID, COUNT(VenteID) AS nbproduit
     FROM Ventes
     GROUP BY ProduitID
     HAVING nbproduit>2) as t
        JOIN Clients USING(ClientID)
        JOIN Produits USING(ProduitID)
        JOIN Ventes USING(ProduitID);


-- Donner la liste des nom de fournisseur, le nom de produit et
-- les noms des clients pour tous les produits
-- qui ont été acheté plus de 50 fois
SELECT *
FROM
    (SELECT ProduitID, COUNT(VenteID) AS nbproduit
     FROM Ventes
     GROUP BY ProduitID
     HAVING nbproduit > 50) as t
        JOIN Clients USING(ClientID)
        JOIN Produits USING(ProduitID)
        JOIN Ventes USING(ProduitID);

-- Quels produits ont été vendus par plus d'un employé ?
-- Qui sont les clients ayant acheté le plus grand nombre de produits différents ?


/* Maitriser les opérations ensemblistes */


/*======================================================================
Utilisation des opérations ensemblistes pour combiner les résultats de requêtes
SELECT colonne1, colonne2, ...
FROM table1
UNION [ALL] / INTERSECT / EXCEPT
SELECT colonne1, colonne2, ...
FROM table2;

Explication:
- SELECT colonne1, colonne2, ...: spécifie les colonnes à récupérer dans les résultats des requêtes.
- UNION: combine les résultats de deux requêtes en une seule liste de résultats sans doublons.
- UNION ALL: combine les résultats de deux requêtes en une seule liste de résultats avec doublons.
- INTERSECT: retourne uniquement les lignes communes aux deux requêtes.
- EXCEPT: retourne les lignes de la première requête qui ne sont pas présentes dans la seconde requête.
======================================================================*/


-- Donner la liste des employé qui ont plus de 100 ventes ou dont le chiffres d'affaires annuelle réalisé est supérieure à 2000 euro

-- Donner la liste des employé qui ont réalisé plus de 100 ventes et dont le CA annuelle est supérieure à 2000 euros

-- Quels employés n'ont réalisé aucune vente au premièr trimestre 2021 , contrairement au deuxième trimestre de 2021 ?





