# Work Package: CASS Software Ecosystem Working Group Website

**For:** Claude Code
**Owner:** Mike Heroux (chair, CASS Software Ecosystem Working Group)
**Design doc:** https://claude.ai/code/artifact/0ee7f54e-e0fd-451a-b907-c63296c2a8dc
**Target URL:** `https://cass.community/wg-ecosystem`

## 1. What you're building

A small static website for the CASS Software Ecosystem Working Group, hosted on GitHub Pages from its own repo in the CASS GitHub org. It has two kinds of pages:

- A **thin evergreen main page**: what the working group is, the three kinds of gatherings, how to plug in, and a pointer to the current season. It changes rarely and never restates current-season details.
- **Per-season pages** (one per roughly academic-year "season," October through spring): the season's theme, a loose running agenda, and a card for every event. Each event also gets its own small page.
- **A resource library page**: a standing, time-independent collection of white papers, articles, reports, and links the working group finds valuable.

Events and resources are authored as one Markdown file each. The build turns those folders into cards, lists, and pages, so nobody ever hand-writes HTML. The current season (2026–27) has the theme **Agent Skills**.

Read `CLAUDE.md` in this package before starting. It holds the durable conventions and goes into the repo root as-is.

## 2. Fixed decisions (do not revisit)

1. **Separate repo** in the CASS GitHub org, named `wg-ecosystem`. Do not modify the cass.community repo; treat it as read-only.
2. **Same look and feel as cass.community, by copy not coupling.** Adapt its styles into this repo. Don't hot-link its CSS or depend on its build.
3. **cass.community is the single source of truth** for shared WG metadata (name, description, meeting info). Fetch it at build time. Never commit a copy.
4. **One Markdown file per event**, with YAML front matter: `title`, `type`, `date`, `people`, `description`. The body holds artifacts.
5. **Three gathering types**, treated differently:
   - *Talks and panels*: archival. Event files, cards, pages, artifacts.
   - *Working group sessions*: event files, light artifacts. The season page carries a loose running agenda ("what we're chewing on").
   - *Tea time*: monthly, 30 minutes, drop-in. **No event files, no recording, no notes, no archive, no published topics.** It lives on the evergreen page only, as a standing invitation.
6. **No on-page interaction.** No comments (no Giscus or Utterances), no forms. The page is a record, not a forum.
7. **One follow-up link per event**, to the working group's groups.io mailing list. Not Slack, and never both.
8. **No shared calendar invites.** Publish a stable Zoom link on the evergreen page plus downloadable ICS files people import themselves.
9. **The plain-file workflow must stand alone.** The Claude skill (Phase 5) is a convenience on top, never a requirement.
10. **Real pages, no pop-ups.** Cards and list rows are previews; clicking navigates. An event card opens the event's own page at its own URL (bookmarkable, shareable in Slack, works on phones). A resource entry links straight to its source. No modals, lightboxes, or overlay windows for content.
11. **Resources are timeless.** They live on their own `/resources` page, never inside a season, as a flat list with keyword `tags` carried for future search.

## 3. Phase 0: Discovery (do first, report briefly)

Inspect the cass.community repo and site, then write a short `docs/DISCOVERY.md` covering:

