-- Créez une vue des ventes de l'année 2021`
CREATE VIEW Vente2021 AS
SELECT *
FROM Ventes
WHERE YEAR(DateVente) = 2021;

SELECT *
FROM Vente2021;

-- Quelle est la liste des clients qui ont réalisé plus de 2 achats en 2021
SELECT ClientID, Nom, Prenom, COUNT(VenteID) as NbAchat
FROM Clients
         LEFT JOIN Vente2021 USING(ClientID)
GROUP BY ClientID
HAVING NbAchat > 1;


-- Quelle est la liste des employés qui ont les ventes moyennes supérieures à 500 en 2021?
SELECT EmployeID, Nom, Prenom, AVG(MontantTotal) as AvgVente
FROM Employes
         LEFT JOIN Vente2021 USING(EmployeID)
GROUP BY EmployeID, Nom, Prenom
HAVING AvgVente >500;

-- Créez une vue contenant les produits dont le prix est supérieur à 500 euros
CREATE VIEW ProduitSup500 AS
SELECT *
FROM Produits
WHERE PrixUnitaire > 500;

-- Créez une vue contenant pour chaque client le nom, le prénom ainsi que la somme des achats par année

-- Quelle est pour chaque client la moyenne des CA générés par année?

