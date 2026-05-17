# Spécification technique — Application locale d’analyse de marché et d’aide à la décision d’investissement

**Nom de projet proposé :** `investment-market-analyzer`  
**Version du document :** 1.0  
**Date :** 2026-05-17  
**Contexte :** application locale développée dans VS Code avec assistance GitHub Copilot.  
**Base de données imposée :** MariaDB.  
**Statut :** document de référence pour génération du code, backlog MVP et architecture cible.

---

## 1. Objectif du document

Ce document doit être importé dans le repository VS Code pour servir de référence à GitHub Copilot et aux futurs développements.

Copilot devra s’appuyer sur ce document pour :

1. créer l’architecture applicative ;
2. générer le backend ;
3. générer le frontend web local ;
4. créer le modèle de données MariaDB ;
5. implémenter les connecteurs de données financières ;
6. produire les écrans, endpoints, services, tests et migrations ;
7. respecter les contraintes de sécurité, maintenabilité et évolutivité.

Le projet vise une application personnelle d’aide à la décision d’investissement, pas un système de trading automatique.

---

## 2. Vision produit

L’application doit devenir un tableau de bord local d’analyse financière permettant de passer rapidement d’informations dispersées à une synthèse exploitable pour décider si un titre mérite d’être acheté, surveillé, renforcé, évité ou vendu.

L’application doit agréger :

- données de marché ;
- historique de prix ;
- actualités financières ;
- informations fondamentales ;
- consensus analystes ;
- indicateurs techniques ;
- événements financiers ;
- notes et décisions personnelles ;
- historiques de recherches et d’analyses.

La logique produit est orientée vers un investisseur qui souhaite investir environ **1 000 EUR par mois**, principalement sur actions ou ETF cotés en Europe ou aux États-Unis, avec une préférence pour les instruments cotés en EUR lorsque c’est pertinent.

---

## 3. Périmètre fonctionnel cible

### 3.1 Tableau de bord principal

Le tableau de bord doit donner une vue synthétique du marché et de la watchlist.

Fonctionnalités attendues :

- résumé des marchés Europe / États-Unis ;
- fil d’actualité général ;
- actualités importantes par secteur ;
- top variations des titres suivis ;
- prochaines publications de résultats ;
- alertes sur titres favoris ;
- derniers titres recherchés ;
- synthèse des opportunités à analyser ;
- indicateurs de fraîcheur des données.

### 3.2 Recherche d’un instrument financier

L’utilisateur doit pouvoir rechercher un instrument par :

- nom de société ;
- ticker ;
- ISIN ;
- place de cotation ;
- éventuellement secteur ou pays dans une phase ultérieure.

La recherche doit retourner une fiche instrument contenant :

- identité instrument ;
- dernier cours connu ;
- devise ;
- bourse ;
- ISIN ;
- ticker ;
- secteur ;
- pays ;
- données fondamentales principales ;
- graphique de prix ;
- indicateurs techniques ;
- actualités récentes ;
- consensus analystes si disponible ;
- synthèse d’aide à la décision ;
- notes utilisateur.

### 3.3 Watchlist / favoris

L’utilisateur doit pouvoir ajouter un titre à une liste de favoris.

Pour chaque favori, afficher :

- nom ;
- ticker ;
- ISIN ;
- devise ;
- cours actuel ;
- performance 1 jour, 1 semaine, 1 mois, 3 mois, 6 mois, 1 an ;
- objectif de cours moyen si disponible ;
- potentiel théorique ;
- score global ;
- signal technique ;
- dernières actualités ;
- prochaine date de résultat ;
- note personnelle.

### 3.4 Historique des recherches

Chaque recherche doit être historisée pour permettre de retrouver les analyses passées.

Données à conserver :

- date et heure ;
- type de recherche ;
- requête saisie ;
- instrument trouvé ;
- sources utilisées ;
- résumé généré ;
- score au moment de l’analyse ;
- décision utilisateur ;
- notes utilisateur.

### 3.5 Fiche de synthèse par titre

La fiche cible doit contenir :

1. résumé exécutif ;
2. identification instrument ;
3. cours et performance ;
4. graphique historique ;
5. analyse fondamentale ;
6. analyse technique ;
7. consensus analystes ;
8. actualités récentes ;
9. risques identifiés ;
10. catalyseurs positifs ;
11. score global ;
12. conclusion d’aide à la décision ;
13. notes personnelles.

### 3.6 Décision d’investissement assistée

L’application doit aider à classer un titre dans une des catégories suivantes :

- `BUY_NOW` : acheter maintenant ;
- `WAIT_ENTRY_POINT` : attendre un meilleur point d’entrée ;
- `WATCH` : surveiller ;
- `AVOID` : éviter ;
- `TAKE_PROFIT` : prendre bénéfice si déjà détenu ;
- `SELL` : vendre si déjà détenu.

