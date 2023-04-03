#!/bin/bash

sudo docker build -t itpercepthor/admin-dashboard:latest -f Dockerfile .

sudo docker push itpercepthor/admin-dashboard
