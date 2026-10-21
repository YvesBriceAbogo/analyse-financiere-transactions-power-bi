# Mesures DAX

Ce document décrit les mesures du modèle sémantique. Elles sont hébergées dans la table `finance_transactions`.

Les noms des mesures, en anglais, sont ceux affichés dans le rapport. Leurs descriptions sont en français.

## Conventions de nommage

| Préfixe | Signification |
|---|---|
| `Total` | Agrégation de base |
| `Avg` | Moyenne |
| `PY` | Valeur de la même période de l'année précédente (*Previous Year*) |
| `YoY %` | Variation annuelle en pourcentage (*Year over Year*) |
| `Nb` | Comptage, utilisé pour le contrôle qualité |

## 1. Mesures de base

```dax
Total Amount        = SUM ( finance_transactions[amount_abs] )
Total Fees          = SUM ( finance_transactions[fee_amount] )
Total Tax           = SUM ( finance_transactions[tax_amount] )
Total Transactions  = DISTINCTCOUNT ( finance_transactions[transaction_id] )
Avg Transaction val = AVERAGE ( finance_transactions[amount_abs] )
```

| Mesure | Description |
|---|---|
| `Total Amount` | Volume des opérations, en valeur absolue |
| `Total Fees` | Total des frais renseignés ; les frais manquants ne sont pas imputés |
| `Total Tax` | Total des taxes |
| `Total Transactions` | Nombre de transactions distinctes |
| `Avg Transaction val` | Montant moyen par transaction, en valeur absolue |

> `Total Amount` et `Avg Transaction val` reposent sur `amount_abs`. Le traitement des montants est détaillé dans `power-query/README.md`.

## 2. Comparaison avec l'année précédente

```dax
PY Amount          = CALCULATE ( [Total Amount],        SAMEPERIODLASTYEAR ( 'Calendar Table'[Date] ) )
PY Avg Transaction = CALCULATE ( [Avg Transaction val], SAMEPERIODLASTYEAR ( 'Calendar Table'[Date] ) )
PY Total Fees      = CALCULATE ( [Total Fees],          SAMEPERIODLASTYEAR ( 'Calendar Table'[Date] ) )
PY Total Tax       = CALCULATE ( [Total Tax],           SAMEPERIODLASTYEAR ( 'Calendar Table'[Date] ) )
PY Transaction     = CALCULATE ( [Total Transactions],  SAMEPERIODLASTYEAR ( 'Calendar Table'[Date] ) )
```

Chaque mesure `PY` évalue la mesure de base sur la même période, décalée d'un an. La période comparée est équivalente : voir `table-calendrier.md`.

## 3. Variations annuelles

```dax
YoY % Amount =
VAR _Actuel = [Total Amount]
VAR _PY     = [PY Amount]
RETURN
    IF ( HASONEVALUE ( 'Calendar Table'[Year] ), DIVIDE ( _Actuel - _PY, _PY ) )

YoY % Avg Transaction value =
VAR _Actuel = [Avg Transaction val]
VAR _PY     = [PY Avg Transaction]
RETURN
    IF ( HASONEVALUE ( 'Calendar Table'[Year] ), DIVIDE ( _Actuel - _PY, _PY ) )

YoY % Total Fees =
VAR _Actuel = [Total Fees]
VAR _PY     = [PY Total Fees]
RETURN
    IF ( HASONEVALUE ( 'Calendar Table'[Year] ), DIVIDE ( _Actuel - _PY, _PY ) )

YoY % Total Tax =
VAR _Actuel = [Total Tax]
VAR _PY     = [PY Total Tax]
RETURN
    IF ( HASONEVALUE ( 'Calendar Table'[Year] ), DIVIDE ( _Actuel - _PY, _PY ) )

YoY % Transaction =
VAR _Actuel = [Total Transactions]
VAR _PY     = [PY Transaction]
RETURN
    IF ( HASONEVALUE ( 'Calendar Table'[Year] ), DIVIDE ( _Actuel - _PY, _PY ) )
```

### Règles de calcul

| Situation | Résultat |
|---|---|
| Une seule année sélectionnée, avec données N-1 | Variation en pourcentage |
| Aucune donnée N-1 (par exemple 2023) | **Vide** |
| Plusieurs années sélectionnées, ou aucune sélection | **Vide** |

Une version antérieure renvoyait `0` à la place du vide (troisième argument de `DIVIDE`). Elle affichait un faux « 0 % » lorsque l'année précédente était absente. Le vide est désormais renvoyé.

## 4. Contrôle qualité

```dax
Nb Frais Manquants =
CALCULATE ( COUNTROWS ( finance_transactions ), finance_transactions[is_fee_missing] = TRUE () )

Nb Montants Négatifs =
CALCULATE ( COUNTROWS ( finance_transactions ), finance_transactions[amount] < 0 )
```

| Mesure | Description |
|---|---|
| `Nb Frais Manquants` | Transactions dont les frais sont absents du fichier source |
| `Nb Montants Négatifs` | Transactions dont le montant source est négatif (anomalie probable) |

## 5. Mesures d'affichage

| Mesure | Description |
|---|---|
| `Selected Year` | Année sélectionnée dans le segment `Year` |
| `Selected Dynamic Metric` | Libellé de la mesure sélectionnée dans le paramètre `Dynamic Metric` |

Les formules figurent dans `table-calendrier.md` et `parametre-mesures-dynamiques.md`.

## 6. Dossiers d'affichage

| Dossier | Mesures |
|---|---|
| `1 - Mesures de base` | Total Amount, Total Fees, Total Tax, Total Transactions, Avg Transaction val |
| `2 - Année précédente` | PY Amount, PY Avg Transaction, PY Total Fees, PY Total Tax, PY Transaction |
| `3 - Variations annuelles` | YoY % Amount, YoY % Avg Transaction value, YoY % Total Fees, YoY % Total Tax, YoY % Transaction |
| `4 - Contrôle qualité` | Nb Frais Manquants, Nb Montants Négatifs |
| `5 - Affichage` | Selected Year, Selected Dynamic Metric |
