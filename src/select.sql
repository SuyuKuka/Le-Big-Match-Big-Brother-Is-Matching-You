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
\echo "Description : "

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
\echo "Description : "

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
\echo "Description : "

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
\echo "Description : "

-- Requête 10 : 
\echo "Requête 10 : 2. Requête équivalente exprimant une condition de totalité avec agrégation"
\echo "Description : "

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
\echo "Description : "

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




