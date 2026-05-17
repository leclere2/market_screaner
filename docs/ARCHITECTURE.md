# Architecture — investment-market-analyzer

## Vue d’ensemble

Application locale en trois couches :

```text
Frontend Next.js / React / TypeScript
        |
        | REST JSON
        v
Backend FastAPI / Python
        |
        | SQLAlchemy ORM
        v
MariaDB local
```

## Décisions structurantes

- Frontend et backend séparés pour garder une architecture claire.
- Backend Python pour faciliter l’analyse financière, les indicateurs techniques et la future intégration IBKR.
- MariaDB comme source de vérité locale.
- API REST versionnée sous `/api/v1`.
- Pas d’exécution d’ordres dans le MVP.
- Données externes encapsulées par connecteurs.

## Flux principal MVP

```text
Utilisateur saisit ASML
  -> Frontend appelle GET /api/v1/instruments/search?q=ASML
  -> Backend cherche en DB
  -> Si absent, backend appelle connecteur externe
  -> Backend normalise et stocke l’instrument
  -> Frontend affiche les résultats
  -> Utilisateur ouvre la fiche
  -> Backend récupère ou rafraîchit les prix
  -> Backend calcule les indicateurs techniques
  -> Frontend affiche graphique + synthèse
```

## Backend layers

```text
api/routes -> services -> repositories -> models -> MariaDB
                    |
                    -> connectors externes
                    -> analysis/scoring
```

### API routes

- Validation HTTP.
- Appel services.
- Mapping erreurs métier vers réponses HTTP.

### Services

- Logique métier.
- Orchestration.
- Décisions de cache/refresh.
- Appels connecteurs.

### Repositories

- Requêtes SQLAlchemy.
- Pas de logique métier lourde.

### Connectors

- Appels API externes.
- Normalisation.
- Gestion rate limit.
- Journalisation fetch logs.

## Frontend layers

```text
app/routes -> features -> components -> lib/api.ts -> FastAPI
```

- `app/` : pages et routing.
- `features/` : modules fonctionnels.
- `components/` : composants UI réutilisables.
- `lib/api.ts` : client API centralisé.
- `types/` : types TypeScript.

## Environnements

### Local dev

- MariaDB via Docker Compose ou Homebrew.
- Backend sur `localhost:8000`.
- Frontend sur `localhost:3000`.

### Évolutions futures

- Ajout Redis optionnel pour cache.
- Ajout jobs planifiés.
- Ajout IBKR read-only.
- Packaging desktop local possible plus tard.
