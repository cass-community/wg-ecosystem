---
title: "CASS Software Ecosystem"
excerpt: "A Working Group of the Consortium for the Advancement of Scientific Software"
permalink: /
layout: splash
---
{% assign up = site.data.upstream %}
{% assign first = up.description | slice: 0, 1 | upcase %}
{% assign rest = up.description | slice: 1, 10000 %}

## What the working group is

**{{ up.name }}:** {{ first }}{{ rest }}.
{% if site.intro and site.intro != "" %}

{{ site.intro }}
{% endif %}

More about the working group, including its charter, is on the
[CASS website](https://cass.community/working-groups/software-ecosystem).

## Ways we gather

**Talks and panels.** Webinars and panel discussions on topics of interest to
the community. Each one has its own page with slides and, where participants
agree, a summary.

**Working group sessions.** Working meetings where members dig into the
season's theme together. The season page carries a loose running agenda.

**Tea time.** A standing invitation: monthly, 30 minutes, drop in. It is
deliberately informal. There is no recording, no notes, and no archive, so
come and think out loud. Tea time has its own mailing list.

**Schedule:** {{ up.meeting_schedule }}.

## How to plug in

- **Slack:** the [working group channel]({{ up.links.slack_channel }}) in the CASS Slack workspace.
- **Mailing list:** the [working group list]({{ up.links.mailing_list }}) on groups.io. Announcements and follow-up conversation happen here.
- **Tea time list:** the separate [tea time list]({{ up.links.teatime_list }}) on groups.io.
- **Zoom:**
{%- for s in site.series %}
  {{ s.name }}: {% if s.zoom contains "http" %}[join]({{ s.zoom }}){% else %}**{{ s.zoom }}** (Zoom link to be added){% endif %}{% unless forloop.last %};{% endunless %}
{%- endfor %}
- **Calendar:** download and import these into your own calendar app. We do not send shared invites.
{%- for c in site.data.series_ics %}
  {% if c.url %}[{{ c.name }} (.ics)]({{ c.url }}){% else %}{{ c.name }}: TODO (schedule to be added){% endif %}{% unless forloop.last %};{% endunless %}
{%- endfor %}

Questions? Ask on the working group mailing list.

## Current season

{% assign cur = site.pages | where_exp: "p", "p.path contains site.current_season" | where_exp: "p", "p.path contains 'season.md'" | first %}
{% if cur %}
**[{{ cur.label }}: {{ cur.theme }}]({{ cur.url | relative_url }})**
{% else %}
TODO: season page for {{ site.current_season }} not found.
{% endif %}

## Past seasons

{% assign past = site.pages | where_exp: "p", "p.path contains 'season.md'" | where_exp: "p", "p.label" | sort: "starts" | reverse %}
{% assign shown = 0 %}
{% for p in past %}{% unless p.path contains site.current_season %}
- [{{ p.label }}: {{ p.theme }}]({{ p.url | relative_url }})
{% assign shown = shown | plus: 1 %}{% endunless %}{% endfor %}
{% if shown == 0 %}None yet.{% endif %}
