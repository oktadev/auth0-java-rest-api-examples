#!/usr/bin/env bash

# exit when any command fails
set -e

rm -rf {micronaut,quarkus,spring-boot}/build
rm -rf helidon/target

source ~/.sdkman/bin/sdkman-init.sh
sdk use java 22.3.3.r20-grl

echo "Building Micronaut..."
cd micronaut && ./gradlew nativeCompile

echo "Building Quarkus..."
cd ../quarkus && ./gradlew build -Dquarkus.package.type=native

echo "Building Spring Boot..."
cd ../spring-boot && ./gradlew nativeCompile

echo "Building Helidon..."
cd ../helidon && mvn package -Pnative-image
