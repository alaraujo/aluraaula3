FROM golang:1.22-alpine AS build

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY ./controllers/ ./controllers/
COPY ./database/ ./database/
COPY ./models/ ./models/
COPY ./routes/ ./routes/
COPY ./main.go .
RUN go build -o main main.go

FROM alpine:latest AS production

WORKDIR /app
EXPOSE 8080

ENV PORT 8080
ENV DB_HOST postgres
ENV DB_USER root
ENV DB_PASSWORD root
ENV DB_NAME root
ENV DB_PORT 5432

COPY ./assets/ ./assets/
COPY ./templates/ ./templates/
COPY --from=build /app/main .

CMD ["./main"]
