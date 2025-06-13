/*
  Warnings:

  - A unique constraint covering the columns `[country_id,year,indicator_id]` on the table `tourism_data` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "tourism_data" ADD COLUMN     "decimal" INTEGER DEFAULT 0;

-- CreateIndex
CREATE UNIQUE INDEX "tourism_data_country_id_year_indicator_id_key" ON "tourism_data"("country_id", "year", "indicator_id");
