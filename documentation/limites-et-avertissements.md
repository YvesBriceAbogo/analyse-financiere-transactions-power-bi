# Limites et avertissements

## Données

| Point | Précision |
|---|---|
| Origine | Source publique en ligne, **non identifiée avec certitude** ; licence d'origine non confirmée |
| Nature | Données vraisemblablement fictives, sans garantie ; usage pédagogique et de démonstration |
| Devise | Montants exprimés dans la devise de la colonne `currency` (`INR` dans les lignes examinées) |
| Licence | La licence MIT couvre le code et la documentation, **pas les fichiers de données** |

## Qualité des données

| Constat | Volume | Traitement |
|---|---:|---|
| Identifiants de transaction en double | 69 | Une seule ligne conservée, la plus complète |
| Frais manquants | 23 | Non imputés ; repérés par `is_fee_missing` |
| Montants négatifs | 8 | Anomalie probable ; mesures basées sur `amount_abs` |
| Espaces superflus et devise en minuscules | Quelques cas | Nettoyés par Power Query |

## Hypothèses d'analyse

- **Volumes en valeur absolue.** `Total Amount` et `Avg Transaction val` expriment des volumes d'opérations, pas des soldes.
- **Frais.** `Total Fees` ne porte que sur les frais renseignés. Une version antérieure imputait 14,53 aux frais manquants. Cette règle a été abandonnée : le total 2026 est passé de 75 442,06 à 75 413,00.
- **Taxe.** La taxe vaut 18 % des frais sur 28 111 lignes testées. Ce constat n'est pas appliqué pour reconstituer les frais manquants.

## Interprétation des indicateurs

- **Année 2026 incomplète.** Les données s'arrêtent au 30 avril 2026. Les variations N-1 comparent janvier à avril 2026 avec janvier à avril 2025.
- **Année 2023.** Aucune donnée antérieure : les variations sont vides.
- **Plusieurs années sélectionnées.** Les variations sont vides.
- **Fraude et score de risque.** Les colonnes `is_fraud` et `risk_score` sont chargées mais ne sont pas exploitées dans les pages actuelles.

## Actualisation

Le sous-titre du rapport, « Real Time Insights », ne correspond pas à un temps réel au sens strict. Les données proviennent de fichiers CSV actualisés **2 fois par jour** (11 h 30 et 17 h 00), à condition que le poste hébergeant la passerelle soit en ligne.

## Accès

- Le rapport n'est pas accessible publiquement sur Power BI Service (restriction du compte).
- Le fichier `.pbix` du dépôt utilise des chemins neutres ; il doit être adapté pour fonctionner (voir `guide-installation.md`).
