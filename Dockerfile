
FROM golang:1.23.0-alpine AS builder

WORKDIR /app

# Копируем файлы зависимостей отдельно для кэширования
COPY go.mod go.sum ./
RUN go mod download

# Копируем остальной проект
COPY . .

# Собираем бинарный файл
RUN go build -o main .

# Финальный (production) образ
FROM alpine:latest

WORKDIR /app

# Копируем собранный бинарник из builder
COPY --from=builder /app/main .

# Запускаем бинарник
CMD ["./main"]