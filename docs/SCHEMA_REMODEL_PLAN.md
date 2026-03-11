# Schema Remodel Plan

Mirror the IFSC API data shapes as closely as possible, with a `source` enum to
support IFSC, USAC, and future providers.

Last updated: 2026-03-08

---

## Current vs target hierarchy

```
CURRENT                                 TARGET
───────                                 ──────
Season                                  Season  (+source)
└─ Event                                └─ Event  (+source, timestamps, timezone)
   └─ Category                             └─ Category  (+category_status)
      ├─ CategoryRegistration                 ├─ CategoryRegistration
      │  └─ Athlete                           │  └─ Athlete  (+source, nullable fields)
      └─ Round                                └─ Round  (+format, unique index)
         ├─ Climb          ──────►               ├─ Route  (renamed from Climb)
         └─ RoundResult                          └─ RoundResult  (+ranking metadata)
            └─ ClimbResult ──────►                  └─ Ascent  (renamed from ClimbResult)
```

---

## Target schema

### `seasons`

| Column      | Type    | Null | Notes                                        |
|-------------|---------|------|----------------------------------------------|
| source      | integer | NO   | NEW — enum (ifsc: 0, usac: 1), default: 0    |
| external_id | integer | YES  |                                               |
| name        | string  | YES  |                                               |
| year        | integer | YES  |                                               |

**Indexes:**

- `(source, external_id)` unique — replaces current unique on `external_id` alone

### `events`

| Column                        | Type     | Null | Notes                                           |
|-------------------------------|----------|------|-------------------------------------------------|
| season_id                     | bigint   | NO   |                                                 |
| source                        | integer  | NO   | NEW — enum (ifsc: 0, usac: 1), default: 0       |
| external_id                   | integer  | YES  |                                                 |
| name                          | string   | NO   |                                                 |
| location                      | string   | NO   |                                                 |
| country_code                  | string(3)| YES  | NEW — API `"country": "JPN"`                     |
| starts_on                     | date     | NO   | keep for date-range queries                      |
| ends_on                       | date     | NO   | keep for date-range queries                      |
| starts_at                     | datetime | YES  | NEW — API `"starts_at"` (UTC)                    |
| ends_at                       | datetime | YES  | NEW — API `"ends_at"` (UTC)                      |
| timezone_name                 | string   | YES  | NEW — API `timezone.value` e.g. `"Asia/Tokyo"`   |
| status                        | integer  | NO   | enum: upcoming(0), in_progress(1), completed(2) |
| sync_state                    | integer  | NO   | enum: pending_sync(0), synced(1), needs_results(2) |
| results_synced_at             | datetime | YES  |                                                 |
| registrations_last_checked_at | datetime | YES  |                                                 |

**Indexes:**

- `(source, external_id)` unique — replaces no-uniqueness on `external_id`
- `(sync_state)` — keep existing

### `athletes`

| Column              | Type     | Null | Notes                                          |
|---------------------|----------|------|-------------------------------------------------|
| source              | integer  | NO   | NEW — enum (ifsc: 0, usac: 1), default: 0       |
| external_athlete_id | integer  | YES  |                                                 |
| first_name          | string   | NO   |                                                 |
| last_name           | string   | NO   |                                                 |
| country_code        | string(3)| YES  | CHANGED — was NOT NULL                           |
| gender              | integer  | YES  | CHANGED — was NOT NULL                           |
| photo_url           | string   | YES  |                                                 |
| federation          | string   | YES  | NEW — API `"federation": "SCA"`                  |
| federation_id       | integer  | YES  | NEW — API `"federation_id": 28`                  |

**Indexes:**

- `(source, external_athlete_id)` unique — replaces unique on `external_athlete_id` alone

### `categories`

| Column           | Type    | Null | Notes                                                |
|------------------|---------|------|------------------------------------------------------|
| event_id         | bigint  | NO   |                                                      |
| external_dcat_id | integer | YES  |                                                      |
| name             | string  | NO   |                                                      |
| discipline       | integer | NO   | enum: boulder(0), lead(1), speed(2)                  |
| gender           | integer | NO   | enum: male(0), female(1)                             |
| category_status  | integer | YES  | NEW — enum (not_started: 0, active: 1, finished: 2)   |

**Indexes:**

- `(event_id, external_dcat_id)` unique — keep existing, source inherited from event

### `rounds`

| Column            | Type    | Null | Notes                                  |
|-------------------|---------|------|----------------------------------------|
| category_id       | bigint  | NO   |                                        |
| external_round_id | integer | YES  |                                        |
| name              | string  | NO   |                                        |
| round_type        | string  | NO   | enum: qualification, round_of_16, quarter_final, semi_final, small_final, final |
| status            | integer | NO   | enum: pending(0), in_progress(1), completed(2) |
| format            | string  | YES  | NEW — round format descriptor from API |

