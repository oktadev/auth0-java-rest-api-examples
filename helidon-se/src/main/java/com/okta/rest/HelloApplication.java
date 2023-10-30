package com.okta.rest;

import java.net.URI;

import com.okta.rest.controller.HelloResource;

import io.helidon.common.configurable.Resource;
import io.helidon.config.Config;
import io.helidon.security.Security;
import io.helidon.security.providers.jwt.JwtProvider;
import io.helidon.webserver.WebServer;
import io.helidon.webserver.context.ContextFeature;
import io.helidon.webserver.http.HttpRouting;
import io.helidon.webserver.security.SecurityFeature;

public class HelloApplication {

  public static void main(String[] args) {

    var config = Config.global();
    var oauth =
        JwtProvider.builder()
            .issuer(config.get("se.jwt.verify.issuer").asString().get())
            .verifyJwk(
                Resource.create(
                    config
                        .get("se.jwt.verify.publickey.location")
                        .asString()
                        .map(URI::create)
                        .orElseThrow()))
            .build();

    Security security = Security.builder().addProvider(oauth).build();
    var securityFeature =
        SecurityFeature.create(
            sfb ->
                sfb.security(security)
                    .addPath(p -> p.path("/hello").handler(h -> h.authenticate(true))));

    WebServer.builder()
        .config(config.get("server"))
        .routing(HelloApplication::routing)
        .addFeature(ContextFeature.create())
        .addFeature(securityFeature)
        .build()
        .start();
  }

  /** Updates HTTP Routing. */
  static void routing(HttpRouting.Builder routing) {
    routing.addFeature(new HelloResource());
  }
}