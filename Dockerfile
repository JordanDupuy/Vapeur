FROM node:20-alpine AS builder

RUN apk update && apk add --no-cache bash sed   

WORKDIR /app

COPY package*.json ./

ENV PRISMA_SKIP_POSTINSTALL=true
RUN npm install

COPY . .
RUN chmod +x /app/entrypoint.sh

RUN npx prisma generate

FROM node:20-alpine AS final

RUN apk update && apk add --no-cache bash sed

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app .

EXPOSE 3042

ENTRYPOINT [ "/app/entrypoint.sh" ]