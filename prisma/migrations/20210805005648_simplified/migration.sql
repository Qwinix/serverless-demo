/*
  Warnings:

  - You are about to drop the column `item_id` on the `DailyProfit` table. All the data in the column will be lost.
  - You are about to drop the column `item_id` on the `Order` table. All the data in the column will be lost.
  - You are about to drop the `Item` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `item_type` to the `DailyProfit` table without a default value. This is not possible if the table is not empty.
  - Added the required column `item_type` to the `Order` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "DailyProfit" DROP CONSTRAINT "DailyProfit_item_id_fkey";

-- DropForeignKey
ALTER TABLE "Order" DROP CONSTRAINT "Order_item_id_fkey";

-- DropIndex
DROP INDEX "DailyProfit.item_id_order_date_unique";

-- AlterTable
ALTER TABLE "DailyProfit" DROP COLUMN "item_id",
ADD COLUMN     "created_on" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "item_type" UUID NOT NULL;

-- AlterTable
ALTER TABLE "Order" DROP COLUMN "item_id",
ADD COLUMN     "created_on" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "item_type" TEXT NOT NULL;

-- DropTable
DROP TABLE "Item";

-- CreateIndex
CREATE INDEX "Order.item_type_index" ON "Order"("item_type");
