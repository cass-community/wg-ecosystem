---
title: "Resources"
permalink: /resources/
---
A standing library of white papers, articles, reports, and links the working
group finds valuable. It is not tied to any season. Newest first.

<ul class="resource-list">
{%- for r in site.data.resources_all %}
  <li class="resource" data-kind="{{ r.kind }}" data-tags="{{ r.tags | join: ',' }}">
    {% if r.href contains "http" or r.href contains "/resources/" -%}
    <a class="resource__title" href="{{ r.href }}">{{ r.title }}</a>
    {%- else -%}
    <span class="resource__title">{{ r.title }} (link to be added)</span>
    {%- endif %}
    <span class="resource__meta">
      <span class="event-card__badge">{{ r.kind_label }}</span>
      {{ r.authors | join: ", " }} &middot; {{ r.date }}
    </span>
    <span class="resource__desc">{{ r.description }}</span>
    {%- if r.tags.size > 0 %}
    <span class="resource__tags">
      {%- for t in r.tags %}<span class="resource__tag">{{ t }}</span>{% endfor -%}
    </span>
    {%- endif %}
    {%- if r.related_event %}
    <span class="resource__related">Related: <a href="{{ r.related_event.url }}">{{ r.related_event.title }}</a></span>
    {%- endif %}
  </li>
{%- endfor %}
</ul>
