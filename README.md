# wg-ecosystem

The website for the CASS Software Ecosystem Working Group, served at
<https://cass.community/wg-ecosystem/> from this repo through GitHub Pages. It
is a record, not a forum: no comments, no forms. Conversation happens on Slack
and the groups.io lists.

Everything you normally do is the same gesture: **copy a template, fill it in,
commit.** Nobody writes HTML. See [CLAUDE.md](CLAUDE.md) for the conventions
and [docs/WORK_PACKAGE.md](docs/WORK_PACKAGE.md) for the original spec.

## How the site is put together

- **Main page** (`index.md`): what the group is, the kinds of gatherings, how to
  plug in, the current season, past seasons. It changes rarely and never
  repeats season details.
- **Seasons** (`seasons/<label>/`): one per academic year, e.g. `2026-27`.
  `season.md` holds the theme, intro and the running agenda; `events/` holds
  one Markdown file per event.
- **Resources** (`resources/`): a time-independent library, one Markdown file
  per item, shown on the `/resources/` page.
- **Shared metadata** (name, description, schedule text, Slack and groups.io
  links) is read from cass.community every build. Do not copy it here. Fix it
  in the cass.community repo (`_working-groups/software-ecosystem.md`).
- **Group-specific settings** live only in `site.config.yml`: timezone, current
  season, recurring series (schedule and Zoom link), and which upstream links to
  use.
- **Tea time** appears only as a standing invitation on the main page. No event
  files, notes, recordings, or topics. Do not add any.

## Add an event

1. Copy `seasons/<season>/events/_template.md` to
   `seasons/<season>/events/YYYY-MM-DD-short-slug.md`.
2. Fill in the front matter: `title`, `type` (`talk`, `panel`, or
   `working-group-session`), `date`, `people` (each with `name`, `role` =
   `presenter`/`panelist`/`moderator`, optional `affiliation`), `description`.
   Add `duration_minutes` if not 60.
3. Use `date: 2026-11-12` for a date only, or `date: 2026-11-12T12:00` (site
   timezone) to get an "Add to your calendar" link.
4. Commit and push to `main`. The card and page appear under **Upcoming**, and
   move to **Past** on their own once the event has ended.

The life cycle is always the same file:

1. **Announce:** front matter only. The Artifacts section stays hidden.
2. **Before the meeting:** add slides or readings to the body.
3. **After:** add what participants agreed to share (for example a
   panelist-approved summary). Only post artifacts people consented to.

## Add artifacts to an event

1. Create a folder beside the event file with the same name minus `.md`, e.g.
   `seasons/2026-27/events/2026-10-05-agent-skills-panel/`, and put the files in it.
2. Link them from the event's body, exactly as in the template:
   `- [Slides (PDF)](./2026-10-05-agent-skills-panel/slides.pdf)`.
3. Commit.

## Add a resource

1. Copy `resources/_template.md` to `resources/<short-slug>.md`.
2. Fill in `title`, `kind` (`white-paper`, `article`, `report`, `link`),
   `authors`, `date`, `tags` (keywords, may be `[]`), and `description` (why the
   group cares).
3. Set **exactly one** of:
   - `url:` an external link (leave `file: ""`), or
   - `file:` a PDF you commit under `resources/`, e.g. put it at
     `resources/<short-slug>/paper.pdf` and write `file: ./<short-slug>/paper.pdf`
     (leave `url: ""`).
4. Optional: `related_event` with the event's slug (its filename minus `.md`)
   to link back to it.
5. Commit. There is no per-resource page; the title links straight to the source.

## Start a new season

1. Create `seasons/<label>/` (e.g. `2027-28`) with:
   - `season.md`: copy the existing one and change `label`, `theme`, `starts`
     (`YYYY-MM`), `permalink` (`/seasons/<label>/`), and the body (intro and
     "What we're chewing on").
   - `events/_template.md`: copy it from the previous season.
2. In `site.config.yml`, set `current_season: <label>`.
3. Commit. The nav's "Current season" and the main page switch over, and the
   old season moves to **Past seasons**.

## Calendar files

Built automatically; there is nothing to author.

- `/calendar/<series-id>.ics` for each recurring gathering in `series:` in
  `site.config.yml` (rrule, `start_time`, Zoom link). Linked from the main page.
- `/calendar/<event-slug>.ics` for each upcoming event that has a time.

Series with `TODO` for `rrule` or `start_time` get no file; a `TODO` Zoom link
leaves the location out. We do not send shared calendar invites.

## Build and check locally

Needs Ruby 3.4 and Bundler.

```sh
bundle install
bin/prebuild                                   # fetch cass.community metadata
bundle exec jekyll serve --config _config.yml,site.config.yml
```

Open <http://localhost:4000/wg-ecosystem/>. Run `bin/prebuild` again whenever you
change the metadata URL, the upstream link labels or `current_season`.

Validation errors stop the build and name the file and field (for example an
unknown event `type`, a bad date, or a resource with both `url` and `file`).
`bin/prebuild` also fails, with a clear message, if cass.community cannot be
reached or this group's entry is incomplete. CI deploys only if both steps pass,
so the last good version stays live.

## Deployment

`.github/workflows/pages.yml` builds and deploys on every push to `main`, on
manual run, and daily (so events flip from upcoming to past). The repo's Pages
source must be set to **GitHub Actions** (Settings, Pages).

## Still to fill in (search for `TODO`)

- Zoom links and confirmed schedules and timezone (`site.config.yml`)
- Season intro and running agenda (`seasons/2026-27/season.md`)
- Agent Skills panel details, slides and approved summary
- Real resource entries (replace `resources/example-resource.md`)

## Claude skill (optional)

`.claude/skills/wg-content/SKILL.md` lets Claude Code do the steps above from a
plain description. It does only what this README describes; everything works
without it.
