#!/usr/bin/env bash

CPATH="$(clang -v 2>&1 | grep "Selected GCC installation" | rev | cut -d' ' -f1 | rev)/include" \
  cargo build
