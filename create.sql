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
DROP TABLE IF EXISTS interaction_match CASCADE;
DROP TABLE IF EXISTS historique_match CASCADE;
DROP TABLE IF EXISTS chat CASCADE;
DROP TABLE IF EXISTS message CASCADE;
DROP TABLE IF EXISTS evenement CASCADE;
DROP TABLE IF EXISTS suggestion_evenement CASCADE;
DROP TABLE IF EXISTS interaction_evenement CASCADE;
DROP TABLE IF EXISTS historique_evenement CASCADE;
DROP TABLE IF EXISTS lieu CASCADE;
DROP TABLE IF EXISTS categorie CASCADE;
DROP TABLE IF EXISTS sous_categorie CASCADE;
DROP TABLE IF EXISTS mot_clef CASCADE;
DROP TABLE IF EXISTS tag CASCADE;
DROP TABLE IF EXISTS tag_utilisateur CASCADE;
DROP TABLE IF EXISTS tag_evenement CASCADE;
DROP TABLE IF EXISTS oeuvre CASCADE;
DROP TABLE IF EXISTS artiste CASCADE;
DROP TABLE IF EXISTS genre CASCADE;
DROP TABLE IF EXISTS oeuvre_vue CASCADE;
DROP TABLE IF EXISTS traces_numeriques CASCADE;
DROP TABLE IF EXISTS spotify CASCADE;
DROP TABLE IF EXISTS netflix CASCADE;

-- Drop types

DROP TYPE IF EXISTS TYPE_ABONNEMENT;
DROP TYPE IF EXISTS STATUT_MATCH;
DROP TYPE IF EXISTS TYPE_INTERACTION_MATCH;
DROP TYPE IF EXISTS STATUT_EVENEMENT;
DROP TYPE IF EXISTS TYPE_INTERACTION_EVENEMENT;

-- Utilisateurs

CREATE TABLE utilisateur(
    id SERIAL PRIMARY KEY,
    pseudo VARCHAR(32) NOT NULL,
    age INT NOT NULL CHECK (age > 17)
);

-- Formulaires à l'inscription

CREATE TABLE formulaire(
    id SERIAL PRIMARY KEY,
    id_utilisateur INTEGER NOT NULL,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id)
);

CREATE TABLE formulaire_personnel(
    id_formulaire INTEGER NOT NULL,
    photo VARCHAR(64) NOT NULL,
    prenom VARCHAR(64) NOT NULL,
    email VARCHAR(64) NOT NULL,
    telephone VARCHAR(16) NOT NULL,
    FOREIGN KEY (id_formulaire) REFERENCES formulaire(id)
);

CREATE TABLE formulaire_residence(
    id_formulaire INTEGER NOT NULL,
    ville VARCHAR(64) NOT NULL,
    pays VARCHAR(64) NOT NULL,
    FOREIGN KEY (id_formulaire) REFERENCES formulaire(id)
);

CREATE TABLE formulaire_sexualite(
    id_formulaire INTEGER NOT NULL,
    genre VARCHAR(64) NOT NULL,
    orientation_sexuel VARCHAR(64) NOT NULL,
    FOREIGN KEY (id_formulaire) REFERENCES formulaire(id)
);

CREATE TABLE formulaire_physique(
    id_formulaire INTEGER NOT NULL,
    taille INT NOT NULL,
    poids INT NOT NULL,
    couleur_yeux VARCHAR(32) NOT NULL,
    couleur_cheveux VARCHAR(32) NOT NULL,
    FOREIGN KEY (id_formulaire) REFERENCES formulaire(id)
);

-- Abonnement utilisateur

CREATE TYPE TYPE_ABONNEMENT AS ENUM ('ARGENT', 'OR', 'DIAMANT');

CREATE TABLE abonne(
    id SERIAL PRIMARY KEY,
    id_utilisateur INTEGER UNIQUE NOT NULL,
    type_abonnement TYPE_ABONNEMENT NOT NULL,
    debut DATE NOT NULL,
    fin DATE NOT NULL,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id)
);

