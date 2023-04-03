#!/bin/bash

flutter run -d chrome --web-hostname 0.0.0.0 --web-port 3001 \
--dart-define=RUNTIME=Development --dart-define=SERVER_URL=https://test.silvertime.silvertime.mx \
--dart-define=FORCE_BEARER_TOKEN=NONE \
--dart-define=LOGIN_URL=http://test.login.silverse.mx \
--dart-define=DOMAIN=0.0.0.0 \
--dart-define=JWT_KEY=silverse-dev-test-jwt \
--dart-define=APP_NAME=Silverse-Admin-Test