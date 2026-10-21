# Dictionnaire de données

Ce document décrit les tables du modèle et leurs colonnes. Les valeurs citées en exemple sont celles observées dans les fichiers sources.

## Table `finance_transactions`

Table de faits : une ligne par transaction (50 000 transactions après dédoublonnage, du 1ᵉʳ janvier 2023 au 30 avril 2026).

| Colonne | Type | Description |
|---|---|---|
| `transaction_id` | Texte | Identifiant unique de la transaction (exemple : `T00000001`) |
| `transaction_date` | Date | Date de la transaction, lue au format `JJ-MM-AAAA` |
| `account_id` | Texte | Identifiant du compte (exemple : `A001795`) |
| `customer_id` | Texte | Identifiant du client, clé vers `customers` (exemple : `C00629`) |
| `transaction_type` | Texte | Nature de l'opération : Bill Payment, Card Payment, Deposit, Fee Charge, Interest Credit, Investment, Loan EMI, Refund, Transfer, Withdrawal |
| `channel` | Texte | Canal : Mobile App, UPI, Net Banking, Auto Debit, Branch, ATM, POS |
| `merchant_category` | Texte | Catégorie de dépense ou d'opération (exemples : Food, Groceries, Rent, Salary) |
| `amount` | Nombre décimal | Montant d'origine, avec son signe |
| `fee_amount` | Nombre décimal | Frais de l'opération ; vide lorsqu'absent du fichier source |
| `tax_amount` | Nombre décimal | Taxe associée aux frais |
| `currency` | Texte | Devise, en majuscules (`INR` dans les lignes examinées) |
| `transaction_status` | Texte | Statut : Success, Failed, Pending |
| `is_fraud` | Texte | Indicateur de fraude (`Yes` ou `No`) |
| `risk_score` | Nombre entier | Score de risque de la transaction |
| `reference_no` | Texte | Numéro de référence de l'opération |
| **`is_fee_missing`** | Logique | *Colonne ajoutée.* Vrai si les frais sont absents du fichier source |
| **`amount_abs`** | Nombre décimal | *Colonne ajoutée.* Valeur absolue de `amount`, utilisée par les mesures |

## Table `customers`

Table de dimension : une ligne par client.

| Colonne | Type | Description |
|---|---|---|
| `customer_id` | Texte | Identifiant unique du client (exemple : `C00001`) |
| `Customer_name` | Texte | *Colonne calculée.* Nom complet, fusion de `fisrt_name` et `second_name` |
| `gender` | Texte | Genre (Female, Male) |
| `date_of_birth` | Date | Date de naissance, lue au format `JJ-MM-AAAA` |
| `city` | Texte | Ville |
| `state` | Texte | État |
| `occupation` | Texte | Situation professionnelle (exemples : Salaried, Retired, Freelancer, Student) |
| `customer_segment` | Texte | Segment : Retail, Premium, SME, Corporate, Wealth |
| `annual_income` | Nombre décimal | Revenu annuel |
| `join_date` | Date | Date d'entrée en relation, lue au format `JJ-MM-AAAA` |

Les colonnes sources `fisrt_name` et `second_name` sont fusionnées dans `Customer_name`. La coquille `fisrt_name` provient du fichier d'origine.

## Table `Calendar Table`

| Colonne | Type | Description |
|---|---|---|
| `Date` | Date | Un jour par ligne, du 1ᵉʳ janvier 2023 au 30 avril 2026 |
| `Year` | Nombre entier | Année civile |
| `Month number` | Nombre entier | Numéro du mois (1 à 12), utilisé pour le tri |
| `Month` | Texte | Libellé abrégé du mois (Jan, Feb, Mar, Apr…) |

## Table `Dynamic Metric`

Table de paramètre de champs, sans relation avec les autres tables. Voir `dax/parametre-mesures-dynamiques.md`.

## Règles de gestion observées

| Règle | Constat |
|---|---|
| Taxe et frais | Sur les 28 111 lignes dont les frais dépassent 1, la taxe vaut exactement 18 % des frais (arrondi au centime) |
| Frais manquants | 23 transactions ; non imputées |
| Montants négatifs | 8 transactions ; traitées comme anomalie de saisie probable |
| Doublons | 69 identifiants présents en double dans la source ; une seule ligne conservée |
