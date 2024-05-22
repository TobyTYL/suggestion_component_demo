# 使用 Go 语言 1.19 镜像作为基础镜像
FROM golang:1.19

# 更新包列表并安装 git
RUN apt-get update && apt-get install -y git

# 设置工作目录
WORKDIR /app

# 将 go.mod 和 go.sum 复制到工作目录
COPY ./backend/go.mod ./backend/go.sum ./

# 下载依赖
RUN go mod download

# 复制整个项目到工作目录
COPY ./backend/ .

# 构建 Go 应用程序
RUN go build -o main .

# 暴露应用程序端口
EXPOSE 8080

# 运行可执行文件
CMD ["./main"]
