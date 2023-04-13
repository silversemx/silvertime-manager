FROM cirrusci/flutter:3.3.7 as builder

WORKDIR "/home/silvertime"

ENV RUNTIME=Production
ENV SERVER_URL="https://time.silverse.mx"
ENV LOGIN_URL="https://login.silverse.mx"
ENV DOMAIN=".silverse.mx"
ENV JWT_KEY="silverse-jwt"
ENV APP_NAME="Silverse Admin"

COPY . .
RUN flutter clean
RUN flutter pub get
RUN flutter build web --dart-define=RUNTIME=${RUNTIME} \
	--dart-define=SERVER_URL=${SERVER_URL} \
	--dart-define=LOGIN_URL=${LOGIN_URL} \
	--dart-define=JWT_KEY=${JWT_KEY} \
	--dart-define=APP_NAME=${APP_NAME} \
	--dart-define=DOMAIN=${DOMAIN}

FROM nginx

COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /home/percepthor/build/web /usr/share/nginx/html

EXPOSE 3001
