-- Requête 1 : 
\echo "Requête 1 : Requête qui porte sur au moins trois tables"
\echo "Description : Utilisateurs abonnés ayant au moins un match"
SELECT DISTINCT u.pseudo
FROM abonne a
JOIN utilisateur u ON a.id_utilisateur = u.id
JOIN chat c ON c.id_utilisateur1 = u.id OR c.id_utilisateur2 = u.id;

-- Requête 2 : 
\echo "Requête 2 : Auto jointure ou Jointure réflexive"
\echo "Description : "

-- Requête 3 : 
\echo "Requête 3 : Sous-requête corrélée"
\echo "Description : Utilisateurs qui n'ont pas encore répondu a une suggestion d'evenement (en attente)"
SELECT u.id, u.pseudo
FROM utilisateur u
WHERE EXISTS (
    SELECT 1
    FROM suggestion_evenement se
    WHERE se.id_utilisateur = u.id
        AND se.type_interaction = 'EN_ATTENTE'
);

-- Requête 4 : 
\echo "Requête 4 : Sous-requête dans le FROM"
\echo "Description : "

-- Requête 5 :
\echo "Requête 5 : Sous-requête dans le WHERE"
\echo "Description : Utilisateurs qui a au moins un tag de la sous-catégorie Sports"
SELECT u.id, u.pseudo
FROM utilisateur u
WHERE u.id IN (
    SELECT tu.id_utilisateur
    FROM tag_utilisateur tu
    WHERE tu.id_tag IN (
        SELECT t.id
        FROM tag t
        JOIN sous_categorie sc ON t.id_sous_categorie = sc.id
        WHERE sc.nom = 'Sports'
    )
);

-- Requête 6 : 
\echo "Requête 6 : Deux agrégats nécessitant GROUP BY et HAVING"
\echo "Description : "

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
\echo "Description : "

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
\echo "Description : "

-- Requête 12 : 
\echo "Requête 12 : 2. Requête non équivalente à cause de null"
\echo "Description : "

-- Requête 13 : 
\echo "Requête 13 : 1bis. Requête équivalente avec information incomplète"
\echo "Description : "

-- Requête 14 : 
\echo "Requête 14 : 2bis. Requête équivalente avec information incomplète"
\echo "Description : "

-- Requête 15 : 
\echo "Requête 15 : Requête récursive"
\echo "Description : Messages envoyés dans le chat 1 dans l'odre chronologique"
WITH RECURSIVE
    message_init AS (
        SELECT m.id, m.id_chat, m.id_utilisateur, m.contenu, m.date
        FROM message m
        WHERE m.id_chat = 1
        ORDER BY m.date ASC
        LIMIT 1
    ),

    message_heredite AS (
        SELECT * FROM message_init

        UNION ALL

        SELECT m2.id, m2.id_chat, m2.id_utilisateur, m2.contenu, m2.date
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
\echo "Description : "




