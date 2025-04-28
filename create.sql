DROP TABLE IF EXISTS utilisateur CASCADE;
DROP TABLE IF EXISTS formulaire_physique CASCADE;
DROP TABLE IF EXISTS formulaire_personnel CASCADE;
DROP TABLE IF EXISTS formulaire_residence CASCADE;
DROP TABLE IF EXISTS formulaire_sexualite CASCADE;
DROP TYPE IF EXISTS type_abonnement CASCADE;
DROP TABLE IF EXISTS abonne CASCADE;
DROP TABLE IF EXISTS match CASCADE;
DROP TABLE IF EXISTS message CASCADE;
DROP TYPE IF EXISTS type_interaction CASCADE;
DROP TABLE IF EXISTS interaction CASCADE;
DROP TABLE IF EXISTS evenement CASCADE;
DROP TABLE IF EXISTS tagguer CASCADE;
DROP TABLE IF EXISTS lieu CASCADE;
DROP TABLE IF EXISTS tag CASCADE;
DROP TABLE IF EXISTS sous_categorie_tag CASCADE;
DROP TABLE IF EXISTS categorie_tag CASCADE;
DROP TYPE IF EXISTS type_utilisateur_evenement CASCADE;
DROP TABLE IF EXISTS utilisateur_evenement CASCADE;

-- Utilisateurs

CREATE TABLE utilisateur(
    id SERIAL PRIMARY KEY,
    pseudo VARCHAR(32) NOT NULL,
    age INT NOT NULL CHECK (age > 17)
);

-- Formulaires à l'inscription

CREATE TABLE formulaire(
    id_formulaire SERIAL PRIMARY KEY
);

CREATE TABLE formulaire_physique(
    id_formulaire INTEGER NOT NULL,
    taille INT NOT NULL,
    poids INT NOT NULL,
    couleur_yeux VARCHAR(32) NOT NULL,
    couleur_cheveux VARCHAR(32) NOT NULL,
    couleur_peau VARCHAR(32) NOT NULL,
    FOREIGN KEY (id_formulaire) REFERENCES formulaire(id_formulaire)
);

CREATE TABLE formulaire_personnel(
    id_formulaire INTEGER NOT NULL,
    prenom VARCHAR(64) NOT NULL,
    nom VARCHAR(64) NOT NULL,
    photo_url VARCHAR(64) NOT NULL,
    email VARCHAR(64) NOT NULL,
    telephone VARCHAR(16) NOT NULL,
    FOREIGN KEY (id_formulaire) REFERENCES formulaire(id_formulaire)
);

CREATE TABLE formulaire_residence(
    id_formulaire INTEGER NOT NULL,
    ville VARCHAR(64) NOT NULL,
    pays VARCHAR(64) NOT NULL,
    FOREIGN KEY (id_formulaire) REFERENCES formulaire(id_formulaire)
);

CREATE TABLE formulaire_sexualite(
    id_formulaire INTEGER NOT NULL,
    genre VARCHAR(64) NOT NULL,
    orientation_sexuel VARCHAR(64) NOT NULL,
    FOREIGN KEY (id_formulaire) REFERENCES formulaire(id_formulaire)
);

CREATE TABLE inscription(
    id_utilisateur INT NOT NULL,
    id_formulaire INT NOT NULL,
    PRIMARY KEY (id_utilisateur, id_formulaire),
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY (id_formulaire) REFERENCES formulaire(id_formulaire)
);

-- Abonnement utilisateur

CREATE TYPE type_abonnement AS ENUM ('ARGENT', 'OR', 'DIAMANT');

CREATE TABLE abonne(
    id_utilisateur INTEGER UNIQUE NOT NULL,
    type_abonnement type_abonnement NOT NULL,
    debut DATE NOT NULL,
    fin DATE NOT NULL,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id)
);

-- Match, chat et intéraction

-- Match je sais pas trop
CREATE TABLE match(
    id_match SERIAL PRIMARY KEY,
    id_utilisateur1 INTEGER NOT NULL,
    id_utilisateur2 INTEGER NOT NULL,
    FOREIGN KEY (id_utilisateur1) REFERENCES utilisateur(id),
    FOREIGN KEY (id_utilisateur2) REFERENCES utilisateur(id),
    UNIQUE(id_utilisateur1, id_utilisateur2),
    CHECK(id_utilisateur1 < id_utilisateur2)
);