-- Match, chat, suggestion et interaction

CREATE TYPE STATUT_MATCH AS ENUM ('EN_ATTENTE', 'EN_COURS', 'TERMINE');

-- Si les deux utilisateurs se sont LIKE mutuellement, dans ce cas le statut est EN_COURS, sinon TERMINE de maniere automatique
CREATE TABLE match (
    id SERIAL PRIMARY KEY,
    id_interaction INTEGER NOT NULL,
    statut STATUT_MATCH NOT NULL DEFAULT 'EN_ATTENTE',
    FOREIGN KEY (id_interaction) REFERENCES interaction_match(id),
    UNIQUE (id_interaction)
);

CREATE TABLE suggestion_match(
    id SERIAL PRIMARY KEY,
    id_utilisateur INTEGER NOT NULL,
    id_utilisateur_cible INTEGER NOT NULL,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY (id_utilisateur_cible) REFERENCES utilisateur(id),
    UNIQUE (id_utilisateur, id_utilisateur_cible),
    CHECK(id_utilisateur < id_utilisateur_cible)
);

CREATE TYPE TYPE_INTERACTION_MATCH AS ENUM ('LIKE', 'NOPE');

CREATE TABLE interaction_match(
    id SERIAL PRIMARY KEY,
    id_suggestion_match INTEGER NOT NULL,
    type TYPE_INTERACTION_MATCH NOT NULL,
    actif BOOLEAN NOT NULL DEFAULT true, -- permet d'annuler l'interaction (seulement les abonnés)
    FOREIGN KEY (id_suggestion_match) REFERENCES suggestion_match(id)
);

CREATE TABLE historique_match(
    id SERIAL PRIMARY KEY,
    id_match INTEGER NOT NULL,
    id_utilisateur INTEGER NOT NULL,
    FOREIGN KEY (id_match) REFERENCES match(id),
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id),
    UNIQUE(id_match, id_utilisateur)
);

CREATE TABLE chat(
    id SERIAL PRIMARY KEY,
    id_match INTEGER NOT NULL,
    FOREIGN KEY (id_match) REFERENCES match(id),
    UNIQUE(id_match)
);

CREATE TABLE message(
    id SERIAL PRIMARY KEY,
    id_chat INTEGER NOT NULL,
    id_utilisateur_source INTEGER NOT NULL,
    contenu TEXT NOT NULL,
    date TIMESTAMP NOT NULL,
    FOREIGN KEY (id_chat) REFERENCES chat(id)
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
    FOREIGN KEY (id_annonceur) REFERENCES utilisateur(id),
);

CREATE TABLE suggestion_evenement(
    id SERIAL PRIMARY KEY,
    id_utilisateur INTEGER NOT NULL,
    id_evenement INTEGER NOT NULL,
    id_oeuvre_vu INTEGER NOT NULL,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY (id_evenement) REFERENCES evenement(id),
    FOREIGN KEY (id_oeuvre_vu) REFERENCES oeuvre_vue(id),
    UNIQUE(id_utilisateur, id_evenement, id_oeuvre_vu)
);

CREATE TYPE TYPE_INTERACTION_EVENEMENT AS ENUM ('Intéresser', 'Participer');

CREATE TABLE interaction_evenement(
    id SERIAL PRIMARY KEY,
    id_utilisateur INTEGER NOT NULL,
    id_evenement INTEGER NOT NULL,
    type_utilisateur_evenement TYPE_INTERACTION_EVENEMENT,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY (id_evenement) REFERENCES evenement(id),
    UNIQUE(id_utilisateur, id_evenement)
);

CREATE TABLE historique_evenement(
    id SERIAL PRIMARY KEY,
    id_evenement INTEGER NOT NULL,
    id_utilisateur INTEGER NOT NULL,
    FOREIGN KEY (id_evenement) REFERENCES evenement(id),
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id),
    UNIQUE(id_evenement, id_utilisateur)
);

-- Tags

