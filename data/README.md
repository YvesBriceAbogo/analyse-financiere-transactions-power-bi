# Données du projet

Ce dossier contient les deux fichiers sources utilisés par le rapport Power BI.

| Fichier | Contenu | Colonnes | Taille approximative |
|---|---|---:|---:|
| `finance_transactions.csv` | Transactions financières | 15 | 5,5 Mo |
| `customers.csv` | Référentiel clients | 11 | 463 Ko |

## Origine des données

Jeu de données obtenu depuis une source publique en ligne. La source originale n'a pas pu être identifiée avec certitude, et la licence d'origine n'est pas confirmée.

Ces données sont publiées uniquement à des fins pédagogiques et de démonstration. Elles ne constituent pas nécessairement des opérations réelles, et aucune garantie d'exactitude n'est donnée.

> La licence MIT du dépôt s'applique au code et à la documentation. Elle **ne s'applique pas** aux fichiers de données.
> Si vous êtes titulaire de droits sur ces données et souhaitez leur retrait, merci de me contacter via GitHub ou LinkedIn.

## Format technique

| Paramètre | Valeur |
|---|---|
| Format | CSV |
| Séparateur de colonnes | Virgule (`,`) |
| Encodage | Windows-1252 (ANSI) |
| Séparateur décimal | Point (`.`) |
| Format des dates | `JJ-MM-AAAA` (exemple : `21-02-2025`) |
| En-têtes | Première ligne |

## Structure de `finance_transactions.csv`

| Colonne | Type après import |
|---|---|
| `transaction_id` | Texte |
| `transaction_date` | Date |
| `account_id` | Texte |
| `customer_id` | Texte |
| `transaction_type` | Texte |
| `channel` | Texte |
| `merchant_category` | Texte |
| `amount` | Nombre décimal |
| `fee_amount` | Nombre décimal |
| `tax_amount` | Nombre décimal |
| `currency` | Texte |
| `transaction_status` | Texte |
| `is_fraud` | Texte |
| `risk_score` | Nombre entier |
| `reference_no` | Texte |

## Structure de `customers.csv`

| Colonne | Type après import |
|---|---|
| `customer_id` | Texte |
| `fisrt_name` | Texte |
| `second_name` | Texte |
| `gender` | Texte |
| `date_of_birth` | Date |
| `city` | Texte |
| `state` | Texte |
| `occupation` | Texte |
| `customer_segment` | Texte |
| `annual_income` | Nombre décimal |
| `join_date` | Date |

> Le nom de colonne `fisrt_name` est conservé tel quel, avec la coquille présente dans le fichier source. Il est fusionné avec `second_name` dans la colonne `Customer_name` lors de la transformation Power Query.

## Utilisation dans Power BI Desktop

Le rapport utilise deux paramètres Power Query contenant des **chemins locaux** :

| Paramètre | Valeur à renseigner |
|---|---|
| `PathFinance` | Chemin complet vers `finance_transactions.csv` |
| `PathCustomers` | Chemin complet vers `customers.csv` |

Après téléchargement du dépôt, adaptez ces deux paramètres à votre poste. La procédure détaillée figure dans `documentation/guide-installation.md`.
