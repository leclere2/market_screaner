# API Contract — FastAPI `/api/v1`

Toutes les réponses doivent être en JSON. Les erreurs doivent utiliser un format stable.

## Format d’erreur standard

```json
{
  "error": {
    "code": "INSTRUMENT_NOT_FOUND",
    "message": "Instrument not found",
    "details": {}
  }
}
```

## Health

### GET `/api/v1/health`

Response 200 :

```json
{
  "status": "ok",
  "app": "investment-market-analyzer",
  "version": "0.1.0"
}
```

## Instruments

### GET `/api/v1/instruments/search?q={query}`

Recherche par nom, ticker ou ISIN.

Response 200 :

```json
[
  {
    "id": 1,
    "name": "ASML Holding N.V.",
    "ticker": "ASML",
    "isin": "NL0010273215",
    "instrument_type": "EQUITY",
    "exchange": {"id": 1, "code": "XAMS", "name": "Euronext Amsterdam"},
    "sector": {"id": 2, "name": "Semiconductors"},
    "currency": "EUR",
    "country": "Netherlands"
  }
]
```

### GET `/api/v1/instruments/{instrument_id}`

Response 200 :

```json
{
  "id": 1,
  "name": "ASML Holding N.V.",
  "ticker": "ASML",
  "isin": "NL0010273215",
  "instrument_type": "EQUITY",
  "currency": "EUR",
  "country": "Netherlands",
  "exchange": {"id": 1, "code": "XAMS", "name": "Euronext Amsterdam"},
  "sector": {"id": 2, "name": "Semiconductors"},
  "latest_price": 650.25,
  "latest_price_date": "2026-05-15"
}
```

### POST `/api/v1/instruments/resolve`

Body :

```json
{
  "query": "ASML",
  "preferred_exchange": "XAMS"
}
```

## Prices

### GET `/api/v1/instruments/{instrument_id}/prices`

Query params :

- `timeframe`: `1d` par défaut.
- `from`: date ISO optionnelle.
- `to`: date ISO optionnelle.

Response :

```json
[
  {
    "date": "2026-05-15",
    "open": 640.0,
    "high": 655.0,
    "low": 638.0,
    "close": 650.25,
    "adjusted_close": 650.25,
    "volume": 1234567,
    "source": "Yahoo Finance"
  }
]
```

### POST `/api/v1/instruments/{instrument_id}/prices/refresh`

Force un refresh.

## Technical analysis

### GET `/api/v1/instruments/{instrument_id}/technical-snapshot`

Response :

```json
{
  "instrument_id": 1,
  "snapshot_date": "2026-05-15",
  "close_price": 650.25,
  "sma_50": 632.1,
  "sma_200": 610.8,
  "rsi_14": 58.2,
  "trend_signal": "POSITIVE",
  "explanation": "Price is above SMA50 and SMA200; RSI is neutral."
}
```

### POST `/api/v1/instruments/{instrument_id}/technical-snapshot/recompute`

Recalcule les indicateurs depuis les prix stockés.

## Watchlists

### GET `/api/v1/watchlists`

### POST `/api/v1/watchlists`

Body :

```json
{
  "name": "Opportunités Europe",
  "description": "Titres EUR à surveiller"
}
```

### GET `/api/v1/watchlists/{watchlist_id}/items`

### POST `/api/v1/watchlists/{watchlist_id}/items`

Body :

```json
{
  "instrument_id": 1,
  "target_entry_price": 620.0,
  "target_exit_price": 780.0,
  "priority": 1,
  "user_thesis": "Leader sectoriel avec potentiel moyen terme."
}
```

### DELETE `/api/v1/watchlists/{watchlist_id}/items/{instrument_id}`

## Search history

### GET `/api/v1/search-history?limit=50`

### POST `/api/v1/search-history`

Body :

```json
{
  "query": "ASML",
  "query_type": "TICKER",
  "instrument_id": 1,
  "result_count": 1,
  "summary": "Instrument found and opened."
}
```

## News

### GET `/api/v1/news?sector=Semiconductors&region=EU&limit=20`

### GET `/api/v1/instruments/{instrument_id}/news?limit=20`

### POST `/api/v1/news/refresh`

## Analysis

### GET `/api/v1/instruments/{instrument_id}/analysis/latest`

### POST `/api/v1/instruments/{instrument_id}/analysis/generate`

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
