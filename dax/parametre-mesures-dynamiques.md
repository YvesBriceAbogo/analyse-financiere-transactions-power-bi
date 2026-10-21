# Paramètre de champs « Dynamic Metric »

## Rôle

Le paramètre de champs `Dynamic Metric` permet à l'utilisateur de choisir, depuis un segment, la mesure affichée par les visuels qui l'utilisent. Le libellé choisi s'affiche aussi dans l'en-tête du rapport (exemple : « 2026 Total Amount »).

## Définition du paramètre

```dax
Dynamic Metric = {
    ( "Total Amount",       NAMEOF ( 'finance_transactions'[Total Amount] ),       0 ),
    ( "Total Fees",         NAMEOF ( 'finance_transactions'[Total Fees] ),         1 ),
    ( "Total Tax",          NAMEOF ( 'finance_transactions'[Total Tax] ),          2 ),
    ( "Total Transactions", NAMEOF ( 'finance_transactions'[Total Transactions] ), 3 )
}
```

## Colonne calculée de libellé

```dax
Dynamic Metric Title =
SWITCH (
    'Dynamic Metric'[Dynamic Metric Order],
    0, "Total Amount",
    1, "Total Fees",
    2, "Total Tax",
    3, "Total Transactions",
    "Other"
)
```

Cette colonne fournit un libellé texte exploitable dans une mesure, ce que ne permet pas directement la colonne du paramètre.

## Structure de la table

| Colonne | Type | Contenu |
|---|---|---|
| `Dynamic Metric` | Paramètre | Libellé affiché dans le segment |
| `Dynamic Metric Fields` | Paramètre (masquée) | Référence vers la mesure |
| `Dynamic Metric Order` | Paramètre (masquée) | Ordre d'affichage |
| `Dynamic Metric Title` | Calculée | Libellé texte, utilisé par la mesure `Selected Dynamic Metric` |

## Mesures d'affichage associées

```dax
Selected Year           = SELECTEDVALUE ( 'Calendar Table'[Year] )
Selected Dynamic Metric = SELECTEDVALUE ( 'Dynamic Metric'[Dynamic Metric Title] )
```

Ces deux mesures composent l'en-tête du rapport. Elles renvoient une valeur vide si plusieurs éléments sont sélectionnés dans le segment.

## Mesures proposées

| Libellé | Mesure | Ordre |
|---|---|---:|
| Total Amount | `Total Amount` | 0 |
| Total Fees | `Total Fees` | 1 |
| Total Tax | `Total Tax` | 2 |
| Total Transactions | `Total Transactions` | 3 |

## Ajouter une mesure au paramètre

1. Ouvrez la table `Dynamic Metric` et modifiez la formule du paramètre. Ajoutez une ligne `( "Libellé", NAMEOF ( 'finance_transactions'[Mesure] ), n )`, avec un numéro d'ordre unique.
2. **Modifiez aussi la colonne `Dynamic Metric Title`** : ajoutez la ligne `n, "Libellé"` dans le `SWITCH`. Sinon, l'en-tête du rapport affichera « Other ».

## Points d'attention

- Le paramètre ne propose que quatre mesures. Les variations `YoY %` et le montant moyen n'en font pas partie.
- `NAMEOF` suit automatiquement le renommage d'une mesure, mais pas les libellés, qui doivent être modifiés manuellement dans le paramètre et dans le `SWITCH`.
