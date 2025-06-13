-- DropIndex
DROP INDEX "countries_iso3code_key";

-- AlterTable
ALTER TABLE "countries" ALTER COLUMN "iso3code" DROP NOT NULL,
ALTER COLUMN "iso3code" SET DATA TYPE VARCHAR(10);