- **Generator and stack.** Which static site generator cass.community uses. Use the same one if it's a mainstream generator, so styles and templates port cleanly. Otherwise pick one that handles Markdown + front matter well and builds in GitHub Actions; note why.
- **Styles.** Which stylesheets, fonts, header, and footer to adapt.
- **Metadata file.** Its path, format (JSON or YAML), schema, and this working group's key in it. Note which meeting fields (Zoom link, schedule) it already holds.
- **URL routing.** Confirm that a project repo named `wg-ecosystem` in the same org will serve at `cass.community/wg-ecosystem` (true when cass.community is the org's Pages site on a custom domain). **If this assumption fails, stop and report before building.**

## 4. Phase 1: Skeleton, build pipeline, evergreen page

**Build pipeline**

- GitHub Actions workflow that builds and deploys to Pages on push to `main`, on `workflow_dispatch`, and on a **daily schedule**. The daily run lets events flip from upcoming to past and picks up upstream metadata changes.
- A build step fetches the cass.community metadata file. If the fetch fails or this WG's entry is missing, **fail the build with a clear message**. The last good deploy stays live; never publish with missing data.
- All group-specific settings live in one file, `site.config.yml` (starter provided). This keeps the repo easy to turn into a template for other working groups later.
- **Precedence for meeting info:** use upstream metadata where it exists; `site.config.yml` supplies only what upstream lacks. Don't define the same value in both places.

**Evergreen page** (`/wg-ecosystem/`), in this order:

1. What the working group is (upstream description, plus an optional short local intro).
2. The kinds of gatherings: talks/panels, working group sessions, and tea time. Tea time reads as a standing invitation: monthly, 30 minutes, drop in, no recording or notes, with its own mailing list.
3. How to plug in: CASS Slack channel (in the CASS workspace), the working group groups.io list, the separate tea time groups.io list, the stable Zoom link, and "Add to your calendar" ICS downloads.
4. Current season: label, theme, and a link. Nothing more.
5. Past seasons: a list of links (empty for now).

Site navigation (on every page): Home, Current season, Resources.

Name roles, not people. No chair names on the evergreen page; contact goes through the mailing list.

**Acceptance:** site deploys at the target URL, matches cass.community's look, shows upstream metadata, and the build fails clearly when the metadata URL is broken.

## 5. Phase 2: Seasons and events

**Content layout**

```
seasons/
  2026-27/
    season.md                 # label, theme, intro, running agenda
    events/
      _template.md            # ignored by the build (leading underscore)
      2026-10-05-agent-skills-panel.md
      2026-10-05-agent-skills-panel/   # artifacts for that event (slides, summary PDFs)
```

**Event front matter**

| Field | Required | Notes |
| --- | --- | --- |
| `title` | yes | |
| `type` | yes | `talk`, `panel`, or `working-group-session` |
| `date` | yes | `YYYY-MM-DD`, or `YYYY-MM-DDTHH:MM` local time in the site timezone. A time enables the per-event calendar link. |
| `duration_minutes` | no | Used for the per-event ICS. Default 60. |
| `people` | yes | List of `{name, role, affiliation?}`; role is `presenter`, `panelist`, or `moderator`. |
| `description` | yes | One or two sentences on what the gathering is for. |

**Validation:** the build fails on a missing required field, an unknown `type`, or an unparseable date, naming the file and field. It warns (doesn't fail) when the filename date doesn't match `date`.

**Season page** (`/wg-ecosystem/seasons/2026-27/`): theme and intro, the "What we're chewing on" running agenda from `season.md`, then **Upcoming** events (soonest first) and **Past** events (newest first). An event is past once its date has ended in the site timezone. Link back to the evergreen page.

**Event card:** type badge, title, date, people, description. The whole card links to the event page (a normal navigation, not a pop-up).

**Event page:** everything on the card, then an **Artifacts** section rendering the file body (omitted entirely when the body is empty, as in the announce phase), an "Add to your calendar" link when upcoming and timed, and one **"Continue the conversation"** link to the working group mailing list.

The authoring life cycle this supports, always the same gesture (open the file, add, commit):

1. **Announce:** front matter only. The card and page appear under Upcoming.
2. **Pre-meeting content:** slides or readings added to the body ahead of time.
3. **Capture and set aside:** after-the-fact artifacts (for example, a panelist-approved summary). The event moves to Past on its own.

**Acceptance:** dropping a new file in `events/` produces a card and page with no other edits; the starter Agent Skills panel renders correctly; a malformed file fails the build with a useful message.

## 6. Phase 3: Calendar files

- **Series ICS** for each recurring gathering (tea time; working group sessions if they recur), generated at build time. Each holds the RRULE, a `TZID`, and the Zoom link in both the location and the description. Linked from the evergreen page.
- **Per-event ICS** for any upcoming event with a time, linked from its page.
- Use stable `UID`s so re-importing updates rather than duplicates.

**Acceptance:** the files import cleanly into Apple Calendar, Google Calendar, and Outlook, with the right local time and the Zoom link visible.

## 7. Phase 4: Resource library

A standing, **time-independent** collection of resources the working group finds valuable (white papers, articles, reports, external links). Unlike seasons and events, these are not tied to a point in time, so they must not be buried in a season archive.

- **Its own evergreen page** at `/wg-ecosystem/resources`, linked from the main nav alongside the current season. Not part of the landing page, and not an event page.
- **One Markdown file per resource** in a top-level `resources/` folder (starter template provided), same authoring gesture as events: copy `_template.md`, rename to a short slug, fill in, commit.
- **Front matter:** `title`, `kind` (`white-paper` | `article` | `report` | `link`), `authors`, `date`, `tags` (keyword list), `description` (why the group cares), and exactly one of `url` (external) or `file` (a PDF committed beside the entry). Optional `related_event` back-links to an event slug.
- **Hosting:** support both — an external URL, or a local file committed in a folder beside the entry. Don't force rehosting of things that already live elsewhere.
- **Rendering:** a **flat list, newest first**, for now. No per-resource page: each entry's title links **straight to the source** (the external url or the hosted file). Each entry shows title, kind, authors, date, tags, and description. Render the `tags` into the markup (e.g. as data attributes or visible chips) so a future search/filter layer has something to work with — **but don't build filtering UI yet.**
- **Validation:** fail the build on a missing required field, an unknown `kind`, or an entry that sets neither `url` nor `file` (or sets both). Name the file and field.

**Acceptance:** dropping a resource file in `resources/` adds it to the page with no other edits; both an external-link entry and a local-PDF entry render correctly; tags appear in the output; a malformed entry fails the build with a useful message.

## 8. Phase 5: Authoring aids

- `README.md` aimed at the next maintainer: how to add an event (copy the template, rename `YYYY-MM-DD-slug.md`, fill in, commit), add artifacts, add a resource (copy `resources/_template.md`, rename to a short slug, set `url` or `file`), start a new season, and change `current_season`.
- A repo-local Claude skill at `.claude/skills/wg-content/SKILL.md` that automates the same steps: create an event from a plain description ("new panel Nov 12 on X, panelists A and B"), add artifacts and wire their links, add a resource from a link or PDF (proposing tags for Mike to confirm), start a new season, and run the build to validate. It must only do what a person could do by hand with the README.

## 9. Out of scope

On-page comments or forms; tea time topics, notes, or archive; Zoom registration; shared calendar invites; analytics; a search/filter UI for the resource library (carry tags now, build filtering later); editing the cass.community repo; generalizing into a multi-group template (just keep group specifics in `site.config.yml` so that's easy later).

## 10. Inputs Mike needs to supply

Leave these as visible `TODO` placeholders. Don't invent values; list any still missing at the end of each phase.

- CASS GitHub org name and the cass.community repo (Phase 0 may find these)
- Slack channel name and link
- groups.io URLs for the working group list and the tea time list
- Zoom link(s) and the recurring schedule for tea time and working group sessions, if not already upstream
- Confirm the site timezone (starter assumes `America/Chicago`)
- Season intro text and running agenda for 2026–27
- Agent Skills panel: panelist names and affiliations, slides, and the approved summary
- Initial resource library entries (the starter holds one placeholder)

## 11. Starter files in this package

| File | Goes to |
| --- | --- |
| `CLAUDE.md` | repo root |
| `starter/site.config.yml` | repo root |
| `starter/seasons/2026-27/season.md` | same path |
| `starter/seasons/2026-27/events/_template.md` | same path |
| `starter/seasons/2026-27/events/2026-10-05-agent-skills-panel.md` | same path |
| `starter/resources/_template.md` | same path |
| `starter/resources/example-resource.md` | same path |

Adjust field names if Phase 0 shows the generator needs something different, but keep the authoring experience the same.
