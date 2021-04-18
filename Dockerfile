FROM google/cloud-sdk:alpine

RUN apk --update --no-cache add openjdk8-jre \
    && gcloud components install beta pubsub-emulator

ENV PROJECT=my-project
ENV VERBOSITY=debug

EXPOSE 9200

CMD gcloud beta emulators pubsub start \
    --project=$PROJECT \
    --verbosity=$VERBOSITY \
    --host-port=0.0.0.0:9200
