# investment-market-analyzer

Application locale d’analyse de marché et d’aide à la décision d’investissement.

## Objectif

Centraliser les données utiles pour analyser un titre financier : prix, actualités, fondamentaux, consensus analystes, indicateurs techniques, watchlist et historique de recherche.

## Stack

- Frontend : Next.js + TypeScript + Tailwind CSS.
- Backend : FastAPI + SQLAlchemy + Pydantic.
- Base de données : MariaDB.
- Migrations : Alembic.
- Environnement : VS Code + GitHub Copilot.

## Démarrage DB

```bash
docker compose up -d db
```

## Backend

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -e ".[dev]"
alembic upgrade head
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

## Frontend

```bash
cd frontend
npm install
npm run dev
```

## Documentation

Lire en priorité :

- `docs/SPECIFICATION_TECHNIQUE.md`
- `docs/API_CONTRACT.md`
- `docs/DATABASE_SCHEMA.md`
- `.github/copilot-instructions.md`

## Statut MVP

Le MVP doit permettre :

- recherche instrument ;
- stockage MariaDB ;
- historique prix ;
- graphique ;
- SMA/RSI ;
- watchlist ;
- historique de recherche.
