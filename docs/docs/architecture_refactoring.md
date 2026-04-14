# Conversation Export: Project Refactoring into Monorepo

**Date:** Monday, April 13, 2026
**Project:** Lyon 2027 Presidential Election Prediction

---

## 1. User Request
The user requested to divide the existing monolithic project (containing ML/ETL, a Dash frontend, and MkDocs documentation) into three distinct applications.
- **Backend:** ML and ETL with MySQL.
- **Frontend:** Dash app for data visualization (communicating with the backend DB).
- **Documentation:** MkDocs (isolated).

---

## 2. Strategy & Plan
A refactoring plan was developed to move the project to a Monorepo structure:
- **`backend/`**: ETL, ML, scripts, notebooks, and data layers.
- **`frontend/`**: Dash application.
- **`docs/`**: MkDocs documentation.
- **`docker-compose.yml`**: Updated to orchestrate `mysql`, `backend`, `frontend`, and `docs`.

---

## 3. Execution Steps

### File Reorganization
- Created `backend/src`, `frontend/src`, and `docs/src` directories.
- Moved ETL and ML code, data directories, and scripts into `backend/`.
- Moved the Dash application to `frontend/src/app.py`.
- Moved MkDocs content into `docs/`.

### Dependency Management
- Created service-specific `pyproject.toml` files:
    - **Backend**: Included `pyspark`, `scikit-learn`, `pandas`, `mysql-connector-python`.
    - **Frontend**: Included `dash`, `plotly`, `pandas`, `mysql-connector-python`.
    - **Docs**: Included `mkdocs-material`.

### Containerization
- Created unique `Dockerfiles` for each service.
- Updated `docker-compose.yml` to define the four services and their dependencies.
- Updated `.devcontainer/devcontainer.json` to point to the `backend` service for development.

### Documentation Updates
- Rewrote the root `README.md` to reflect the new architecture.
- Cleaned up redundant root configuration files (`Dockerfile`, `requirements.txt`, `pyproject.toml`).

---

## 4. Final Architecture

```text
/app
├── docker-compose.yml      # Orchestrates all services
├── README.md               # Root documentation
├── backend/                # ETL, ML, and Database
│   ├── src/                # ETL/ML Source
│   ├── data-raw/           # Raw Data
│   └── pyproject.toml      # Backend Deps
├── frontend/               # Dash BI
│   ├── src/app.py          # Dashboard
│   └── pyproject.toml      # Frontend Deps
└── docs/                   # Documentation
    ├── docs/               # Markdown files
    ├── mkdocs.yml          # MkDocs Config
    └── pyproject.toml      # Docs Deps
```

---

## 5. Verification
- All services are configured to run via `docker-compose up --build`.
- The frontend is mapped to port `8050`.
- Documentation is mapped to port `8000`.
- The backend development environment is accessible via VS Code Dev Containers.
