FROM node:18-slim AS web-builder
WORKDIR /app
COPY package.json package-lock.json ./
COPY server/package.json server/package.json
COPY web/package.json web/package.json
RUN npm ci && npm install --no-save --package-lock=false @rollup/rollup-linux-x64-gnu@4.60.1
COPY web ./web
RUN npm run build -w web

FROM nginx:alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=web-builder /app/web/dist /usr/share/nginx/html
EXPOSE 80
