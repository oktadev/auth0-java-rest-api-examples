package com.okta.rest.controller;

import static io.helidon.http.Status.OK_200;

import io.helidon.common.media.type.MediaTypes;
import io.helidon.security.SecurityContext;
import io.helidon.webserver.http.HttpFeature;
import io.helidon.webserver.http.HttpRouting;
import io.helidon.webserver.http.ServerRequest;
import io.helidon.webserver.http.ServerResponse;

public class HelloResource implements HttpFeature {

  @Override
  public void setup(HttpRouting.Builder routing) {
    routing.get("/hello", this::hello);
  }

  public void hello(ServerRequest req, ServerResponse res) {

    SecurityContext context = req.context().get(SecurityContext.class).orElseThrow();
    res.status(OK_200);
    res.headers().contentType(MediaTypes.TEXT_PLAIN);
    res.send("Hello, " + context.userName() + "!");
  }
}
