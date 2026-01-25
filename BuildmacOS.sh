#!/usr/bin/env bash
set -euo pipefail

echo "BuildmacOS.sh — 使用 Homebrew 的 Crow 编译示例"

BREW_PREFIX=""
if command -v brew >/dev/null 2>&1; then
  BREW_PREFIX="$(brew --prefix)"
  echo "Homebrew prefix detected: $BREW_PREFIX"
fi

# 选择 include 路径
if [ -n "${BREW_PREFIX}" ] && [ -f "${BREW_PREFIX}/include/crow/app.h" ]; then
  EXTRA_INCLUDES="-I${BREW_PREFIX}/include"
  echo "Using Crow headers from: ${BREW_PREFIX}/include/crow"
else
  EXTRA_INCLUDES="-I./include"
  echo "Using local include: ./include (no Homebrew Crow found)"
fi

CXX=clang++
CXXFLAGS="-std=c++17 -stdlib=libc++ -g ${EXTRA_INCLUDES} -I./include"

echo "$CXX $CXXFLAGS main.cpp -o main"
$CXX $CXXFLAGS main.cpp -o main

echo "Build complete: ./main"
echo "Run: ./main"
