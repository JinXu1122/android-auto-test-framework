# Docker Usage Guide

## Prerequisites

- Docker installed: https://docs.docker.com/get-docker/
- Docker Compose installed (optional): https://docs.docker.com/compose/install/

## Quick Start

### Build and run all tests

```bash
docker-compose up test-runner
```

### Run specific test suite

```bash
docker-compose up test-media
```

### View test results

```bash
open test-results/log.html
```

## Commands

| Command | Description |
|---------|-------------|
| `docker-compose up test-runner` | Run all tests in container |
| `docker-compose up test-media` | Run media tests only |
| `docker-compose up test-verbose` | Run with debug logging |
| `docker-compose up test-shell` | Open shell for debugging |

## Development Workflow

### 1. Edit test files locally

Test files are mounted from your local `tests/` directory.

### 2. Run tests in Docker

```bash
docker-compose up test-runner
```

### 3. View results locally

Results are saved to `test-results/` which is mounted as a volume.

## Advantages

- **Consistent environment**: Same Python/Robot Framework version everywhere
- **No local installation**: Works on any machine with Docker
- **Scalable**: Easy to run multiple test containers
- **Isolated**: Tests don't affect host system
