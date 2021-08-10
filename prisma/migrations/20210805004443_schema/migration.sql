-- CreateTable
CREATE TABLE "Item" (
    "uuid" UUID NOT NULL,
    "name" TEXT NOT NULL,

    PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "Order" (
    "uuid" UUID NOT NULL,
    "item_id" UUID NOT NULL,
    "order_id" TEXT NOT NULL,
    "order_date" DATE NOT NULL,
    "ship_date" DATE NOT NULL,
    "sold" INTEGER NOT NULL,
    "price" DECIMAL(65,30) NOT NULL,
    "cost" DECIMAL(65,30) NOT NULL,

    PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "DailyProfit" (
    "uuid" UUID NOT NULL,
    "item_id" UUID NOT NULL,
    "order_date" DATE NOT NULL,
    "total_price" DECIMAL(65,30) NOT NULL,
    "total_cost" DECIMAL(65,30) NOT NULL,
    "total_revenue" DECIMAL(65,30) NOT NULL,

    PRIMARY KEY ("uuid")
);

-- CreateIndex
CREATE UNIQUE INDEX "DailyProfit.item_id_order_date_unique" ON "DailyProfit"("item_id", "order_date");

-- AddForeignKey
ALTER TABLE "Order" ADD FOREIGN KEY ("item_id") REFERENCES "Item"("uuid") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailyProfit" ADD FOREIGN KEY ("item_id") REFERENCES "Item"("uuid") ON DELETE CASCADE ON UPDATE CASCADE;
