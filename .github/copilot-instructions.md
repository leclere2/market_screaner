# Copilot instructions — investment-market-analyzer

Tu aides à développer une application locale d’analyse de marché et d’aide à la décision d’investissement.

## Documents à lire avant de générer du code

Toujours te baser sur :

1. `docs/SPECIFICATION_TECHNIQUE.md`
2. `docs/API_CONTRACT.md`
3. `docs/DATABASE_SCHEMA.md`
4. `docs/CODING_STANDARDS.md`
5. `docs/SECURITY.md`

## Stack imposée

- Frontend : Next.js + React + TypeScript + Tailwind CSS.
- Backend : Python FastAPI.
- DB : MariaDB.
- ORM : SQLAlchemy 2.x.
- Migrations : Alembic.
- Validation : Pydantic v2.
- Tests backend : pytest.
- Tests frontend : Vitest / React Testing Library.

## Architecture à respecter

Backend :

- Les routes FastAPI ne contiennent pas de logique métier complexe.
- Les routes appellent des services.
- Les services orchestrent repositories, connecteurs et logique métier.
- Les repositories sont les seuls modules à faire des requêtes DB directes.
- Les modèles SQLAlchemy sont dans `backend/app/models`.
- Les schémas Pydantic sont dans `backend/app/schemas`.
- Les connecteurs externes sont dans `backend/app/connectors`.
- Les calculs financiers sont dans `backend/app/analysis`.

Frontend :

- Ne jamais appeler MariaDB directement.
- Tous les appels passent par l’API FastAPI.
- Centraliser les appels HTTP dans `frontend/src/lib/api.ts`.
- Prévoir systématiquement loading, empty state et error state.
- Ne pas mettre de logique financière complexe dans les composants React.

## Règles de sécurité

- Ne jamais commiter de secret.
- Ne jamais écrire de clé API dans le code.
- Utiliser `.env` local et `.env.example`.
- Ne jamais créer d’ordre de trading réel.
- Toute intégration IBKR doit être read-only tant qu’une validation manuelle n’est pas explicitement spécifiée.
- Ne jamais présenter une analyse comme une recommandation financière certaine.

## Règles de données

- Toute donnée importante doit avoir une source et une date de récupération.
- Prévoir le cas des données manquantes.
- Prévoir le cas des API indisponibles ou limitées.
- Ne pas faire de scraping non autorisé par défaut.
- Stocker les prix historiques en OHLCV dans `price_bars`.
- Garder l’historique des recherches utilisateur.

## Style de code

Python :

- Type hints obligatoires.
- SQLAlchemy 2.x typed mappings.
- Pydantic v2 pour validation.
- Fonctions courtes, testables.
- Utiliser Ruff et mypy.

TypeScript :

- TypeScript strict.
- Composants React fonctionnels.
- Types explicites pour les réponses API.
- Éviter `any` sauf justification.
- UI claire, sobre et orientée décision.

## Priorité MVP

Générer dans cet ordre :

1. setup DB MariaDB + Docker Compose ;
2. backend FastAPI minimal + healthcheck ;
3. modèles SQLAlchemy initiaux ;
4. migration Alembic initiale ;
5. endpoint recherche instrument ;
6. page Next.js `/search` ;
7. historique prix + graphique ;
8. indicateurs techniques SMA/RSI ;
9. watchlist ;
10. historique de recherche.
