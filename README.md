# Java REST API Examples: Micronaut, Quarkus, Spring Boot, and Helidon

This repository contains example OAuth 2.0 resource servers built with Micronaut, Quarkus, Spring Boot, and Helidon. See [this demo script](demo.adoc) to learn how these apps were created.

**Prerequisites:** [Java 21 with GraalVM](https://sdkman.io/) and [HTTPie](https://httpie.io/).

* [Getting Started](#getting-started)
* [Links](#links)
* [Help](#help)
* [License](#license)

## Getting Started

First, clone this repository:

```bash
git clone https://github.com/oktadev/auth0-java-rest-api-examples.git
```

You will need a JDK with GraalVM and its native-image compiler. Using [SDKMAN](https://sdkman.io), run the following command and set it as the default:

```bash
sdk install java 21-graalce
```

Next, you'll need a [free Auth0 developer account](https://auth0.com/signup). 

Install the [Auth0 CLI](https://github.com/auth0/auth0-cli#installation) and run `auth0 login` to connect it to your account.

Create an access token using Auth0's CLI:

```shell
auth0 test token -a https://<your-auth0-domain>/api/v2/
```

Set the access token as a `TOKEN` environment variable in a terminal window.

```shell
TOKEN=eyJraWQiOiJYa2pXdjMzTDRBYU1ZSzNGM...
```

Change the following files for each framework to match your Auth0 domain:

- Micronaut: `micronaut/src/main/resources/application.properties`
- Quarkus: `quarkus/src/main/resources/application.properties`
- Spring Boot: `spring-boot/src/main/resources/application.properties`
- Helidon: `helidon/src/main/resources/META-INF/microprofile-config.properties`

You can start each app using its CLI, Gradle, or Maven. Note that you will only be able to start one at a time since they all run on port 8080.

- Micronaut: `./gradlew run`
- Micronaut [AOT](https://micronaut-projects.github.io/micronaut-gradle-plugin/latest/#_micronaut_aot_plugin): `./gradlew optimizedRun`
- Quarkus: `quarkus dev`
- Spring Boot: `./gradlew bootRun`
- Helidon: `helidon dev`

Then, you can test them with an access token and HTTPie.

Use HTTPie to pass the JWT in as a bearer token in the `Authorization` header.

```bash
http :8080/hello Authorization:"Bearer $TOKEN"
```

You should see your email address printed to your terminal.

You can also build and run each example as a native app.

- Micronaut: `./gradlew nativeCompile`
- Micronaut [AOT](https://micronaut-projects.github.io/micronaut-gradle-plugin/latest/#_micronaut_aot_plugin): `./gradlew nativeOptimizedCompile` - GraalVM executable compiled with Micronaut AOT optimizations
- Quarkus: `quarkus build --native`
- Spring Boot: `./gradlew nativeCompile`
- Helidon: `mvn package -Pnative-image`

Then, start each app as a native executable.

- Micronaut: `./build/native/nativeCompile/app`
- Micronaut AOT: `./build/native/nativeOptimizedCompile/app`
- Quarkus: `./build/quarkus-1.0.0-SNAPSHOT-runner`
- Spring Boot:  `./build/native/nativeCompile/spring-boot`
- Helidon: `./target/helidon`

## Links

This example uses the following open source libraries:

* [Micronaut](https://micronaut.io)
* [Quarkus](https://quarkus.io)
* [Spring Boot](https://spring.io/projects/spring-boot)
* [Helidon](https://helidon.io)

## Help

Please post any questions as issues in this repo or on the [Auth0 Community Forums](https://community.auth0.com/).

## License

Apache 2.0, see [LICENSE](LICENSE).
