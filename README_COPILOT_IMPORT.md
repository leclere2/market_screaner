# Comment utiliser ce pack dans VS Code avec Copilot

## 1. Copier les fichiers dans le repository

Copier le contenu de ce dossier à la racine du futur repository `investment-market-analyzer`.

Structure minimale attendue après copie :

```text
investment-market-analyzer/
├── docs/
├── .github/copilot-instructions.md
├── .vscode/
├── db/
├── backend/
├── frontend/
├── docker-compose.yml
├── .env.example
└── README.md
```

## 2. Ouvrir VS Code

```bash
code investment-market-analyzer
```

## 3. Activer Copilot Chat

Dans Copilot Chat, commencer par :

```text
Lis docs/SPECIFICATION_TECHNIQUE.md, docs/API_CONTRACT.md, docs/DATABASE_SCHEMA.md et .github/copilot-instructions.md. Ensuite propose-moi l’ordre de génération du code pour construire le MVP.
```

## 4. Prompt recommandé pour démarrer le code

```text
En te basant sur les documents du dossier docs et sur .github/copilot-instructions.md, crée le squelette backend FastAPI avec healthcheck, configuration .env, session SQLAlchemy MariaDB et structure de dossiers conforme à la spécification.
```

Puis :

```text
Crée les modèles SQLAlchemy initiaux et une migration Alembic pour Exchange, Sector, Instrument, DataSource, PriceBar, Watchlist, WatchlistItem et SearchHistory.
```

Puis :

```text
Crée le frontend Next.js avec une page /search, une page /watchlist, un client API centralisé et une UI Tailwind propre.
```

## 5. Démarrage local attendu

```bash
docker compose up -d db
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -e ".[dev]"
alembic upgrade head
uvicorn app.main:app --reload --port 8000

cd ../frontend
npm install
npm run dev
```
