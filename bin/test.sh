#!/usr/bin/env bash

set -e -x
psql < spec/db/pg.dump > /dev/null
bundle exec rspec
