-- Active: 1746155383017@@localhost@3306@projet_hotel
-- first drop the database before use it
DROP DATABASE IF EXISTS projet;
-- CREATE DATABASE AND USE IT
CREATE DATABASE IF NOT EXISTS projet;
USE projet;

-- HOTEL TABLE
CREATE TABLE IF NOT EXISTS Hotel (
    Id_Hotel INT PRIMARY KEY, 
    Ville VARCHAR(30),
    Pays VARCHAR(30),
    Code_Pstal INT  -- FIX: Consistent with spelling (though it’s probably meant to be Code_Postal)
);

-- TYPECH TABLE
CREATE TABLE IF NOT EXISTS TypeCh (
    Id_Type INT PRIMARY KEY,
    Type VARCHAR(30),
    Tarif FLOAT
);

-- CHAMBRE TABLE
CREATE TABLE IF NOT EXISTS Chambre (
    Id_Chambre INT PRIMARY KEY, 
    Numero INT, 
    Etage INT,
    Fumeur BOOLEAN,  -- FIX: "Fumeure" → "Fumeur"
    Id_Hotel INT, 
    Id_Type INT,
    FOREIGN KEY (Id_Hotel) REFERENCES Hotel(Id_Hotel),
    FOREIGN KEY (Id_Type) REFERENCES TypeCh(Id_Type)
);

-- PRESTATION TABLE
CREATE TABLE IF NOT EXISTS Prestation (
    Id_Prestation INT PRIMARY KEY,
    Prix INT,
    Choix TEXT
);

-- OFFRE TABLE
CREATE TABLE IF NOT EXISTS Offre (
    Id_Hotel INT,
    Id_Prestation INT,
    PRIMARY KEY (Id_Hotel, Id_Prestation),
    FOREIGN KEY (Id_Hotel) REFERENCES Hotel(Id_Hotel),
    FOREIGN KEY (Id_Prestation) REFERENCES Prestation(Id_Prestation)
);

-- CLIENT TABLE
CREATE TABLE IF NOT EXISTS Client (
    Id_Client INT PRIMARY KEY,
    Nom_Complet VARCHAR(40),
    Adresse VARCHAR(40),
    Ville VARCHAR(30),
    Code_Post VARCHAR(30),
    E_mail VARCHAR(30),
    Num_Tele VARCHAR(15)  -- FIX: "NUM_TELE" → "Num_Tele" to match insert
);

-- EVALUATION TABLE
CREATE TABLE IF NOT EXISTS Evaluation (
    Id_Evaluation INT PRIMARY KEY,
    Date_arr DATE,
    Note INT,
    TexteDesc VARCHAR(100),
    Id_Hotel INT,  -- FIX: Added Id_Hotel to match foreign key
    Id_Client INT,
    FOREIGN KEY (Id_Hotel) REFERENCES Hotel(Id_Hotel),
    FOREIGN KEY (Id_Client) REFERENCES Client(Id_Client)
); 

-- RESERVATION TABLE
CREATE TABLE IF NOT EXISTS Reservation (
    Id_Reservation INT PRIMARY KEY,
    Date_ar DATE,
    Date_dep DATE,
    Id_Client INT,
    FOREIGN KEY (Id_Client) REFERENCES Client(Id_Client)
);

-- CONCERNER TABLE
CREATE TABLE IF NOT EXISTS Concerner (
    Id_Type INT,
    Id_Reservation INT,
    PRIMARY KEY (Id_Type, Id_Reservation),
    FOREIGN KEY (Id_Type) REFERENCES TypeCh(Id_Type),
    FOREIGN KEY (Id_Reservation) REFERENCES Reservation(Id_Reservation)
);

-- INSERTION DE DONNÉES
USE projet;

-- HOTELS
INSERT INTO Hotel (Id_Hotel, Ville, Pays, Code_Pstal) VALUES 
  (1, 'Paris', 'France', 75001),
  (2, 'Lyon', 'France', 69002);

-- CLIENTS
INSERT INTO Client (Id_Client, Adresse, Ville, Code_Post, E_mail, Num_Tele, Nom_Complet) VALUES 
  (1, '12 Rue de Paris', 'Paris', '75001', 'jean.dupont@email.fr', '0612345678', 'Jean Dupont'),
  (2, '5 Avenue Victor Hugo', 'Lyon', '69002', 'marie.leroy@email.fr', '0623456789', 'Marie Leroy'),
  (3, '8 Boulevard Saint-Michel', 'Marseille', '13005', 'paul.moreau@email.fr', '0634567890', 'Paul Moreau'),
  (4, '27 Rue Nationale', 'Lille', '59800', 'lucie.martin@email.fr', '0645678901', 'Lucie Martin'),
  (5, '3 Rue des Fleurs', 'Nice', '06000', 'emma.giraud@email.fr', '0656789012', 'Emma Giraud');

