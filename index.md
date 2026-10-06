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

<div class="tiles">
  <div class="tile">
    <i class="fa-solid fa-fw fa-chalkboard-user tile__icon" aria-hidden="true"></i>
    <h3 class="tile__title">Talks and panels</h3>
    <p>Webinars and panel discussions on topics of interest to the community. Each one has its own page with slides and, where participants agree, a summary.</p>
    <p class="tile__meta">Archived</p>
  </div>
  <div class="tile">
    <i class="fa-solid fa-fw fa-people-group tile__icon" aria-hidden="true"></i>
    <h3 class="tile__title">Working group sessions</h3>
    <p>Working meetings where members dig into the season's theme together. The season page carries a loose running agenda.</p>
    <p class="tile__meta">Light notes</p>
  </div>
  <div class="tile tile--invite">
    <i class="fa-solid fa-fw fa-mug-hot tile__icon" aria-hidden="true"></i>
    <h3 class="tile__title">Tea time</h3>
    <p>A standing invitation. Drop in and think out loud. There is no recording, no notes, and no archive. Tea time has its own mailing list.</p>
    <p class="tile__meta">Monthly &middot; 30 minutes &middot; drop in</p>
  </div>
</div>

**Schedule:** {{ up.meeting_schedule }}.

## How to plug in

<div class="tiles">
  <a class="tile tile--link" href="{{ up.links.slack_channel }}">
    <i class="fa-brands fa-fw fa-slack tile__icon" aria-hidden="true"></i>
    <h3 class="tile__title">Slack</h3>
    <p>Chat with the group in the working group channel in the CASS Slack workspace.</p>
    <p class="tile__meta">Open the channel &rarr;</p>
  </a>
  <a class="tile tile--link" href="{{ up.links.mailing_list }}">
    <i class="fa-solid fa-fw fa-envelopes-bulk tile__icon" aria-hidden="true"></i>
    <h3 class="tile__title">Working group list</h3>
    <p>Announcements and follow-up conversation happen on this groups.io list.</p>
    <p class="tile__meta">Join on groups.io &rarr;</p>
  </a>
  <a class="tile tile--link" href="{{ up.links.teatime_list }}">
    <i class="fa-solid fa-fw fa-mug-hot tile__icon" aria-hidden="true"></i>
    <h3 class="tile__title">Tea time list</h3>
    <p>A separate groups.io list for the informal monthly tea time.</p>
    <p class="tile__meta">Join on groups.io &rarr;</p>
  </a>
  <div class="tile">
    <i class="fa-solid fa-fw fa-video tile__icon" aria-hidden="true"></i>
    <h3 class="tile__title">Zoom</h3>
    <ul class="tile__list">
{%- for s in site.series %}
      <li>{{ s.name }}: {% if s.zoom contains "http" %}<a href="{{ s.zoom }}">join</a>{% else %}<strong>{{ s.zoom }}</strong> (Zoom link to be added){% endif %}</li>
{%- endfor %}
    </ul>
  </div>
  <div class="tile">
    <i class="fa-solid fa-fw fa-calendar-plus tile__icon" aria-hidden="true"></i>
    <h3 class="tile__title">Add to your calendar</h3>
    <p>Download and import into your own calendar app. We do not send shared invites.</p>
    <ul class="tile__list">
{%- for c in site.data.series_ics %}
      <li>{% if c.url %}<a href="{{ c.url }}">{{ c.name }} (.ics)</a>{% else %}{{ c.name }}: TODO (schedule to be added){% endif %}</li>
{%- endfor %}
    </ul>
  </div>
</div>

Questions? Ask on the working group mailing list.

## Seasons

Each season has a theme, a loose running agenda, and a page for every event.

{% assign seasons = site.pages | where_exp: "p", "p.path contains 'season.md'" | where_exp: "p", "p.label" | sort: "starts" | reverse -%}
<div class="tiles">
{%- for p in seasons %}
{%- assign is_current = false %}{% if p.path contains site.current_season %}{% assign is_current = true %}{% endif %}
  <a class="tile tile--link{% if is_current %} tile--invite{% endif %}" href="{{ p.url | relative_url }}">
    <i class="fa-solid fa-fw {% if is_current %}fa-seedling{% else %}fa-box-archive{% endif %} tile__icon" aria-hidden="true"></i>
    <h3 class="tile__title">{{ p.label }}</h3>
    <p>{{ p.theme }}</p>
    <p class="tile__meta">{% if is_current %}Current season{% else %}Past season{% endif %} &rarr;</p>
  </a>
{%- endfor %}
</div>
{% unless seasons.size > 1 %}
<p class="muted">Past seasons will be listed here.</p>
{% endunless %}
