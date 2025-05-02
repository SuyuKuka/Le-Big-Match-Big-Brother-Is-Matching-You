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
DROP TABLE IF EXISTS "like" CASCADE;
DROP TABLE IF EXISTS nope CASCADE;
DROP TABLE IF EXISTS historique_match CASCADE;
DROP TABLE IF EXISTS chat CASCADE;
DROP TABLE IF EXISTS message CASCADE;
DROP TABLE IF EXISTS evenement CASCADE;
DROP TABLE IF EXISTS suggestion_evenement CASCADE;
DROP TABLE IF EXISTS interaction_suggestion_evenement CASCADE;
DROP TABLE IF EXISTS historique_evenement CASCADE;
DROP TABLE IF EXISTS tag CASCADE;
DROP TABLE IF EXISTS lieu CASCADE;
DROP TABLE IF EXISTS categorie CASCADE;
DROP TABLE IF EXISTS sous_categorie CASCADE;
DROP TABLE IF EXISTS mot_clef CASCADE;
DROP TABLE IF EXISTS traces_numeriques CASCADE;
DROP TABLE IF EXISTS spotify CASCADE;
DROP TABLE IF EXISTS netflix CASCADE;
DROP TABLE IF EXISTS oeuvre CASCADE;
DROP TABLE IF EXISTS artiste CASCADE;
DROP TABLE IF EXISTS genre CASCADE;
DROP TABLE IF EXISTS oeuvre_vue CASCADE;

-- Drop types

DROP TYPE IF EXISTS TYPE_ABONNEMENT;
DROP TYPE IF EXISTS STATUT_MATCH;
DROP TYPE IF EXISTS STATUT_EVENEMENT;
DROP TYPE IF EXISTS TYPE_INTERACTION;

-- Utilisateurs

CREATE TABLE utilisateur(
    id SERIAL PRIMARY KEY,
    pseudo VARCHAR(32) NOT NULL,
    age INT NOT NULL,
    CHECK(age > 17)
);

-- Formulaires à l'inscription

CREATE TABLE formulaire(
    id SERIAL PRIMARY KEY,
    id_utilisateur INTEGER NOT NULL,
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id)
);

CREATE TABLE formulaire_personnel(
    id_formulaire INTEGER NOT NULL,
    photo VARCHAR(64) NOT NULL,
    prenom VARCHAR(64) NOT NULL,
    email VARCHAR(64) NOT NULL,
    telephone VARCHAR(16) NOT NULL,
    FOREIGN KEY(id_formulaire) REFERENCES formulaire(id)
);

CREATE TABLE formulaire_residence(
    id_formulaire INTEGER NOT NULL,
    ville VARCHAR(64) NOT NULL,
    pays VARCHAR(64) NOT NULL,
    FOREIGN KEY(id_formulaire) REFERENCES formulaire(id)
);

CREATE TABLE formulaire_sexualite(
    id_formulaire INTEGER NOT NULL,
    genre VARCHAR(64) NOT NULL,
    orientation_sexuel VARCHAR(64) NOT NULL,
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
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id)
);

-- Match

CREATE TYPE STATUT_MATCH AS ENUM ('EN_COURS', 'TERMINE');

CREATE TABLE match (
    id SERIAL PRIMARY KEY,
    id_utilisateur_source INTEGER NOT NULL,
    id_utilisateur_cible INTEGER NOT NULL,
    statut STATUT_MATCH NOT NULL DEFAULT 'EN_COURS',
    FOREIGN KEY(id_utilisateur_source) REFERENCES utilisateur(id),
    FOREIGN KEY(id_utilisateur_cible) REFERENCES utilisateur(id),
    UNIQUE(id_utilisateur_source, id_utilisateur_cible),
    CHECK(id_utilisateur_source < id_utilisateur_cible)
);

CREATE TABLE suggestion_match(
    id SERIAL PRIMARY KEY,
    id_utilisateur INTEGER NOT NULL,
    id_utilisateur_cible INTEGER NOT NULL,
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY(id_utilisateur_cible) REFERENCES utilisateur(id),
    UNIQUE(id_utilisateur, id_utilisateur_cible),
    CHECK(id_utilisateur < id_utilisateur_cible)
);

CREATE TABLE "like"(
    id SERIAL PRIMARY KEY,
    id_utilisateur INTEGER NOT NULL,
    id_suggestion_match INTEGER NOT NULL,
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY(id_suggestion_match) REFERENCES suggestion_match(id),
    UNIQUE(id_utilisateur, id_suggestion_match)
);

CREATE TABLE nope(
    id SERIAL PRIMARY KEY,
    id_utilisateur INTEGER NOT NULL,
    id_suggestion_match INTEGER NOT NULL,
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY(id_suggestion_match) REFERENCES suggestion_match(id),
    UNIQUE(id_utilisateur, id_suggestion_match)
);

CREATE TABLE historique_match(
    id SERIAL PRIMARY KEY,
    id_match INTEGER NOT NULL,
    id_utilisateur INTEGER NOT NULL,
    FOREIGN KEY(id_match) REFERENCES match(id),
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id),
    UNIQUE(id_match, id_utilisateur)
);

CREATE TABLE chat(
    id SERIAL PRIMARY KEY,
    id_match INTEGER,
    id_historique_match INTEGER,
    FOREIGN KEY(id_match) REFERENCES match(id),
    FOREIGN KEY(id_historique_match) REFERENCES historique_match(id) ON DELETE CASCADE,
    UNIQUE(id_match, id_historique_match)
);