La décision proposée doit toujours être accompagnée d’une justification. L’application ne doit jamais présenter une décision comme une recommandation financière certaine.

---

## 4. Choix de stack technique

### 4.1 Stack recommandée

Le projet doit être construit avec une architecture simple, locale, modulaire et efficace dans VS Code.

| Couche | Choix recommandé | Raison |
|---|---|---|
| Frontend | Next.js + React + TypeScript | Interface moderne, composants réutilisables, bon support VS Code/Copilot, routage App Router. |
| Backend | Python FastAPI | Très adapté aux APIs, à la finance quantitative, à pandas, aux calculs d’indicateurs et aux futures intégrations IBKR. |
| Base de données | MariaDB | Choix imposé, robuste, SQL relationnel, facile à lancer en local avec Docker ou Homebrew. |
| ORM | SQLAlchemy 2.x | Standard Python robuste, compatible MariaDB, explicite, maintenable. |
| Migrations | Alembic | Outil standard avec SQLAlchemy. |
| Validation | Pydantic v2 | Validation stricte des entrées/sorties API. |
| Graphiques | Recharts ou ECharts côté frontend | Graphiques de prix et indicateurs. |
| UI | Tailwind CSS + shadcn/ui | Développement rapide, composants propres, très compatible avec Copilot. |
| Tests backend | pytest | Standard Python. |
| Tests frontend | Vitest + Testing Library | Tests unitaires React/TypeScript. |
| Qualité Python | Ruff + mypy | Lint, formatage, typage. |
| Qualité TS | ESLint + Prettier | Standards frontend. |
| Conteneurs | Docker Compose | MariaDB local, option backend/frontend conteneurisés plus tard. |
| Gestion secrets | `.env` local non versionné | Clés API, DB URL, IBKR settings. |

### 4.2 Architecture logique

Architecture cible :

```text
[Frontend Next.js]
        |
        | HTTP JSON / REST
        v
[Backend FastAPI]
        |
        | SQLAlchemy ORM
        v
[MariaDB]
        ^
        |
[Connecteurs données externes]
Yahoo / FMP / Alpha Vantage / Twelve Data / IBKR plus tard
```

Le frontend ne doit jamais appeler directement la base de données. Toutes les écritures et lectures applicatives passent par l’API FastAPI.

### 4.3 Pourquoi ne pas tout faire dans Next.js ?

Un backend Python séparé est préférable car :

- l’analyse de données financières est plus simple en Python ;
- pandas, numpy et bibliothèques d’indicateurs techniques sont disponibles ;
- l’API IBKR Python pourra être intégrée plus naturellement ;
- la séparation frontend/backend rend l’architecture plus claire ;
- Copilot pourra générer des modules spécialisés par couche.

### 4.4 Versions recommandées

Recommandations initiales :

- Python 3.12 ou 3.13 ;
- Node.js 24 LTS ;
- MariaDB 11.8 stable ou version LTS/stable disponible dans l’environnement ;
- FastAPI version récente ;
- SQLAlchemy 2.x ;
- Pydantic 2.x ;
- Next.js version récente avec App Router ;
- TypeScript strict.

---

## 5. Structure du repository

Le repository doit suivre cette structure :

```text
investment-market-analyzer/
├── README.md
├── docker-compose.yml
├── .env.example
├── .gitignore
├── .github/
│   └── copilot-instructions.md
├── .vscode/
│   ├── extensions.json
│   ├── settings.json
│   └── tasks.json
├── docs/
│   ├── SPECIFICATION_TECHNIQUE.md
│   ├── ARCHITECTURE.md
│   ├── DATABASE_SCHEMA.md
│   ├── API_CONTRACT.md
│   ├── BACKLOG_MVP.md
│   ├── CODING_STANDARDS.md
│   └── SECURITY.md
├── db/
│   ├── schema_mariadb.sql
│   └── seed_dev.sql
├── backend/
│   ├── pyproject.toml
│   ├── alembic.ini
│   ├── alembic/
│   │   ├── env.py
│   │   └── versions/
│   ├── app/
│   │   ├── main.py
│   │   ├── core/
│   │   │   ├── config.py
│   │   │   ├── logging.py
│   │   │   └── errors.py
│   │   ├── db/
│   │   │   ├── session.py
│   │   │   └── base.py
│   │   ├── models/
│   │   ├── schemas/
│   │   ├── repositories/
│   │   ├── services/
│   │   ├── connectors/
│   │   │   ├── market_data/
│   │   │   ├── news/
│   │   │   └── ibkr/
│   │   ├── analysis/
│   │   │   ├── technical_indicators.py
│   │   │   ├── scoring.py
│   │   │   └── summaries.py
│   │   └── api/
│   │       └── v1/
│   │           ├── router.py
│   │           ├── instruments.py
│   │           ├── watchlist.py
│   │           ├── searches.py
│   │           ├── prices.py
│   │           ├── news.py
│   │           └── analysis.py
│   └── tests/
└── frontend/
    ├── package.json
    ├── next.config.ts
    ├── tsconfig.json
    ├── src/
    │   ├── app/
    │   ├── components/
    │   ├── features/
    │   ├── lib/
    │   ├── hooks/
    │   └── types/
    └── tests/
```

