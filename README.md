# 2027 Presidential Election Prediction Project (Lyon Scope)

This project is a multi-service application for predicting the 2027 French presidential elections in Lyon. It is divided into three main components: **Backend** (ETL/ML), **Frontend** (Dash BI), and **Documentation** (MkDocs).

## 🏗 Architecture

The project is organized as a monorepo with the following services:

- **`backend/`**: ETL pipelines (Spark), Machine Learning models (Scikit-learn), and Database management.
- **`frontend/`**: Interactive Dash BI dashboard for data visualization.
- **`docs/`**: Technical documentation site built with MkDocs.
- **`mysql`**: Dedicated database service for persistent storage.

## 🛠 Prerequisites

- **Docker Desktop** (or Engine on Linux).
- **Docker Compose**.
- **VS Code** with the **Dev Containers** extension (recommended for backend development).

## 🚀 Quick Start

### 1. Launch All Services

To start the entire stack (Database, Backend, Frontend, and Docs):

```bash
docker-compose up --build
```

- **Frontend (Dash)**: [http://localhost:8050](http://localhost:8050)
- **Documentation**: [http://localhost:8000](http://localhost:8000)
- **MySQL**: `localhost:3306`

### 2. Backend Development (Dev Container)

For active development on ETL or ML:
1. Open the project root in VS Code.
2. Reopen in Container (it will use the `backend` service).
3. The environment is pre-configured with Spark 3.5, Java 17, and all Python dependencies.

## 📂 Project Structure

```text
.
├── backend/                # ETL, ML, and Data Layers
│   ├── src/                # Source code (etl, ml, common)
│   ├── data-raw/           # Immutable source data
│   ├── bronze/silver/gold/ # Medallion data layers (Parquet)
│   ├── notebooks/          # Jupyter exploration
│   └── tests/              # Backend tests
├── frontend/               # Dash BI Application
│   └── src/app.py          # Dashboard entry point
├── docs/                   # MkDocs Documentation
│   ├── docs/               # Markdown files
│   └── mkdocs.yml          # Configuration
└── docker-compose.yml      # Orchestration
```

## ⚙️ Service Details

### Backend (ETL & ML)
Run an ETL script from within the backend container:
```bash
python -m src.etl.bronze.bronze_presidentielle
```

### Frontend (Dash BI)
The dashboard connects directly to the MySQL service. It is accessible at `http://localhost:8050`.

### Documentation
The documentation is served by MkDocs at `http://localhost:8000`. It is automatically reloaded when you modify files in `docs/docs/`.

## 💡 Best Practices

- **Service Isolation**: Keep dependencies separate in each service's `pyproject.toml`.
- **Path Centralization**: In the backend, use `src.config` to access data directories.
- **Database**: Use the `mysql` service name as the host when connecting from other containers.