CREATE TABLE message(
    id SERIAL PRIMARY KEY,
    id_chat INTEGER NOT NULL,
    id_utilisateur_source INTEGER NOT NULL, -- Pour savoir qui a envoyé le message
    contenu TEXT NOT NULL,
    date TIMESTAMP NOT NULL,
    FOREIGN KEY(id_chat) REFERENCES chat(id) ON DELETE CASCADE
);

-- Evenements

CREATE TYPE STATUT_EVENEMENT AS ENUM ('TERMINE', 'EN_COURS', 'FUTUR');

CREATE TABLE evenement(
    id SERIAL PRIMARY KEY,
    titre TEXT NOT NULL,
    description TEXT NOT NULL,
    date timestamp NOT NULL,
    organisateur TEXT NOT NULL,
    prix INTEGER NOT NULL,
    statut STATUT_EVENEMENT NOT NULL,
    id_annonceur INTEGER,
    FOREIGN KEY(id_annonceur) REFERENCES utilisateur(id)
);

CREATE TABLE suggestion_evenement(
    id SERIAL PRIMARY KEY,
    id_utilisateur INTEGER NOT NULL,
    id_evenement INTEGER NOT NULL,
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY(id_evenement) REFERENCES evenement(id),
    UNIQUE(id_utilisateur, id_evenement)
);

CREATE TYPE TYPE_INTERACTION AS ENUM ('INTERESSER', 'PARTICIPER');

CREATE TABLE interaction_suggestion_evenement(
    id SERIAL PRIMARY KEY,
    id_suggestion_evenement INTEGER NOT NULL,
    id_utilisateur INTEGER NOT NULL,
    statut TYPE_INTERACTION NOT NULL,
    FOREIGN KEY(id_suggestion_evenement) REFERENCES suggestion_evenement(id),
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id),
    UNIQUE(id_suggestion_evenement, id_utilisateur)
);

CREATE TABLE historique_evenement(
    id SERIAL PRIMARY KEY,
    id_evenement INTEGER NOT NULL,
    id_utilisateur INTEGER NOT NULL,
    FOREIGN KEY(id_evenement) REFERENCES evenement(id),
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id),
    UNIQUE(id_evenement, id_utilisateur)
);

-- Tags

CREATE TABLE tag(
    id SERIAL PRIMARY KEY,
    id_utilisateur INTEGER,
    id_evenement INTEGER,
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY(id_evenement) REFERENCES evenement(id),
    UNIQUE(id_utilisateur, id_evenement),
    CHECK(id_utilisateur IS NOT NULL OR id_evenement IS NOT NULL)
);

CREATE TABLE lieu(
    id SERIAL PRIMARY KEY,
    id_tag INTEGER NOT NULL,
    nom TEXT,
    adresse TEXT NOT NULL,
    code_postal TEXT NOT NULL,
    pays TEXT NOT NULL,
    FOREIGN KEY(id_tag) REFERENCES tag(id),
    UNIQUE(adresse, code_postal, pays)
);

CREATE TABLE categorie(
    id SERIAL PRIMARY KEY,
    nom VARCHAR(24) UNIQUE NOT NULL,
    UNIQUE(nom)
);

CREATE TABLE sous_categorie(
    id SERIAL PRIMARY KEY,
    id_categorie INTEGER NOT NULL,
    nom VARCHAR(24) NOT NULL,
    FOREIGN KEY(id_categorie) REFERENCES categorie(id) ON DELETE CASCADE,
    UNIQUE(id_categorie, nom)
);

CREATE TABLE mot_clef(
    id SERIAL PRIMARY KEY,
    id_tag INTEGER NOT NULL,
    id_sous_categorie INTEGER NOT NULL,
    mot VARCHAR(24) NOT NULL,
    FOREIGN KEY(id_tag) REFERENCES tag(id),
    FOREIGN KEY(id_sous_categorie) REFERENCES sous_categorie(id) ON DELETE CASCADE,
    UNIQUE(mot)
);

-- Traces numérique

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

CREATE TABLE oeuvre(
    id SERIAL PRIMARY KEY,
    titre TEXT NOT NULL,
    id_traces_numeriques INTEGER NOT NULL,
    FOREIGN KEY(id_traces_numeriques) REFERENCES traces_numeriques(id)
);

CREATE TABLE artiste(
    id SERIAL PRIMARY KEY,
    id_oeuvre INTEGER NOT NULL,
    nom TEXT NOT NULL,
    FOREIGN KEY(id_oeuvre) REFERENCES oeuvre(id)
);

CREATE TABLE genre(
    id SERIAL PRIMARY KEY,
    id_oeuvre INTEGER NOT NULL,
    nom TEXT NOT NULL,
    FOREIGN KEY(id_oeuvre) REFERENCES oeuvre(id)
);

CREATE TABLE oeuvre_vue(
    id SERIAL PRIMARY KEY,
    id_utilisateur INTEGER NOT NULL,
    id_oeuvre INTEGER NOT NULL,
    id_suggestion_evenement INTEGER,
    FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY(id_oeuvre) REFERENCES oeuvre(id),
    FOREIGN KEY(id_suggestion_evenement) REFERENCES suggestion_evenement(id)
);
