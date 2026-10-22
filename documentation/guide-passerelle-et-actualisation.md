# Passerelle de données et actualisation

## Pourquoi une passerelle

Les données sont des fichiers CSV stockés sur un poste local. Power BI Service ne peut pas y accéder directement : une **passerelle de données locale** (*On-premises data gateway*), en mode standard, fait le lien entre le service cloud et ces fichiers.

```text
Fichiers CSV locaux
        |
        v
Passerelle de données locale (mode standard)
        |
        v
Modèle sémantique sur Power BI Service
        |
        v
Actualisation planifiée
```

## Configuration en place

| Élément | Valeur |
|---|---|
| Type de passerelle | Standard (*On-premises data gateway*) |
| Sources de données | 2 fichiers CSV (transactions et clients) |
| Fréquence d'actualisation | **2 fois par jour : 11 h 30 et 17 h 00** |
| Fuseau horaire | Heure d'Afrique du Sud (UTC+2) |

## Configurer l'actualisation planifiée

1. Dans Power BI Service, ouvrez l'espace de travail, puis le **modèle sémantique**.
2. Cliquez sur **Paramètres**, puis **Connexion à la passerelle**.
3. Sélectionnez la passerelle et vérifiez que les deux sources CSV sont **mappées**.
4. Dans **Actualisation**, activez **Maintenir vos données à jour**.
5. Ajoutez deux heures : **11:30** et **17:00**, en vérifiant que le fuseau horaire sélectionné est celui d'Afrique du Sud.
6. Enregistrez avec **Appliquer**.

## Conditions de fonctionnement

- Le poste hébergeant la passerelle doit être **allumé** et connecté à Internet aux heures prévues.
- Le service de la passerelle doit être démarré.
- Les chemins des CSV doivent être **identiques** à ceux de `PathFinance` et `PathCustomers` dans le modèle publié.
- Les identifiants configurés doivent donner accès aux fichiers.
- Après un changement de chemin, republier le rapport et refaire le mappage des sources.

## Suivi des actualisations

Dans **Paramètres du modèle sémantique**, ouvrez **Historique d'actualisation** pour contrôler les succès et les échecs. Une actualisation en échec conserve les données précédentes.

## Limite du compte

Un compte Pro autorise 8 actualisations planifiées par jour. La configuration retenue, soit 2 par jour, reste dans cette limite.
