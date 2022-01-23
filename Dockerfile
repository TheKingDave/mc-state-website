# syntax=docker/dockerfile:1
# On the basis of https://hub.docker.com/_/dart

FROM dart:stable AS app
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get
COPY bin/ ./bin/
COPY lib/ ./lib/
COPY analysis_options.yaml ./
RUN dart pub get --offline
RUN dart compile exe /app/bin/mc_status.dart -o /app/bin/mc_status
RUN chmod +x ./bin/mc_status

FROM node as web
WORKDIR /web
COPY web/ ./
RUN npm i
RUN npm run build

FROM scratch
COPY --from=app /runtime/ /
COPY --from=app /app/bin/mc_status /mc_status
COPY --from=web /web/public/ /web/public/

ENV HOST=0.0.0.0
EXPOSE 8000
CMD ["/mc_status"]