---

## 6. Modules backend

### 6.1 `core`

Responsabilités :

- configuration applicative ;
- chargement `.env` ;
- gestion des erreurs ;
- logging ;
- constantes globales ;
- configuration CORS ;
- configuration sécurité.

### 6.2 `db`

Responsabilités :

- création engine SQLAlchemy ;
- gestion sessions DB ;
- base déclarative ORM ;
- dépendance FastAPI `get_db()` ;
- intégration migrations Alembic.

### 6.3 `models`

Contient les modèles SQLAlchemy mappés aux tables MariaDB :

- Instrument ;
- Exchange ;
- Sector ;
- PriceBar ;
- Watchlist ;
- WatchlistItem ;
- SearchHistory ;
- NewsArticle ;
- FundamentalSnapshot ;
- AnalystConsensus ;
- TechnicalIndicatorSnapshot ;
- InvestmentAnalysis ;
- UserNote ;
- DataSource ;
- DataFetchLog.

### 6.4 `schemas`

Contient les modèles Pydantic utilisés pour :

- request body ;
- response body ;
- validation ;
- sérialisation ;
- contrats d’API stables.

### 6.5 `repositories`

Responsabilités :

- accès direct à la DB ;
- requêtes SQLAlchemy ;
- pagination ;
- tri ;
- filtres ;
- transactions courtes.

Les repositories ne doivent pas contenir de logique métier complexe.

### 6.6 `services`

Responsabilités :

- logique métier ;
- orchestration des repositories ;
- orchestration des connecteurs externes ;
- refresh des données ;
- création des fiches de synthèse ;
- scoring.

### 6.7 `connectors`

Responsabilités :

- encapsuler les appels externes ;
- normaliser les réponses ;
- gérer les erreurs API ;
- gérer les quotas ;
- enregistrer la source et la fraîcheur des données.

Exemples :

- `YahooFinanceConnector` ;
- `FinancialModelingPrepConnector` ;
- `AlphaVantageConnector` ;
- `TwelveDataConnector` ;
- `IbkrConnector` en phase ultérieure.

### 6.8 `analysis`

Responsabilités :

- calcul des indicateurs techniques ;
- calcul score fondamental ;
- calcul score technique ;
- calcul score news/sentiment ;
- synthèse décisionnelle ;
- comparaison secteur ;
- contrôle cohérence des données.

---

## 7. Modules frontend

### 7.1 Pages principales

Le frontend doit exposer les pages suivantes :

| Route | Description |
|---|---|
| `/` | Dashboard principal |
| `/search` | Recherche instrument |
| `/instruments/[id]` | Fiche détail instrument |
| `/watchlist` | Favoris |
| `/news` | Fil d’actualité général |
| `/sectors` | Vue par secteur |
| `/history` | Historique des recherches |
| `/settings` | Paramètres sources/API/local |

### 7.2 Composants principaux

Composants UI attendus :

- `MarketDashboard` ;
- `InstrumentSearchBar` ;
- `InstrumentCard` ;
- `PriceChart` ;
- `TechnicalIndicatorPanel` ;
- `FundamentalMetricsPanel` ;
- `AnalystConsensusPanel` ;
- `NewsFeed` ;
- `WatchlistTable` ;
- `DecisionSummaryCard` ;
- `RiskCatalystList` ;
- `UserNoteEditor` ;
- `DataFreshnessBadge` ;
- `SourceBadge` ;
- `LoadingState` ;
- `ErrorState`.

### 7.3 Gestion API côté frontend

Créer une couche `frontend/src/lib/api.ts` pour centraliser les appels HTTP.

Ne pas disperser les `fetch()` dans les composants.

Exemple de pattern attendu :

```ts
export async function searchInstruments(query: string): Promise<InstrumentSearchResult[]> {
  const response = await fetch(`${API_BASE_URL}/api/v1/instruments/search?q=${encodeURIComponent(query)}`);
  if (!response.ok) throw new Error("Failed to search instruments");
  return response.json();
}
```

### 7.4 État frontend

Pour le MVP :

- préférer Server Components et fetch côté page lorsque possible ;
- utiliser React state local pour formulaires simples ;
- utiliser TanStack Query seulement si besoin de cache client avancé ;
- ne pas introduire Redux pour le MVP.

---

## 8. Modèle de données MariaDB

### 8.1 Principes

Le modèle de données doit :

