const String serverURL = String.fromEnvironment(
  "SERVER_URL", defaultValue: "https://admin.time.silverse.mx"
);

const String loginURL = String.fromEnvironment(
  "LOGIN_URL", defaultValue: "https://login.time.silverse.mx"
);

const String forcedBearerToken = String.fromEnvironment("FORCE_BEARER_TOKEN");

const String runtime = String.fromEnvironment("RUNTIME", defaultValue: "Production");

const String domain = String.fromEnvironment(
  "DOMAIN", defaultValue: ".silverse.mx"
);

const String appName = String.fromEnvironment(
  "APP_NAME", defaultValue: "Silvertime Admin"
);

const String alias = String.fromEnvironment("ALIAS", defaultValue: "admin");

const String jwtKey = String.fromEnvironment(
  "JWT_KEY", defaultValue: "silverse-jwt"
);