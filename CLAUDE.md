# CLAUDE.md — CASS Software Ecosystem Working Group site

Durable conventions for this repo. Full rationale: the design doc linked in docs/ or WORK_PACKAGE.md.

## What this site is
A static record for the CASS Software Ecosystem Working Group, served at cass.community/wg-ecosystem from this repo via GitHub Pages. It is a record, not a forum.

## Rules
- **Never modify the cass.community repo.** Read its metadata at build time; never copy it into this repo.
- **One place per fact.** Shared WG metadata comes from cass.community. Group-specific settings live only in `site.config.yml`. The evergreen page points to the current season; it never repeats season details.
- **Build around activity and roles, not people.** CASS is meant to outlast the people and projects (e.g. PESO) currently staffing it. Don't hardcode leads' names on the evergreen page.
- **Tea time leaves no trail.** No event files, notes, recordings, archives, or published topics for tea time. It appears only as a standing invitation on the evergreen page.
- **No on-page interaction.** No comment widgets or forms. Conversation happens on Slack and the groups.io lists.
- **One follow-up link per event:** the working group groups.io list. Never Slack, never both.
- **The record bends to consent.** Only post artifacts participants agreed to (e.g. a panel not recorded at the panelists' request gets slides plus an approved summary, nothing more).
- **The resource library is timeless.** Resources (white papers, articles, links) live on their own `/resources` page as a flat list, never inside a season. Carry `tags` on each for future search; don't build filtering UI until the collection warrants it.
- **Real pages, no pop-ups.** Cards and list rows preview; clicking navigates to a real URL (event page) or straight to the source (resource). No modals or overlays for content.
- **Plain files first.** Everything must be doable by copying `_template.md`, editing Markdown, and committing. Automation (the wg-content skill) only wraps that workflow.
- **Don't invent content.** Unknown values stay as visible `TODO` placeholders.

## Authoring
- Event file: `seasons/<season>/events/YYYY-MM-DD-short-slug.md`, copied from `_template.md`.
- Artifacts: in a folder beside the event file with the same name (minus `.md`), linked from the event body.
- New resource: copy `resources/_template.md`, rename to a short slug, set either `url` or `file` (not both), commit.
- New season: new `seasons/<label>/` folder with `season.md` and `events/_template.md`; then update `current_season` in `site.config.yml`.
- Always run the build locally (or let CI run) before considering a change done; validation errors name the file and field.
