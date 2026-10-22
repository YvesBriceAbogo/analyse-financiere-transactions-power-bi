# Journal des modifications

Format inspiré de [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/). Versionnement : [SemVer](https://semver.org/lang/fr/).

## [1.0.0] — 2026-10-22

Première version publiée.

### Ajouté

- Rapport Power BI de deux pages : Overview Analysis et Transactions.
- Modèle en étoile : transactions, clients et calendrier.
- Mesures DAX : mesures de base, comparaison N-1, variations annuelles, contrôle qualité.
- Paramètre de champs « Dynamic Metric » (quatre mesures).
- Scripts Power Query documentés pour `finance_transactions` et `customers`.
- Colonnes `is_fee_missing` et `amount_abs`.
- Documentation : dictionnaire de données, modèle, installation, publication, passerelle et actualisation, limites.
- Fichiers sources CSV, fichier `.pbix`, captures et export PDF.

### Modifié par rapport au rapport initial

- Dates lues avec un format explicite (`JJ-MM-AAAA`), indépendamment de la région du poste.
- Conversion des montants avec une culture explicite, sans remplacement du séparateur décimal.
- Dédoublonnage placé avant le typage, en conservant la ligne la plus complète.
- Frais manquants **non imputés** (la valeur forfaitaire 14,53 est supprimée) : le total 2026 passe de 75 442,06 à 75 413,00. La variation annuelle reste de 7,17 %.
- Montant source conservé dans `amount` ; mesures basées sur `amount_abs`.
- Variations annuelles vides, et non à 0 %, lorsque l'année précédente est absente.
- Colonne `Month` indépendante de la langue du poste et triée par numéro de mois.
- Mesures organisées en dossiers d'affichage.

### Valeurs de contrôle

| Indicateur | Valeur |
|---|---:|
| Transactions | 50 000 |
| Total Amount (toutes années) | 455 534 249,62 |
| Total Fees (toutes années) | 725 914,91 |
| Total Tax (toutes années) | 130 736,35 |
| Total Fees 2026 | 75 413,00 |
| Total Fees 2025 (même période) | 70 366,43 |
