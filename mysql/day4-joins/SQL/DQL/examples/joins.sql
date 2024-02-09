-- Produit cartesien
SELECT *
FROM Ventes, Employes;

-- Produit cartesien ordonne
SELECT *
FROM Ventes, Employes
ORDER BY VenteID;


-- Produit cartesien filtre et ordonne
SELECT *
FROM Ventes, Employes
WHERE Ventes.EmployeID = Employes.EmployeID
ORDER BY VenteID;


-- Produit cartesien avec conservation de valeurs
SELECT VenteID, Ventes.EmployeID, Nom, Prenom
FROM Ventes, Employes
WHERE Ventes.EmployeID = Employes.EmployeID
ORDER BY VenteID;


/*=========================================================
           JOINS
===========================================================*/
-- INNER JOIN
-- ( Faire des jointures uniquement sur des lignes qui sont a la fois table Ventes et dans la table Employes)
SELECT *
FROM Ventes as v
         INNER JOIN Employes e ON v.EmployeID = e.EmployeID;


-- USING est plus simple a utiliser, par rapport a ON
SELECT *
FROM Ventes
         INNER JOIN Employes USING(EmployeID);


-- Select quelques colonnes
SELECT VenteID, Nom, Prenom
FROM Ventes v
         INNER JOIN Employes e ON v.EmployeID = e.EmployeID;


-- JOIN (simplification de INNER JOIN)
SELECT *
FROM Ventes as v
         JOIN Employes e ON v.EmployeID = e.EmployeID;


SELECT *
FROM Ventes
         JOIN Employes USING(EmployeID);


-- Select quelques colonnes
SELECT VenteID, Nom, Prenom
FROM Ventes v
         JOIN Employes e ON v.EmployeID = e.EmployeID;


-- Exercice: Donner pour chaque produit de la base de données le nom et l'adresse de son fournisseur
SELECT ProduitID, NomFournisseur, Adresse
FROM Fournisseurs fo
         JOIN Produits pr USING(FournisseurID);


SELECT ProduitID, NomProduit, NomFournisseur, Adresse
FROM Fournisseurs fo
         JOIN Produits pr ON fo.FournisseurID = pr.FournisseurID;



-- https://www.thecrazyprogrammer.com/2019/05/joins-in-sql.html
-- INNER JOIN conserve uniquement les clients qui ont fait des achats
SELECT EmployeID, Nom, Prenom, COUNT(VenteID) as NbVente
FROM Employes
         JOIN Ventes USING (EmployeID)
GROUP BY EmployeID, Nom, Prenom
ORDER BY NbVente;

-- Question donner pour chaque employé, le nom, le prénom et le nombre de vente réalisé (il faut conserver dans la base les employés qui ont des ventes nulles)
SELECT EmployeID, Nom, Prenom, COUNT(VenteID) as NbVente
FROM Employes
         LEFT JOIN Ventes USING (EmployeID)
GROUP BY EmployeID, Nom, Prenom
ORDER BY NbVente;



SELECT EmployeID, Nom, Prenom, COUNT(VenteID) as NbVente
FROM Employes
         RIGHT JOIN Ventes USING (EmployeID)
GROUP BY EmployeID, Nom, Prenom
ORDER BY NbVente;

