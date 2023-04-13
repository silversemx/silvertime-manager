#!/bin/bash

sudo docker build -t ermiry/silvertime-admin:latest -f Dockerfile .

sudo docker push ermiry/silvertime-admin
