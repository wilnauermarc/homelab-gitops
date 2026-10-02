CREATE TABLE IF NOT EXISTS categories (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS products (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  category_id INTEGER NOT NULL REFERENCES categories (id),
  price NUMERIC(10, 2) NOT NULL,
  stock INTEGER NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS products_category_id_idx ON products (category_id);

CREATE TABLE IF NOT EXISTS product_views (
  product_id INTEGER PRIMARY KEY REFERENCES products (id),
  views INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS test_runs (
  id UUID PRIMARY KEY,
  started_at TIMESTAMPTZ NOT NULL,
  ended_at TIMESTAMPTZ,
  status TEXT NOT NULL,
  target_users INTEGER NOT NULL,
  ramp_up_seconds INTEGER NOT NULL,
  duration_seconds INTEGER NOT NULL,
  min_actions_per_minute INTEGER NOT NULL,
  max_actions_per_minute INTEGER NOT NULL,
  cache_mode TEXT NOT NULL,
  traffic_pattern TEXT NOT NULL,
  max_users INTEGER,
  avg_rps DOUBLE PRECISION,
  peak_rps DOUBLE PRECISION,
  p95_latency_ms DOUBLE PRECISION,
  cache_hit_rate DOUBLE PRECISION,
  avg_db_queries_per_sec DOUBLE PRECISION,
  error_rate DOUBLE PRECISION,
  peak_pool_active INTEGER,
  pool_max INTEGER,
  name TEXT,
  kind TEXT NOT NULL DEFAULT 'live',
  warmup_seconds INTEGER,
  steady_seconds INTEGER,
  cooldown_seconds INTEGER,
  random_seed INTEGER,
  cache_ttl_seconds INTEGER,
  cache_warmth TEXT,
  ab_pair_id UUID,
  ab_role TEXT,
  workload_model TEXT,
  planned_rps DOUBLE PRECISION
);

CREATE TABLE IF NOT EXISTS ab_test_groups (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  status TEXT NOT NULL,
  run_a_id UUID,
  run_b_id UUID,
  comparison_status TEXT NOT NULL,
  dataset_products INTEGER,
  dataset_products_b INTEGER,
  note TEXT
);

CREATE TABLE IF NOT EXISTS test_results (
  run_id UUID PRIMARY KEY REFERENCES test_runs (id),
  measured_seconds DOUBLE PRECISION,
  total_requests DOUBLE PRECISION,
  avg_rps DOUBLE PRECISION,
  peak_rps DOUBLE PRECISION,
  p50_ms DOUBLE PRECISION,
  p90_ms DOUBLE PRECISION,
  p95_ms DOUBLE PRECISION,
  p99_ms DOUBLE PRECISION,
  http_errors DOUBLE PRECISION,
  http_error_rate DOUBLE PRECISION,
  db_queries DOUBLE PRECISION,
  db_queries_per_second DOUBLE PRECISION,
  db_errors DOUBLE PRECISION,
  db_avg_ms DOUBLE PRECISION,
  db_p95_ms DOUBLE PRECISION,
  cache_hits DOUBLE PRECISION,
  cache_misses DOUBLE PRECISION,
  cache_hit_rate DOUBLE PRECISION,
  cache_errors DOUBLE PRECISION,
  peak_active_requests DOUBLE PRECISION,
  cache_keys DOUBLE PRECISION,
  cache_memory_bytes DOUBLE PRECISION,
  cache_evictions DOUBLE PRECISION,
  configured_cache_ttl DOUBLE PRECISION,
  effective_cache_ttl DOUBLE PRECISION,
  whole_run_requests DOUBLE PRECISION,
  validation JSONB,
  dropped_iterations DOUBLE PRECISION,
  scheduled_iterations DOUBLE PRECISION,
  target_requests DOUBLE PRECISION,
  target_max_ms DOUBLE PRECISION,
  target_p99_ms DOUBLE PRECISION,
  target_p99_9_ms DOUBLE PRECISION,
  reporter_max_ms DOUBLE PRECISION,
  target_over_1s DOUBLE PRECISION,
  target_over_5s DOUBLE PRECISION,
  target_over_10s DOUBLE PRECISION
);

CREATE INDEX IF NOT EXISTS test_runs_started_at_idx ON test_runs (started_at DESC);
