# 构建阶段
FROM golang:1.19-alpine AS builder

RUN apk add --no-cache git

WORKDIR /app

COPY backend/go.mod backend/go.sum ./
RUN go mod download

COPY backend/ .

RUN go build -o main .

# 运行阶段
FROM alpine:latest

WORKDIR /root/

COPY --from=builder /app/main .

EXPOSE 8080

CMD ["./main"]
