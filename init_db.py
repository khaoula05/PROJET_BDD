import sqlite3

conn = sqlite3.connect("hotel.db")
cursor = conn.cursor()

# Création des tables
cursor.execute("""
CREATE TABLE IF NOT EXISTS Client (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT,
    email TEXT
)
""")

cursor.execute("""
CREATE TABLE IF NOT EXISTS Chambre (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    numero TEXT,
    type TEXT,
    prix REAL
)
""")

cursor.execute("""
CREATE TABLE IF NOT EXISTS Reservation (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date_debut DATE,
    date_fin DATE,
    idClient INTEGER,
    idChambre INTEGER,
    FOREIGN KEY(idClient) REFERENCES Client(id),
    FOREIGN KEY(idChambre) REFERENCES Chambre(id)
)
""")

# Insertion de données fictives
cursor.execute("INSERT INTO Client (nom, email) VALUES ('Alice', 'alice@example.com')")
cursor.execute("INSERT INTO Chambre (numero, type, prix) VALUES ('101', 'Simple', 50)")
cursor.execute("INSERT INTO Chambre (numero, type, prix) VALUES ('102', 'Double', 80)")

conn.commit()
conn.close()
