---
label: "2026–27"
theme: "Agent Skills"
starts: 2026-10
permalink: /seasons/2026-27/
title: "Season 2026–27"
---

This season looks at agent skills: structured, shareable encodings of the expert judgment that has long lived in developers' heads, which an AI agent loads only when a task calls for them. The [Agent Skills Panel]({{ '/seasons/2026-27/events/2026-10-05-agent-skills-panel/' | relative_url }}) opened the season with leads from five CASS libraries and tools. Their shared conclusion was that skills are useful but not the hard part. Agents already write, test, and document scientific code well, and the bottleneck has moved to code review, CI capacity, and trust. Through the year we will compare how projects build and share skills, how they keep pace with the contributions agents now generate, and what a curated portfolio like ours needs to be both agent-accessible and agent-trustworthy.

## What we're chewing on

<!-- Loose running agenda for working group sessions. A shared sense of
     direction, never homework. Edit freely through the season. -->

Drawn from the open questions in the [Agent Skills Panel]({{ '/seasons/2026-27/events/2026-10-05-agent-skills-panel/' | relative_url }}) summary.

- **Layered, risk-based PR review.** Which automated gates and risk rules let agents handle low-risk changes and route the rest to people? Who checks the classifier?
- **Review and CI capacity.** Agents write code faster than projects can review and test it. Should projects reshape contributions, for example smaller PRs or plain-language specifications in place of code?
- **"A human reviews every line."** What that expectation means when agents write and review most of the code.
- **Trust infrastructure for skills.** Shared practice for testing, versioning, and verifying the source of skills, including protection against prompt injection.
- **Skills that span libraries.** Where cross-library skills should live, and how a CASS effort would relate to emerging skill marketplaces.
- **Skills as a way to transfer expertise.** Curated knowledge bases and user-facing skills, where encoding expert judgment seems to pay off most.
- **What a library is worth.** How a library's value changes when a user can re-implement a single algorithm in an afternoon.
- **The human side.** How early-career researchers build the skills agents now cover for them, and how projects plan for AI access that may become rationed or more expensive.

Added after the [November 2 working session]({{ '/seasons/2026-27/events/2026-11-02-panel-summary-discussion/' | relative_url }}).

- **Helped by scale, or obsoleted by scale?** A test for which AI-related investments will last as agent capability improves.
- **Build versus reuse.** Agents make it cheaper both to write your own algorithm and to adopt an existing library. Which effect wins, and what it means for how libraries position themselves.
- **Regenerating software from specifications.** The minimum specification an agent needs to rebuild a software product, organized as domain, system, environment and usability requirements.
- **Agentic workflows and agent costs.** Users supplying their own agent resources, distributing pre-generated artifacts, and treating agent-generated code as a derived product.