**Indexes:**

- `(category_id)` — keep existing
- `(external_round_id)` unique — NEW

### `routes` (renamed from `climbs`)

| Column            | Type    | Null | Notes                                         |
|-------------------|---------|------|-----------------------------------------------|
| round_id          | bigint  | NO   |                                               |
| external_route_id | integer | NO   | RENAMED from `number` — API `route_id`         |
| route_name        | string  | YES  | NEW — API `"name": "1"`, `"A"`, `"B"`          |
| route_order       | integer | YES  | NEW — display sorting                          |
| group_label       | string  | YES  | keep — boulder qual group splits (`"A"`, `"B"`) |

**Indexes:**

- `(round_id)` — keep existing
- `(round_id, group_label, external_route_id)` unique — updated column name

### `round_results`

| Column                 | Type    | Null | Notes                                        |
|------------------------|---------|------|----------------------------------------------|
| round_id               | bigint  | NO   |                                              |
| athlete_id             | bigint  | NO   |                                              |
| rank                   | integer | YES  |                                              |
| score_raw              | string  | YES  | API `"score"` string                          |
| group_label            | string  | YES  |                                              |
| start_order            | integer | YES  | NEW — API `"start_order"`                     |
| bib                    | string  | YES  | NEW — API `"bib": "52"`                       |
| starting_group         | string  | YES  | NEW — API `"starting_group": "Group B"`       |
| group_rank             | integer | YES  | NEW — API `"group_rank"`                      |
| active                 | boolean | YES  | NEW — API `"active"` (athlete on wall)        |
| under_appeal           | boolean | YES  | NEW — API `"under_appeal"`                    |
| tops                   | integer | YES  | boulder aggregate                             |
| zones                  | integer | YES  | boulder aggregate                             |
| top_attempts           | integer | YES  | boulder aggregate                             |
| zone_attempts          | integer | YES  | boulder aggregate                             |
| high_zones             | integer | YES  | boulder aggregate                             |
| high_zone_attempts     | integer | YES  | boulder aggregate                             |
| boulder_points         | decimal | YES  | boulder aggregate                             |
| lead_height            | decimal | YES  | lead aggregate                                |
| lead_plus              | boolean | YES  | lead aggregate                                |
| speed_time             | decimal | YES  | speed aggregate                               |
| speed_eliminated_stage | string  | YES  | speed aggregate                               |

**Indexes:**

- `(round_id, athlete_id)` unique — keep existing
- `(round_id)`, `(athlete_id)` — keep existing

### `ascents` (renamed from `climb_results`)

| Column          | Type        | Null | Notes                                           |
|-----------------|-------------|------|-------------------------------------------------|
| round_result_id | bigint      | NO   |                                                 |
| route_id        | bigint      | NO   | RENAMED from `climb_id`                          |
| ascent_status   | string      | YES  | NEW — API `"confirmed"` / `"locked"`             |
| modified_at     | datetime    | YES  | NEW — API `"modified"` timestamp                 |
| **Boulder**     |             |      |                                                 |
| top             | boolean     | YES  | NEW — API `"top": true`                          |
| top_tries       | integer     | YES  | NEW — API `"top_tries": 5` (actual attempt count)|
| zone            | boolean     | YES  | NEW — API `"zone": true`                         |
| zone_tries      | integer     | YES  | NEW — API `"zone_tries": 3`                      |
| low_zone        | boolean     | YES  | NEW — API `"low_zone": false`                    |
| low_zone_tries  | integer     | YES  | NEW — API `"low_zone_tries": null`               |
| points          | decimal     | YES  | NEW — API `"points": 0.0`                        |
| **Lead**        |             |      |                                                 |
| height          | decimal(5,2)| YES  | keep — API ascent `"score"` (height reached)     |
| plus            | boolean     | YES  | keep — API `"plus"`                              |
| rank            | integer     | YES  | keep — API ascent-level rank                     |
| score_raw       | string      | YES  | keep — API ascent `"score"` string               |
| **Speed**       |             |      |                                                 |
| time_ms         | integer     | YES  | NEW — API `"time_ms": 4977` (store as-is)        |
| dnf             | boolean     | YES  | NEW — API `"dnf": false`                         |
| dns             | boolean     | YES  | NEW — API `"dns": false`                         |

**Columns removed** (replaced by API-accurate fields):

