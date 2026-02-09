#!/bin/bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
source "${SCRIPT_PATH}/.env"

curl -X POST -F content="${MESSAGE}" ${WEBHOOK_URL}

