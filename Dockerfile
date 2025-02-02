FROM node:lts-alpine AS builder
COPY . /app
WORKDIR /app

RUN npm install && npm run build

FROM alpine:3.15
RUN apk add --no-cache python3 py3-pip py3-pyldap py3-pytoml \
    && pip3 install 'Hypercorn==0.12.*'  'python-dotenv==0.19.*' \
        'Quart==0.16.*' 'Quart-CORS==0.5.*'

COPY . /app
COPY --from=builder /app/dist /app/dist
WORKDIR /app

EXPOSE 5000
CMD ["/usr/bin/hypercorn", "-b", "0.0.0.0:5000", "app:app"]
