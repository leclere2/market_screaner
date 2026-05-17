# Security

## Objectif

L’application est locale, mais elle manipule des historiques de recherche, des clés API potentielles et plus tard une connexion IBKR. La sécurité doit être intégrée dès le MVP.

## Secrets

Ne jamais versionner :

- `.env` ;
- clés API ;
- tokens ;
- identifiants IBKR ;
- dumps DB ;
- backups personnels.

Utiliser seulement `.env.example` dans Git.

## Variables sensibles

- `DB_PASSWORD`
- `DATABASE_URL`
- `FMP_API_KEY`
- `ALPHA_VANTAGE_API_KEY`
- `TWELVE_DATA_API_KEY`
- `NEWS_API_KEY`
- `IBKR_*`

## Trading safety

- Pas d’ordre réel dans le MVP.
- Toute fonctionnalité IBKR doit être read-only au départ.
- Toute future exécution d’ordre doit avoir validation manuelle explicite.
- Journalisation obligatoire de toute préparation d’ordre.
- Mode simulation obligatoire avant mode réel.

## Données externes

- Respecter les conditions d’utilisation des fournisseurs.
- Préférer les APIs officielles.
- Ne pas contourner les paywalls.
- Ne pas scraper par défaut.

## CORS

En local :

- Autoriser `http://localhost:3000`.
- Refuser wildcard en configuration cible.

## Logs

Interdit de logger :

- mots de passe ;
- tokens ;
- clés API ;
- chaînes de connexion complètes si elles contiennent un mot de passe.

Autorisé :

- nom source ;
- endpoint logique ;
- durée ;
- statut ;
- nombre d’éléments récupérés ;
- erreur nettoyée sans secret.