- séparer les instruments, marchés, secteurs et données temporelles ;
- conserver la source de chaque donnée importante ;
- historiser les prix ;
- stocker les analyses calculées ;
- permettre plusieurs watchlists ;
- permettre l’ajout futur d’un portefeuille IBKR ;
- garder les données utilisateur en local.

### 8.2 Tables principales

#### `exchanges`

Référentiel des places de cotation.

Champs :

- `id` ;
- `code` ;
- `name` ;
- `country` ;
- `currency` ;
- `timezone`.

#### `sectors`

Référentiel sectoriel.

Champs :

- `id` ;
- `name` ;
- `parent_sector_id`.

#### `instruments`

Instrument financier.

Champs :

- `id` ;
- `name` ;
- `ticker` ;
- `isin` ;
- `instrument_type` ;
- `exchange_id` ;
- `sector_id` ;
- `currency` ;
- `country` ;
- `figi` optionnel ;
- `ibkr_conid` optionnel ;
- `is_active` ;
- timestamps.

Contrainte :

- unique sur `(ticker, exchange_id)` ;
- index sur `isin` ;
- index full-text optionnel sur `name`.

#### `price_bars`

Historique OHLCV.

Champs :

- `id` ;
- `instrument_id` ;
- `bar_date` ;
- `timeframe` ;
- `open_price` ;
- `high_price` ;
- `low_price` ;
- `close_price` ;
- `adjusted_close` ;
- `volume` ;
- `source_id` ;
- timestamps.

Contrainte unique :

- `(instrument_id, bar_date, timeframe, source_id)`.

#### `watchlists`

Liste de favoris.

Champs :

- `id` ;
- `name` ;
- `description` ;
- `is_default` ;
- timestamps.

#### `watchlist_items`

Association instruments/favoris.

Champs :

- `id` ;
- `watchlist_id` ;
- `instrument_id` ;
- `target_entry_price` ;
- `target_exit_price` ;
- `user_thesis` ;
- `priority` ;
- timestamps.

#### `search_history`

Historique des recherches.

Champs :

- `id` ;
- `query` ;
- `query_type` ;
- `instrument_id` nullable ;
- `result_count` ;
- `summary` ;
- `created_at`.

#### `news_articles`

Actualités financières.

Champs :

- `id` ;
- `title` ;
- `url` ;
- `publisher` ;
- `published_at` ;
- `summary` ;
- `language` ;
- `sentiment_score` ;
- `source_id` ;
- timestamps.

#### `instrument_news`

Relation many-to-many entre instruments et actualités.

Champs :

- `instrument_id` ;
- `news_article_id` ;
- `relevance_score`.

#### `fundamental_snapshots`

Données fondamentales à une date donnée.

Champs :

- `id` ;
- `instrument_id` ;
- `snapshot_date` ;
- `fiscal_year` ;
- `fiscal_period` ;
- `revenue` ;
- `revenue_growth` ;
- `operating_margin` ;
- `net_income` ;
- `eps` ;
- `free_cash_flow` ;
- `net_debt` ;
- `pe_ratio` ;
- `ev_ebitda` ;
- `price_to_sales` ;
- `dividend_yield` ;
- `source_id` ;
- timestamps.

#### `analyst_consensus`

Consensus analystes.

Champs :

- `id` ;
- `instrument_id` ;
- `snapshot_date` ;
- `buy_count` ;
- `hold_count` ;
- `sell_count` ;
- `rating_average` ;
- `target_price_mean` ;
- `target_price_high` ;
- `target_price_low` ;
- `currency` ;
- `source_id` ;
- timestamps.

#### `technical_indicator_snapshots`

Indicateurs techniques calculés.

Champs :

- `id` ;
- `instrument_id` ;
- `snapshot_date` ;
- `close_price` ;
- `sma_20` ;
- `sma_50` ;
- `sma_200` ;
- `ema_20` ;
- `rsi_14` ;
- `macd` ;
- `macd_signal` ;
- `macd_histogram` ;
- `support_level` ;
- `resistance_level` ;
- `trend_signal` ;
- timestamps.

#### `investment_analyses`

Analyse synthétique d’un instrument.

Champs :

- `id` ;
- `instrument_id` ;
- `analysis_date` ;
- `horizon` ;
- `fundamental_score` ;
- `technical_score` ;
- `analyst_score` ;
- `news_score` ;
- `risk_score` ;
- `global_score` ;
- `decision` ;
- `executive_summary` ;
- `positive_factors` JSON ;
- `negative_factors` JSON ;
- `risks` JSON ;
- `catalysts` JSON ;
- `data_quality_warning` ;
- timestamps.

#### `user_notes`

Notes personnelles.

Champs :

- `id` ;
- `instrument_id` ;
- `note_text` ;
- `decision` ;
- `confidence_level` ;
- timestamps.

#### `data_sources`

Sources de données.

