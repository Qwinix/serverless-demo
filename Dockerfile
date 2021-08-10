FROM node:14 as builder

WORKDIR /app

COPY package*.json ./
COPY . .

RUN npm install

FROM node:14

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/bin ./bin
COPY --from=builder /app/app.js ./
COPY --from=builder /app/package*.json ./

CMD ["npm", "start"]