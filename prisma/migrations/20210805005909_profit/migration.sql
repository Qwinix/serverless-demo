/*
  Warnings:

  - You are about to drop the `DailyProfit` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
DROP TABLE "DailyProfit";

-- CreateTable
CREATE TABLE "Profit" (
    "uuid" UUID NOT NULL,
    "item_type" UUID NOT NULL,
    "order_date" DATE NOT NULL,
    "total_cost" DECIMAL(65,30) NOT NULL,
    "total_revenue" DECIMAL(65,30) NOT NULL,
    "total_profit" DECIMAL(65,30) NOT NULL,
    "created_on" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY ("uuid")
);
