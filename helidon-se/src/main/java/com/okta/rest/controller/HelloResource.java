package com.okta.rest.controller;

import io.avaje.http.api.Controller;
import io.avaje.http.api.Get;
import io.avaje.http.api.MediaType;
import io.avaje.http.api.Produces;
import io.helidon.security.SecurityContext;
import io.helidon.webserver.http.ServerRequest;

// controller and DI classes generated at compile time
@Controller("/hello")
public class HelloResource {

  @Get
  @Produces(MediaType.TEXT_PLAIN)
  public String hello(ServerRequest req) {

    SecurityContext context = req.context().get(SecurityContext.class).orElseThrow();

    return "Hello, " + context.userName() + "!";
  }
}
