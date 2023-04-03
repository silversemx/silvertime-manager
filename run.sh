#!/bin/bash

flutter run -d chrome --web-hostname 0.0.0.0 --web-port 3001 \
--dart-define=RUNTIME=Development --dart-define=SERVER_URL=https://service.silverse.com \
--dart-define=FORCE_BEARER_TOKEN=NONE \
--dart-define=LOGIN_URL=http://login.localhost.com \
--dart-define=DOMAIN=0.0.0.0 \
--dart-define=JWT_KEY=silverse-dev-jwt \
--dart-define=APP_NAME=Silverse-Admin