-- Database

DROP DATABASE IF EXISTS chen_chiv;
CREATE DATABASE chen_chiv;

\c chen_chiv

-- Drop tables

DROP TABLE IF EXISTS formulaire_personnel CASCADE;
DROP TABLE IF EXISTS formulaire_residence CASCADE;
DROP TABLE IF EXISTS formulaire_sexualite CASCADE;
DROP TABLE IF EXISTS formulaire_physique CASCADE;

DROP TABLE IF EXISTS utilisateur CASCADE;
DROP TABLE IF EXISTS abonne CASCADE;
DROP TABLE IF EXISTS match CASCADE;
DROP TABLE IF EXISTS chat CASCADE;
DROP TABLE IF EXISTS message CASCADE;

DROP TABLE IF EXISTS lieu CASCADE;
DROP TABLE IF EXISTS evenement CASCADE;
DROP TABLE IF EXISTS lieu_evenement CASCADE;
DROP TABLE IF EXISTS suggestion_evenement CASCADE;
DROP TABLE IF EXISTS tag CASCADE;
DROP TABLE IF EXISTS sous_categorie CASCADE;
DROP TABLE IF EXISTS categorie CASCADE;
DROP TABLE IF EXISTS tag_lieu CASCADE;
DROP TABLE IF EXISTS tag_utilisateur CASCADE;
DROP TABLE IF EXISTS tag_evenement CASCADE;

DROP TABLE IF EXISTS genre CASCADE;

DROP TABLE IF EXISTS utilisateur_netflix CASCADE;
DROP TABLE IF EXISTS film CASCADE;
DROP TABLE IF EXISTS genre_film CASCADE;
DROP TABLE IF EXISTS film_note CASCADE;

DROP TABLE IF EXISTS utilisateur_spotify CASCADE;
DROP TABLE IF EXISTS musique CASCADE;
DROP TABLE IF EXISTS genre_musique CASCADE;
DROP TABLE IF EXISTS musique_ecoute CASCADE;

-- Drop types

DROP TYPE IF EXISTS TYPE_ABONNEMENT;
DROP TYPE IF EXISTS STATUT_MATCH;
DROP TYPE IF EXISTS STATUT_EVENEMENT;
DROP TYPE IF EXISTS TYPE_INTERACTION;

-- Formulaires

CREATE TABLE utilisateur(
    id SERIAL PRIMARY KEY,
    pseudo VARCHAR(32) NOT NULL,
    mot_de_passe VARCHAR(64) NOT NULL
);

CREATE TABLE formulaire_personnel(
    id_utilisateur INT PRIMARY KEY,
    photo VARCHAR(64) NOT NULL,
    prenom VARCHAR(64) NOT NULL,
    age INT NOT NULL,
    email VARCHAR(64) UNIQUE NOT NULL,
    numero_de_telephone VARCHAR(16) UNIQUE NOT NULL,
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id),
    CHECK(age > 17)
);

CREATE TABLE formulaire_residence(
    id_utilisateur INT PRIMARY KEY,
    pays VARCHAR(64) NOT NULL,
    ville VARCHAR(64) NOT NULL,
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id)
);

CREATE TABLE formulaire_sexualite(
    id_utilisateur INT PRIMARY KEY,
    genre VARCHAR(64) NOT NULL,
    orientation_sexuelle VARCHAR(64) NOT NULL,
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id)
);

CREATE TABLE formulaire_physique(
    id_utilisateur INT PRIMARY KEY,
    taille INT NOT NULL,
    poids INT NOT NULL,
    couleur_yeux VARCHAR(32) NOT NULL,
    couleur_cheveux VARCHAR(32) NOT NULL,
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id)
);

CREATE TYPE TYPE_ABONNEMENT AS ENUM ('ARGENT', 'OR', 'DIAMANT');

CREATE TABLE abonne(
    id SERIAL PRIMARY KEY,
    id_utilisateur INTEGER UNIQUE NOT NULL,
    type_abonnement TYPE_ABONNEMENT NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id),
    CHECK(date_debut < date_fin)
);

-- Match

CREATE TYPE STATUT_MATCH AS ENUM ('SUGGERER', 'LIKE', 'NOPE');

CREATE TABLE match (
    id SERIAL PRIMARY KEY,
    id_utilisateur1 INTEGER NOT NULL,
    id_utilisateur2 INTEGER NOT NULL,
    statut_match STATUT_MATCH NOT NULL,
    FOREIGN KEY(id_utilisateur1) REFERENCES utilisateur(id),
    FOREIGN KEY(id_utilisateur2) REFERENCES utilisateur(id),
    UNIQUE(id_utilisateur1, id_utilisateur2)
);


CREATE TABLE chat(
    id SERIAL PRIMARY KEY,
    id_utilisateur1 INTEGER NOT NULL,
    id_utilisateur2 INTEGER NOT NULL,
    FOREIGN KEY(id_utilisateur1) REFERENCES utilisateur(id),
    FOREIGN KEY(id_utilisateur2) REFERENCES utilisateur(id),
    CHECK(id_utilisateur1 < id_utilisateur2),
    UNIQUE(id_utilisateur1, id_utilisateur2)
);

CREATE TABLE message(
    id SERIAL PRIMARY KEY,
    id_utilisateur INTEGER NOT NULL,
    id_chat INTEGER NOT NULL,
    contenu TEXT NOT NULL,
    date TIMESTAMP NOT NULL,
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY(id_chat) REFERENCES chat(id) ON DELETE CASCADE
);

-- Lieu et Evenements

CREATE TABLE lieu(
    id SERIAL PRIMARY KEY,
    adresse TEXT NOT NULL,
    code_postal TEXT NOT NULL,
    pays TEXT NOT NULL
);

