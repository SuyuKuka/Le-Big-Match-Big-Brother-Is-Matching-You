# Base de donnée projet

- create.sql : pose la structure des tables de la base de données
- insert.sql : ajoute des données fictives dans la base de données
- select.sql : teste des scénarios possibles par rapport aux données dans la base de données

# Mode d'emploi

```
psql -U username

\pset pager off

\cd src

\i src/create.sql
\i src/insert.sql
\i src/select.sql
```

## Membres
|  Nom  | Prénom | N° étudiant |
| :---: | :----: | :---------: |
| CHIV  | Henri  |  22205265   |
| CHEN  | Michel |  22202655   |
