#!/usr/bin/env bash

set -x
pg_dump --clean --create --format=plain --if-exists \
  --no-password --no-owner --no-acl advanced_search > spec/db/pg.dump
