# Phase 0: Discovery

Inspected `cass-community/cass-community.github.io` (read-only; commit `b3e9fee`) on 2026-10-06.

## Generator and stack
- **Jekyll 4.3** with the **minimal-mistakes-jekyll** gem theme, `air` skin (`_config.yml`). Plugins: jekyll-feed, jekyll-sitemap, jekyll-include-cache, jekyll-link-attributes.
- Built in GitHub Actions (`.github/workflows/jekyll.yml`): Ruby 3.4, `bundle exec jekyll build`, `actions/deploy-pages`. Triggers: push to `main`, `workflow_dispatch`, daily cron `1 12 * * *` (just after midnight AOE).
- **Decision: use Jekyll + minimal-mistakes `air`** so styles and layouts port directly. Collections (`_events`-style) are not needed; a pre-build script will generate or validate content, and Jekyll renders it.

## Styles
- No custom stylesheet: the look is the stock minimal-mistakes `air` skin (`_sass/minimal-mistakes.scss`) plus `_includes/head/custom.html`. Fonts and icons (Font Awesome) come from the theme.
- To adapt (copy, not link): `_includes/footer.html` (footer links, CC-BY 4.0 notice), `_includes/head/custom.html`, `_data/navigation.yml` (replace with Home / Current season / Resources), and logo/favicon images from `assets/images/` (`cass-logo.png`, `cass-logo-white.png`, `favicons/`, `apple-touch-icon.png`).
- Footer links to reuse: YouTube, Slack signup, announcement list signup, email, GitHub.

## Metadata file
- There is **no standalone metadata file**. This WG's metadata is the YAML front matter of `_working-groups/software-ecosystem.md` (key/slug: `software-ecosystem`; `name: Software Ecosystem`).
- Raw URL: `https://raw.githubusercontent.com/cass-community/cass-community.github.io/main/_working-groups/software-ecosystem.md`. The build must fetch it and parse the front matter (not JSON/YAML alone).
- Relevant fields: `name`, `description`, `charter` (purpose, relationships, lifetime, membership, reporting, status), `chair` (**do not render**; roles not people), `meeting_schedule` (free text), `additional_resource_links` (Slack channel, WG groups.io list, Teatime groups.io list).
- **Already upstream:** Slack URL (`https://softwareecosy-91t5745.slack.com/archives/C076BK498RL`, `#wg-ecosystem`), WG list (`https://groups.io/g/cass-sci-soft-ecosystem-wg`), Teatime list (`https://groups.io/g/cass-scisoft-genai-teatime`), and the schedule as prose: webinars 12-1 pm ET first Monday of even months; working meetings 12-1 pm ET first Monday of odd months; Teatimes 4-4:30 pm ET third Thursday monthly.
- **Not upstream:** Zoom link(s); machine-readable schedule (RRULE/start time). These stay in `site.config.yml`.
- Consequences: `links.*` in `site.config.yml` should be read from upstream, not duplicated. The schedule is prose upstream, so the series RRULEs and times (from the prose above) are needed locally; flagged for Mike to confirm. Upstream uses **Eastern time**; the starter's `America/Chicago` is likely wrong, so the site timezone should probably be `America/New_York` (to confirm).

## URL routing
- Confirmed: `cass-community.github.io` is the org's user/org Pages site, served at `https://cass.community` (HTTP 200 from GitHub.com; DNS on GitHub Pages IPs). A project repo named `wg-ecosystem` with Pages enabled in the same org serves at `https://cass.community/wg-ecosystem/`. `https://cass.community/wg-ecosystem` currently returns 404, as expected since nothing is deployed yet.
- The repo's Pages source must be set to "GitHub Actions". The Jekyll `baseurl` must be `/wg-ecosystem`.
- Assumption holds; no stop needed.

## Items still needed from Mike
- Zoom link(s); confirm recurrence for working group sessions and Tea Time; confirm timezone (see above).
- Season intro and running agenda; Agent Skills panel details; initial resources (all existing TODOs).
