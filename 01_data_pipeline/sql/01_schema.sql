-- ============================================================
-- 01_schema.sql
-- Run once to create the table and all derived columns.
-- ============================================================

-- Allow Python to load local CSV/TSV files
SET GLOBAL local_infile = 1;

-- Main holdings table
CREATE TABLE IF NOT EXISTS nbim_holdings (
    year          INT          NOT NULL,
    nbim_id       VARCHAR(32)  NOT NULL,
    asset_class   VARCHAR(32),
    company       VARCHAR(255),
    ticker        VARCHAR(32),
    sector        VARCHAR(32),
    ownership     DOUBLE,
    value_usd     BIGINT,
    country_code  CHAR(2),
    incorporated  CHAR(2),
    sector_std    VARCHAR(64),
    fi_sector_std VARCHAR(64),

    PRIMARY KEY (year, asset_class, nbim_id),
    INDEX ix_ticker  (ticker),
    INDEX ix_country (country_code),
    INDEX ix_sector  (sector),
    INDEX ix_nbim_id (nbim_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;


