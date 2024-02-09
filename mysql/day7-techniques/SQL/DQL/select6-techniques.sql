
/*==================================================================================
            Fonctions de fenêtrage
==================================================================================*/
-- Syntaxe de Base pour les Fonctions de Fenêtrage en SQL
/*
SELECT colonnes,
       FONCTION_DE_FENETRAGE() OVER (
           PARTITION BY colonne_de_partitionnement
           ORDER BY colonne_de_tri
           RANGE | ROWS BETWEEN debut AND fin
       ) AS nom_colonne_resultat
FROM table;

Explication:
- SELECT colonnes: Spécifie les colonnes à récupérer dans le résultat final, incluant la colonne résultante de la fonction de fenêtrage.
- FONCTION_DE_FENETRAGE() OVER (...): Applique une fonction de fenêtrage à un ensemble de lignes.
- PARTITION BY colonne_de_partitionnement: Divise les données en partitions pour le traitement par la fonction de fenêtrage.
- ORDER BY colonne_de_tri: Détermine l'ordre des lignes dans chaque partition.
- RANGE | ROWS BETWEEN debut AND fin: Définit le cadre de lignes pour l'application de la fonction.

*/

-- Rownumber: créer une requête qui permet d'afficher la table vente en ajoutant le numéro de la ligne
SELECT *,
       ROW_NUMBER()
           OVER(ORDER BY MontantTotal) AS NumeroLigne
FROM Ventes
ORDER BY MontantTotal;


-- Ajouter le rang avec RANK() et DENSE_RANK()
SELECT *,
       RANK()
           OVER(ORDER BY MontantTotal) AS Rang
FROM Ventes
ORDER BY MontantTotal;

SELECT *,
       DENSE_RANK()
           OVER(ORDER BY MontantTotal) AS Rang
FROM Ventes
ORDER BY MontantTotal;

/* LEAD LAG*/
-- Pour chaque année donner le CA de l'année précédente et le CA de l'année suivante
SELECT YEAR(DateVente) AS Annee, SUM(MontantTotal) AS CA
FROM Ventes
GROUP BY Annee;


SELECT YEAR(DateVente) AS Annee,
    SUM(MontantTotal) AS CA,
    LAG( SUM(MontantTotal),1,0)
    OVER(ORDER BY YEAR(DateVente)) AS CAPrecedent,
    LEAD(SUM(MontantTotal),1,0)
    OVER(ORDER BY YEAR(DateVente)) AS CASuivant

FROM Ventes
GROUP BY Annee;



/*FIRST_VALUE() et LAST_VALUE()*/
/*ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING: garantit que la fonction FIRST_VALUE() prend en compte toutes les lignes dans la fenêtre de partitionnement pour trouver le premier produit acheté*/


-- Pour chaque client quel était le premier produit qu'il a acheté
SELECT ClientID,
       ProduitID,
       DateVente,
       FIRST_VALUE(ProduitID)
           OVER(PARTITION BY ClientID
				   ORDER BY DateVente
                   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) As PremierAchat
FROM Ventes;


-- Pour chaque client quel était le dernier produit acheté
SELECT ClientID,
       ProduitID,
       DateVente,
       LAST_VALUE(ProduitID)
           OVER(PARTITION BY ClientID
				   ORDER BY DateVente
                   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) As DernierAchat
FROM Ventes;




/*==================================================================================
           Maitriser les CTE
==================================================================================*/

/*
Les CTE, ou 'Expressions de Table Communes', permettent de créer des ensembles de résultats temporaires accessibles dans une requête SELECT, INSERT, UPDATE ou DELETE. Elles sont définies avec le mot-clé WITH suivi du nom de la CTE et du mot-clé AS qui introduit la requête de la CTE.

Forme Générale:
WITH Nom_CTE AS (
    -- Requête de la CTE ici
)
SELECT * FROM Nom_CTE;

Utilisation :
- Simplifier les jointures complexes et les sous-requêtes.
- Activer la récursivité pour le traitement de données hiérarchiques.
- Améliorer la lisibilité et la maintenance du code SQL.

Note :
- Une CTE est valide uniquement dans le contexte d'une seule instruction SQL.
- Les CTEs récursives doivent inclure un UNION ALL entre les membres ancre et récursif.
- Plusieurs CTEs peuvent être définies dans une seule clause WITH, séparées par des virgules.
*/


