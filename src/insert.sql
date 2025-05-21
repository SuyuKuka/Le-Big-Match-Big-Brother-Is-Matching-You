-- Utilisateurs

\copy utilisateur FROM 'data/utilisateur.csv' WITH (FORMAT csv, HEADER);

-- Formulaires

\copy formulaire FROM 'data/formulaire.csv' WITH (FORMAT csv, HEADER);
\copy formulaire_personnel FROM 'data/formulaire_personnel.csv' WITH (FORMAT csv, HEADER);
\copy formulaire_residence FROM 'data/formulaire_residence.csv' WITH (FORMAT csv, HEADER);
\copy formulaire_sexualite FROM 'data/formulaire_sexualite.csv' WITH (FORMAT csv, HEADER);
\copy formulaire_physique FROM 'data/formulaire_physique.csv' WITH (FORMAT csv, HEADER);

-- Abonne

\copy abonne FROM 'data/abonne.csv' WITH (FORMAT csv, HEADER);

-- Match

\copy match FROM 'data/match.csv' WITH (FORMAT csv, HEADER);
\copy chat FROM 'data/chat.csv' WITH (FORMAT csv, HEADER);
\copy message FROM 'data/message.csv' WITH (FORMAT csv, HEADER);

-- Evenement

\copy evenement FROM 'data/evenement.csv' WITH (FORMAT csv, HEADER);
\copy suggestion_evenement FROM 'data/suggestion_evenement.csv' WITH (FORMAT csv, HEADER);

-- Tag

\copy tag FROM 'data/tag.csv' WITH (FORMAT csv, HEADER);
\copy utilisateur_tag FROM 'data/utilisateur_tag.csv' WITH (FORMAT csv, HEADER);
\copy evenement_tag FROM 'data/evenement_tag.csv' WITH (FORMAT csv, HEADER);
\copy lieu FROM 'data/lieu.csv' WITH (FORMAT csv, HEADER);
\copy categorie FROM 'data/categorie.csv' WITH (FORMAT csv, HEADER);
\copy sous_categorie FROM 'data/sous_categorie.csv' WITH (FORMAT csv, HEADER);
\copy mot_clef FROM 'data/mot_clef.csv' WITH (FORMAT csv, HEADER);

-- Traces numériques

\copy traces_numeriques FROM 'data/traces_numeriques.csv' WITH (FORMAT csv, HEADER);
\copy spotify FROM 'data/spotify.csv' WITH (FORMAT csv, HEADER);
\copy netflix FROM 'data/netflix.csv' WITH (FORMAT csv, HEADER);
\copy oeuvre_vue FROM 'data/oeuvre_vue.csv' WITH (FORMAT csv, HEADER);
\copy artiste_prefere FROM 'data/artiste_prefere.csv' WITH (FORMAT csv, HEADER);
\copy genre FROM 'data/genre.csv' WITH (FORMAT csv, HEADER);
\copy genre_oeuvre_vue FROM 'data/genre_oeuvre_vue.csv' WITH (FORMAT csv, HEADER);