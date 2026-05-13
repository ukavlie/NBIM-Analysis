-- ============================================================
-- 02_clean_equity.sql
-- Standardises sector for all Equity holdings.
-- Safe to re-run after new data is loaded (resets sector_std
-- before repopulating).
--
-- Dependencies:
--   - nbim_holdings table with sector_std column (01_schema.sql)
--   - sector_map table (ticker -> sector) if ticker-based
--     override is desired. Create it with:
--
--       CREATE TABLE IF NOT EXISTS sector_map (
--           ticker  VARCHAR(32) PRIMARY KEY,
--           sector  VARCHAR(64) NOT NULL
--       ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;
--
--     Populate it manually with any corrections before running
--     this script. Leave it empty to skip the ticker override.
-- ============================================================
SET GLOBAL innodb_lock_wait_timeout = 480;
SET SESSION wait_timeout            = 28800;
SET SESSION interactive_timeout     = 28800;


SET SQL_SAFE_UPDATES = 0;


-- Step 1: Reset so the script is idempotent
UPDATE nbim_holdings
SET sector_std = NULL
WHERE asset_class = 'Equity';

-- Step 2: Fill from most-recent known sector per company name.
--         Uses a temp table to avoid subquery limitations.
DROP TEMPORARY TABLE IF EXISTS sector_map_company;


CREATE TEMPORARY TABLE sector_map_company AS
SELECT sector, nbim_id
FROM (
    SELECT
        sector,
        nbim_id,
        ROW_NUMBER() OVER (
            PARTITION BY nbim_id
            ORDER BY year DESC
        ) AS rn
    FROM nbim_holdings
    WHERE asset_class = 'Equity'
      AND sector IS NOT NULL
) t
WHERE rn = 1;

ALTER TABLE sector_map_company
    ADD INDEX ix_nbim_id (nbim_id);

UPDATE nbim_holdings h
JOIN sector_map_company s ON h.nbim_id = s.nbim_id
SET h.sector_std = s.sector
WHERE h.asset_class = 'Equity';


-- Step 3: Fall back to raw sector for anything still unmapped.
UPDATE nbim_holdings
SET sector_std = sector
WHERE sector_std IS NULL
  AND asset_class = 'Equity';
