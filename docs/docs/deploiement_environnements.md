# Stratégie de Déploiement par Environnement (Analyse)

## Introduction
Ce document détaille les évolutions techniques nécessaires pour passer de l'environnement de développement actuel (basé sur Docker Compose local) vers des environnements de Pré-production (Staging) et de Production. La transition repose sur la séparation des responsabilités, la scalabilité et la sécurisation des accès.

---

## 1. Backend (ETL & Machine Learning)

L'application backend, responsable de l'ingestion Spark et de l'entraînement des modèles, doit passer d'un mode "batch local" à un mode "cloud managé".

### Pré-production (Staging)
- **Base de données :** Migration du conteneur MySQL local vers une instance de base de données managée (ex: **AWS RDS** ou **Google Cloud SQL**) avec isolation réseau (VPC). Les données de test doivent être représentatives de la production tout en étant anonymisées.
- **Stockage de données :** Remplacement des dossiers locaux (`bronze/`, `silver/`, `gold/`) par un stockage objet cloud (**Amazon S3** ou **GCS**). Le code Spark doit être configuré pour utiliser les URI du type `s3a://my-bucket/path`.
- **Orchestration :** Les scripts Bash manuels (`run_etl_pipeline.sh`) sont remplacés par un orchestrateur de workflows (**Apache Airflow**, **Dagster** ou **Prefect**) pour gérer les dépendances et les reprises en cas d'erreur.
- **Ressources :** Utilisation d'un cluster Spark éphémère (ex: **AWS EMR** ou **Dataproc**) ou de conteneurs sur Kubernetes (**EKS/GKE**) avec gestion fine des ressources CPU/RAM.

### Production
- **Disponibilité :** BDD configurée en **Multi-AZ** pour garantir la continuité de service.
- **Sécurisation :** Chiffrement au repos (KMS) pour le stockage S3 et transit chiffré. Accès IAM (Identity and Access Management) restrictifs.
- **Observabilité :** Monitoring détaillé via des outils comme **CloudWatch**, **Prometheus/Grafana** ou **Datadog**. Mise en place d'alertes automatiques en cas d'échec de job Spark.

---

## 2. Frontend (Dash BI)

L'application Dash doit évoluer pour supporter une charge simultanée de plusieurs utilisateurs et garantir une sécurité maximale.

### Pré-production (Staging)
- **Serveur Web :** Remplacement du serveur interne de Flask par un serveur WSGI robuste comme **Gunicorn** ou **Waitress**.
- **Reverse Proxy :** Utilisation d'un reverse proxy (**Nginx**) pour gérer les en-têtes, la compression et la sécurité des requêtes.
- **CI/CD :** Build automatique de l'image Docker via une pipeline (ex: GitHub Actions) et déploiement sur un service de conteneur managé (ex: **AWS App Runner** ou **Google Cloud Run**).

### Production
- **Scalabilité :** Déploiement multi-instances derrière un **Application Load Balancer (ALB)**. Configuration du scaling automatique (HPA) basé sur l'usage CPU/Mémoire.
- **Sécurité :** Désactivation totale du mode debug (`DEBUG=False`). Injection des secrets (clés DB, etc.) via un gestionnaire de secrets (**AWS Secrets Manager** or **HashiCorp Vault**).
- **HTTPS :** Terminaison SSL (HTTPS) au niveau du Load Balancer.

---

## 3. Documentation (MkDocs)

### Pré-production (Staging)
- **Build Statique :** Abandon de `mkdocs serve`. Le site est construit via `mkdocs build` dans la pipeline CI.
- **Hébergement :** Les fichiers statiques sont hébergés sur un bucket S3 configuré en mode "Static Website" ou sur **GitHub Pages** restreint à l'organisation.

### Production
- **Performance :** Mise en place d'un réseau de diffusion de contenu (**CDN** comme CloudFront) pour accélérer le chargement des pages et réduire la latence mondiale.
- **Nom de Domaine :** Association d'un nom de domaine dédié (ex: `docs.election-lyon.fr`).

---

## Synthèse Transverse

| Aspect | Développement | Pré-production | Production |
| :--- | :--- | :--- | :--- |
| **BDD** | Conteneur Docker local | RDS (Single Instance) | RDS (Multi-AZ + Backup) |
| **Stockage** | Système de fichiers local | S3 (Bucket Staging) | S3 (Bucket Prod chiffré) |
| **Secrets** | Fichier `.env` ou `.secrets` | Variables d'env (CI) | Secrets Manager / Vault |
| **Hébergement** | Docker Compose local | Kubernetes (Staging) | Kubernetes (Prod avec Auto-scaling) |
| **Logs** | Console / Fichier local | Centralisés (CloudWatch/ELK) | Centralisés + Alerting (OpsGenie) |
