/*
  Warnings:

  - A unique constraint covering the columns `[iso3code]` on the table `countries` will be added. If there are existing duplicate values, this will fail.
  - Made the column `iso3code` on table `countries` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "countries" ALTER COLUMN "iso3code" SET NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "countries_iso3code_key" ON "countries"("iso3code");
