# Table calendrier

## Rôle

La table `Calendar Table` est la dimension de dates du modèle. Elle alimente les segments `Year`, les axes mensuels et les comparaisons avec l'année précédente.

## Définition

```dax
Calendar Table =
CALENDAR (
    DATE ( YEAR ( MIN ( finance_transactions[transaction_date] ) ), 1, 1 ),
    MAX ( finance_transactions[transaction_date] )
)
```

La table commence au 1ᵉʳ janvier de la première année de données et s'arrête à la **dernière date de transaction**. Dans la version actuelle, elle couvre du 1ᵉʳ janvier 2023 au 30 avril 2026. Sa plage se met à jour à chaque actualisation des données.

## Colonnes calculées

```dax
Year         = YEAR ( 'Calendar Table'[Date] )
Month number = MONTH ( 'Calendar Table'[Date] )
Month        = FORMAT ( 'Calendar Table'[Date], "mmm", "en-US" )
```

| Colonne | Rôle |
|---|---|
| `Date` | Date du jour, clé de la relation |
| `Year` | Année civile |
| `Month number` | Numéro du mois, utilisé pour le tri |
| `Month` | Libellé abrégé du mois (Jan, Feb, Mar, Apr…) |

La langue du libellé est indiquée explicitement (`"en-US"`) : le résultat ne dépend donc pas des paramètres régionaux du poste. Pour des mois en français, remplacer par `"fr-FR"`.

## Configuration du modèle

| Réglage | Valeur |
|---|---|
| Tri de la colonne `Month` | Par `Month number`, afin d'afficher les mois dans l'ordre calendaire |
| Table de dates | `Calendar Table`, colonne `Date` (marquée comme table de dates) |
| Relation | `Calendar Table[Date]` (1) vers `finance_transactions[transaction_date]` (plusieurs) |
| Sens du filtre | Unique, de la table calendrier vers les transactions |

## Pourquoi le calendrier s'arrête à la dernière transaction

Les mesures `PY` utilisent `SAMEPERIODLASTYEAR`, qui décale d'un an les dates visibles dans le contexte de filtre.

| Année sélectionnée | Période affichée | Période de comparaison |
|---|---|---|
| 2026 | 1ᵉʳ janvier au 30 avril 2026 | 1ᵉʳ janvier au 30 avril 2025 |
| 2025 | 1ᵉʳ janvier au 31 décembre 2025 | 1ᵉʳ janvier au 31 décembre 2024 |
| 2023 | 1ᵉʳ janvier au 31 décembre 2023 | Aucune donnée : variation vide |

Le calendrier ne contient que des dates jusqu'au 30 avril 2026 : l'année en cours est donc comparée à la même période de l'année précédente.

> **Ne pas étendre le calendrier au 31 décembre.** Les quatre premiers mois de 2026 seraient alors comparés à l'année 2025 entière, ce qui fausserait toutes les variations N-1.
