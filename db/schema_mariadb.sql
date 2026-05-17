-- MariaDB schema for investment-market-analyzer
-- Version: 0.1 MVP baseline
-- This file is a reference DDL. Production schema should be managed through Alembic migrations.

CREATE DATABASE IF NOT EXISTS investment_app
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE investment_app;

CREATE TABLE IF NOT EXISTS exchanges (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(32) NOT NULL,
    name VARCHAR(255) NOT NULL,
    country VARCHAR(100) NULL,
    currency CHAR(3) NULL,
    timezone VARCHAR(100) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_exchanges_code (code)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS sectors (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    parent_sector_id BIGINT UNSIGNED NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_sectors_name (name),
    CONSTRAINT fk_sectors_parent FOREIGN KEY (parent_sector_id) REFERENCES sectors(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS data_sources (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    source_type VARCHAR(50) NOT NULL,
    base_url VARCHAR(500) NULL,
    requires_api_key BOOLEAN NOT NULL DEFAULT FALSE,
    is_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    priority INT NOT NULL DEFAULT 100,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_data_sources_name (name)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS instruments (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    ticker VARCHAR(50) NOT NULL,
    isin VARCHAR(12) NULL,
    instrument_type VARCHAR(50) NOT NULL DEFAULT 'EQUITY',
    exchange_id BIGINT UNSIGNED NULL,
    sector_id BIGINT UNSIGNED NULL,
    currency CHAR(3) NULL,
    country VARCHAR(100) NULL,
    figi VARCHAR(32) NULL,
    ibkr_conid VARCHAR(50) NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_instruments_ticker_exchange (ticker, exchange_id),
    KEY idx_instruments_isin (isin),
    KEY idx_instruments_name (name),
    KEY idx_instruments_sector_id (sector_id),
    CONSTRAINT fk_instruments_exchange FOREIGN KEY (exchange_id) REFERENCES exchanges(id),
    CONSTRAINT fk_instruments_sector FOREIGN KEY (sector_id) REFERENCES sectors(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS price_bars (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    instrument_id BIGINT UNSIGNED NOT NULL,
    bar_date DATE NOT NULL,
    timeframe VARCHAR(20) NOT NULL DEFAULT '1d',
    open_price DECIMAL(20, 6) NULL,
    high_price DECIMAL(20, 6) NULL,
    low_price DECIMAL(20, 6) NULL,
    close_price DECIMAL(20, 6) NOT NULL,
    adjusted_close DECIMAL(20, 6) NULL,
    volume BIGINT NULL,
    source_id BIGINT UNSIGNED NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_price_bars_unique (instrument_id, bar_date, timeframe, source_id),
    KEY idx_price_bars_instrument_date (instrument_id, bar_date),
    CONSTRAINT fk_price_bars_instrument FOREIGN KEY (instrument_id) REFERENCES instruments(id) ON DELETE CASCADE,
    CONSTRAINT fk_price_bars_source FOREIGN KEY (source_id) REFERENCES data_sources(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS watchlists (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NULL,
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_watchlists_name (name)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS watchlist_items (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    watchlist_id BIGINT UNSIGNED NOT NULL,
    instrument_id BIGINT UNSIGNED NOT NULL,
    target_entry_price DECIMAL(20, 6) NULL,
    target_exit_price DECIMAL(20, 6) NULL,
    user_thesis TEXT NULL,
    priority INT NOT NULL DEFAULT 3,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_watchlist_items_unique (watchlist_id, instrument_id),
    CONSTRAINT fk_watchlist_items_watchlist FOREIGN KEY (watchlist_id) REFERENCES watchlists(id) ON DELETE CASCADE,
    CONSTRAINT fk_watchlist_items_instrument FOREIGN KEY (instrument_id) REFERENCES instruments(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS search_history (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    query VARCHAR(255) NOT NULL,
    query_type VARCHAR(50) NOT NULL DEFAULT 'UNKNOWN',
    instrument_id BIGINT UNSIGNED NULL,
    result_count INT NOT NULL DEFAULT 0,
    summary TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_search_history_created_at (created_at),
    KEY idx_search_history_instrument_id (instrument_id),
    CONSTRAINT fk_search_history_instrument FOREIGN KEY (instrument_id) REFERENCES instruments(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS news_articles (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    url VARCHAR(1000) NOT NULL,
    publisher VARCHAR(150) NULL,
    published_at DATETIME NULL,
    summary TEXT NULL,
    language VARCHAR(10) NULL,
    sentiment_score DECIMAL(8, 4) NULL,
    source_id BIGINT UNSIGNED NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_news_articles_url (url(255)),
    KEY idx_news_articles_published_at (published_at),
    CONSTRAINT fk_news_articles_source FOREIGN KEY (source_id) REFERENCES data_sources(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS instrument_news (
    instrument_id BIGINT UNSIGNED NOT NULL,
    news_article_id BIGINT UNSIGNED NOT NULL,
    relevance_score DECIMAL(8, 4) NULL,
    PRIMARY KEY (instrument_id, news_article_id),
    CONSTRAINT fk_instrument_news_instrument FOREIGN KEY (instrument_id) REFERENCES instruments(id) ON DELETE CASCADE,
    CONSTRAINT fk_instrument_news_article FOREIGN KEY (news_article_id) REFERENCES news_articles(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS fundamental_snapshots (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    instrument_id BIGINT UNSIGNED NOT NULL,
    snapshot_date DATE NOT NULL,
    fiscal_year INT NULL,
    fiscal_period VARCHAR(20) NULL,
    revenue DECIMAL(24, 4) NULL,
    revenue_growth DECIMAL(10, 6) NULL,
    operating_margin DECIMAL(10, 6) NULL,
    net_income DECIMAL(24, 4) NULL,
    eps DECIMAL(20, 6) NULL,
    free_cash_flow DECIMAL(24, 4) NULL,
    net_debt DECIMAL(24, 4) NULL,
    pe_ratio DECIMAL(20, 6) NULL,
    ev_ebitda DECIMAL(20, 6) NULL,
    price_to_sales DECIMAL(20, 6) NULL,
    dividend_yield DECIMAL(10, 6) NULL,
    source_id BIGINT UNSIGNED NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_fundamental_snapshot (instrument_id, snapshot_date, fiscal_period, source_id),
    KEY idx_fundamental_instrument_date (instrument_id, snapshot_date),
    CONSTRAINT fk_fundamental_instrument FOREIGN KEY (instrument_id) REFERENCES instruments(id) ON DELETE CASCADE,
    CONSTRAINT fk_fundamental_source FOREIGN KEY (source_id) REFERENCES data_sources(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS analyst_consensus (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    instrument_id BIGINT UNSIGNED NOT NULL,
    snapshot_date DATE NOT NULL,
    buy_count INT NULL,
    hold_count INT NULL,
    sell_count INT NULL,
    rating_average DECIMAL(10, 4) NULL,
    target_price_mean DECIMAL(20, 6) NULL,
    target_price_high DECIMAL(20, 6) NULL,
    target_price_low DECIMAL(20, 6) NULL,
    currency CHAR(3) NULL,
    source_id BIGINT UNSIGNED NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_analyst_consensus (instrument_id, snapshot_date, source_id),
    CONSTRAINT fk_analyst_instrument FOREIGN KEY (instrument_id) REFERENCES instruments(id) ON DELETE CASCADE,
    CONSTRAINT fk_analyst_source FOREIGN KEY (source_id) REFERENCES data_sources(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS technical_indicator_snapshots (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    instrument_id BIGINT UNSIGNED NOT NULL,
    snapshot_date DATE NOT NULL,
    close_price DECIMAL(20, 6) NULL,
    sma_20 DECIMAL(20, 6) NULL,
    sma_50 DECIMAL(20, 6) NULL,
    sma_200 DECIMAL(20, 6) NULL,
    ema_20 DECIMAL(20, 6) NULL,
    rsi_14 DECIMAL(10, 6) NULL,
    macd DECIMAL(20, 6) NULL,
    macd_signal DECIMAL(20, 6) NULL,
    macd_histogram DECIMAL(20, 6) NULL,
    support_level DECIMAL(20, 6) NULL,
    resistance_level DECIMAL(20, 6) NULL,
    trend_signal VARCHAR(30) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_technical_snapshot (instrument_id, snapshot_date),
    CONSTRAINT fk_technical_instrument FOREIGN KEY (instrument_id) REFERENCES instruments(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS investment_analyses (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    instrument_id BIGINT UNSIGNED NOT NULL,
    analysis_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    horizon VARCHAR(50) NOT NULL DEFAULT '3_6_MONTHS',
    fundamental_score DECIMAL(6, 2) NULL,
    technical_score DECIMAL(6, 2) NULL,
    analyst_score DECIMAL(6, 2) NULL,
    news_score DECIMAL(6, 2) NULL,
    risk_score DECIMAL(6, 2) NULL,
    global_score DECIMAL(6, 2) NULL,
    decision VARCHAR(50) NULL,
    executive_summary TEXT NULL,
    positive_factors JSON NULL,
    negative_factors JSON NULL,
    risks JSON NULL,
    catalysts JSON NULL,
    data_quality_warning TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY idx_investment_analyses_instrument_date (instrument_id, analysis_date),
    CONSTRAINT fk_analyses_instrument FOREIGN KEY (instrument_id) REFERENCES instruments(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS user_notes (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    instrument_id BIGINT UNSIGNED NOT NULL,
    note_text TEXT NOT NULL,
    decision VARCHAR(50) NULL,
    confidence_level INT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY idx_user_notes_instrument_id (instrument_id),
    CONSTRAINT fk_user_notes_instrument FOREIGN KEY (instrument_id) REFERENCES instruments(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS data_fetch_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    source_id BIGINT UNSIGNED NULL,
    endpoint VARCHAR(500) NULL,
    status VARCHAR(50) NOT NULL,
    http_status INT NULL,
    error_message TEXT NULL,
    fetched_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    duration_ms INT NULL,
    KEY idx_data_fetch_logs_fetched_at (fetched_at),
    CONSTRAINT fk_fetch_logs_source FOREIGN KEY (source_id) REFERENCES data_sources(id)
) ENGINE=InnoDB;
