// ============================================================================
// Requête      : customers
// Source       : fichier CSV local (paramètre PathCustomers)
// Auteur       : Brice Abogo
// Version      : 1.0.0
// Description  : Import, typage et constitution du nom complet des clients.
// Prérequis    : paramètre Power Query PathCustomers (type Texte)
// Format source: dates JJ-MM-AAAA, séparateur décimal = point
// Remarque     : la colonne source « fisrt_name » est conservée telle quelle
//                (coquille présente dans le fichier d'origine).
// ============================================================================
let
    // --- Réglages de la requête -------------------------------------------
    CultureNombres = "en-US",
    FormatDate     = "dd-MM-yyyy",

    ConvertirDate = (t as nullable text) as nullable date =>
        if t = null or Text.Trim(t) = "" then null
        else Date.FromText(Text.Trim(t), [Format = FormatDate, Culture = "en-US"]),

    // --- 1. Import du fichier CSV -----------------------------------------
    Source = Csv.Document(
        File.Contents(PathCustomers),
        [Delimiter = ",", Columns = 11, Encoding = 1252, QuoteStyle = QuoteStyle.None]
    ),

    // --- 2. Promotion de la première ligne en en-têtes --------------------
    EnTetes = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),

    // --- 3. Unicité de l'identifiant client (côté « 1 » de la relation) ---
    SansDoublons = Table.Distinct(EnTetes, {"customer_id"}),

    // --- 4. Typage ---------------------------------------------------------
    DatesConverties = Table.TransformColumns(
        SansDoublons,
        {
            {"date_of_birth", ConvertirDate, type date},
            {"join_date",     ConvertirDate, type date}
        }
    ),
    TypesCorriges = Table.TransformColumnTypes(
        DatesConverties,
        {
            {"customer_id",       type text},
            {"fisrt_name",        type text},
            {"second_name",       type text},
            {"gender",            type text},
            {"city",              type text},
            {"state",             type text},
            {"occupation",        type text},
            {"customer_segment",  type text},
            {"annual_income",     type number}
        },
        CultureNombres
    ),

    // --- 5. Constitution du nom complet -----------------------------------
    NomComplet = Table.CombineColumns(
        TypesCorriges,
        {"fisrt_name", "second_name"},
        Combiner.CombineTextByDelimiter(" ", QuoteStyle.None),
        "Customer_name"
    ),

    // --- 6. Suppression des espaces superflus -----------------------------
    Resultat = Table.TransformColumns(
        NomComplet,
        {{"Customer_name", Text.Trim, type text}}
    )
in
    Resultat
