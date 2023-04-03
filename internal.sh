#!/bin/bash

sudo docker build -t itpercepthor/admin-dashboard:internal -f Dockerfile.internal .

sudo docker push itpercepthor/admin-dashboard:internal