-- PRESTATIONS
INSERT INTO Prestation (Id_Prestation, Prix, Choix) VALUES
  (1, 15, 'Petit-déjeuner'),
  (2, 30, 'Navette aéroport'),
  (3, 0, 'Wi-Fi gratuit'),
  (4, 50, 'Spa et bien-être'),
  (5, 20, 'Parking sécurisé');

-- TYPES DE CHAMBRES
INSERT INTO TypeCh (Id_Type, Type, Tarif) VALUES
  (1, 'Simple', 80),
  (2, 'Double', 120);

-- CHAMBRES
INSERT INTO Chambre (Id_Chambre, Numero, Etage, Fumeur, Id_Hotel, Id_Type) VALUES
  (1, 201, 2, 0, 1, 1),
  (2, 502, 5, 1, 1, 2),
  (3, 305, 3, 0, 2, 1),
  (4, 410, 4, 0, 2, 2),
  (5, 104, 1, 1, 2, 2),
  (6, 202, 2, 0, 1, 1),
  (7, 307, 3, 1, 1, 2),
  (8, 101, 1, 0, 1, 1);

-- RÉSERVATIONS
INSERT INTO Reservation (Id_Reservation, Date_ar, Date_dep, Id_Client) VALUES 
  (1, '2025-06-15', '2025-06-18', 1),
  (2, '2025-07-01', '2025-07-05', 2),
  (3, '2025-08-10', '2025-08-14', 3),
  (4, '2025-09-05', '2025-09-07', 4),
  (5, '2025-09-20', '2025-09-25', 5),
  (7, '2025-11-12', '2025-11-14', 2),
  (9, '2026-01-15', '2026-01-18', 4),
  (10, '2026-02-01', '2026-02-05', 2);

-- ÉVALUATIONS
INSERT INTO Evaluation (Id_Evaluation, Date_arr, Note, TexteDesc, Id_Client, Id_Hotel) VALUES
  (1, '2025-06-15', 5, 'Excellent séjour, personnel très accueillant.', 1, 1),
  (2, '2025-07-01', 4, 'Chambre propre, bon rapport qualité/prix.', 2, 1),
  (3, '2025-08-10', 3, 'Séjour correct mais bruyant la nuit.', 3, 2),
  (4, '2025-09-05', 5, 'Service impeccable, je recommande.', 4, 2),
  (5, '2025-09-20', 4, 'Très bon petit-déjeuner, hôtel bien situé.', 5, 1);

-- ALGÈBRE RELATIONNELLE - REQUÊTES
USE projet;

-- A. Liste des réservations avec client et ville
SELECT 
    R.Id_Reservation,
    C.Nom_Complet,
    H.Ville
FROM 
    Reservation R
JOIN Client C ON R.Id_Client = C.Id_Client
JOIN Concerner Co ON R.Id_Reservation = Co.Id_Reservation
JOIN TypeCh T ON Co.Id_Type = T.Id_Type
JOIN Chambre Ch ON T.Id_Type = Ch.Id_Type
JOIN Hotel H ON Ch.Id_Hotel = H.Id_Hotel
GROUP BY R.Id_Reservation, C.Nom_Complet, H.Ville;

-- B. Clients à Paris
SELECT * 
FROM Client 
WHERE Ville = 'Paris';

-- C. Nombre de réservations par client
SELECT 
  C.Id_Client, 
  C.Nom_Complet, 
  COUNT(R.Id_Reservation) AS Nb_Reservations
FROM 
  Client C
LEFT JOIN Reservation R ON C.Id_Client = R.Id_Client
GROUP BY C.Id_Client, C.Nom_Complet;

-- D. Nombre de chambres par type
SELECT 
    T.Type,
    COUNT(Ch.Id_Chambre) AS Nb_Chambres
FROM 
    TypeCh T
LEFT JOIN Chambre Ch ON T.Id_Type = Ch.Id_Type
GROUP BY T.Type;

-- E. Chambres non réservées entre 1er et 10 juin 2025
SELECT * 
FROM Chambre Ch
WHERE Ch.Id_Chambre NOT IN (
    SELECT DISTINCT Ch.Id_Chambre
    FROM Chambre Ch
    JOIN Concerner Co ON Ch.Id_Type = Co.Id_Type
    JOIN Reservation R ON Co.Id_Reservation = R.Id_Reservation
    WHERE 
        R.Date_ar <= '2025-06-10' AND R.Date_dep >= '2025-06-01'
);
