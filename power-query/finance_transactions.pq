// ============================================================================
// Requête      : finance_transactions
// Source       : fichier CSV local (paramètre PathFinance)
// Auteur       : Brice Abogo
// Version      : 1.0.0
// Description  : Import, dédoublonnage, typage et nettoyage des transactions.
// Prérequis    : paramètre Power Query PathFinance (type Texte)
// Format source: dates JJ-MM-AAAA, séparateur décimal = point
// ============================================================================
let
    // --- Réglages de la requête -------------------------------------------
    CultureNombres = "en-US",        // nombres : point décimal
    FormatDate     = "dd-MM-yyyy",   // dates du fichier source

    // Conversion explicite d'une date texte, indépendante de la région du poste
    ConvertirDate = (t as nullable text) as nullable date =>
        if t = null or Text.Trim(t) = "" then null
        else Date.FromText(Text.Trim(t), [Format = FormatDate, Culture = "en-US"]),

    // --- 1. Import du fichier CSV -----------------------------------------
    Source = Csv.Document(
        File.Contents(PathFinance),
        [Delimiter = ",", Columns = 15, Encoding = 1252, QuoteStyle = QuoteStyle.None]
    ),

    // --- 2. Promotion de la première ligne en en-têtes --------------------
    EnTetes = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),

    // --- 3. Dédoublonnage (avant toute conversion de type) ----------------
    // Pour un même identifiant, la ligne la plus complète (le moins de champs
    // vides) est conservée. Table.Buffer fige le tri avant Table.Distinct.
    AvecCompletude = Table.AddColumn(
        EnTetes,
        "_nb_vides",
        each List.Count(List.Select(Record.FieldValues(_), each _ = null or _ = "")),
        Int64.Type
    ),
    Trie = Table.Buffer(
        Table.Sort(AvecCompletude, {{"transaction_id", Order.Ascending}, {"_nb_vides", Order.Ascending}})
    ),
    SansDoublons = Table.RemoveColumns(
        Table.Distinct(Trie, {"transaction_id"}),
        {"_nb_vides"}
    ),

    // --- 4. Typage ---------------------------------------------------------
    DateConvertie = Table.TransformColumns(
        SansDoublons,
        {{"transaction_date", ConvertirDate, type date}}
    ),
    TypesCorriges = Table.TransformColumnTypes(
        DateConvertie,
        {
            {"transaction_id",     type text},
            {"account_id",         type text},
            {"customer_id",        type text},
            {"transaction_type",   type text},
            {"channel",            type text},
            {"merchant_category",  type text},
            {"amount",             type number},
            {"fee_amount",         type number},
            {"tax_amount",         type number},
            {"currency",           type text},
            {"transaction_status", type text},
            {"is_fraud",           type text},
            {"risk_score",         Int64.Type},
            {"reference_no",       type text}
        },
        CultureNombres
    ),

    // --- 5. Nettoyage des colonnes texte ----------------------------------
    TexteNettoye = Table.TransformColumns(
        TypesCorriges,
        {
            {"transaction_type",   Text.Trim, type text},
            {"channel",            Text.Trim, type text},
            {"merchant_category",  Text.Trim, type text},
            {"transaction_status", Text.Trim, type text},
            {"currency",           each Text.Upper(Text.Trim(_)), type text}
        }
    ),

    // --- 6. Traçabilité des frais manquants -------------------------------
    // Aucune valeur n'est inventée : fee_amount reste vide (null) s'il est
    // absent du fichier source.
    IndicateurFrais = Table.AddColumn(
        TexteNettoye,
        "is_fee_missing",
        each [fee_amount] = null,
        type logical
    ),

    // --- 7. Montant en valeur absolue (colonne complémentaire) ------------
    // « amount » conserve son signe d'origine ; « amount_abs » exprime le
    // volume de l'opération, quel que soit son sens.
    Resultat = Table.AddColumn(
        IndicateurFrais,
        "amount_abs",
        each Number.Abs([amount]),
        type number
    )
in
    Resultat
