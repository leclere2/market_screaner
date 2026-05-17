# Database schema — MariaDB

La base de données cible s’appelle `investment_app`.

Le DDL de référence est disponible dans `db/schema_mariadb.sql`. Les changements effectifs doivent ensuite être gérés par Alembic.

## Tables MVP obligatoires

1. `exchanges`
2. `sectors`
3. `data_sources`
4. `instruments`
5. `price_bars`
6. `watchlists`
7. `watchlist_items`
8. `search_history`
9. `technical_indicator_snapshots`
10. `user_notes`

## Tables post-MVP

1. `news_articles`
2. `instrument_news`
3. `fundamental_snapshots`
4. `analyst_consensus`
5. `investment_analyses`
6. `data_fetch_logs`

## Relations clés

```text
exchanges 1---N instruments
sectors 1---N instruments
instruments 1---N price_bars
instruments N---N news_articles via instrument_news
watchlists 1---N watchlist_items
instruments 1---N watchlist_items
instruments 1---N search_history
instruments 1---N technical_indicator_snapshots
instruments 1---N investment_analyses
instruments 1---N user_notes
data_sources 1---N price_bars
data_sources 1---N news_articles
data_sources 1---N fundamental_snapshots
data_sources 1---N analyst_consensus
```

## Index importants

- `instruments(ticker, exchange_id)` unique.
- `instruments(isin)`.
- `instruments(name)`.
- `price_bars(instrument_id, bar_date)`.
- `price_bars(instrument_id, bar_date, timeframe, source_id)` unique.
- `news_articles(published_at)`.
- `search_history(created_at)`.
- `investment_analyses(instrument_id, analysis_date)`.

## Types financiers

Utiliser `DECIMAL`, jamais `FLOAT`, pour les prix, ratios et montants financiers stockés.

Recommandation :

- prix : `DECIMAL(20,6)` ;
- grands montants : `DECIMAL(24,4)` ;
- ratios : `DECIMAL(20,6)` ;
- scores : `DECIMAL(6,2)`.

## Règles de migration

- Toute modification structurelle passe par Alembic.
- Ne jamais modifier manuellement la DB locale sans migration si le changement doit être versionné.
- Nommer les migrations clairement : `create_instruments_tables`, `add_technical_snapshots`, etc.
- Garder les migrations petites et cohérentes.
