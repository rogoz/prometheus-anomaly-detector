FROM python:3.8

ARG TARGETPLATFORM
ARG BUILDDIR=.
ARG APPDIR=app

ENV FLT_PROM_URL="https://prometheus-ns-team-arm-validation.corp.ethos21-stage-nld2.ethos.adobe.net"
ENV FLT_METRICS_LIST='usm_object_cpu_utilisation_value{aem_container_type="aem9-aem-publish", aem_env_name="dev42", aem_env_type="dev", aem_hipaa="false", aem_multi_region="false", aem_pod_type="publish", aem_program="AEM-K8s-Base", aem_program_type="standard", aem_sandbox="false", aem_service="aem9", aem_sla_9999="false", aem_tenant_id="aemk8s-helm-dev", cluster="ethos21stagenld2", namespace="ns-team-arm-validation"}'
ENV FLT_RETRAINING_INTERVAL_MINUTES=1
ENV FLT_DATA_START_TIME=3d
ENV FLT_ROLLING_TRAINING_WINDOW_SIZE=15d

RUN echo 'deb http://deb.debian.org/debian testing main' >> /etc/apt/sources.list

# Update the repos
RUN apt-get update -y

# Install the latest gcc (should be version 10)
RUN apt-get install -y gcc

# No need to install further packages so remove the lists to save space
RUN rm -rf /var/lib/apt/lists/*

# Install PyStan
RUN pip install --upgrade pip
COPY requirementsDocker.txt ${BUILDDIR}/
RUN pip install numpy
RUN pip install Cython
RUN pip install --pre pystan==2.14
RUN pip install -r requirementsDocker.txt
RUN mkdir -p ${APPDIR}
COPY *.py ${APPDIR}/
WORKDIR ${APPDIR}
RUN ls -l
CMD [ "python","app.py" ]

# docker container run -d --name test 6df8122222f36195fea5ee20b83976593b7b07958c938e366ec400609507c18c sleep infinity