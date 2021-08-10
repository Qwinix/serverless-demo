const csv = require("csvtojson");
const multer = require("multer");
const express = require("express");
const path = require("path");
const cookieParser = require("cookie-parser");
const logger = require("morgan");
const { PrismaClient } = require("@prisma/client");
const { memoryStorage } = require("multer");

const app = express();
const prisma = new PrismaClient();
const upload = multer({ storage: memoryStorage() });

app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

app.get("/api/v1/order/all", async (req, res) => {
  const result = await prisma.order.findMany({
    select: {
      uuid: true,
      item_type: true,
      order_id: true,
      order_date: true,
      ship_date: true,
      sold: true,
      price: true,
      cost: true,
      created_on: true,
    },
  });
  res.send(result);
});

app.get("/api/v1/order/:id", async (req, res) => {
  const result = await prisma.order.findUnique({
    where: {
      uuid: req.params.id,
    },
  });
  res.send(result);
});

app.get("/api/v1/profit/all", async (req, res) => {
  const result = await prisma.profit.findMany({
    select: true,
  });
  res.send(result);
});

app.post("/api/v1/profit/process", async (req, res) => {
  const group = await prisma.order.groupBy({
    by: ["item_type", "order_date"],
    _sum: {
      price: true,
      cost: true,
    },
  });
  const transactions = group.map(
    ({ item_type, order_date, _sum: { price, cost } }) =>
      prisma.profit.create({
        data: {
          item_type,
          order_date,
          total_cost: cost,
          total_revenue: price,
          total_profit: price - cost,
        },
      })
  );
  const result = await prisma.$transaction(transactions);
  res.send(result);
});

app.post("/api/v1/profit/process/daily", async (req, res) => {
  const today = new Date().toJSON().split("T").shift();
  const group = await prisma.order.groupBy({
    by: ["item_type", "order_date"],
    _sum: {
      price: true,
      cost: true,
    },
    where: {
      order_date: new Date(today),
    },
  });
  const transactions = group.map(
    ({ item_type, order_date, _sum: { price, cost } }) =>
      prisma.profit.create({
        data: {
          item_type,
          order_date,
          total_cost: cost,
          total_revenue: price,
          total_profit: price - cost,
        },
      })
  );
  const result = await prisma.$transaction(transactions);
  res.send(result);
});

app.post("/api/v1/order", async (req, res) => {
  const { item_type, order_id, order_date, ship_date, sold, price, cost } =
    req.body;
  const result = await prisma.order.create({
    data: {
      item_type,
      order_id,
      order_date: new Date(order_date),
      ship_date: new Date(ship_date),
      sold: parseInt(sold),
      price: parseFloat(price),
      cost: parseFloat(cost),
    },
  });
  return result;
});

app.post("/api/v1/upload", upload.single("file"), async (req, res) => {
  const raw = req.file.buffer.toString();
  const data = await csv().fromString(raw);
  const transactions = data.map((record) =>
    prisma.order.create({
      data: {
        item_type: record["Item Type"],
        order_id: record["Order ID"],
        order_date: new Date(record["Order Date"]),
        ship_date: new Date(record["Ship Date"]),
        sold: parseInt(record["Units Sold"]),
        price: parseFloat(record["Unit Price"]),
        cost: parseFloat(record["Unit Cost"]),
      },
    })
  );
  const result = await prisma.$transaction(transactions);
  res.send(result);
});

// error handler
app.use(function (err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get("env") === "development" ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render("error");
});

module.exports = app;
