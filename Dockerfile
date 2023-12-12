FROM apache/airflow:2.6.2-python3.10

COPY requirements ./requirements

USER root
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
         gcc \
         heimdal-dev \
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# install odbc 17 driver
RUN apt-get update \
  && apt-get install -y curl apt-transport-https gnupg2 \
  && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
  && curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list \
  && apt-get update \
  && ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools \
  && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc \
  && source ~/.bashrc

# install ca-certificates
RUN apt-get update && \
  apt-get install ca-certificates && \
  apt-get clean


# copy certs to container
RUN if [ ! -d "/usr/local/share/ca-certificates/ay" ]; then mkdir "/usr/local/share/ca-certificates/ay"; fi

RUN cp requirements/certs/* /usr/local/share/ca-certificates/ay

RUN update-ca-certificates

USER airflow

ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt


RUN pip install --upgrade pip

RUN pip install -r requirements/requirements.txt


ENV PYTHONPATH "${PYTHONPATH}:${AIRFLOW_HOME}/dags/ASI_AA_ETL/ASI_AA_DNI_Signals/dni_signals_dag"