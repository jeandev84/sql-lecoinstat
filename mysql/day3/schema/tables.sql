-- Création de la table "Clients"
-- DROP TABLE Clients;
CREATE TABLE Clients (
 ClientID INT PRIMARY KEY,
 Nom VARCHAR(255),
 Prenom VARCHAR(255),
 Adresse VARCHAR(255),
 Email VARCHAR(255),
 NumeroTelephone VARCHAR(25)
);




-- Création de la table Fournisseurs
-- DROP TABLE Fournisseurs;
CREATE TABLE Fournisseurs (
  FournisseurID INT PRIMARY KEY,
  NomFournisseur VARCHAR(200),
  Adresse VARCHAR(100),
  Email VARCHAR(200),
  NumeroTelephone VARCHAR(200)
);

-- Creation de la table employe
-- DROP TABLE Employes;
CREATE TABLE Employes (
  EmployeID INT PRIMARY KEY,
  Nom VARCHAR(200),
  Prenom VARCHAR(200),
  Fonction VARCHAR(200),
  Email VARCHAR(200),
  NumeroTelephone VARCHAR(200)
) ;


-- Insertion des données dans les table fournisseurs
-- INSERT INTO Fournisseurs (FournisseurID, NomFournisseur, Adresse, Email, NumeroTelephone)
-- VALUES (1233, "Steve", "Rue Voltaire", "steve2024@gmail.com", "07 54 34, 72"),
-- (1444, "Arthur", "Rue Lumière", "arthur024@gmail.com", "07 54 34, 72");

-- Modification de la table Produits pour intégrer l'identifiant du fournisseur
-- Création de la table "Produits"
-- DROP TABLE Produits;
CREATE TABLE Produits (
  ProduitID INT PRIMARY KEY,
  NomProduit VARCHAR(200),
  Description TEXT,
  PrixUnitaire DECIMAL(10, 2),
  FournisseurID INT,
  FOREIGN KEY(FournisseurID)  REFERENCES Fournisseurs(FournisseurID)
);


-- Modification de la création de la table vente pour intégrer l'identifiant de l'employe
-- DROP TABLE Ventes;
CREATE TABLE Ventes (
    VenteID INT PRIMARY KEY,
    DateVente DATE,
    ClientID INT,
    ProduitID INT,
    EmployeID INT,
    FOREIGN KEY(ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY(ProduitID)  REFERENCES Produits(ProduitID),
    FOREIGN KEY(EmployeID) REFERENCES Employes(EmployeID),
    QuantiteVendue INT,
    MontantTotal DECIMAL(10, 2)
);

