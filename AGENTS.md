# Agents

Guidance for AI coding agents working with the Climbing Fantasy codebase.

## Development setup

Prerequisites: Ruby 4.0.0, Node.js, PostgreSQL 17, Redis.

```bash
bin/setup           # interactive: bundle, db:prepare, optional db:reset, starts dev server
bin/dev             # start Rails server + Tailwind watchers via Procfile.dev
```

The app runs on `localhost:3000`. Admin dashboard at `/admin`, Swagger UI at `/api-docs`.

### Admin login (seeded)

- Email: `admin@climbingfantasy.com`
- Password: `password123456`

## Testing & CI

Run the full test suite:

```bash
bin/rails test                  # unit, model, controller, service, job tests
bin/rails test:system           # system tests (Capybara + Selenium)
```

CI pipeline (GitHub Actions, `.github/workflows/ci.yml`) runs five jobs:

1. **scan_ruby** — Brakeman security scan + Bundler-Audit
2. **scan_js** — Importmap audit
3. **lint** — RuboCop (Omakase style)
4. **test** — Minitest with PostgreSQL service
5. **system-test** — Capybara system tests, uploads screenshots on failure

Run linting and security scans locally:

```bash
bin/rubocop                     # RuboCop (rubocop-rails-omakase)
bin/brakeman                    # Rails security scanner
bin/bundler-audit               # Gem vulnerability audit
```

Pre-commit hooks via Overcommit (`.overcommit.yml`) run RuboCop, BundleAudit, and Brakeman automatically.

## Architecture

### Data model

```txt
Season -< Competition -< Category -< Round -< RoundResult >- Athlete
```

- **Season** — competition year (e.g., "IFSC World Cup 2024")
- **Competition** — single event with discipline enum (boulder, lead, speed, combined, boulder_and_lead) and status enum (upcoming, in_progress, completed)
- **Category** — discipline + gender combination
- **Round** — qualification, semi_final, or final with status tracking
- **RoundResult** — athlete's score in a round (tops, zones, attempts, lead height, speed time)
- **Athlete** — competitor with name, country_code (3 chars), gender, physical stats
- **AdminUser** — Devise-authenticated with roles: viewer, admin, super_admin

### API (read-only, JSON)

All endpoints are namespaced under `api/v1`. Controllers inherit from `Api::V1::BaseController` which extends `ActionController::API` and includes Pagy pagination.

```txt
GET /api/v1/seasons             # paginated list
GET /api/v1/seasons/:id         # includes competitions
GET /api/v1/competitions        # filterable: season_id, discipline, status, year
GET /api/v1/competitions/:id    # includes season + categories
GET /api/v1/categories/:id      # includes rounds
GET /api/v1/rounds/:id          # includes results + athletes (eager loaded)
GET /api/v1/athletes            # searchable: q (name), country
GET /api/v1/athletes/:id        # includes results
```

Response shape: `{ "data": [...], "meta": { "page": 1, "per_page": 25, "total": N } }`

### Serialization

Blueprinter serializers live in `app/blueprints/`. Each has a default view and an extended view that includes associations.

### Authorization

Pundit policies in `app/policies/` gate admin access by role. API endpoints are public (no auth required).

### OpenAPI validation

Tests use Committee to validate API responses against `swagger/v1/swagger.yaml`. The test helper loads the spec and provides `assert_schema_conform` for controller tests.

## Data syncing

Data flows in from the IFSC results API via background jobs. No manual data entry through the API — it is read-only.

### IFSC services (`app/services/ifsc/`)

- **Ifsc::Client** — Faraday HTTP wrapper around `ifsc.results.info`. Raises `Ifsc::Client::ApiError` on failures.
- **Ifsc::SeasonFetcher** — fetches and syncs seasons
- **Ifsc::EventFetcher** — fetches and syncs event categories
- **Ifsc::ResultFetcher** — fetches and syncs round results
- **Ifsc::ResultSyncer** — core synchronization logic (class methods). Handles find-or-create for all models, discipline/gender/round_type mapping, and status inference from dates.

### Background jobs

Sidekiq + sidekiq-cron. Queues: `default`, `scraping`.

| Job                     | Schedule         | Description                    |
|-------------------------|------------------|--------------------------------|
| `SyncSeasonsJob`        | Weekly (Mon 6am) | Fetch seasons and competitions |
| `SyncEventResultsJob`   | Daily (8am UTC)  | Fetch results for events       |
| `SyncUpcomingEventsJob` | Daily (7am UTC)  | Update upcoming event details  |

Sidekiq Web UI at `/sidekiq` (super_admin only).

### CSV import

Bulk import from Kaggle IFSC dataset:

```bash
rake import:athletes[path/to/athletes.csv]
rake import:results[path/to/results.csv]
rake import:all[athletes.csv,results.csv]
```

Services: `CsvImporter::AthleteImporter`, `CsvImporter::ResultImporter`.

## Project structure

```txt
app/
  admin/              # ActiveAdmin resource definitions
  blueprints/         # Blueprinter JSON serializers
  controllers/
    api/v1/           # API controllers (BaseController + 5 resources)
  jobs/               # Sidekiq background jobs
  models/             # ActiveRecord models (7 domain + AdminUser)
  policies/           # Pundit authorization policies
  services/
    ifsc/             # IFSC API client and data syncers
    csv_importer/     # CSV import services
config/
  database.yml        # PostgreSQL, multi-db in production (primary, cache, queue, cable)
  sidekiq.yml         # Queue configuration
  deploy.yml          # Kamal deployment config
  routes.rb           # API routes, ActiveAdmin, Sidekiq Web, Swagger
swagger/
  v1/swagger.yaml     # OpenAPI 3.0 specification
test/
  controllers/        # API request tests
  fixtures/           # YAML fixtures and mock data
  jobs/               # Background job tests
  models/             # Model validation tests
  services/           # Service object tests
```

## Conventions

- **Ruby style:** Omakase via `rubocop-rails-omakase`. No custom overrides.
- **Testing:** Minitest with parallel workers. Shoulda-matchers for model validations. Committee for API schema conformance.
- **Models:** Enums for discipline, status, gender, round_type, role. Validations on presence and uniqueness where appropriate.
- **Services:** Class method interfaces (e.g., `CsvImporter::AthleteImporter.import(path)`). IFSC services take a client in the initializer for testability.
- **Controllers:** Thin controllers. Filtering logic lives in controller private methods. Pagination via Pagy.
- **Serialization:** Blueprinter with default and extended views. No inline JSON rendering.
- **Jobs:** Rescue from `ApiError`, log, and continue processing remaining items.
- **Database:** PostgreSQL with UUID-less integer primary keys. Multi-database in production (Solid Cache, Solid Queue, Solid Cable).

## Deployment

Docker multi-stage build with Kamal orchestration. Production uses Thruster for HTTP acceleration in front of Puma. Config in `config/deploy.yml` and `.kamal/secrets`.

```bash
bin/kamal deploy            # deploy to production
bin/kamal console           # Rails console on server
bin/kamal logs              # tail production logs
```
