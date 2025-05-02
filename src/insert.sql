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
\copy suggestion_match FROM 'data/suggestion_match.csv' WITH (FORMAT csv, HEADER);
\copy "like" FROM 'data/like.csv' WITH (FORMAT csv, HEADER);
\copy nope FROM 'data/nope.csv' WITH (FORMAT csv, HEADER);
\copy historique_match FROM 'data/historique_match.csv' WITH (FORMAT csv, HEADER);
\copy chat FROM 'data/chat.csv' WITH (FORMAT csv, HEADER);
\copy message FROM 'data/message.csv' WITH (FORMAT csv, HEADER);

-- Evenement