Champs :

- `id` ;
- `name` ;
- `source_type` ;
- `base_url` ;
- `requires_api_key` ;
- `is_enabled` ;
- `priority` ;
- timestamps.

#### `data_fetch_logs`

Journal des collectes.

Champs :

- `id` ;
- `source_id` ;
- `endpoint` ;
- `status` ;
- `http_status` ;
- `error_message` ;
- `fetched_at` ;
- `duration_ms`.

---

## 9. Contrat API REST

Toutes les routes backend doivent être préfixées par `/api/v1`.

### 9.1 Health

#### `GET /api/v1/health`

Retour :

```json
{
  "status": "ok",
  "app": "investment-market-analyzer",
  "version": "0.1.0"
}
```

### 9.2 Instruments

#### `GET /api/v1/instruments/search?q={query}`

Recherche un instrument par nom, ticker ou ISIN.

Retour :

```json
[
  {
    "id": 1,
    "name": "ASML Holding N.V.",
    "ticker": "ASML",
    "isin": "NL0010273215",
    "exchange": "Euronext Amsterdam",
    "currency": "EUR",
    "sector": "Semiconductors"
  }
]
```

#### `GET /api/v1/instruments/{instrument_id}`

Retourne la fiche instrument de base.

#### `POST /api/v1/instruments/resolve`

Résout un instrument via une source externe si absent de la base locale.

Body :

```json
{
  "query": "ASML",
  "preferred_exchange": "XAMS"
}
```

### 9.3 Prix

#### `GET /api/v1/instruments/{instrument_id}/prices?timeframe=1d&from=2025-01-01&to=2026-05-17`

Retourne les données OHLCV.

#### `POST /api/v1/instruments/{instrument_id}/prices/refresh`

Force le rafraîchissement des prix via connecteur externe.

### 9.4 Indicateurs techniques

#### `GET /api/v1/instruments/{instrument_id}/technical-snapshot`

Retourne le dernier snapshot technique calculé.

#### `POST /api/v1/instruments/{instrument_id}/technical-snapshot/recompute`

Recalcule les indicateurs techniques.

### 9.5 Watchlist

#### `GET /api/v1/watchlists`

Liste les watchlists.

#### `POST /api/v1/watchlists`

Crée une watchlist.

#### `GET /api/v1/watchlists/{watchlist_id}/items`

Retourne les favoris.

#### `POST /api/v1/watchlists/{watchlist_id}/items`

Ajoute un instrument aux favoris.

Body :

```json
{
  "instrument_id": 1,
  "target_entry_price": 620.0,
  "target_exit_price": 780.0,
  "priority": 1,
  "user_thesis": "Leader semi-conducteurs, correction récente intéressante."
}
```

#### `DELETE /api/v1/watchlists/{watchlist_id}/items/{instrument_id}`

Retire un favori.

### 9.6 Actualités

#### `GET /api/v1/news?sector=Semiconductors&region=EU&limit=20`

Retourne les actualités filtrées.

#### `GET /api/v1/instruments/{instrument_id}/news?limit=20`

Retourne les actualités d’un titre.

#### `POST /api/v1/news/refresh`

Rafraîchit les news.

### 9.7 Analyse

#### `GET /api/v1/instruments/{instrument_id}/analysis/latest`

Retourne la dernière analyse synthétique.

#### `POST /api/v1/instruments/{instrument_id}/analysis/generate`

Génère ou régénère une analyse.

Body :

```json
{
  "horizon": "3_6_MONTHS",
  "include_news": true,
  "include_technical": true,
  "include_fundamentals": true,
  "include_analyst_consensus": true
}
```

### 9.8 Historique

#### `GET /api/v1/search-history?limit=50`

Retourne les dernières recherches.

#### `POST /api/v1/search-history`

Crée une entrée d’historique.

### 9.9 Notes utilisateur

#### `GET /api/v1/instruments/{instrument_id}/notes`

Retourne les notes.

#### `POST /api/v1/instruments/{instrument_id}/notes`

Crée une note.

#### `PUT /api/v1/notes/{note_id}`

Met à jour une note.

#### `DELETE /api/v1/notes/{note_id}`

Supprime une note.

---

## 10. Logique de scoring

### 10.1 Score global

Le score global est une aide à la priorisation. Il ne doit pas être interprété comme une recommandation d’investissement certaine.

Score de 0 à 100 :

```text
global_score =
  0.30 * fundamental_score +
  0.25 * technical_score +
  0.20 * analyst_score +
  0.15 * news_score +
  0.10 * risk_adjustment_score
```

### 10.2 Interprétation

| Score | Interprétation |
|---:|---|
| 80-100 | Opportunité forte à analyser en priorité |
| 65-79 | Profil intéressant |
| 50-64 | Neutre / à surveiller |
| 35-49 | Risque élevé ou manque de visibilité |
| 0-34 | Profil défavorable |

