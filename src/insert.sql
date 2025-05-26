-- Truncate

TRUNCATE TABLE utilisateur CASCADE;

TRUNCATE TABLE formulaire_personnel CASCADE;
TRUNCATE TABLE formulaire_residence CASCADE;
TRUNCATE TABLE formulaire_sexualite CASCADE;
TRUNCATE TABLE formulaire_physique CASCADE;

TRUNCATE TABLE abonne CASCADE;
TRUNCATE TABLE match CASCADE;
TRUNCATE TABLE chat CASCADE;
TRUNCATE TABLE message CASCADE;

TRUNCATE TABLE lieu CASCADE;
TRUNCATE TABLE evenement CASCADE;
TRUNCATE TABLE lieu_evenement CASCADE;
TRUNCATE TABLE suggestion_evenement CASCADE;

TRUNCATE TABLE tag CASCADE;
TRUNCATE TABLE sous_categorie CASCADE;
TRUNCATE TABLE categorie CASCADE;
TRUNCATE TABLE tag_lieu CASCADE;
TRUNCATE TABLE tag_utilisateur CASCADE;
TRUNCATE TABLE tag_evenement CASCADE;

TRUNCATE TABLE utilisateur_netflix CASCADE;
TRUNCATE TABLE film CASCADE;
TRUNCATE TABLE film_note CASCADE;

TRUNCATE TABLE utilisateur_spotify CASCADE;
TRUNCATE TABLE musique CASCADE;
TRUNCATE TABLE musique_ecoute CASCADE;

TRUNCATE TABLE genre CASCADE;
TRUNCATE TABLE genre_film CASCADE;
TRUNCATE TABLE genre_musique CASCADE;

-- Utilisateurs

\copy utilisateur FROM 'data/utilisateur/utilisateur.csv' WITH (FORMAT csv, HEADER);

-- Formulaires

\copy formulaire_personnel FROM 'data/formulaire/formulaire_personnel.csv' WITH (FORMAT csv, HEADER);
\copy formulaire_residence FROM 'data/formulaire/formulaire_residence.csv' WITH (FORMAT csv, HEADER);
\copy formulaire_sexualite FROM 'data/formulaire/formulaire_sexualite.csv' WITH (FORMAT csv, HEADER);
\copy formulaire_physique FROM 'data/formulaire/formulaire_physique.csv' WITH (FORMAT csv, HEADER);

-- Abonne

\copy abonne FROM 'data/utilisateur/abonne.csv' WITH (FORMAT csv, HEADER);

-- Match

\copy match FROM 'data/match/match.csv' WITH (FORMAT csv, HEADER);
\copy chat FROM 'data/match/chat.csv' WITH (FORMAT csv, HEADER);
\copy message FROM 'data/match/message.csv' WITH (FORMAT csv, HEADER);

-- Evenement

\copy lieu FROM 'data/evenement/lieu.csv' WITH (FORMAT csv, HEADER);
\copy evenement FROM 'data/evenement/evenement.csv' WITH (FORMAT csv, HEADER);
\copy lieu_evenement FROM 'data/evenement/lieu_evenement.csv' WITH (FORMAT csv, HEADER);
\copy suggestion_evenement FROM 'data/evenement/suggestion_evenement.csv' WITH (FORMAT csv, HEADER);

-- Tag

\copy categorie FROM 'data/tag/categorie.csv' WITH (FORMAT csv, HEADER);
\copy sous_categorie FROM 'data/tag/sous_categorie.csv' WITH (FORMAT csv, HEADER);
\copy tag FROM 'data/tag/tag.csv' WITH (FORMAT csv, HEADER);
\copy tag_lieu FROM 'data/tag/tag_lieu.csv' WITH (FORMAT csv, HEADER);
\copy tag_utilisateur FROM 'data/tag/tag_utilisateur.csv' WITH (FORMAT csv, HEADER);
\copy tag_evenement FROM 'data/tag/tag_evenement.csv' WITH (FORMAT csv, HEADER);

-- Netflix

\copy utilisateur_netflix FROM 'data/netflix/utilisateur_netflix.csv' WITH (FORMAT csv, HEADER);
\copy film FROM 'data/netflix/film.csv' WITH (FORMAT csv, HEADER);
\copy film_note FROM 'data/netflix/film_note.csv' WITH (FORMAT csv, HEADER);

-- Spotify

\copy utilisateur_spotify FROM 'data/spotify/utilisateur_spotify.csv' WITH (FORMAT csv, HEADER);
\copy musique FROM 'data/spotify/musique.csv' WITH (FORMAT csv, HEADER);
\copy musique_ecoute FROM 'data/spotify/musique_ecoute.csv' WITH (FORMAT csv, HEADER);

-- Traces numériques

\copy genre FROM 'data/trace_numerique/genre.csv' WITH (FORMAT csv, HEADER);
\copy genre_film FROM 'data/trace_numerique/genre_film.csv' WITH (FORMAT csv, HEADER);
\copy genre_musique FROM 'data/trace_numerique/genre_musique.csv' WITH (FORMAT csv, HEADER);