-- écrire une requête qui permet d'obtenir le top 3 des meilleurs clients (en terme de CA) par année

-- Donner pour chaque client le chiffre d'affaires
SELECT ClientID, SUM(MontantTotal) AS CA
FROM Ventes
GROUP BY ClientID;

-- Donner pour chaque client le chiffre d'affaires  par année
SELECT ClientID,
    YEAR(DateVente) AS Annee, SUM(MontantTotal) AS CA
FROM Ventes
GROUP BY ClientID, Annee;

-- Classement par année
CREATE VIEW Temp as (
                    SELECT ClientID,
                        YEAR(DateVente) AS Annee,
                        SUM(MontantTotal) AS CA,
                        RANK()
                        OVER(PARTITION BY YEAR(DateVente)
                        ORDER BY SUM(MontantTotal) DESC) As Classement
                    FROM Ventes
                    GROUP BY ClientID, Annee);

SELECT *
FROM Temp
WHERE Classement BETWEEN 1 AND 3;


-- Deuxième option : Sous requête
SELECT *
FROM (SELECT ClientID,
          YEAR(DateVente) AS Annee,
          SUM(MontantTotal) AS CA,
          RANK()
          OVER(PARTITION BY YEAR(DateVente)
          ORDER BY SUM(MontantTotal) DESC) As Classement
      FROM Ventes
      GROUP BY ClientID, Annee) As Temp
WHERE Classement BETWEEN 1 AND 3;

-- Troisième option CTE
WITH tempCA AS (

    SELECT ClientID,
    YEAR(DateVente) AS Annee,
    SUM(MontantTotal) AS CA,
    RANK()
    OVER(PARTITION BY YEAR(DateVente)
    ORDER BY SUM(MontantTotal) DESC) As Classement
FROM Ventes
GROUP BY ClientID, Annee
    )
SELECT *
FROM tempCA
WHERE Classement BETWEEN 1 AND 3;


WITH tempCA AS (

    SELECT ClientID,
    YEAR(DateVente) AS Annee,
    SUM(MontantTotal) AS CA,
    RANK()
    OVER(PARTITION BY YEAR(DateVente)
    ORDER BY SUM(MontantTotal) DESC) As Classement
FROM Ventes
GROUP BY ClientID, Annee
    )
SELECT *
FROM tempCA
WHERE Classement BETWEEN 1 AND  3 ;


-- Liste des clients qui ont dépensé plus que la moyenne des dépenses de tous les clients:

-- Donner pour chaque client le chiffre d'affaires
WITH temp1 AS (

    SELECT ClientID, SUM(MontantTotal) AS CA
    FROM Ventes
    GROUP BY ClientID

)
SELECT *
FROM temp1
WHERE CA > (SELECT AVG(MontantTotal) AS Moyenne FROM Ventes);

SELECT *
FROM (
         SELECT ClientID, SUM(MontantTotal) AS CA
         FROM Ventes
         GROUP BY ClientID) as temp
WHERE CA >(SELECT AVG(MontantTotal) AS Moyenne FROM Ventes);

SELECT AVG(MontantTotal) AS Moyenne FROM Ventes;

SELECT ClientID, MontantTotal
FROM Ventes
WHERE MontantTotal > (SELECT AVG(MontantTotal) AS Moyenne FROM Ventes);

SELECT AVG(MontantTotal) AS Moyenne FROM Ventes

/*==================================================================================
           Fonctions ensemblistes
==================================================================================*/

/* CTE Réutilisable
WITH CTE1 AS (
    SELECT * FROM TableA
), CTE2 AS (
    SELECT * FROM TableB
)
SELECT * FROM CTE1
UNION ALL
SELECT * FROM CTE2;
*/