### 10.3 Score technique initial

Le MVP doit calculer :

- SMA 20 ;
- SMA 50 ;
- SMA 200 ;
- RSI 14 ;
- tendance prix vs moyennes mobiles ;
- momentum 1 mois / 3 mois ;
- support/résistance simple via plus bas/plus haut récents.

Exemple de règles :

- cours > SMA50 > SMA200 : signal positif ;
- cours < SMA50 < SMA200 : signal négatif ;
- RSI > 70 : surachat potentiel ;
- RSI < 30 : survente potentielle ;
- volume en hausse sur breakout : signal positif à confirmer.

### 10.4 Score fondamental initial

Le MVP peut rester simple :

- croissance CA ;
- marge opérationnelle ;
- dette nette ;
- PER relatif ;
- free cash-flow ;
- dividende si pertinent.

### 10.5 Score analystes

Basé sur :

- distribution buy/hold/sell ;
- objectif de cours moyen ;
- dispersion objectif haut/bas ;
- révisions récentes.

### 10.6 Score news

Basé sur :

- fréquence des actualités ;
- tonalité positive/négative ;
- importance de l’événement ;
- type d’événement : résultats, guidance, M&A, réglementation, profit warning.

---

## 11. Sources de données

### 11.1 Principe général

Chaque source doit être encapsulée derrière une interface commune afin de pouvoir remplacer facilement un fournisseur.

Interface conceptuelle :

```python
class MarketDataProvider:
    def search_instruments(self, query: str) -> list[InstrumentCandidate]: ...
    def get_price_history(self, symbol: str, start: date, end: date) -> list[PriceBar]: ...
    def get_quote(self, symbol: str) -> Quote: ...
```

### 11.2 Sources MVP possibles

Pour le MVP, privilégier des sources faciles à intégrer :

- Yahoo Finance via librairie Python ou endpoint non officiel pour prototypage ;
- Stooq pour certains historiques ;
- Financial Modeling Prep si abonnement/API key disponible ;
- Alpha Vantage si API key disponible ;
- Twelve Data si API key disponible.

### 11.3 Règles importantes

- Ne jamais supposer qu’une donnée est exacte sans source/date.
- Stocker la source et le timestamp de récupération.
- Prévoir un cache local.
- Prévoir le cas où une API rate-limit ou refuse une donnée.
- Éviter le scraping non autorisé.
- Prévoir un statut de qualité des données.

---

## 12. Intégration IBKR future

L’intégration Interactive Brokers n’est pas dans le MVP d’exécution. Elle peut être préparée structurellement.

### 12.1 Phase 1 — Read-only

- mapping instrument vers `ibkr_conid` ;
- récupération de contrats ;
- vérification place de cotation ;
- éventuellement récupération données si abonnement actif.

### 12.2 Phase 2 — Portefeuille

- récupération positions ;
- performance ;
- prix de revient ;
- devise ;
- exposition secteur/devise.

### 12.3 Phase 3 — Préparation d’ordre

- création d’un ticket local ;
- pas d’exécution automatique ;
- validation manuelle obligatoire.

### 12.4 Règles de sécurité IBKR

- aucune exécution d’ordre sans validation explicite ;
- journaliser chaque action ;
- vérifier place, devise, quantité, frais estimés ;
- désactiver toute stratégie automatique par défaut ;
- ajouter un mode simulation avant tout envoi réel.

---

## 13. Sécurité

### 13.1 Secrets

Ne jamais commiter :

- clés API ;
- tokens ;
- identifiants DB ;
- identifiants IBKR ;
- fichiers `.env` ;
- dumps DB personnels.

Utiliser `.env.example` pour documenter les variables attendues.

### 13.2 Local-first

L’application est locale. Les données restent dans MariaDB local.

### 13.3 CORS

Pour le développement local :

- autoriser `http://localhost:3000` ;
- backend sur `http://localhost:8000`.

Ne pas utiliser `allow_origins=["*"]` en configuration cible.

### 13.4 Validation

Tous les inputs API doivent être validés par Pydantic.

### 13.5 Logs

Ne jamais logger les secrets.

Logs utiles :

- source appelée ;
- durée ;
- status HTTP ;
- nombre d’éléments récupérés ;
- erreur sans secret ;
- instrument concerné.

---

## 14. Performance et cache

### 14.1 Principe

L’application ne doit pas appeler les sources externes à chaque affichage.

### 14.2 Stratégie MVP

- prix journaliers : rafraîchissement manuel ou quotidien ;
- fiche instrument : cache DB ;
- news : cache de 6 à 24 heures selon source ;
- fondamentaux : cache longue durée ;
- analystes : cache quotidien/hebdomadaire ;
- indicateurs techniques : recalcul après refresh prix.

### 14.3 Optimisations DB

