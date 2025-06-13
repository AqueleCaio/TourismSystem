-- CreateTable
CREATE TABLE "users" (
    "id" SERIAL NOT NULL,
    "username" VARCHAR(50) NOT NULL,
    "email" VARCHAR(100),
    "password_hash" VARCHAR(255) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "indicators" (
    "id" VARCHAR(20) NOT NULL,
    "name" VARCHAR(100) NOT NULL,

    CONSTRAINT "indicators_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "countries" (
    "id" VARCHAR(20) NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "iso3code" CHAR(3) NOT NULL,

    CONSTRAINT "countries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tourism_data" (
    "id" SERIAL NOT NULL,
    "indicator_id" VARCHAR(20) NOT NULL,
    "country_id" VARCHAR(20) NOT NULL,
    "year" INTEGER NOT NULL,
    "value" DOUBLE PRECISION,
    "unit" VARCHAR(50),
    "obs_status" VARCHAR(50),

    CONSTRAINT "tourism_data_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tier_lists" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "tier_lists_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tier_list_items" (
    "id" SERIAL NOT NULL,
    "tier_list_id" INTEGER NOT NULL,
    "country_id" VARCHAR(20) NOT NULL,
    "position" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "tier_list_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "visited_countries" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "country_id" VARCHAR(20) NOT NULL,
    "rating" INTEGER,
    "visited_at" TIMESTAMP(3),

    CONSTRAINT "visited_countries_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_username_key" ON "users"("username");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "countries_iso3code_key" ON "countries"("iso3code");

-- CreateIndex
CREATE UNIQUE INDEX "visited_countries_user_id_country_id_key" ON "visited_countries"("user_id", "country_id");

-- AddForeignKey
ALTER TABLE "tourism_data" ADD CONSTRAINT "tourism_data_indicator_id_fkey" FOREIGN KEY ("indicator_id") REFERENCES "indicators"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tourism_data" ADD CONSTRAINT "tourism_data_country_id_fkey" FOREIGN KEY ("country_id") REFERENCES "countries"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tier_lists" ADD CONSTRAINT "tier_lists_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tier_list_items" ADD CONSTRAINT "tier_list_items_tier_list_id_fkey" FOREIGN KEY ("tier_list_id") REFERENCES "tier_lists"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tier_list_items" ADD CONSTRAINT "tier_list_items_country_id_fkey" FOREIGN KEY ("country_id") REFERENCES "countries"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "visited_countries" ADD CONSTRAINT "visited_countries_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "visited_countries" ADD CONSTRAINT "visited_countries_country_id_fkey" FOREIGN KEY ("country_id") REFERENCES "countries"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
