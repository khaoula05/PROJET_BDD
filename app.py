import streamlit as st
import sqlite3

conn = sqlite3.connect('hotel.db')
cursor = conn.cursor()

st.title("Gestion d'Hôtel")

menu = st.sidebar.selectbox("Menu", ["Réservations", "Clients", "Chambres disponibles", "Ajouter client", "Ajouter réservation"])

if menu == "Clients":
    cursor.execute("SELECT * FROM Client")
    rows = cursor.fetchall()
    for row in rows:
        st.write(row)

elif menu == "Réservations":
    cursor.execute("SELECT * FROM Reservation")
    st.table(cursor.fetchall())

elif menu == "Chambres disponibles":
    date_debut = st.date_input("Date début")
    date_fin = st.date_input("Date fin")
    query = """
    SELECT * FROM Chambre WHERE id NOT IN (
        SELECT id FROM Reservation WHERE date_debut <= ? AND date_fin >= ?
    )
    """
    cursor.execute(query, (date_fin, date_debut))
    st.table(cursor.fetchall())

elif menu == "Ajouter client":
    nom = st.text_input("Nom")
    email = st.text_input("Email")
    if st.button("Ajouter"):
        cursor.execute("INSERT INTO Client (nom, email) VALUES (?, ?)", (nom, email))
        conn.commit()
        st.success("Client ajouté")

elif menu == "Ajouter réservation":
    client_id = st.number_input("ID client", step=1)
    date_debut = st.date_input("Date début")
    date_fin = st.date_input("Date fin")
    if st.button("Réserver"):
        cursor.execute("INSERT INTO Reservation (date_debut, date_fin, idClient) VALUES (?, ?, ?)",
                       (date_debut, date_fin, client_id))
        conn.commit()
        st.success("Réservation ajoutée")
