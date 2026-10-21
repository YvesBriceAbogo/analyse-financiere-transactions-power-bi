# Requêtes Power Query (langage M)

Ce dossier contient les scripts de transformation des données, dans une version documentée et optimisée.

| Fichier | Table produite | Source |
|---|---|---|
| `finance_transactions.m` | `finance_transactions` | `PathFinance` |
| `customers.m` | `customers` | `PathCustomers` |

## Paramètres requis

Avant d'utiliser ces scripts, créez dans Power BI Desktop deux paramètres de type Texte :

- `PathFinance` : chemin complet du fichier `finance_transactions.csv`
- `PathCustomers` : chemin complet du fichier `customers.csv`

## Utilisation d'un script

1. Dans Power BI Desktop, cliquez sur **Accueil**, puis **Transformer les données**.
2. Créez une requête vide : **Nouvelle source**, puis **Requête vide**.
3. Ouvrez **Accueil**, puis **Éditeur avancé**.
4. Remplacez le contenu par celui du fichier `.m` correspondant.
5. Nommez la requête `finance_transactions` ou `customers`, puis cliquez sur **Fermer et appliquer**.

## Règles de transformation

| Règle | Détail |
|---|---|
| Import | CSV, séparateur virgule, encodage Windows-1252 |
| Doublons | Suppression sur `transaction_id` (transactions) et `customer_id` (clients), **avant** toute conversion de type. Pour les transactions, la ligne la plus complète est conservée. |
| Typage | Dates lues avec le format explicite `dd-MM-yyyy`, nombres avec la culture `en-US` (point décimal) : aucune dépendance aux paramètres régionaux du poste |
| Texte | Suppression des espaces superflus ; devise en majuscules |
| Nom complet | Fusion de `fisrt_name` et `second_name` dans `Customer_name` |

## Traitement des frais manquants

Les frais absents du fichier source ne sont **pas imputés** : `fee_amount` reste vide. Les totaux de frais ne portent donc que sur les frais renseignés.

La colonne `is_fee_missing` (vrai/faux) identifie ces transactions. Elles sont très peu nombreuses (moins de 0,1 % des transactions), et leur effet sur le total des frais est négligeable.

**Constat :** sur les 28 111 transactions dont les frais dépassent 1, la taxe représente exactement 18 % des frais (arrondi au centime). Cette relation permettrait de reconstituer les frais manquants. Elle n'est volontairement pas appliquée, afin de ne pas introduire dans les totaux de valeur absente de la source.

## Traitement des montants

| Colonne | Contenu |
|---|---|
| `amount` | Montant d'origine, **avec son signe**, tel que présent dans le fichier source |
| `amount_abs` | Valeur absolue du montant, utilisée par les mesures du rapport |

**Constat :** moins de 0,1 % des transactions présentent un montant négatif. Ces montants sont répartis sur plusieurs types d'opérations, y compris des types qui ne sont pas des sorties de fonds par nature, comme les dépôts. Le signe ne correspond donc pas à un sens d'opération fiable. Il est traité comme une **anomalie de saisie probable**.

**Hypothèse retenue :** les mesures reposent sur `amount_abs`. Le montant d'origine est conservé afin de permettre le contrôle de ces lignes.

## Doublons

Le fichier source contient 69 identifiants de transaction en double. Pour chacun, une seule ligne est conservée : la plus complète, c'est-à-dire celle qui compte le moins de champs vides.

## Format des fichiers source

Les fichiers CSV utilisent le point comme séparateur décimal et des dates au format `JJ-MM-AAAA` (exemple : `21-02-2025`). Pour une source utilisant un autre format, modifiez les variables `CultureNombres` et `FormatDate` en tête de script.
