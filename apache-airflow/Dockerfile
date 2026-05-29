# https://hub.docker.com/r/apache/airflow
FROM apache/airflow:3.2.2-python3.14

# Versions can be overridden at build time.
# https://pypi.org/project/apache-airflow/
ARG AIRFLOW_VERSION=3.2.2 
# https://pypi.org/project/apache-airflow-providers-trino/
ARG AIRFLOW_TRINO_PROVIDER_VERSION=6.6.0
# https://pypi.org/project/dbt-trino/
ARG DBT_TRINO_VERSION=1.10.2 
# https://pypi.org/project/astronomer-cosmos/
ARG ASTROMER_COSMOS_VERSION=1.14.2

# Install the Trino provider and dbt-trino using the official Airflow constraint
# file to prevent dependency conflicts.
RUN pip install --no-cache-dir \
        --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-3.14.txt" \
        "apache-airflow-providers-trino==${AIRFLOW_TRINO_PROVIDER_VERSION}" \
        "dbt-trino==${DBT_TRINO_VERSION}" \
        "astromer-cosmos==${ASTROMER_COSMOS_VERSION}"