| Old column         | Replaced by                        |
|--------------------|------------------------------------|
| top_attempts       | `top` (boolean) + `top_tries` (int)|
| zone_attempts      | `zone` (boolean) + `zone_tries`    |
| high_zone_attempts | `low_zone` + `low_zone_tries`      |
| time               | `time_ms` (integer, no conversion) |
| disqualification   | `dnf` / `dns` / `ascent_status`    |

**Indexes:**

- `(round_result_id, route_id)` unique — updated column name
- `(round_result_id)`, `(route_id)` — updated column name

---

## Fields intentionally not stored

| API field                          | Reason                                           |
|------------------------------------|--------------------------------------------------|
| `flag_url`                         | Derivable from `country_code`                    |
| `event_logo`, `series_logo`        | CDN URLs, fetch on demand                        |
| `result_url`, `registration_url`   | API endpoint refs, constructed at sync time       |
| `name` (full name string)          | Derived from `first_name` + `last_name`           |
| `public_information`               | Not core to fantasy scoring — add later if needed |
| `cup_name`, `cup_id`, `custom_cup_ids` | Cup/series standings are a separate feature   |
| `startlist[]`, `next_round_startlist[]` | Operational data, not results               |
| `is_paraclimbing_event`            | Filtered at sync time                            |
| `corrective_rank` (lead)           | Edge case, `rank` is sufficient                  |
| `restarted` (lead)                 | Rare edge case                                   |
| `record`, `record_types[]` (speed) | Display-only, can be derived                     |

---

## Migration sequence

One migration per table concern, each its own commit.

| #  | Migration name                              | Changes                                                                                            |
|----|---------------------------------------------|----------------------------------------------------------------------------------------------------|
| 1  | `add_source_to_seasons`                     | Add `source` (default: `ifsc`). Drop unique on `external_id`, add `(source, external_id)` unique   |
| 2  | `add_source_and_timestamps_to_events`       | Add `source`, `starts_at`, `ends_at`, `timezone_name`, `country_code`. Composite unique `(source, external_id)` |
| 3  | `add_source_and_relax_constraints_on_athletes` | Add `source`, `federation`, `federation_id`. Nullable `country_code` + `gender`. Composite unique `(source, external_athlete_id)` |
| 4  | `add_category_status_to_categories`         | Add `category_status` integer enum (not_started: 0, active: 1, finished: 2)                        |
| 5  | `add_format_and_unique_index_to_rounds`     | Add `format`. Add unique index on `external_round_id`                                              |
| 6  | `rename_climbs_to_routes`                   | Rename table. Rename `number` → `external_route_id`. Add `route_name`, `route_order`. Update index |
| 7  | `rename_climb_results_to_ascents`           | Rename table. Rename `climb_id` → `route_id`. Add new fields. Remove replaced columns. Update indexes |
| 8  | `add_ranking_fields_to_round_results`       | Add `start_order`, `bib`, `starting_group`, `group_rank`, `active`, `under_appeal`                 |

---

## Post-migration work

### packs/core — Models (~6 files)

- Rename `Climb` → `Route`, `ClimbResult` → `Ascent`
- Update all associations across `Round`, `RoundResult`, `Athlete`
- Add `source` enum to `Season`, `Event`, `Athlete`
- Relax `Athlete` validations (nullable `country_code`, `gender`)
- Update `Ascent` validations + helper methods (`topped?` → `top?`, etc.)

### packs/sync — Syncers (~4 services + 3 jobs)

- Map API fields directly to new column names (no more `top ? 1 : 0`)
- Store `time_ms` as-is (drop `/1000.0` conversion)
- Populate new fields: `timezone_name`, `starts_at`, `country_code`, `federation`, etc.
- Set `source: :ifsc` on all created records
- Rename internal methods: `sync_climb` → `sync_route`, `sync_climb_results` → `sync_ascents`

### packs/api — Blueprints

- No existing Climb/ClimbResult blueprints, minimal changes
- Update `RoundBlueprint` if it references climbs

### packs/admin — ActiveAdmin

- No direct Climb/ClimbResult admin resources found, minimal changes

### tests — Fixtures + tests (~8 files)

- Rename `test/fixtures/climbs.yml` → `routes.yml`
- Rename `test/fixtures/climb_results.yml` → `ascents.yml`
- Update field names in fixture data
- Update model tests, service tests, fixture helper calls

### docs — Documentation

- Update `AGENTS.md` data model and conventions sections
- Update `packs/sync/docs/SYNC.md` data model diagram and pipeline docs

### seeds — `db/seeds.rb`

- Update Climb/ClimbResult references to Route/Ascent

---

## IFSC API ↔ new schema field mapping

