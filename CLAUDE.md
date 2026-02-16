# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Docker-packaged wrapper around [humioctl](https://github.com/humio/cli) v0.39.0 for running search queries against the `ezp_developer` Humio/LogScale repository.

## Build & Run

```bash
docker build -t humiocli .
docker run --rm -e HUMIO_ADDR=https://your-instance -e HUMIO_TOKEN=your-token humiocli 'search query'
```

## Architecture

This is a single-Dockerfile project using a multi-stage build:

1. **Builder stage** (`golang:1.21-alpine`): Downloads humioctl source from GitHub (v0.39.0 zip), compiles the Go binary at `./cmd/humioctl`
2. **Runtime stage** (`alpine:3.19`): Copies the compiled binary; entrypoint is `humioctl search --repo=ezp_developer` with the search query appended from container arguments

Required environment variables: `HUMIO_ADDR` (instance URL) and `HUMIO_TOKEN` (API token).
