FROM cccs/assemblyline-v4-service-base:stable

# Python path to the service class from your service directory
#  The following example refers to the class "Sample" from the "sample.py" file
ENV SERVICE_PATH capa.Capa

# Install any service dependencies here
# For example: RUN apt-get update && apt-get install -y libyaml-dev
#              RUN pip install utils

USER root

RUN apt update
RUN apt-get install -y git
RUN apt install -y python3-pip
RUN pip install flare-capa

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
