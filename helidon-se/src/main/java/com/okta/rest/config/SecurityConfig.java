package com.okta.rest.config;

import io.avaje.config.Config;
import io.avaje.inject.Factory;
import io.helidon.common.configurable.Resource;
import io.helidon.security.Security;
import io.helidon.security.providers.jwt.JwtProvider;
import io.helidon.webserver.WebServerConfig;
import io.helidon.webserver.context.ContextFeature;
import io.helidon.webserver.security.SecurityFeature;
import jakarta.inject.Inject;

@Factory
public class SecurityConfig {

  @Inject
  void ctx(WebServerConfig.Builder builder) {

    var oauth =
        JwtProvider.builder()
            .issuer(Config.get("se.jwt.verify.issuer"))
            .verifyJwk(Resource.create(Config.getURI("se.jwt.verify.publickey.location")))
            .build();
    Security security = Security.builder().addProvider(oauth).build();
    var securityFeature =
        SecurityFeature.create(
            sfb ->
                sfb.security(security)
                    .addPath(p -> p.path("/hello").handler(h -> h.authenticate(true))));
    builder.addFeature(securityFeature);
    builder.addFeature(ContextFeature.create());
  }
}
