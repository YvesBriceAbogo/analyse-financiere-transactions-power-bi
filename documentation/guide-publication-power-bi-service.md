# Guide de publication sur Power BI Service

## Principe

Le rapport est développé dans Power BI Desktop, puis publié dans un espace de travail Power BI Service, où il peut être consulté, partagé et actualisé.

## Étapes de publication

1. Dans Power BI Desktop, vérifiez que les paramètres `PathFinance` et `PathCustomers` pointent vers les fichiers **utilisés par la passerelle**.
2. Cliquez sur **Accueil**, puis **Publier**.
3. Connectez-vous avec votre compte Power BI.
4. Choisissez l'espace de travail de destination.
5. Si un rapport du même nom existe déjà, confirmez son **remplacement**.
6. Ouvrez le lien proposé pour contrôler le rapport.

## Après la publication

1. Dans Power BI Service, ouvrez le **modèle sémantique** (*semantic model*), puis **Paramètres**.
2. Vérifiez que la source de données est **liée à la passerelle** (voir `guide-passerelle-et-actualisation.md`).
3. Lancez une actualisation manuelle et contrôlez qu'elle réussit.
4. Comparez les indicateurs avec ceux de `guide-installation.md`.

## Deux versions du fichier

| Version | Chemins | Usage |
|---|---|---|
| Version Power BI Service | Chemins réels de la passerelle | Publication et actualisation |
| Version GitHub | Chemins neutres `C:\Data\analyse-financiere\` | Partage public ; **ne pas republier** |

La version GitHub ne doit jamais être publiée sur Power BI Service : elle écraserait la source de données de la passerelle.

## Partage

Le compte utilisé pour ce projet ne permet pas de partage public du rapport. L'accès interactif n'est donc pas disponible pour les visiteurs du dépôt. Le rapport est consultable via :

- l'export PDF : `../rapports/analyse-financiere-power-bi.pdf` ;
- les captures : `../images/` ;
- le fichier `.pbix`, ouvrable dans Power BI Desktop.