Quick reference for syncer implementation.

### Season sync (`GET /api/v1/seasons/:id`)

| API field            | Column              |
|----------------------|---------------------|
| `name`               | `Season.name`       |
| `name` (parsed year) | `Season.year`       |
| —                    | `Season.source = :ifsc` |

### Event sync (`GET /api/v1/season_leagues/:id` events)

| API field                 | Column                 |
|---------------------------|------------------------|
| `event_id`                | `Event.external_id`    |
| `event`                   | `Event.name`           |
| `location`                | `Event.location`       |
| `country`                 | `Event.country_code`   |
| `local_start_date`        | `Event.starts_on`      |
| `local_end_date`          | `Event.ends_on`        |
| `starts_at`               | `Event.starts_at`      |
| `ends_at`                 | `Event.ends_at`        |
| `timezone.value`          | `Event.timezone_name`  |
| —                         | `Event.source = :ifsc` |

### Registration sync (`GET /api/v1/events/:id/registrations`)

| API field              | Column                         |
|------------------------|--------------------------------|
| `athlete_id`           | `Athlete.external_athlete_id`  |
| `firstname`            | `Athlete.first_name`           |
| `lastname`             | `Athlete.last_name`            |
| `country`              | `Athlete.country_code`         |
| `gender` (0/1)         | `Athlete.gender`               |
| `federation`           | `Athlete.federation`           |
| `federation_id`        | `Athlete.federation_id`        |
| —                      | `Athlete.source = :ifsc`       |
| `d_cats[].status`      | `CategoryRegistration.status`  |

### Category sync (`GET /api/v1/events/:id` d_cats)

| API field          | Column                      |
|--------------------|-----------------------------|
| `dcat_id`          | `Category.external_dcat_id` |
| `dcat_name`        | `Category.name`             |
| `discipline_kind`  | `Category.discipline`       |
| `category_name`    | parsed → `Category.gender`  |
| `status`           | `Category.category_status`  |

### Round sync (`GET /api/v1/events/:id` category_rounds)

| API field            | Column                   |
|----------------------|--------------------------|
| `category_round_id`  | `Round.external_round_id`|
| `name`               | `Round.name`             |
| `kind`               | mapped → `Round.round_type` |
| `status`             | mapped → `Round.status`  |
| `format`             | `Round.format`           |

### Route sync (from category_rounds routes/starting_groups)

| API field    | Column                   |
|--------------|--------------------------|
| `id`         | `Route.external_route_id`|
| `name`       | `Route.route_name`       |
| (index)      | `Route.route_order`      |
| (group name) | `Route.group_label`      |

### Result sync (`GET /api/v1/category_rounds/:id/results` ranking)

| API field         | Column                          |
|-------------------|---------------------------------|
| `rank`            | `RoundResult.rank`              |
| `score`           | `RoundResult.score_raw`         |
| `start_order`     | `RoundResult.start_order`       |
| `bib`             | `RoundResult.bib`               |
| `starting_group`  | `RoundResult.starting_group`    |
| `group_rank`      | `RoundResult.group_rank`        |
| `active`          | `RoundResult.active`            |
| `under_appeal`    | `RoundResult.under_appeal`      |

### Ascent sync (from ranking ascents)

**Boulder:**

| API field        | Column               |
|------------------|----------------------|
| `route_id`       | matched → `route_id` |
| `top`            | `Ascent.top`         |
| `top_tries`      | `Ascent.top_tries`   |
| `zone`           | `Ascent.zone`        |
| `zone_tries`     | `Ascent.zone_tries`  |
| `low_zone`       | `Ascent.low_zone`    |
| `low_zone_tries` | `Ascent.low_zone_tries` |
| `points`         | `Ascent.points`      |
| `status`         | `Ascent.ascent_status` |
| `modified`       | `Ascent.modified_at` |

**Lead:**

| API field   | Column               |
|-------------|----------------------|
| `route_id`  | matched → `route_id` |
| `score`     | `Ascent.height`      |
| `plus`      | `Ascent.plus`        |
| `top`       | `Ascent.top`         |
| `rank`      | `Ascent.rank`        |
| `score`     | `Ascent.score_raw`   |
| `status`    | `Ascent.ascent_status` |

**Speed:**

| API field   | Column               |
|-------------|----------------------|
| `route_id`  | matched → `route_id` |
| `time_ms`   | `Ascent.time_ms`     |
| `dnf`       | `Ascent.dnf`         |
| `dns`       | `Ascent.dns`         |
| `status`    | `Ascent.ascent_status` |
| `modified`  | `Ascent.modified_at` |
