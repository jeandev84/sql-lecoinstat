/*
INSERT INTO table (colonne1, colonne2, ..., colonneN)
VALUES (valeur1, valeur2, ..., valeurN);

Explication:
- INSERT INTO table: Déclare l'intention d'insérer des données dans la table spécifiée.
- (colonne1, colonne2, ..., colonneN): Spécifie les colonnes cibles pour l'insertion. L'ordre des colonnes doit correspondre à l'ordre des valeurs fournies.
- VALUES (valeur1, valeur2, ..., valeurN): Définit les valeurs à insérer pour les colonnes spécifiées. Chaque ensemble de valeurs entre parenthèses représente une ligne à insérer dans la table.

Variantes:
1. Insertion de multiples lignes:
   INSERT INTO table (colonne1, colonne2)
   VALUES (valeur1A, valeur2A),
          (valeur1B, valeur2B),
          ...;
   - Cette syntaxe permet d'insérer plusieurs lignes en une seule commande, en séparant chaque ensemble de valeurs par des virgules.

2. Insertion à partir d'une sélection:
   INSERT INTO table1 (colonne1, colonne2)
   SELECT colonneA, colonneB
   FROM table2
   WHERE condition;
   - Cette méthode permet d'insérer des données dans table1 directement à partir d'un sous-ensemble de données sélectionnées dans table2 ou toute autre table, en fonction d'une condition spécifiée.

Conseils:
- Assurez-vous que les types de données des valeurs correspondent aux types de données des colonnes.
- Lors de l'insertion de données dans une table avec une colonne ID auto-incrémentée, il n'est pas nécessaire de spécifier une valeur pour cette colonne, sauf si vous souhaitez écraser le comportement auto-incrémenté.
- Utilisez la clause ON DUPLICATE KEY UPDATE pour mettre à jour la ligne si l'insertion aboutit à un doublon de clé primaire ou unique.

*/


/* Ajout d'un nouvel employe*/

INSERT INTO Employes(EmployeID,Nom,Prenom,Email,NumeroTelephone)
VALUES (200,"NJONGWA","Natacha","temp@gmail.com",0978349);

-- Remplacer tous les produits <200 par 100

UPDATE Produits
SET PrixUnitaire=100
WHERE NomProduit = "Nike Air Max";


/*
UPDATE table
SET colonne1 = nouvelle_valeur1,
    colonne2 = nouvelle_valeur2,
    ...
WHERE condition_de_filtrage;

Explication:
- UPDATE table: Déclare l'intention de mettre à jour des données dans la table spécifiée.
- SET colonne1 = nouvelle_valeur1, ... : Spécifie les colonnes à mettre à jour et les nouvelles valeurs à leur attribuer. Vous pouvez mettre à jour une ou plusieurs colonnes en même temps.
- WHERE condition_de_filtrage: Détermine les lignes à mettre à jour grâce à une condition spécifiée. Si la clause WHERE est omise, toutes les lignes de la table seront mises à jour, ce qui n'est généralement pas recommandé.

Variantes:
1. Mise à jour conditionnelle:
   UPDATE table
   SET colonne = nouvelle_valeur
   WHERE colonne_condition = certaine_valeur;
   - Cette syntaxe permet de mettre à jour des lignes spécifiques qui correspondent à la condition énoncée dans la clause WHERE.

2. Mise à jour avec jointures:
   UPDATE table1
   JOIN table2 ON table1.colonne_jointure = table2.colonne_jointure
   SET table1.colonne = nouvelle_valeur
   WHERE table2.colonne_condition = certaine_valeur;
   - Permet de mettre à jour une table en se basant sur les données d'une autre table, en utilisant une condition de jointure.

Conseils:
- Faites preuve de prudence avec la clause WHERE pour éviter de mettre à jour plus de lignes que prévu.
- Il est souvent utile de tester votre clause WHERE avec une commande SELECT avant de l'exécuter avec UPDATE, pour s'assurer qu'elle sélectionne les bonnes lignes.
- Pour des raisons de performance, essayez de limiter le nombre de colonnes mises à jour uniquement à celles qui doivent réellement être changées.
- Pensez à utiliser des transactions pour regrouper plusieurs opérations de mise à jour en une seule unité de travail, permettant ainsi de les annuler toutes ensemble en cas d'erreur.

*/



/*
UPDATE table
SET colonne1 = nouvelle_valeur1,
    colonne2 = nouvelle_valeur2,
    ...
WHERE condition_de_filtrage;

Explication:
- UPDATE table: Déclare l'intention de mettre à jour des données dans la table spécifiée.
- SET colonne1 = nouvelle_valeur1, ... : Spécifie les colonnes à mettre à jour et les nouvelles valeurs à leur attribuer. Vous pouvez mettre à jour une ou plusieurs colonnes en même temps.
- WHERE condition_de_filtrage: Détermine les lignes à mettre à jour grâce à une condition spécifiée. Si la clause WHERE est omise, toutes les lignes de la table seront mises à jour, ce qui n'est généralement pas recommandé.

Variantes:
1. Mise à jour conditionnelle:
   UPDATE table
   SET colonne = nouvelle_valeur
   WHERE colonne_condition = certaine_valeur;
   - Cette syntaxe permet de mettre à jour des lignes spécifiques qui correspondent à la condition énoncée dans la clause WHERE.

2. Mise à jour avec jointures:
   UPDATE table1
   JOIN table2 ON table1.colonne_jointure = table2.colonne_jointure
   SET table1.colonne = nouvelle_valeur
   WHERE table2.colonne_condition = certaine_valeur;
   - Permet de mettre à jour une table en se basant sur les données d'une autre table, en utilisant une condition de jointure.

Conseils:
- Faites preuve de prudence avec la clause WHERE pour éviter de mettre à jour plus de lignes que prévu.
- Il est souvent utile de tester votre clause WHERE avec une commande SELECT avant de l'exécuter avec UPDATE, pour s'assurer qu'elle sélectionne les bonnes lignes.
- Pour des raisons de performance, essayez de limiter le nombre de colonnes mises à jour uniquement à celles qui doivent réellement être changées.
- Pensez à utiliser des transactions pour regrouper plusieurs opérations de mise à jour en une seule unité de travail, permettant ainsi de les annuler toutes ensemble en cas d'erreur.

*/


/* Pour Supprimer la table*/
/* DROP TABLE table; our DROP TABLE IF EXISTS table;



/*-- Supprime la colonne des colonnes
ALTER TABLE table
DROP COLUMN colonne;*/

-- Supprimer prixUnitaire
ALTER TABLE Produits
DROP COLUMN NomProduit;

/*Supprimer plusieurs colonnes
ALTER TABLE table
DROP COLUMN colonne1
DROP COLUMN colonne1;;*/


/*Modifie le nom de la colonne `ancien_nom` en `nouveau_nom` dans la table `ma_table`: RENAME
ALTER TABLE ma_table
CHANGE COLUMN ancien_nom nouveau_nom nouveau_type;*/

DROP TABLE IF EXISTS table;
