-- Requête 1 : 
\echo "Requête 1 : Requête qui porte sur au moins trois tables"
\echo "Description : Utilisateurs abonnés ayant au moins un match"
SELECT DISTINCT u.pseudo
FROM abonne a
JOIN utilisateur u ON a.id_utilisateur = u.id
JOIN chat c ON c.id_utilisateur1 = u.id OR c.id_utilisateur2 = u.id;

-- Requête 2 : 
\echo "Requête 2 : Auto jointure ou Jointure réflexive"
\echo "Description : Tuples de 2 utilisateurs qui se sont likés mutuellement"
SELECT c.id AS id_chat, u1.pseudo AS Utilisateur_1, u2.pseudo AS Utilisateur_2
FROM chat c
JOIN utilisateur u1 ON c.id_utilisateur1 = u1.id
JOIN utilisateur u2 ON c.id_utilisateur2 = u2.id;

-- Requête 3 : 
\echo "Requête 3 : Sous-requête corrélée"
\echo "Description : Utilisateurs qui n'ont pas encore répondu a une suggestion d'evenement (en attente)"
SELECT id, pseudo
FROM utilisateur
WHERE id IN (
    SELECT id_utilisateur
    FROM suggestion_evenement
    WHERE type_interaction = 'EN_ATTENTE'
);

-- Requête 4 : 
\echo "Requête 4 : Sous-requête dans le FROM"
\echo "Description : Requête qui récupère tous les evènements qui ont été assigné au moins un lieu dont le pays est la France. Parmi ceux-là, récupère seulement les evènements qui n'ont pas encore commencé."
SELECT titre
FROM (
    SELECT *
    FROM evenement
    JOIN lieu_evenement l ON l.id_evenement = evenement.id
    JOIN lieu ON l.id_lieu = lieu.id
    WHERE UPPER(lieu.pays) = 'FRANCE'
) as requete
WHERE date_debut > NOW();

-- Requête 5 :
\echo "Requête 5 : Sous-requête dans le WHERE"
\echo "Description : Utilisateurs qui a au moins un tag de la sous-catégorie Sports"
SELECT id, pseudo
FROM utilisateur
WHERE id IN (
    SELECT tu.id_utilisateur
    FROM tag_utilisateur tu
    JOIN tag t ON tu.id_tag = t.id
    JOIN sous_categorie sc ON t.id_sous_categorie = sc.id
    WHERE sc.nom = 'Sports'
);

-- Requête 6 : 
\echo "Requête 6 : Deux agrégats nécessitant GROUP BY et HAVING"
\echo "Description : Les utilisateurs likés par 10% du nombre d'utilisateurs total. "
SELECT 
    u.pseudo,
    COUNT(m.id_utilisateur_source) AS likes_recus
FROM match m
JOIN utilisateur u ON u.id = m.id_utilisateur_cible
WHERE m.statut_match = 'LIKE'
GROUP BY u.id, u.pseudo
HAVING COUNT(m.id_utilisateur_source) >= (
    0.10 * (SELECT COUNT(*) FROM utilisateur)
);

-- Requête 7 : 
\echo "Requête 7 : Requête impliquant le calcul de deux agrégats"
\echo "Description : Total d'écoutes et maximum d'écoutes des utilisateurs qui ont au moins écouter deux musiques sur Spotify"
SELECT 
    me.id_utilisateur_spotify AS id_utilisateur,
    SUM(me.ecoute) AS total_ecoutes,
    MAX(me.ecoute) AS max_ecoutes
FROM musique_ecoute me
GROUP BY me.id_utilisateur_spotify
HAVING COUNT(*) >= 2;

-- Requête 8 : 
\echo "Requête 8 : Jointure externe (LEFT JOIN, RIGHT JOIN ou FULL JOIN)"
\echo "Description : Donne la liste des utilisateurs ainsi que leurs abonnements"
SELECT 
    u.id AS utilisateur_id, u.pseudo, a.id AS abonnement_id,
    a.type_abonnement, a.date_debut, a.date_fin
FROM utilisateur u
FULL JOIN abonne a ON u.id = a.id_utilisateur;

