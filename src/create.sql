-- Database

DROP DATABASE IF EXISTS chen_chiv;
CREATE DATABASE chen_chiv;

\c chen_chiv

-- Drop tables

DROP TABLE IF EXISTS utilisateur CASCADE;
DROP TABLE IF EXISTS formulaire CASCADE;
DROP TABLE IF EXISTS formulaire_personnel CASCADE;
DROP TABLE IF EXISTS formulaire_residence CASCADE;
DROP TABLE IF EXISTS formulaire_sexualite CASCADE;
DROP TABLE IF EXISTS formulaire_physique CASCADE;
DROP TABLE IF EXISTS abonne CASCADE;
DROP TABLE IF EXISTS match CASCADE;
DROP TABLE IF EXISTS suggestion_match CASCADE;
DROP TABLE IF EXISTS chat CASCADE;
DROP TABLE IF EXISTS message CASCADE;
DROP TABLE IF EXISTS evenement CASCADE;
DROP TABLE IF EXISTS suggestion_evenement CASCADE;
DROP TABLE IF EXISTS tag CASCADE;
DROP TABLE IF EXISTS utilisateur_tag CASCADE;
DROP TABLE IF EXISTS evenement_tag CASCADE;
DROP TABLE IF EXISTS lieu CASCADE;
DROP TABLE IF EXISTS categorie CASCADE;
DROP TABLE IF EXISTS sous_categorie CASCADE;
DROP TABLE IF EXISTS mot_clef CASCADE;
DROP TABLE IF EXISTS traces_numeriques CASCADE;
DROP TABLE IF EXISTS spotify CASCADE;
DROP TABLE IF EXISTS netflix CASCADE;
DROP TABLE IF EXISTS oeuvre_vue CASCADE;
DROP TABLE IF EXISTS artiste_prefere CASCADE;
DROP TABLE IF EXISTS genre CASCADE;
DROP TABLE IF EXISTS genre_oeuvre_vue CASCADE;

-- Drop types

DROP TYPE IF EXISTS TYPE_ABONNEMENT;
DROP TYPE IF EXISTS STATUT_MATCH;
DROP TYPE IF EXISTS STATUT_EVENEMENT;
DROP TYPE IF EXISTS TYPE_INTERACTION;

-- Utilisateurs

CREATE TABLE utilisateur(
    id SERIAL PRIMARY KEY,
    pseudo VARCHAR(32) NOT NULL,
    mot_de_passe VARCHAR(64) NOT NULL
);

-- Formulaires

CREATE TABLE formulaire(
    id SERIAL PRIMARY KEY,
    id_utilisateur INTEGER NOT NULL,
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id)
);

CREATE TABLE formulaire_personnel(
    id_formulaire INTEGER NOT NULL,
    photo VARCHAR(64) NOT NULL,
    prenom VARCHAR(64) NOT NULL,
    age INT NOT NULL,
    email VARCHAR(64) NOT NULL,
    numero_de_telephone VARCHAR(16) NOT NULL,
    FOREIGN KEY(id_formulaire) REFERENCES formulaire(id),
    CHECK(age > 17)
);

CREATE TABLE formulaire_residence(
    id_formulaire INTEGER NOT NULL,
    pays VARCHAR(64) NOT NULL,
    ville VARCHAR(64) NOT NULL,
    FOREIGN KEY(id_formulaire) REFERENCES formulaire(id)
);

CREATE TABLE formulaire_sexualite(
    id_formulaire INTEGER NOT NULL,
    genre VARCHAR(64) NOT NULL,
    orientation_sexuelle VARCHAR(64) NOT NULL,
    FOREIGN KEY(id_formulaire) REFERENCES formulaire(id)
);

CREATE TABLE formulaire_physique(
    id_formulaire INTEGER NOT NULL,
    taille INT NOT NULL,
    poids INT NOT NULL,
    couleur_yeux VARCHAR(32) NOT NULL,
    couleur_cheveux VARCHAR(32) NOT NULL,
    FOREIGN KEY(id_formulaire) REFERENCES formulaire(id)
);

-- Abonnement utilisateur

CREATE TYPE TYPE_ABONNEMENT AS ENUM ('ARGENT', 'OR', 'DIAMANT');

CREATE TABLE abonne(
    id SERIAL PRIMARY KEY,
    id_utilisateur INTEGER UNIQUE NOT NULL,
    type_abonnement TYPE_ABONNEMENT NOT NULL,
    debut DATE NOT NULL,
    fin DATE NOT NULL,
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id),
    CHECK(debut < fin)
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
    CHECK(id_utilisateur1 < id_utilisateur2),
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
    id_chat INTEGER NOT NULL,
    id_utilisateur INTEGER NOT NULL,
    contenu TEXT NOT NULL,
    date TIMESTAMP NOT NULL,
    FOREIGN KEY(id_chat) REFERENCES chat(id) ON DELETE CASCADE,
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id)
);

-- Evenements

CREATE TYPE STATUT_EVENEMENT AS ENUM ('TERMINE', 'EN_COURS', 'FUTUR');

