# Backlog MVP

## Epic 1 — Setup local

### US-001 — Initialiser repository

- Créer structure backend/frontend/docs/db.
- Ajouter `.gitignore`.
- Ajouter `.env.example`.
- Ajouter Docker Compose MariaDB.

Critères d’acceptation : repository ouvrable dans VS Code.

### US-002 — Démarrer MariaDB local

- `docker compose up -d db` fonctionne.
- Port 3306 exposé.
- DB `investment_app` créée.
- Utilisateur `investment_user` créé.

### US-003 — Backend FastAPI healthcheck

- Endpoint `/api/v1/health`.
- CORS configuré pour frontend local.
- Config chargée depuis `.env`.

## Epic 2 — Modèle DB

### US-004 — Modèles initiaux

Créer modèles SQLAlchemy :

- Exchange ;
- Sector ;
- DataSource ;
- Instrument ;
- PriceBar ;
- Watchlist ;
- WatchlistItem ;
- SearchHistory ;
- TechnicalIndicatorSnapshot ;
- UserNote.

### US-005 — Migration initiale

- Alembic configuré.
- Migration initiale générée.
- `alembic upgrade head` fonctionne.

## Epic 3 — Recherche instrument

### US-006 — Repository Instrument

- Recherche par ticker.
- Recherche par ISIN.
- Recherche par nom partiel.
- Création instrument.

### US-007 — Service Instrument

- Normalise la requête.
- Cherche d’abord en base.
- Prépare hook connecteur externe.
- Historise la recherche.

### US-008 — API Search

- `GET /api/v1/instruments/search`.
- Réponse typée Pydantic.
- Tests unitaires.

### US-009 — Page frontend Search

- Champ de recherche.
- Résultats.
- Loading/error states.
- Lien vers fiche instrument.

## Epic 4 — Prix et graphiques

### US-010 — PriceBar repository

- Insérer des prix.
- Lire historique par instrument.
- Upsert sur clé unique.

### US-011 — Connecteur prix MVP

- Interface commune.
- Implémentation simple pour une source choisie.
- Gestion erreurs.

### US-012 — API Price History

- `GET /api/v1/instruments/{id}/prices`.
- `POST /api/v1/instruments/{id}/prices/refresh`.

### US-013 — Graphique frontend

- Composant `PriceChart`.
- Afficher close price.
- Gérer absence de données.

## Epic 5 — Indicateurs techniques

### US-014 — SMA

- Calcul SMA20, SMA50, SMA200.
- Tests cas limites.

### US-015 — RSI14

- Calcul RSI14.
- Tests cas limites.

### US-016 — Snapshot technique

- Stockage DB.
- Endpoint latest.
- Explication signal.

## Epic 6 — Watchlist

### US-017 — CRUD Watchlist

- Créer/lister watchlists.
- Ajouter/supprimer item.

### US-018 — Page Watchlist

- Tableau favoris.
- Dernier prix.
- Signal technique.
- Note utilisateur.

## Epic 7 — Historique et notes

### US-019 — Historique recherche

- Page `/history`.
- Tri récent.
- Lien vers fiche.

### US-020 — Notes utilisateur

- Ajouter note sur instrument.
- Modifier note.
- Supprimer note.

## Definition of Done MVP

- Tests critiques passent.
- Backend et frontend démarrent localement.
- Aucune clé secrète dans Git.
- README à jour.
- Copilot instructions présentes.
