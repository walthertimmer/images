# https://hub.docker.com/r/apache/airflow
FROM apache/airflow:3.2.2-python3.13

# Versions can be overridden at build time.
# https://pypi.org/project/apache-airflow-providers-trino/
ARG AIRFLOW_TRINO_PROVIDER_VERSION=6.6.0
# https://pypi.org/project/dbt-trino/
ARG DBT_TRINO_VERSION=1.10.2 
# https://pypi.org/project/astronomer-cosmos/
ARG ASTRONOMER_COSMOS_VERSION=1.14.2
# https://pypi.org/project/pyiceberg/
ARG PYICEBERG_VERSION=0.11.1

# Install the Trino provider, dbt-trino, astronomer-cosmos, and pyiceberg.
# The Airflow constraint file cannot be used here because dbt-common requires
# older versions of isodate and pathspec than the constraint file pins.
RUN pip install --no-cache-dir \
        "apache-airflow-providers-trino==${AIRFLOW_TRINO_PROVIDER_VERSION}" \
        "dbt-trino==${DBT_TRINO_VERSION}" \
        "astronomer-cosmos==${ASTRONOMER_COSMOS_VERSION}" \
        "pyiceberg==${PYICEBERG_VERSION}"
