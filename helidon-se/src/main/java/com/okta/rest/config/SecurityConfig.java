package com.okta.rest.config;

import io.avaje.config.Config;
import io.avaje.inject.Bean;
import io.avaje.inject.Factory;
import io.helidon.common.configurable.Resource;
import io.helidon.security.Security;
import io.helidon.security.providers.jwt.JwtProvider;
import io.helidon.webserver.context.ContextFeature;
import io.helidon.webserver.security.SecurityFeature;
import io.helidon.webserver.spi.ServerFeature;

@Factory
public class SecurityConfig {

  @Bean
  ServerFeature ctx() {
    return ContextFeature.create();
  }

  @Bean
  ServerFeature oauth() {

    var oauth =
        JwtProvider.builder()
            .issuer(Config.get("se.jwt.verify.issuer"))
            .verifyJwk(Resource.create(Config.getURI("se.jwt.verify.publickey.location")))
            .build();
    Security security = Security.builder().addProvider(oauth).build();

    return SecurityFeature.create(
        sfb ->
            sfb.security(security)
                .addPath(p -> p.path("/hello").handler(h -> h.authenticate(true))));
  }
}
