# Fantasy Climbing Game Rules Spec (MVP v1)

Status: Draft  
Last updated: 2026-03-09

## 1. Scope

This document defines the MVP game rules for the fantasy climbing app.

The MVP supports discipline-based play:

- Boulder roster
- Lead roster
- Speed roster

Users may play any subset of available disciplines for an event. Example: a user can play Boulder only, even if Lead and Speed are also available.

## 2. Core Concepts

- Event: A real IFSC competition event.
- Discipline: Boulder, Lead, or Speed.
- Discipline entry: A user's submitted roster for one discipline in one event.
- Season leaderboard: Cumulative points across all scored discipline entries in the league season.

## 3. Participation Rules

1. Users join leagues and submit discipline entries per event.
2. If an event includes multiple disciplines, users may enter one, two, or all three disciplines.
3. Each discipline is scored independently.
4. Season totals are the sum of all discipline scores the user has entered.

## 4. Roster Rules (Per Discipline Entry)

1. Roster size must be exactly 10 athletes.
2. Gender split must be exactly 5 men and 5 women.
3. Country diversity is required.
4. No two athletes on the same roster can share the same `country_code`.
5. A valid roster therefore has 10 unique countries.
6. Athletes must be eligible for that event and discipline.
7. Users can edit a discipline entry until that discipline starts.
8. No substitutions are allowed after discipline start.
9. The submitted roster plays for the full discipline from start to finish.

## 5. Country Rule Details

1. Country uniqueness is validated using the athlete `country_code` from core data.
2. The rule applies only within a single discipline entry.
3. A user may reuse a country in a different discipline entry for the same event.
4. If an athlete lacks `country_code`, that athlete is ineligible for roster selection.

## 6. Scoring Rules (Per Athlete)

Placement points:

- 1st: 100
- 2nd: 80
- 3rd: 65
- 4th: 55
- 5th: 50
- 6th: 45
- 7th: 40
- 8th: 35
- 9th-16th: 25
- 17th-24th: 15
- 25th+: 5
- DNS/DNF/DSQ: 0

Discipline entry score:

1. Every athlete on the 10-person roster contributes points.
2. Entry score is the sum of all 10 athletes' points.

Event and season score:

1. Event score is the sum of all entered disciplines for that event.
2. Season score is the cumulative sum of all event scores.

## 7. Live vs Final Scoring

1. Live scores are provisional and update as IFSC results update.
2. Final scores are set when official final standings for that discipline are available.
3. Once final, scores are immutable unless upstream IFSC data is corrected.
4. If IFSC publishes a correction, the app recalculates and records an audit entry.

## 8. Tiebreakers

For tied users on a leaderboard:

1. Most discipline-entry wins in the scored period.
2. Highest single discipline-entry score in the scored period.
3. Earliest final submission timestamp among contributing entries in the scored period.
4. If still tied, shared rank.

## 9. Fair Play Rules

1. One account per person.
2. No multi-account play to gain advantage.
3. All entry submissions and edits are audit logged.
4. Platform may suspend accounts for abusive behavior or manipulation.

## 10. Edge Cases

1. If a rostered athlete withdraws after submission and is scored as DNS, they receive 0.
2. If a discipline is canceled with no official standings, that discipline is excluded from scoring for all users.
3. If an event has only one or two disciplines, only those disciplines are playable.

## 11. Future Features (Not in MVP)

1. Captain or multiplier mechanics.
2. Salary cap and athlete pricing.
3. Snake draft leagues.
4. Trades and waivers.
5. Bench slots and substitutions.
6. Streak bonuses and special cards/power-ups.
