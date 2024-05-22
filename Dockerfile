# # 构建阶段
# FROM golang:1.19-alpine AS builder

# RUN apk add --no-cache git

# WORKDIR /app

# COPY backend/go.mod backend/go.sum ./
# RUN go mod download

# COPY backend/ .

# RUN go build -o main .

# # 运行阶段
# FROM alpine:latest

# WORKDIR /root/

# COPY --from=builder /app/main .

# EXPOSE 8080

# CMD ["./main"]


# Dockerfile
# 多阶段构建
# Dockerfile
# 多阶段构建
# Dockerfile
# 多阶段构建
# Dockerfile
# 多阶段构建

# 构建阶段 - Go 应用
FROM golang:1.19-alpine AS go_builder

RUN apk add --no-cache git

WORKDIR /go_app

COPY backend/go.mod backend/go.sum ./
RUN go mod download

COPY backend/ .

RUN go build -o main .

# 构建阶段 - Vue 应用
FROM node:14 AS vue_builder

WORKDIR /vue_app

COPY suggestion_app/package*.json ./

RUN npm install

COPY suggestion_app/ .

RUN npm run build

# 运行阶段
FROM alpine:latest

# 安装nginx
RUN apk add --no-cache nginx

# Go 应用设置
WORKDIR /root/

COPY --from=go_builder /go_app/main .

# Vue 应用设置
COPY --from=vue_builder /vue_app/dist /usr/share/nginx/html

# 拷贝nginx配置文件
COPY nginx.conf /etc/nginx/nginx.conf

# Expose ports for both applications
EXPOSE 8080 80

# CMD to run both applications
CMD ["sh", "-c", "./main & nginx -g 'daemon off;'"]
