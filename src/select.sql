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
\echo "Description : "

-- Requête 4 : 
\echo "Requête 4 : Sous-requête dans le FROM"
\echo "Description : "

-- Requête 5 :
\echo "Requête 5 : Sous-requête dans le WHERE"
\echo "Description : "

-- Requête 6 : 
\echo "Requête 6 : Deux agrégats nécessitant GROUP BY et HAVING"
\echo "Description : "

-- Requête 7 : 
\echo "Requête 7 : Requête impliquant le calcul de deux agrégats"
\echo "Description : "

-- Requête 8 : 
\echo "Requête 8 : Jointure externe (LEFT JOIN, RIGHT JOIN ou FULL JOIN)"
\echo "Description : "

-- Requête 9 : 
\echo "Requête 9 : 1. Requête équivalente exprimant une condition de totalité avec sous requêtes corrélées"
\echo "Description : "

-- Requête 10 : 
\echo "Requête 10 : 2. Requête équivalente exprimant une condition de totalité avec agrégation"
\echo "Description : "

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
\echo "Description : "

-- Requête 16 : 
\echo "Requête 16 : Requête utilisant du fenêtrage"
\echo "Description : "




