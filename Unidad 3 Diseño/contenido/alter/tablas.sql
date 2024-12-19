-- Uses mbta.db

-- Demonstrates removing a table

-- Removes riders table
DROP TABLE "riders";

-- Demonstrates renaming a table

-- Renames "vists" table to "swipes"
ALTER TABLE "visits" RENAME TO "swipes";


-- Demonstrates adding a column to a table

-- Adds "ttpe" column to "swipes" table (intentional typo)
ALTER TABLE "swipes" ADD COLUMN "ttpe" TEXT;


-- Demonstrates renaming a column


-- Fixes typo using RENAME COLUMN
ALTER TABLE "swipes" RENAME COLUMN "ttpe" TO "type";