-- Requête 9 : 
\echo "Requête 9 : 1. Requête équivalente exprimant une condition de totalité avec sous requêtes corrélées"
\echo "Description : Utilisateurs qui s'est INTERESSER et PARTICIPER a tous les evenements"
SELECT u.pseudo
FROM utilisateur u
WHERE NOT EXISTS (
    SELECT 1
    FROM evenement e
    WHERE NOT EXISTS (
        SELECT 1
        FROM suggestion_evenement se
        WHERE se.id_utilisateur = u.id
          AND se.id_evenement = e.id
          AND se.type_interaction IN ('INTERESSER', 'PARTICIPER')
    )
);

-- Requête 10 : 
\echo "Requête 10 : 2. Requête équivalente exprimant une condition de totalité avec agrégation"
\echo "Description : Utilisateurs qui s'est INTERESSER et PARTICIPER a tous les evenements"
SELECT u.pseudo
FROM utilisateur u
JOIN suggestion_evenement se ON se.id_utilisateur = u.id
WHERE se.type_interaction IN ('INTERESSER', 'PARTICIPER')
GROUP BY u.id, u.pseudo
HAVING COUNT(DISTINCT se.id_evenement) = (
    SELECT COUNT(*) FROM evenement
);

-- Requête 11 : 
\echo "Requête 11 : 1. Requête non équivalente à cause de null"
\echo "Description : Evènements dont l'organisateur n'est pas Subway ou n'est pas défini"
SELECT id, titre
FROM evenement
WHERE UPPER(organisateur) != 'SUBWAY' OR organisateur IS NULL;

-- Requête 12 : 
\echo "Requête 12 : 2. Requête non équivalente à cause de null"
\echo "Description : Evènements dont l'organisateur n'est pas Subway ou n'est pas défini"
SELECT id, titre
FROM evenement
WHERE NOT UPPER(organisateur) = 'SUBWAY';

-- Requête 13 : 
\echo "Requête 13 : 1bis. Requête équivalente avec information incomplète"
\echo "Description : Evènements dont l'organisateur n'est pas Subway"
SELECT id, titre
FROM evenement
WHERE NOT (UPPER(organisateur) = 'SUBWAY');

-- Requête 14 : 
\echo "Requête 14 : 2bis. Requête équivalente avec information incomplète"
\echo "Description : Evènements dont l'organisateur est défini et n'est pas Subway"
SELECT id, titre
FROM evenement
WHERE organisateur IS NOT NULL AND UPPER(organisateur) != 'SUBWAY';

-- Requête 15 : 
\echo "Requête 15 : Requête récursive"
\echo "Description : Tous les messages envoyés dans le chat 1 dans l'ordre chronologique"
WITH RECURSIVE
    message_init AS (
        SELECT m.id, m.id_chat, m.id_utilisateur, m.date
        FROM message m
        WHERE m.id_chat = 1
        ORDER BY m.date ASC
        LIMIT 1
    ),

    message_heredite AS (
        SELECT * FROM message_init

        UNION ALL

        SELECT m2.id, m2.id_chat, m2.id_utilisateur, m2.date
        FROM message m2
        JOIN message_heredite mc ON m2.id_chat = mc.id_chat AND m2.date > mc.date
        WHERE NOT EXISTS (
            SELECT 1 FROM message m3
            WHERE m3.id_chat = m2.id_chat AND m3.date > mc.date AND m3.date < m2.date
        )
    )
SELECT * FROM message_heredite;

-- Requête 16 : 
\echo "Requête 16 : Requête utilisant du fenêtrage"
\echo "Description : Renvoie les 3 derniers messages de chaque utilisateur"
SELECT *
FROM (
    SELECT m.id, m.id_utilisateur, u.pseudo, m.id_chat, m.contenu, m.date,
        ROW_NUMBER() OVER (
            PARTITION BY m.id_utilisateur 
            ORDER BY m.date DESC
        ) AS rang_message
    FROM message m
    JOIN utilisateur u ON m.id_utilisateur = u.id
) sous
WHERE rang_message <= 3
ORDER BY id_utilisateur, rang_message;
