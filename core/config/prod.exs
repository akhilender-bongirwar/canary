import Config

# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix assets.deploy` task,
# which you should run after static files are built and
# before starting your production server.
config :canary, CanaryWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: Canary.Finch

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info

config :canary, Canary.Native,
  crate: :canary_native,
  skip_compilation?: true,
  load_from: {:canary, "priv/native/libcanary_native"}

config :opentelemetry,
  traces_exporter: :otlp,
  span_processor: :batch,
  resource: [
    service: [name: "core", namespace: "canary"],
    deployment: [environment: "prod"]
  ],
  sampler: {:parent_based, %{root: {:trace_id_ratio_based, 1.0}}}

config :canary, :github_app_url, "https://github.com/apps/getcanary/installations/new"

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
