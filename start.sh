#!/bin/bash

flutter run -d web-server --web-hostname 0.0.0.0 --web-port $PORT \
--dart-define=RUNTIME=${RUNTIME} --dart-define=SERVER_URL=${SERVER_URL} \
--dart-define=LOGIN_URL=${LOGIN_URL}
