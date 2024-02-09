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



