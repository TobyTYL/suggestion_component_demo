# 使用官方的 Go 语言镜像作为基础镜像
FROM golang:1.19-alpine AS builder

# 安装必要的依赖
RUN apk add --no-cache git

# 设置工作目录
WORKDIR /app

# 复制 go.mod 和 go.sum 文件
COPY backend/go.mod backend/go.sum ./

# 下载依赖
RUN go mod download

# 复制源码
COPY backend/ .

# 构建二进制文件
RUN go build -o main .

# 使用更小的基础镜像
FROM alpine:latest

# 设置工作目录
WORKDIR /app

# 复制构建的二进制文件和 init-mongo.js
COPY --from=builder /app/main .
COPY init-mongo.js .

# 暴露端口
EXPOSE 8080

# 启动服务
CMD ["./main"]