CREATE TABLE evenement(
    id SERIAL PRIMARY KEY,
    id_utilisateur_annonceur INTEGER NOT NULL,
    titre TEXT NOT NULL,
    description TEXT NOT NULL,
    date_debut timestamp NOT NULL,
    date_fin timestamp NOT NULL,
    organisateur TEXT NOT NULL,
    prix INTEGER NOT NULL,
    statut_evenement STATUT_EVENEMENT NOT NULL,
    FOREIGN KEY(id_utilisateur_annonceur) REFERENCES utilisateur(id)
);

CREATE TYPE TYPE_INTERACTION AS ENUM ('EN_ATTENTE', 'INTERESSER', 'PARTICIPER');

CREATE TABLE suggestion_evenement(
    id SERIAL PRIMARY KEY,
    id_utilisateur INTEGER NOT NULL,
    id_evenement INTEGER NOT NULL,
    type_interaction TYPE_INTERACTION NOT NULL,
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY(id_evenement) REFERENCES evenement(id),
    UNIQUE(id_utilisateur, id_evenement)
);

-- Tags

CREATE TABLE tag(
    id SERIAL PRIMARY KEY
);

CREATE TABLE utilisateur_tag(
    id SERIAL PRIMARY KEY,
    id_tag INTEGER NOT NULL,
    id_utilisateur INTEGER NOT NULL,
    FOREIGN KEY(id_tag) REFERENCES tag(id),
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id),
    UNIQUE(id_tag, id_utilisateur)
);

CREATE TABLE evenement_tag(
    id SERIAL PRIMARY KEY,
    id_tag INTEGER NOT NULL,
    id_evenement INTEGER NOT NULL,
    FOREIGN KEY(id_tag) REFERENCES tag(id),
    FOREIGN KEY(id_evenement) REFERENCES evenement(id),
    UNIQUE(id_tag, id_evenement)
);

CREATE TABLE lieu(
    id SERIAL PRIMARY KEY,
    id_tag INTEGER NOT NULL,
    adresse TEXT NOT NULL,
    code_postal TEXT NOT NULL,
    pays TEXT NOT NULL,
    FOREIGN KEY(id_tag) REFERENCES tag(id),
    UNIQUE(adresse)
);

CREATE TABLE categorie(
    id SERIAL PRIMARY KEY,
    nom VARCHAR(32) UNIQUE NOT NULL,
    UNIQUE(nom)
);

CREATE TABLE sous_categorie(
    id SERIAL PRIMARY KEY,
    id_categorie INTEGER NOT NULL,
    nom VARCHAR(32) NOT NULL,
    FOREIGN KEY(id_categorie) REFERENCES categorie(id) ON DELETE CASCADE,
    UNIQUE(id_categorie, nom)
);

CREATE TABLE mot_clef(
    id SERIAL PRIMARY KEY,
    id_tag INTEGER NOT NULL,
    id_sous_categorie INTEGER NOT NULL,
    mot VARCHAR(32) NOT NULL,
    FOREIGN KEY(id_tag) REFERENCES tag(id),
    FOREIGN KEY(id_sous_categorie) REFERENCES sous_categorie(id) ON DELETE CASCADE,
    UNIQUE(mot)
);

-- Traces numériques

CREATE TABLE traces_numeriques(
    id SERIAL PRIMARY KEY,
    id_utilisateur INTEGER NOT NULL,
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id)
);

CREATE TABLE spotify(
    id SERIAL PRIMARY KEY,
    id_traces_numeriques INTEGER NOT NULL,
    FOREIGN KEY(id_traces_numeriques) REFERENCES traces_numeriques(id),
    UNIQUE(id_traces_numeriques)
);

CREATE TABLE netflix(
    id SERIAL PRIMARY KEY,
    id_traces_numeriques INTEGER NOT NULL,
    FOREIGN KEY(id_traces_numeriques) REFERENCES traces_numeriques(id),
    UNIQUE(id_traces_numeriques)
);

CREATE TABLE oeuvre_vue(
    id SERIAL PRIMARY KEY,
    id_traces_numeriques INTEGER NOT NULL,
    titre TEXT NOT NULL,
    FOREIGN KEY(id_traces_numeriques) REFERENCES traces_numeriques(id)
);

CREATE TABLE artiste_prefere(
    id SERIAL PRIMARY KEY,
    id_traces_numeriques INTEGER NOT NULL,
    nom TEXT NOT NULL,
    nb_ecoutes INTEGER NOT NULL,
    FOREIGN KEY(id_traces_numeriques) REFERENCES traces_numeriques(id)
);

CREATE TABLE genre(
    id SERIAL PRIMARY KEY,
    nom TEXT NOT NULL,
    UNIQUE(nom)
);

CREATE TABLE genre_oeuvre_vue(
    id SERIAL PRIMARY KEY,
    id_oeuvre_vue INTEGER NOT NULL,
    id_genre INTEGER NOT NULL,
    FOREIGN KEY(id_oeuvre_vue) REFERENCES oeuvre_vue(id),
    FOREIGN KEY(id_genre) REFERENCES genre(id),
    UNIQUE(id_oeuvre_vue, id_genre)
);
