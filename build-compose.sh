#!/bin/bash

PROJECTNAME="global_apps"
STAGE=${1:?STAGE is required}

if [ "$STAGE" = "dev" ]; then
  STAGE=$STAGE docker compose -p $PROJECTNAME -f docker-compose.yml -f docker-compose-override.yml up -d --build
elif [ "$STAGE" = "prod" ]; then
  VERSION=${2:?VERSION is required for prod}
  STAGE=$STAGE VERSION=$VERSION docker compose -p $PROJECTNAME -f docker-compose.yml up -d
else
  echo "Usage: $0 [dev|prod] [version]"
  echo "  dev:  $0 dev"
  echo "  prod: $0 prod 1.0.0"
  exit 1
fi