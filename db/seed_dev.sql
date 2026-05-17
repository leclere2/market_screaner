USE investment_app;

INSERT IGNORE INTO exchanges(code, name, country, currency, timezone) VALUES
('XPAR', 'Euronext Paris', 'France', 'EUR', 'Europe/Paris'),
('XAMS', 'Euronext Amsterdam', 'Netherlands', 'EUR', 'Europe/Amsterdam'),
('XLUX', 'Luxembourg Stock Exchange', 'Luxembourg', 'EUR', 'Europe/Luxembourg'),
('XETR', 'Xetra', 'Germany', 'EUR', 'Europe/Berlin'),
('NASDAQ', 'Nasdaq', 'United States', 'USD', 'America/New_York'),
('NYSE', 'New York Stock Exchange', 'United States', 'USD', 'America/New_York');

INSERT IGNORE INTO sectors(name) VALUES
('Technology'),
('Semiconductors'),
('Luxury'),
('Automotive'),
('Energy'),
('Banks'),
('Healthcare'),
('Defense'),
('Consumer Discretionary'),
('Industrials'),
('Utilities');

INSERT IGNORE INTO data_sources(name, source_type, base_url, requires_api_key, is_enabled, priority) VALUES
('Yahoo Finance', 'market_data', 'https://finance.yahoo.com', false, true, 100),
('Financial Modeling Prep', 'fundamentals', 'https://financialmodelingprep.com', true, false, 80),
('Alpha Vantage', 'market_data', 'https://www.alphavantage.co', true, false, 90),
('Twelve Data', 'market_data', 'https://twelvedata.com', true, false, 90),
('Interactive Brokers', 'broker', null, false, false, 50);

INSERT IGNORE INTO watchlists(name, description, is_default) VALUES
('Default', 'Watchlist principale', true);
