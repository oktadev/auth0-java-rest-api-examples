package com.okta.rest.controller;

import io.helidon.security.Principal;
import io.helidon.security.SecurityContext;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.Context;
import java.util.Optional;

import static jakarta.ws.rs.core.MediaType.TEXT_PLAIN;

@Path("/hello")
public class HelloResource {

    @GET
    @Path("/")
    @Produces(TEXT_PLAIN)
    public String hello(@Context SecurityContext context) {
        Optional<Principal> userPrincipal = context.userPrincipal();
        return "Hello, " + userPrincipal.get().getName() + "!";
    }
}
