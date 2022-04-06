FROM cccs/assemblyline-v4-service-base:stable

# Python path to the service class from your service directory
#  The following example refers to the class "Sample" from the "sample.py" file
ENV SERVICE_PATH capa.Capa

# Install any service dependencies here
# For example: RUN apt-get update && apt-get install -y libyaml-dev
#              RUN pip install utils

USER root

RUN apt-get update && apt-get install -y \
    git \
    curl \
    python3-pip  \
    unzip \
    build-essential \
    wget \
    && rm -rf /var/lib/apt/lists/*
RUN curl -s https://api.github.com/repos/mandiant/capa/releases/latest | grep https.*capa.*linux.zip | cut -d : -f 2,3 | tr -d \" | wget -qi - -O capa.zip
RUN unzip capa.zip -d /opt

WORKDIR /opt/al_service

RUN git clone https://github.com/mandiant/capa
RUN git clone https://github.com/mandiant/capa-rules

# Switch to assemblyline user
USER assemblyline

# Copy Sample service code
WORKDIR /opt/al_service
COPY . .

ARG version=4.0.0.dev1
USER root
RUN sed -i -e "s/\$SERVICE_TAG/$version/g" service_manifest.yml

USER assemblyline
