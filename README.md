# simple-pubsub-emulator

A simple gcloud pubsub emulator

## Build

`docker build -t gcr.io/iguazio/nuclio/simple-pubsub-emulator:v1 .`

## Run

`docker run --detach --env PROJECT=my-project --name pubsub-emulator --publish 9200:9200 gcr.io/iguazio/nuclio/simple-pubsub-emulator:v1`

## Usage example

```go
package main

import (
    "context"
    "log"
    "os"

    "cloud.google.com/go/pubsub"
    "google.golang.org/api/option"
    "google.golang.org/grpc"
)

func run() error {
    ctx := context.TODO()

    // create grpc-based connection to pubsub emulator
    conn, err := grpc.Dial("0.0.0.0:9200", grpc.WithInsecure()) // local address, insecure
    if err != nil {
        os.Exit(1)
    }

    // create client
    client, err := pubsub.NewClient(ctx,
        "my-project",
        option.WithGRPCConn(conn),      // use insecure grpc connection
        option.WithTelemetryDisabled(), // disable telemetry
        option.WithoutAuthentication(), // do not authenticate - emulator
    )
    if err != nil {
        return err
    }

    // create topic
    topic, err := client.CreateTopic(ctx, "some-topic")
    if err != nil {
        return err
    }

    // send a message over topic
    topic.Publish(context.TODO(), &pubsub.Message{
        Data: []byte("Hello-world"),
    })
    return nil
}

func main() {
    if err := run(); err != nil {
        log.Fatalf("Failed: %v", err)
    }
}

```
