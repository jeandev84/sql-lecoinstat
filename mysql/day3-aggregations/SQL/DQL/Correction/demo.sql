SELECT EmployeID, MontantTotal
FROM Ventes
ORDER BY EmployeID DESC;

SELECT EmployeID, ClientID, SUM(MontantTotal) AS MontantTotal
FROM Ventes
GROUP BY EmployeID, ClientID
ORDER BY EmployeID DESC;


SELECT EmployeID, COUNT(VenteID) AS NombreVentes
FROM Ventes
GROUP BY EmployeID
ORDER BY EmployeID DESC, NombreVentes DESC;



SELECT *, EXTRACT(YEAR FROM DateVente) as Annee
FROM Ventes;

SELECT EXTRACT(YEAR FROM DateVente) as Annee, SUM(MontantTotal) as MontantTotal
FROM Ventes
GROUP BY Annee;


SELECT EXTRACT(YEAR FROM DateVente) as Annee, SUM(MontantTotal) as MontantTotal
FROM Ventes
GROUP BY Annee
ORDER BY Annee;


SELECT EXTRACT(YEAR FROM DateVente) as Annee, SUM(MontantTotal) as MontantTotal
FROM Ventes
GROUP BY Annee
ORDER BY MontantTotal DESC;



SELECT YEAR(DateVente) as Annee, EmployeID, SUM(MontantTotal) as Mtotal
FROM Ventes
GROUP BY Annee, EmployeID
HAVING Mtotal > 1000
ORDER BY Mtotal DESC;



SELECT YEAR(DateVente) as Annee, EmployeID, SUM(MontantTotal) as Mtotal
FROM Ventes
WHERE MontantTotal > 1000
GROUP BY Annee, EmployeID
HAVING Mtotal > 1000
ORDER BY Mtotal DESC;



SELECT YEAR(DateVente) as Annee, SUM(MontantTotal) as Mtotal
FROM Ventes
GROUP BY Annee
HAVING Mtotal > 1000
ORDER BY Mtotal DESC;


/*
SQL — Ordre d'exécution des requêtes
1 — FROM (avec les JOIN)
2 — WHERE.
3 — GROUP BY.
4 — HAVING.
5 — SELECT.
6 — ORDER BY.
Exemples.
*/

