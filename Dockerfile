FROM dart AS app
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get
COPY . ./
RUN dart pub get --offline
RUN dart compile exe /app/bin/mc_status.dart -o /app/bin/mc_status
RUN chmod +x ./bin/mc_status

FROM node as web
WORKDIR /web
COPY web/ ./
RUN npm i
RUN npm run build

FROM subfuzion/dart:slim
COPY --from=app /app/bin/mc_status /mc_status
COPY --from=web /web/public/ /web/public/
EXPOSE 8000
ENTRYPOINT ["/mc_status"]
CMD []