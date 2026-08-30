{ lib, pkgs, ... }:
let
  networkName = "honcho";
  databaseEnvironmentFile = "/var/lib/honcho/database.env";
  providerEnvironmentFile = "/var/lib/honcho/honcho.env";

  # Official image built from plastic-labs/honcho@a74f2b3.
  honchoImage = "ghcr.io/plastic-labs/honcho@sha256:0c2f1045494b86afac460eea00511b091a7ccfa03ac3386e4a3f5064e31765d0";

  commonEnvironment = {
    AUTH_USE_AUTH = "false";
    CACHE_ENABLED = "true";
    CACHE_URL = "redis://honcho-redis:6379/0?suppress=true";
    SENTRY_ENABLED = "false";
  };

  initSql = pkgs.writeText "honcho-init.sql" ''
    CREATE EXTENSION IF NOT EXISTS vector;
  '';
in
{
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      honcho-postgres = {
        image = "pgvector/pgvector@sha256:de007ff8bef525f09a25a230eb80fe1392ad8109d27806aba3b21a2d9b83dae3";
        environment = {
          PGDATA = "/var/lib/postgresql/data/pgdata";
        };
        environmentFiles = [ databaseEnvironmentFile ];
        volumes = [
          "honcho-postgres:/var/lib/postgresql/data"
          "${initSql}:/docker-entrypoint-initdb.d/init.sql:ro"
        ];
        networks = [ networkName ];
        extraOptions = [
          "--health-cmd=pg_isready -U honcho -d honcho"
          "--health-interval=5s"
          "--health-timeout=5s"
          "--health-retries=10"
        ];
      };

      honcho-redis = {
        image = "redis@sha256:d9f0312a780ed4ad4c22c05790c20b3902498b563ba01f3f1134678b9bd2f311";
        volumes = [ "honcho-redis:/data" ];
        networks = [ networkName ];
        extraOptions = [
          "--health-cmd=redis-cli ping"
          "--health-interval=5s"
          "--health-timeout=5s"
          "--health-retries=10"
        ];
      };

      honcho-api = {
        image = honchoImage;
        dependsOn = [
          "honcho-postgres"
          "honcho-redis"
        ];
        environment = commonEnvironment;
        environmentFiles = [
          databaseEnvironmentFile
          providerEnvironmentFile
        ];
        ports = [ "127.0.0.1:8000:8000" ];
        networks = [ networkName ];
        entrypoint = "/bin/sh";
        cmd = [
          "-ec"
          ''
            until /app/.venv/bin/python -c "import socket; socket.create_connection(('honcho-postgres', 5432), 2).close()"; do sleep 1; done
            until /app/.venv/bin/python -c "import socket; socket.create_connection(('honcho-redis', 6379), 2).close()"; do sleep 1; done
            /app/.venv/bin/python scripts/provision_db.py
            exec /app/.venv/bin/fastapi run --host 0.0.0.0 src/main.py
          ''
        ];
        extraOptions = [
          "--health-cmd=/app/.venv/bin/python -c \"import urllib.request; urllib.request.urlopen('http://localhost:8000/health', timeout=2).read()\""
          "--health-interval=5s"
          "--health-timeout=5s"
          "--health-retries=10"
          "--health-start-period=15s"
        ];
      };

      honcho-deriver = {
        image = honchoImage;
        dependsOn = [ "honcho-api" ];
        environment = commonEnvironment;
        environmentFiles = [
          databaseEnvironmentFile
          providerEnvironmentFile
        ];
        networks = [ networkName ];
        entrypoint = "/bin/sh";
        cmd = [
          "-ec"
          ''
            until /app/.venv/bin/python -c "import urllib.request; urllib.request.urlopen('http://honcho-api:8000/health', timeout=2).read()"; do sleep 1; done
            exec /app/.venv/bin/python -m src.deriver
          ''
        ];
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/honcho 0700 root root - -"
    "f ${providerEnvironmentFile} 0600 root root - -"
    "z ${providerEnvironmentFile} 0600 root root - -"
  ];

  system.activationScripts.honcho-database-credentials = lib.stringAfter [ "users" ] ''
    ${pkgs.coreutils}/bin/install -d -o root -g root -m 0700 /var/lib/honcho
    if [ ! -s ${databaseEnvironmentFile} ]; then
      password="$(${pkgs.openssl}/bin/openssl rand -hex 32)"
      temporaryFile="${databaseEnvironmentFile}.tmp"
      umask 077
      ${pkgs.coreutils}/bin/rm -f "$temporaryFile"
      ${pkgs.coreutils}/bin/printf '%s\n' \
        'POSTGRES_DB=honcho' \
        'POSTGRES_USER=honcho' \
        "POSTGRES_PASSWORD=$password" \
        "DB_CONNECTION_URI=postgresql+psycopg://honcho:$password@honcho-postgres:5432/honcho" \
        > "$temporaryFile"
      ${pkgs.coreutils}/bin/mv "$temporaryFile" ${databaseEnvironmentFile}
    fi
    ${pkgs.coreutils}/bin/chown root:root ${databaseEnvironmentFile}
    ${pkgs.coreutils}/bin/chmod 0600 ${databaseEnvironmentFile}
  '';

  systemd.services = {
    honcho-network = {
      description = "Honcho private Docker network";
      wantedBy = [ "multi-user.target" ];
      after = [ "docker.service" ];
      requires = [ "docker.service" ];
      before = [
        "docker-honcho-postgres.service"
        "docker-honcho-redis.service"
        "docker-honcho-api.service"
        "docker-honcho-deriver.service"
      ];
      path = [ pkgs.docker ];
      script = ''
        docker network inspect ${networkName} >/dev/null 2>&1 \
          || docker network create ${networkName}
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
  } // lib.genAttrs [
    "docker-honcho-postgres"
    "docker-honcho-redis"
    "docker-honcho-api"
    "docker-honcho-deriver"
  ] (_: {
    after = [ "honcho-network.service" ];
    requires = [ "honcho-network.service" ];
  });
}
