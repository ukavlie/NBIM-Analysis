-- ============================================================
-- 03_clean_fi.sql
-- Standardises fi_sector_std for all Fixed Income holdings.
-- Safe to re-run after new data is loaded.
--
-- Dependencies:
--   - nbim_holdings table with fi_sector_std column (01_schema.sql)
-- ============================================================

SET SQL_SAFE_UPDATES = 0;

-- Step 1: Reset so the script is idempotent
UPDATE nbim_holdings 
SET 
    fi_sector_std = NULL
WHERE
    asset_class = 'Fixed Income';

-- Step 2: Strip sub-category suffix (e.g. "Corporate/Senior" -> "Corporate")
UPDATE nbim_holdings 
SET 
    fi_sector_std = TRIM(SUBSTRING_INDEX(sector, '/', 1))
WHERE
    asset_class = 'Fixed Income';

-- Step 3: Normalise verbose legacy names to short standard labels
UPDATE nbim_holdings 
SET 
    fi_sector_std = 'Corporate'
WHERE
    fi_sector_std = 'Corporate Bonds'
        AND asset_class = 'Fixed Income';

UPDATE nbim_holdings 
SET 
    fi_sector_std = 'Government Related'
WHERE
    fi_sector_std = 'Government Related Bonds'
        AND asset_class = 'Fixed Income';

UPDATE nbim_holdings 
SET 
    fi_sector_std = 'Index Linked'
WHERE
    fi_sector_std = 'Index Linked Bonds'
        AND asset_class = 'Fixed Income';

-- Standardiser til fire kategorier
UPDATE nbim_holdings
SET 
    fi_sector_std = 'Government'
WHERE
    fi_sector_std = 'Treasuries'
        AND asset_class = 'Fixed Income';

UPDATE nbim_holdings
SET 
    fi_sector_std = 'Corporate'
WHERE
    fi_sector_std = 'Convertible Bonds'
        AND asset_class = 'Fixed Income';

UPDATE nbim_holdings
SET 
    fi_sector_std = 'Government'
WHERE
    fi_sector_std = 'Index Linked'
        AND asset_class = 'Fixed Income';

UPDATE nbim_holdings 
SET 
    fi_sector_std = 'Securitized'
WHERE
    fi_sector_std = 'Securitized Bonds'
        AND asset_class = 'Fixed Income';

-- Unike fi_sector_std per år
SELECT 
    year, fi_sector_std, COUNT(*) AS row_count
FROM
    nbim_holdings
WHERE
    asset_class = 'Fixed Income'
GROUP BY year , fi_sector_std
ORDER BY year , fi_sector_std