Index à prévoir :

- `instruments.ticker` ;
- `instruments.isin` ;
- `instruments.name` ;
- `price_bars(instrument_id, bar_date)` ;
- `news_articles(published_at)` ;
- `search_history(created_at)` ;
- `investment_analyses(instrument_id, analysis_date)`.

---

## 15. MVP détaillé

### 15.1 Objectif MVP

Créer une première application utile permettant de :

1. lancer MariaDB en local ;
2. lancer FastAPI ;
3. lancer Next.js ;
4. rechercher un titre ;
5. stocker l’instrument en base ;
6. récupérer l’historique de prix ;
7. afficher un graphique ;
8. calculer SMA50, SMA200 et RSI14 ;
9. ajouter le titre à une watchlist ;
10. historiser la recherche ;
11. afficher une synthèse simple.

### 15.2 User stories MVP

#### US-001 — Setup local

En tant qu’utilisateur développeur, je veux démarrer l’application en local afin de développer dans VS Code.

Critères d’acceptation :

- `docker compose up -d db` démarre MariaDB ;
- backend accessible sur `localhost:8000` ;
- frontend accessible sur `localhost:3000` ;
- `/api/v1/health` retourne `ok`.

#### US-002 — Recherche instrument

En tant qu’utilisateur, je veux rechercher un titre par nom/ticker/ISIN afin d’obtenir une fiche.

Critères :

- champ de recherche ;
- appel API ;
- résultats listés ;
- possibilité de sélectionner un résultat ;
- création ou mise à jour en DB.

#### US-003 — Fiche instrument

En tant qu’utilisateur, je veux consulter les données principales d’un titre.

Critères :

- nom, ticker, ISIN, devise, bourse ;
- dernier prix ;
- graphique historique ;
- indicateurs SMA50/SMA200/RSI14 ;
- badge qualité/fraîcheur données.

#### US-004 — Watchlist

En tant qu’utilisateur, je veux ajouter un titre à mes favoris.

Critères :

- bouton ajouter ;
- liste favoris ;
- suppression possible ;
- note personnelle optionnelle.

#### US-005 — Historique

En tant qu’utilisateur, je veux retrouver mes recherches passées.

Critères :

- chaque recherche est stockée ;
- page historique ;
- tri chronologique descendant ;
- lien vers fiche instrument.

#### US-006 — Analyse technique simple

En tant qu’utilisateur, je veux voir un signal technique synthétique.

Critères :

- calcul SMA50 ;
- calcul SMA200 ;
- calcul RSI14 ;
- signal `POSITIVE`, `NEUTRAL`, `NEGATIVE` ;
- justification affichée.

---

## 16. Roadmap

### Phase 1 — Setup technique

Livrables :

- repo initial ;
- Docker Compose MariaDB ;
- backend FastAPI ;
- frontend Next.js ;
- healthcheck ;
- modèles DB initiaux ;
- migrations Alembic.

### Phase 2 — Recherche et instruments

Livrables :

- modèle `Instrument` ;
- API recherche ;
- page recherche ;
- stockage en base.

### Phase 3 — Prix et graphiques

Livrables :

- connecteur prix ;
- table `price_bars` ;
- endpoint historique ;
- graphique frontend.

### Phase 4 — Watchlist et historique

Livrables :

- tables watchlist ;
- endpoints CRUD ;
- pages frontend ;
- notes utilisateur.

### Phase 5 — Indicateurs techniques

Livrables :

- SMA ;
- RSI ;
- signal technique ;
- snapshot stocké.

### Phase 6 — News

Livrables :

- connecteur news ;
- table `news_articles` ;
- fil news général ;
- association news/instrument.

### Phase 7 — Fondamentaux et consensus analystes

Livrables :

- données fondamentales ;
- consensus ;
- valorisation ;
- scoring enrichi.

### Phase 8 — Préparation IBKR

Livrables :

- mapping contrat ;
- conid ;
- récupération portefeuille en read-only ;
- aucun ordre réel dans cette phase.

---

## 17. Standards de code

### 17.1 Backend Python

Règles :

- Python typé ;
- fonctions courtes ;
- séparation repository/service/schema ;
- pas de logique métier dans les routes ;
- erreurs métier explicites ;
- tests unitaires pour indicateurs et services ;
- migrations pour toute modification DB.

### 17.2 Frontend TypeScript

Règles :

- TypeScript strict ;
- composants fonctionnels ;
- composants petits et réutilisables ;
- appels API centralisés ;
- loading/error states systématiques ;
- pas de logique financière complexe côté frontend ;
- format monétaire et pourcentages cohérents.

### 17.3 Nommage

Backend :

- fichiers Python en `snake_case` ;
- classes en `PascalCase` ;
- fonctions en `snake_case` ;
- constantes en `UPPER_CASE`.

Frontend :

