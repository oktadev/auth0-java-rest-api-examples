#!/usr/bin/env bash

# exit when any command fails
set -e

rm -rf {micronaut,quarkus,spring-boot}/build
rm -rf helidon/target

cd micronaut && ./gradlew nativeCompile

cd ../quarkus && ./gradlew build -Dquarkus.package.type=native

cd ../spring-boot && ./gradlew nativeCompile

cd ../helidon && mvn package -Pnative-image
