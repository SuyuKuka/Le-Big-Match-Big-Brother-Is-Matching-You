\echo "Requête 1 : Requête avec jointure"
\echo "Description : Tous les suggestions de l'utilisateur ayant le type d'interaction spécifié."
DEALLOCATE suggestions_par_utilisateur_et_type;
PREPARE suggestions_par_utilisateur_et_type(VARCHAR, VARCHAR) AS
SELECT DISTINCT suggestion_evenement.id, e.titre, e.date_debut, e.date_fin, e.organisateur, e.prix
FROM utilisateur
JOIN suggestion_evenement 
    ON utilisateur.id = suggestion_evenement.id_utilisateur
JOIN evenement AS e
    ON suggestion_evenement.id_evenement = e.id
WHERE UPPER(utilisateur.pseudo) = UPPER($1)
  AND suggestion_evenement.type_interaction = UPPER($2)::TYPE_INTERACTION;
EXECUTE suggestions_par_utilisateur_et_type('CyberNomad', 'interesser');