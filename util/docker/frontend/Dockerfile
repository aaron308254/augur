FROM node:11 as build-stage

LABEL maintainer="c@carterlandis.com"
LABEL version="0.1.0"

WORKDIR /augur/
COPY ./util/docker/frontend/frontend.config.json .
RUN cp frontend.config.json augur.config.json

FROM build-stage as core-ui
WORKDIR /augur/frontend/
COPY frontend/package.json .
COPY frontend/package-lock.json .
RUN npm install
RUN npm install @vue/cli
COPY frontend/ .
RUN npm run build

FROM build-stage as augurface
WORKDIR /augur/augurface/
COPY augurface/package.json .
COPY augurface/package-lock.json .
RUN npm install
COPY augurface/ .
RUN npm run build

FROM nginx as production-stage
COPY --from=core-ui /augur/frontend/dist /usr/share/nginx/core
COPY --from=augurface /augur/augurface/dist /usr/share/nginx/augurface
COPY ./util/docker/frontend/nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