-- UNION: Combine les résultats de deux requêtes en éliminant les doublons.
/*
SELECT colonne FROM table1
UNION
SELECT colonne FROM table2;

Explication:
- L'opérateur UNION est utilisé pour combiner les résultats de deux requêtes distinctes.
- Il élimine les lignes en double pour ne retourner que des lignes distinctes.
- Les deux requêtes doivent avoir le même nombre de colonnes dans le résultat, avec des types de données compatibles.
*/

-- Quelle est la liste combinée des noms de tous les employés et de tous les clients ?
SELECT Nom
FROM Employes
UNION
SELECT Nom
FROM Clients;

/* Ajouter le nom des fournisseurs */
SELECT Nom
FROM Employes

UNION

SELECT Nom
FROM Clients

UNION

SELECT NomFournisseur AS Nom
FROM Fournisseurs;

-- Nom et prenom de tous les employés
SELECT Nom,Prenom
FROM Employes

UNION

SELECT Nom,Prenom
FROM Clients;

WITH NomClients AS (SELECT Nom,Prenom
                    FROM Employes),

     NomEmployes AS (SELECT Nom, Prenom
                     FROM Employes)

SELECT *
FROM NomClients

UNION

SELECT *
FROM NomEmployes;



/*
A = (a,b,c,d) B= (e,f,g)
A UNION B
(a,b,c,d,e,f,g)*/
-- UNION ALL: Combine les résultats de deux requêtes en conservant les doublons.

/*
SELECT colonne FROM table1
UNION ALL
SELECT colonne FROM table2;

Explication:
- L'opérateur UNION ALL combine les résultats de deux requêtes sans éliminer les doublons.
- Cela peut être utile si vous souhaitez conserver toutes les lignes, y compris les répétitions.
- Comme pour UNION, les requêtes combinées doivent avoir des résultats avec le même nombre et type de colonnes.
*/

SELECT Nom,Prenom
FROM Employes

UNION ALL

SELECT Nom,Prenom
FROM Clients;

-- Quels sont tous les noms des employés et des clients, en incluant les noms répétés ?
/*
(1,3,5,6) = A
(3,6,2,7)= B
A UNION B (1,3,5,6,2,7)
A INTERSECT B (3,6)*/


-- INTERSECT: Retourne les lignes communes à deux requêtes.
/*
SELECT colonne FROM table1
INTERSECT
SELECT colonne FROM table2;

Explication:
- L'opérateur INTERSECT trouve les lignes qui sont communes aux deux requêtes.
- Il est moins fréquemment supporté que UNION et UNION ALL dans certains systèmes de gestion de bases de données.
- Les deux requêtes doivent avoir des structures de résultat compatibles.
*/


-- Quelles sont les employés ayant réalisé plus de 1000 euros de chiffres d'affaire et qui ont réalisé plus de 10 ventes


-- EXCEPT ou MINUS: Retourne les lignes de la première requête qui ne sont pas présentes dans la seconde.
/*
SELECT colonne FROM table1
EXCEPT
SELECT colonne FROM table2;

Explication:
- L'opérateur EXCEPT (ou MINUS, selon le système de gestion de base de données) soustrait les résultats de la seconde requête de la première.
- Le résultat contient uniquement les lignes uniques de la première requête qui ne sont pas trouvées dans la seconde.
- Les deux requêtes doivent retourner le même nombre de colonnes avec des types de données compatibles.
*/


-- Quels employés n'ont jamais réalisé de vente ?
-- Première approche

SELECT *
FROM Employes
WHERE EmployeID NOT IN (SELECT EmployeID FROM Ventes);





-- Quels employés n'ont pas géré de clients VIP ? (clients achete plus de 5000 euros)

/*CTE Recursive

WITH RECURSIVE CTERecursive (colonne) AS (
    SELECT colonne FROM TableInitiale WHERE condition
    UNION ALL
    SELECT t.colonne FROM TableInitiale t INNER JOIN CTERecursive c ON t.condition = c.colonne
)
SELECT * FROM CTERecursive;
*/




