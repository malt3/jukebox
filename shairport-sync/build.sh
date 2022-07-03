#!/bin/sh
docker buildx build --platform=linux/arm64 -o type=tar,dest=shairport-sync.tar .
