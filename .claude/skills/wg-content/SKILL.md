---
name: wg-content
description: Maintain content for the CASS Software Ecosystem WG site. Use to add an event ("new panel Nov 12 on X, panelists A and B"), add artifacts to an event, add a resource from a link or PDF, start a new season, or validate by running the build.
---

# wg-content

Automates the manual workflow in README.md for this repo. Do only what a person
could do by hand following the README; don't change plugins, layouts or config
structure. Read CLAUDE.md first and follow its rules. Never invent values:
unknown fields stay as visible `TODO` placeholders, and you list them at the end.

## Add an event
1. Parse the request into type (`talk`, `panel`, `working-group-session`),
   date (add `THH:MM` only if a time is given, in the site timezone), title,
   people (`name`, `role`, optional `affiliation`), description, duration.
2. Copy `seasons/<current_season>/events/_template.md` to
   `YYYY-MM-DD-short-slug.md` (season = the one containing the date; ask if
   ambiguous). Fill the front matter. If no description was given, write a
   neutral one-sentence description from the title and mark it for review.
3. Leave the body empty (announce phase) unless artifacts were supplied.
4. Never create files for tea time; refuse and explain (it leaves no trail).
5. Run the build (below).

## Add artifacts to an event
1. Put the files in a folder beside the event file named like it minus `.md`.
2. Add links to the event body: `- [Label](./<event-name>/<file>)`.
3. Only add artifacts the participants agreed to share. If it's unclear (for
   example a panel not recorded at panelists' request), ask before adding
   anything beyond slides and an approved summary.
4. Run the build.

## Add a resource
1. From a link: fetch the page for title, authors, date and a summary. From a
   PDF: copy it to `resources/<slug>/` and set `file: ./<slug>/<name>.pdf`
   (leave `url: ""`). Set exactly one of `url` or `file`.
2. Copy `resources/_template.md` to `resources/<slug>.md`, choose `kind`,
   write `description` as why the group would care.
3. **Propose tags and wait for Mike to confirm them** before finalizing; show
   the proposed list, and leave `tags: []` until confirmed.
4. Run the build.

## Start a new season
1. Create `seasons/<label>/` with `season.md` (copy the previous one; set
   `label`, `theme`, `starts`, `permalink: /seasons/<label>/`; theme and intro
   as `TODO` if not given) and `events/_template.md` (copy the previous one).
2. Set `current_season: <label>` in `site.config.yml`. Confirm with Mike first
   if the previous season still has upcoming events.
3. Run the build.

## Validate
```sh
bin/prebuild
bundle exec jekyll build --config _config.yml,site.config.yml
```
Errors name the file and field. Fix and rerun until clean. Report any warnings
(for example a filename date mismatch or a missing Zoom link). Do not commit or
push unless asked; summarize the files changed and any remaining `TODO`s.
