-- ============================================================
-- 99_reset.sql
-- Resets data for a clean re-load.
-- Choose ONE of the two options below depending on your need.
-- ============================================================

SET SQL_SAFE_UPDATES = 0;

-- OPTION A: Wipe all rows and re-load everything from Python.
--           Run this, then re-run 01_Setup.ipynb, then 02+03.
-- TRUNCATE TABLE nbim_holdings;


-- OPTION B: Keep raw data, only reset the derived/cleaned columns.
--           Run this, then re-run 02_clean_equity.sql and 03_clean_fi.sql.
-- UPDATE nbim_holdings
-- SET sector_std = NULL,
--     fi_sector_std = NULL;
