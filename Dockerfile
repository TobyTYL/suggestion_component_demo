# 构建阶段 - Vue 应用
FROM node:14 AS vue_builder

WORKDIR /vue_app

COPY suggestion_app/package*.json ./
RUN npm install

COPY suggestion_app/ .
RUN npm run build

# 构建阶段 - Go 应用
FROM golang:1.19-alpine AS go_builder

RUN apk add --no-cache git

WORKDIR /go_app

COPY backend/go.mod backend/go.sum ./
RUN go mod download

COPY backend/ .
RUN go build -o main .

# 运行阶段
FROM alpine:latest

# 安装 nginx 和其他必要的工具
RUN apk add --no-cache nginx

# 拷贝 Vue 应用构建输出
COPY --from=vue_builder /vue_app/dist /usr/share/nginx/html

# 拷贝 Go 应用
COPY --from=go_builder /go_app/main /usr/local/bin/main

# 拷贝 nginx 配置文件
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

# 暴露端口
EXPOSE 80 8081

# 启动命令
CMD ["sh", "-c", "/usr/local/bin/main & nginx -g 'daemon off;'"]