CREATE TABLE historique_match(
    id_match INTEGER NOT NULL,
    id_utilisateur INTEGER NOT NULL,
    PRIMARY KEY(id_match, id_utilisateur),
    FOREIGN KEY (id_match) REFERENCES match(id_match),
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id)
);

-- Match terminé et en cours??

CREATE TABLE chat(
    id_chat SERIAL,
    id_match INTEGER NOT NULL,
    PRIMARY KEY(id_chat, id_match),
    FOREIGN KEY (id_match) REFERENCES match(id_match),
    UNIQUE(id_match)
);

CREATE TABLE message(
    id_message SERIAL PRIMARY KEY,
    id_chat INTEGER NOT NULL,
    contenu TEXT NOT NULL,
    date TIMESTAMP NOT NULL,
    FOREIGN KEY (id_chat) REFERENCES chat(id_chat)
);

CREATE TYPE type_interaction AS ENUM ('LIKE', 'NOPE');

CREATE TABLE suggestion_utilisateur(
    id_utilisateur_source INTEGER NOT NULL,
    id_utilisateur_cible INTEGER NOT NULL,
    type_interaction type_interaction NOT NULL,
    PRIMARY KEY(id_utilisateur_source, id_utilisateur_cible),
    FOREIGN KEY (id_utilisateur_source) REFERENCES utilisateur(id),
    FOREIGN KEY (id_utilisateur_cible) REFERENCES utilisateur(id)
);

-- Evenements

-- l'organisateur peut être le pseudo d'un utilisateur ou le nom d'une entité extérieure à l'application

CREATE TABLE lieu(
    id SERIAL PRIMARY KEY,
    adresse TEXT NOT NULL,
    code_postal TEXT NOT NULL,
    pays TEXT NOT NULL,
    UNIQUE (adresse, code_postal, pays)
);

CREATE TABLE evenement(
    id SERIAL PRIMARY KEY,
    id_lieu INTEGER NOT NULL,
    titre TEXT NOT NULL,
    description TEXT NOT NULL,
    date timestamp NOT NULL,
    organisateur TEXT NOT NULL,
    prix INTEGER NOT NULL,
    FOREIGN KEY (id_lieu) REFERENCES lieu(id)
);

CREATE TABLE historique_evenement(
    id_utilisateur INTEGER NOT NULL,
    id_evenement INTEGER NOT NULL,
    PRIMARY KEY(id_utilisateur, id_evenement),
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY (id_evenement) REFERENCES evenement(id)
);

CREATE TABLE suggestion_evenement(
    id_utilisateur INTEGER NOT NULL,
    id_evenement INTEGER NOT NULL,
    PRIMARY KEY(id_utilisateur, id_evenement),
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY (id_evenement) REFERENCES evenement(id)
);

-- Evenement terminé et futur??

CREATE TYPE type_utilisateur_evenement AS ENUM ('Intéresser', 'Participer', 'Annoncer');

CREATE TABLE utilisateur_evenement(
    id_utilisateur INTEGER NOT NULL,
    id_evenement INTEGER NOT NULL,
    type_utilisateur_evenement type_utilisateur_evenement NOT NULL,
    PRIMARY KEY(id_utilisateur, id_evenement),
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY (id_evenement) REFERENCES evenement(id)
);

-- Tags

CREATE TABLE categorie_tag(
    id SERIAL PRIMARY KEY,
    nom VARCHAR(24) UNIQUE NOT NULL
);

CREATE TABLE sous_categorie_tag(
    id SERIAL PRIMARY KEY,
    nom VARCHAR(24) UNIQUE NOT NULL,
    id_categorie INTEGER NOT NULL,
    FOREIGN KEY (id_categorie) REFERENCES categorie_tag(id)
);

CREATE TABLE tag(
    id SERIAL PRIMARY KEY,
    id_sous_categorie INTEGER NOT NULL,
    nom VARCHAR(24) NOT NULL,
    FOREIGN KEY (id_sous_categorie) REFERENCES sous_categorie_tag(id),
    UNIQUE(id_sous_categorie, nom)
);

-- Probleme evenement et utilisateur peuvent etre nuls
CREATE TABLE tagguer(
    id_evenement INTEGER,
    id_utilisateur INTEGER,
    id_tag INTEGER NOT NULL,
    FOREIGN KEY (id_evenement) REFERENCES evenement(id),
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY (id_tag) REFERENCES tag(id),
    UNIQUE(id_evenement, id_tag)
);

-- Application 1 : Netflix

-- Application 2 : ???