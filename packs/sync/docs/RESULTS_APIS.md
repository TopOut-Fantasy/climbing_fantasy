# External Results APIs (IFSC + USAC)

Quick reference for reverse-engineered IFSC/USAC endpoints and response scopes.

Last validated: 2026-03-09 UTC.

## Authentication pattern (both providers)

Both APIs use a session cookie from the public homepage.

1. `GET https://<provider>.results.info/`
2. Read session cookie from `Set-Cookie`
3. Send API requests with:
   - `Cookie: <session_cookie_name>=<session_cookie_value>`
   - `Referer: https://<provider>.results.info/`
   - `Accept: application/json`

Typical cookie names:

- IFSC: `_ifsc_resultservice_session`, `_verticallife_resultservice_session`
- USAC: `_usac_resultservice_session`, `_verticallife_resultservice_session`

## USAC endpoint map (validated with event 448)

### Live feed

- Browser route `GET /live` returns HTML 404 (not API JSON).
- API route `GET /api/v1/live` returns JSON:

```json
{
  "live": [
    {
      "category_round_id": 11422,
      "event_id": 448,
      "event_name": "2026 National Team Trials",
      "category": "Men/Open",
      "discipline_kind": "boulder",
      "round_name": "Round 3",
      "starts_at": "...",
      "ends_at": "...",
      "timezone": { "value": "America/Los_Angeles" }
    }
  ]
}
```

### Scope differences (important)

For event `448` and active boulder category `338`:

1. `GET /api/v1/events/448`
   - Event + category metadata
   - Includes light summary per category (`top_3_results`)
   - Includes link to category full results (`full_results_url`)

2. `GET /api/v1/events/448/result/338`
   - Full standings for one event category
   - `ranking[]` athletes include `rounds[]` with Round 1/2/3 details

3. `GET /api/v1/category_rounds/11422/results`
   - Single-round results only (Round 3 for Men/Open Boulder)
   - `ranking[]` contains current round-level scores/ascents

### Real-time behavior note

`/api/v1/category_rounds/11422/results` returned `status: "active"` during validation and is the correct live round endpoint. Scores may not change every poll; freshness is indicated by `status_as_of`.

## IFSC quick map

- `GET /api/v1/seasons/:id`
- `GET /api/v1/season_leagues/:id`
- `GET /api/v1/events/:id`
- `GET /api/v1/events/:id/registrations`
- `GET /api/v1/category_rounds/:id/results`

These are wired in `Ifsc::ApiClient` and mirrored by `Usac::ApiClient` where endpoints exist.

## Postman assets

Use the external collection and environment files in `postman/`:

- `postman/collections/external_results_apis.postman_collection.json`
- `postman/environments/external_results_apis_local.postman_environment.json`

The collection includes cookie bootstrap requests plus IFSC/USAC requests for event metadata, category full results, and single-round results.