CREATE TABLE lieu(
    id SERIAL PRIMARY KEY,
    nom TEXT,
    adresse TEXT NOT NULL,
    code_postal TEXT NOT NULL,
    pays TEXT NOT NULL,
    UNIQUE (adresse, code_postal, pays)
);

CREATE TABLE categorie(
    id SERIAL PRIMARY KEY,
    nom VARCHAR(24) UNIQUE NOT NULL
);

CREATE TABLE sous_categorie(
    id SERIAL PRIMARY KEY,
    id_categorie INTEGER NOT NULL,
    nom VARCHAR(24) NOT NULL,
    FOREIGN KEY (id_categorie) REFERENCES categorie(id),
    UNIQUE(id_categorie, nom)
);

CREATE TABLE mot_clef(
    id SERIAL PRIMARY KEY,
    id_sous_categorie INTEGER NOT NULL,
    mot VARCHAR(24) NOT NULL,
    FOREIGN KEY (id_sous_categorie) REFERENCES sous_categorie(id),
    UNIQUE(id_sous_categorie, mot)
);

CREATE TABLE tag(
    id SERIAL PRIMARY KEY,
    id_mot_clef INTEGER,
    id_lieu INTEGER,
    FOREIGN KEY (id_mot_clef) REFERENCES mot_clef(id),
    FOREIGN KEY (id_lieu) REFERENCES lieu(id),
    CHECK (
        (id_mot_clef IS NOT NULL AND id_lieu IS NULL) OR
        (id_mot_clef IS NULL AND id_lieu IS NOT NULL)
    )
);

CREATE TABLE tag_utilisateur (
    id_tag INTEGER NOT NULL,
    id_utilisateur INTEGER NOT NULL,
    FOREIGN KEY (id_tag) REFERENCES tag(id),
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id),
    PRIMARY KEY (id_tag, id_utilisateur)
);

CREATE TABLE tag_evenement (
    id_tag INTEGER NOT NULL,
    id_evenement INTEGER NOT NULL,
    FOREIGN KEY (id_tag) REFERENCES tag(id),
    FOREIGN KEY (id_evenement) REFERENCES evenement(id),
    PRIMARY KEY (id_tag, id_evenement)
);


-- Traces numérique

CREATE TABLE oeuvre(
    id SERIAL PRIMARY KEY,
    titre TEXT NOT NULL,
);

CREATE TABLE artiste(
    id SERIAL PRIMARY KEY,
    id_oeuvre INTEGER NOT NULL,
    nom TEXT NOT NULL,
    FOREIGN KEY (id_oeuvre) REFERENCES oeuvre(id)
);

CREATE TABLE genre(
    id SERIAL PRIMARY KEY,
    id_oeuvre INTEGER NOT NULL,
    nom TEXT NOT NULL,
    FOREIGN KEY (id_oeuvre) REFERENCES oeuvre(id)
);

CREATE TABLE oeuvre_vue(
    id SERIAL PRIMARY KEY,
    id_oeuvre INTEGER NOT NULL,
    id_suggestion_evenement INTEGER NOT NULL,
    FOREIGN KEY (id_oeuvre) REFERENCES oeuvre(id),
    FOREIGN KEY (id_suggestion_evenement) REFERENCES suggestion_evenement(id)
);

CREATE TABLE traces_numeriques(
    id SERIAL PRIMARY KEY,
    id_utilisateur INTEGER NOT NULL,
    id_oeuvre INTEGER NOT NULL,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY (id_oeuvre) REFERENCES oeuvre(id)
);

CREATE TABLE spotify(
    id SERIAL PRIMARY KEY,
    id_traces_numeriques INTEGER NOT NULL,
    FOREIGN KEY (id_traces_numeriques) REFERENCES traces_numeriques(id),
    UNIQUE (id_traces_numeriques)
);

CREATE TABLE netflix(
    id SERIAL PRIMARY KEY,
    id_traces_numeriques INTEGER NOT NULL,
    FOREIGN KEY (id_traces_numeriques) REFERENCES traces_numeriques(id),
    UNIQUE (id_traces_numeriques)
);
