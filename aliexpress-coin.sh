#!/bin/bash

source .env

curl -X POST -F content="${MESSAGE}" ${WEBHOOK_URL}

