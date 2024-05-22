# 构建阶段 - Vue 应用
FROM node:14 AS vue_builder

WORKDIR /vue_app

COPY suggestion_app/package*.json ./
RUN npm install

COPY suggestion_app/ .
RUN npm run build

FROM golang:1.19-alpine AS go_builder

RUN apk add --no-cache git

WORKDIR /go_app

COPY backend/go.mod backend/go.sum ./
RUN go mod download

COPY backend/ .
RUN go build -o main .

FROM alpine:latest

RUN apk add --no-cache nginx

COPY --from=vue_builder /vue_app/dist /usr/share/nginx/html

COPY --from=go_builder /go_app/main /usr/local/bin/main

COPY nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 8080

CMD ["sh", "-c", "main & nginx -g 'daemon off;'"]