- composants React en `PascalCase` ;
- hooks en `useSomething` ;
- types en `PascalCase` ;
- fichiers composants en `PascalCase.tsx` ou convention cohérente.

---

## 18. Tests

### 18.1 Backend

Tests prioritaires :

- calcul RSI ;
- calcul SMA ;
- scoring ;
- repositories instrument ;
- endpoints health/search/watchlist ;
- gestion erreurs connecteurs.

### 18.2 Frontend

Tests prioritaires :

- SearchBar ;
- WatchlistTable ;
- InstrumentCard ;
- DataFreshnessBadge ;
- formatage devise ;
- gestion erreur API.

### 18.3 Tests d’intégration

À ajouter après le MVP :

- backend + MariaDB ;
- seed données ;
- workflow recherche -> fiche -> favori -> historique.

---

## 19. Commandes de développement attendues

### 19.1 Démarrage DB

```bash
docker compose up -d db
```

### 19.2 Backend

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -e ".[dev]"
alembic upgrade head
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### 19.3 Frontend

```bash
cd frontend
npm install
npm run dev
```

### 19.4 Tests

```bash
cd backend
pytest
ruff check .
mypy app

cd ../frontend
npm run lint
npm test
```

---

## 20. Variables d’environnement

Variables minimales :

```env
APP_NAME=investment-market-analyzer
APP_ENV=development
API_V1_PREFIX=/api/v1
BACKEND_CORS_ORIGINS=http://localhost:3000

DB_HOST=localhost
DB_PORT=3306
DB_NAME=investment_app
DB_USER=investment_user
DB_PASSWORD=investment_password
DATABASE_URL=mysql+pymysql://investment_user:investment_password@localhost:3306/investment_app

FRONTEND_API_BASE_URL=http://localhost:8000

FMP_API_KEY=
ALPHA_VANTAGE_API_KEY=
TWELVE_DATA_API_KEY=
NEWS_API_KEY=

IBKR_ENABLED=false
IBKR_HOST=127.0.0.1
IBKR_PORT=7497
IBKR_CLIENT_ID=1
```

---

## 21. Prompting Copilot recommandé

Lors de la génération du code, utiliser des prompts courts et précis, par exemple :

> En te basant sur `docs/SPECIFICATION_TECHNIQUE.md`, crée les modèles SQLAlchemy pour `Instrument`, `Exchange`, `Sector` et `PriceBar`, avec typage SQLAlchemy 2.x, relations, indexes et contraintes MariaDB.

> En te basant sur `docs/API_CONTRACT.md`, crée les routes FastAPI pour la recherche d’instruments. La route doit utiliser un service, pas accéder directement au repository.

> En te basant sur `docs/DATABASE_SCHEMA.md`, crée une migration Alembic initiale pour MariaDB.

> En te basant sur `docs/SPECIFICATION_TECHNIQUE.md`, crée la page Next.js `/search` avec une barre de recherche, l’affichage des résultats et la gestion loading/error.

> Implémente le calcul RSI 14 dans `backend/app/analysis/technical_indicators.py` avec tests pytest couvrant les cas limites.

---

## 22. Règles strictes pour Copilot

Copilot doit respecter ces règles :

1. Ne pas créer d’ordre de trading réel.
2. Ne pas stocker de secrets dans le code.
3. Ne pas appeler directement la DB depuis le frontend.
4. Ne pas mélanger logique métier et routes API.
5. Ne pas créer de scraping non autorisé par défaut.
6. Ne pas ignorer la source et la date de récupération des données.
7. Ne pas supprimer les migrations existantes.
8. Ne pas introduire Redux sans justification.
9. Ne pas créer une architecture microservices prématurée.
10. Ne pas afficher une recommandation comme une certitude.

---

## 23. Définition de fini pour le MVP

Le MVP est terminé lorsque :

- MariaDB démarre localement ;
- backend FastAPI démarre ;
- frontend Next.js démarre ;
- l’utilisateur peut rechercher un instrument ;
- l’instrument est stocké en DB ;
- l’utilisateur voit un graphique de prix ;
- les indicateurs techniques simples sont calculés ;
- l’utilisateur peut ajouter un favori ;
- l’historique de recherche est alimenté ;
- les tests critiques passent ;
- le README explique comment lancer le projet ;
- aucune clé secrète n’est versionnée.

---

## 24. Conclusion

Cette spécification doit guider la génération du code dans VS Code. L’objectif n’est pas de construire immédiatement une plateforme financière complète, mais un MVP solide, extensible et réellement utile pour structurer une décision d’investissement.

Priorité absolue :

1. architecture claire ;
2. modèle de données propre ;
3. recherche instrument ;
4. historique prix ;
5. watchlist ;
6. indicateurs techniques ;
7. historique d’analyse ;
8. extension progressive vers news, fondamentaux, analystes et IBKR.
