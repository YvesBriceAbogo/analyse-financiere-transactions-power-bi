# Guide d'installation

## Prérequis

- Power BI Desktop (version Windows, dernière version recommandée)
- Les trois fichiers du dépôt : `power-bi/analyse-financiere-transactions.pbix`, `data/finance_transactions.csv` et `data/customers.csv`

## Étape 1 : télécharger les fichiers

1. Sur la page du dépôt, cliquez sur **Code**, puis **Download ZIP**.
2. Décompressez l'archive sur votre poste.

Pour un seul fichier, ouvrez-le sur GitHub, puis cliquez sur l'icône de téléchargement (*Download raw file*).

## Étape 2 : placer les données

Le rapport est livré avec des chemins neutres :

```text
C:\Data\analyse-financiere\finance_transactions.csv
C:\Data\analyse-financiere\customers.csv
```

Deux possibilités :

- créer le dossier `C:\Data\analyse-financiere\` et y copier les deux CSV (aucune modification du rapport n'est alors nécessaire) ;
- conserver les fichiers où vous voulez et adapter les paramètres (étape 3).

## Étape 3 : adapter les paramètres (si besoin)

1. Ouvrez le fichier `.pbix` dans Power BI Desktop.
2. Cliquez sur **Accueil**, puis **Transformer les données**, puis **Modifier les paramètres**.
3. Renseignez :
   - `PathFinance` : chemin complet de `finance_transactions.csv`
   - `PathCustomers` : chemin complet de `customers.csv`
4. Cliquez sur **OK**, puis **Appliquer les modifications**.

## Étape 4 : contrôler le chargement

Sélectionnez l'année **2026** et la mesure **Total Amount**. Vous devez obtenir :

| Indicateur 2026 | Valeur attendue |
|---|---:|
| Total Amount | 45 324 113,77 (45,32M) |
| Total Transactions | 4,99K |
| Avg Transaction val | 9,08K |
| Total Fees | 75 413,00 (75,41K) |
| Total Tax | 13 574,28 (13,57K) |

Sur toutes les années : 50 000 transactions, 725 914,91 de frais et 130 736,35 de taxes.

## Problèmes fréquents

| Message ou symptôme | Cause probable | Solution |
|---|---|---|
| *Impossible de trouver le fichier* | Chemin des paramètres incorrect | Corriger `PathFinance` et `PathCustomers` |
| Dates erronées ou en erreur | CSV réenregistré avec Excel | Reprendre les CSV originaux du dépôt |
| Caractères accentués altérés | Encodage modifié | Conserver l'encodage Windows-1252 d'origine |
| Visuels vides après chargement | Modifications non appliquées | Cliquer sur **Fermer et appliquer** |

## Utiliser les scripts Power Query seuls

Voir `../power-query/README.md`.
