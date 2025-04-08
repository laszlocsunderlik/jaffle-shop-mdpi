# Jaffle Shop

This project is a demonstration of using dbt with a PostgreSQL database, managed with Docker and UV.

There is a github CI pipeline implementation for pre-commit hooks using:
   - ruff-pre-commit
   - sqlfluff (lint and fix)

## Prerequisites

- Docker
- Python 3.8+
- UV (Universal Virtualenv)

## Setup Instructions

### 1. Clone the Repository

```bash
git clone git@github.com:laszlocsunderlik/jaffle-shop-playground.git
cd jaffle-shop-playground
```

### 2. Set Up Python Environment

#### Using UV

1. **Install UV**:

   ```bash
   pip install uv
   ```

2. **Create and activate venv**:

   ```bash
   uv venv
   source .venv/bin/activate
   ```

3. **Install Python dependencies**:

   ```bash
   uv pip install -e .
   ```

### 3. Set Up Docker

1. **Start PostgreSQL Database**:

   ```bash
   docker-compose up -d
   ```

   The initialization scripts are located in the `docker/init` directory.
   This script runs when the Docker container is initialized.
   It creates the 3 main schemas: raw, staging, mart

2. **Verify PosrgreSQL is running**:

   ```bash
   docker ps
   ```

### 4. Load sample data

0. **Start with a debug to see your are ready**

   ```bash
   dbt debug
   ```

1. **Download dbt packages**

   ```bash
   dbt deps
   ```

2. **Load csv files to db**:

   ```bash
   dbt seed
   ```

### 5. Run dbt models

1. **Execute Models**:

   ```bash
   dbt run
   ```

2. **Test models**:
   ```bash
   dbt test
   ```

### 6. Lint SQL files

1. **pre-commit runs**

   ```bash
   pre-commit run
   ```

## Database connection details

- **Host**: localhost
- **Port**: 5430
- **Database**: jaffle_shop
- **Username**: postgres
- **Password**: postgres

## Stopping the database

To stop the database container:

```bash
docker-compose down
```

Add the `-v` flag to also remove the volume and start fresh next time:

```bash
docker-compose down -v
```
