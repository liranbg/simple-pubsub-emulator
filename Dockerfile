# taken from https://github.com/GoogleCloudPlatform/cloud-sdk-docker/blob/master/emulators/Dockerfile
# with slight modifications to ensure image is minimize as much as possible while providing
# the emulator for pubsub
FROM python:slim-buster

ARG CLOUD_SDK_VERSION=337.0.0
ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION
ENV PATH /google-cloud-sdk/bin:$PATH

RUN mkdir -p /usr/share/man/man1/ && \
    apt-get update && \
    apt-get -y install \
        curl \
        openjdk-11-jre-headless && \
    curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image_emulator && \
    gcloud components remove anthoscli && \
    gcloud components install beta pubsub-emulator && \
    rm /google-cloud-sdk/data/cli/gcloud.json && \
    rm -rf /google-cloud-sdk/.install/.backup/ && \
    find /google-cloud-sdk/ -name "__pycache__" -type d  | xargs -n 1 rm -rf

ENV PROJECT=my-project
ENV VERBOSITY=debug

EXPOSE 9200

CMD gcloud beta emulators pubsub start \
    --project=$PROJECT \
    --verbosity=$VERBOSITY \
    --host-port=0.0.0.0:9200