CREATE TYPE STATUT_EVENEMENT AS ENUM ('TERMINE', 'EN_COURS', 'FUTUR');

CREATE TABLE evenement(
    id SERIAL PRIMARY KEY,
    id_utilisateur_annonceur INTEGER NOT NULL,
    titre TEXT NOT NULL,
    description TEXT,
    date_debut timestamp NOT NULL,
    date_fin timestamp NOT NULL,
    organisateur TEXT,
    prix INTEGER,
    statut_evenement STATUT_EVENEMENT NOT NULL,
    FOREIGN KEY(id_utilisateur_annonceur) REFERENCES utilisateur(id)
);

CREATE TABLE lieu_evenement(
    id SERIAL PRIMARY KEY,
    id_lieu INTEGER NOT NULL,
    id_evenement INTEGER NOT NULL,
    FOREIGN KEY(id_lieu) REFERENCES lieu(id),
    FOREIGN KEY(id_evenement) REFERENCES evenement(id),
    UNIQUE(id_lieu, id_evenement)
);

CREATE TYPE TYPE_INTERACTION AS ENUM ('EN_ATTENTE', 'INTERESSER', 'PARTICIPER');

CREATE TABLE suggestion_evenement(
    id SERIAL PRIMARY KEY,
    id_evenement INTEGER NOT NULL,
    id_utilisateur INTEGER NOT NULL,
    type_interaction TYPE_INTERACTION NOT NULL,
    FOREIGN KEY(id_evenement) REFERENCES evenement(id),
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id),
    UNIQUE(id_utilisateur, id_evenement)
);

-- Tags

CREATE TABLE categorie(
    id SERIAL PRIMARY KEY,
    nom VARCHAR(32) UNIQUE NOT NULL
);

CREATE TABLE sous_categorie(
    id SERIAL PRIMARY KEY,
    id_categorie INTEGER NOT NULL,
    nom VARCHAR(32) NOT NULL,
    FOREIGN KEY(id_categorie) REFERENCES categorie(id) ON DELETE CASCADE,
    UNIQUE(id_categorie, nom)
);

CREATE TABLE tag(
    id SERIAL PRIMARY KEY,
    id_sous_categorie INTEGER NOT NULL,
    mot_clef VARCHAR(32) NOT NULL,
    FOREIGN KEY(id_sous_categorie) REFERENCES sous_categorie(id) ON DELETE CASCADE,
    UNIQUE(id_sous_categorie, mot_clef)
);

CREATE TABLE tag_lieu(
    id SERIAL PRIMARY KEY,
    id_tag INTEGER NOT NULL,
    id_lieu INTEGER NOT NULL,
    FOREIGN KEY(id_tag) REFERENCES tag(id),
    FOREIGN KEY(id_lieu) REFERENCES lieu(id),
    UNIQUE(id_tag, id_lieu)
);

CREATE TABLE tag_utilisateur(
    id SERIAL PRIMARY KEY,
    id_tag INTEGER NOT NULL,
    id_utilisateur INTEGER NOT NULL,
    FOREIGN KEY(id_tag) REFERENCES tag(id),
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id),
    UNIQUE(id_tag, id_utilisateur)
);

CREATE TABLE tag_evenement(
    id SERIAL PRIMARY KEY,
    id_tag INTEGER NOT NULL,
    id_evenement INTEGER NOT NULL,
    FOREIGN KEY(id_tag) REFERENCES tag(id),
    FOREIGN KEY(id_evenement) REFERENCES evenement(id),
    UNIQUE(id_tag, id_evenement)
);

-- Traces numériques

CREATE TABLE utilisateur_netflix(
    id_utilisateur INTEGER PRIMARY KEY,
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id)
);

CREATE TABLE film(
    id SERIAL PRIMARY KEY,
    nom TEXT UNIQUE NOT NULL
);

CREATE TABLE film_note(
    id SERIAL PRIMARY KEY,
    id_film INTEGER NOT NULL,
    id_utilisateur_netflix INTEGER NOT NULL,
    note INTEGER NOT NULL,
    FOREIGN KEY(id_film) REFERENCES film(id),
    FOREIGN KEY(id_utilisateur_netflix) REFERENCES utilisateur_netflix(id_utilisateur)
);

CREATE TABLE utilisateur_spotify(
    id_utilisateur INTEGER PRIMARY KEY,
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id)
);

CREATE TABLE musique(
    id SERIAL PRIMARY KEY,
    nom TEXT UNIQUE NOT NULL
);

CREATE TABLE musique_ecoute(
    id SERIAL PRIMARY KEY,
    id_musique INTEGER NOT NULL,
    id_utilisateur_spotify INTEGER NOT NULL,
    ecoute INTEGER NOT NULL,
    FOREIGN KEY(id_musique) REFERENCES musique(id),
    FOREIGN KEY(id_utilisateur_spotify) REFERENCES utilisateur_spotify(id_utilisateur)
);

CREATE TABLE genre(
    id SERIAL PRIMARY KEY,
    nom TEXT UNIQUE NOT NULL
);

CREATE TABLE genre_film(
    id SERIAL PRIMARY KEY,
    id_genre INTEGER NOT NULL,
    id_film INTEGER NOT NULL,
    FOREIGN KEY(id_genre) REFERENCES genre(id),
    FOREIGN KEY(id_film) REFERENCES film(id)
);

CREATE TABLE genre_musique(
    id SERIAL PRIMARY KEY,
    id_musique INTEGER NOT NULL,
    id_film INTEGER NOT NULL,
    FOREIGN KEY(id_musique) REFERENCES musique(id),
    FOREIGN KEY(id_film) REFERENCES film(id)
);

