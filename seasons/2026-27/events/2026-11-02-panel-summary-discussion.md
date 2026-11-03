---
title: "Working Session: Discussing the Agent Skills Panel Summary"
type: working-group-session
date: 2026-11-02T12:00
duration_minutes: 60
people:
  - name: Mike Heroux
    role: moderator
description: >
  A working session to discuss the approved summary and key themes from the October 5
  Agent Skills Panel.
---

The discussion started from the panel summary:

- [Agent Skills Panel summary and key themes (PDF)](../2026-10-05-agent-skills-panel/2026-10-05-AgentSkillsPanelSummaryKeyThemes.pdf)
- [Agent Skills Panel slides (PDF)](../2026-10-05-agent-skills-panel/2026-10-05-CASS_Agent_Skills_Panel_Slides.pdf)
- [Agent Skills Panel event page](../2026-10-05-agent-skills-panel/)

## Session notes

A small group met for an open discussion of how AI agents are changing the way scientific software is developed and used.

**Keeping up with agentic AI.** Agentic AI is already in practical use, and many researchers are still getting familiar with it. Researchers often lack the unscheduled time it takes to experiment with these tools and gain hands-on experience.

**Helped by scale, or obsoleted by scale?** A member is writing a white paper, "A Better Lesson," that builds on Rich Sutton's ["The Bitter Lesson"](http://www.incompleteideas.net/IncIdeas/BitterLesson.html). It proposes one test for AI-related efforts: will the work be helped by scale, or made obsolete by it? The paper describes improving AI capability as a rising tide that lifts boats and washes away sandcastles. Short-lived work can still be worthwhile if it is useful in the meantime.

**Build-vs-reuse economics for libraries.** AI makes it cheaper to write your own version of a well-understood algorithm, such as a time integrator. It also makes it cheaper to adopt an existing library like AMReX, because an agent can handle the integration. Which effect will dominate is an open question, and the answer matters for how scientific libraries position themselves.

**Making software AI-ready and agent-discoverable.** One practical step is to keep a repository's example input files correct and current, because agents model new inputs on whatever examples they find. PESO has been improving discoverability for both people and agents through Jupyter notebooks and JSON-formatted output.

**The future role of modeling and simulation.** Modeling and simulation are expected to be used more often inside machine learning workflows, for example to generate synthetic data, build world models and support AI training. This is a growing opportunity for ecosystem software.

**Regenerating software from specifications.** An ongoing experiment is measuring the minimum specification an agent needs to regenerate software products that were built before. Requirements fall into four categories: domain, system, programming and execution environment, and usability. Any one category can be swapped while the other three stay fixed, for example to target a new architecture or a new domain.

**Agentic workflows and their costs.**
- In future workflows, an agent may gather data and set up simulation runs, so users would no longer write input files by hand.
- If software is released as an agentic workflow, users would supply their own agent resources, much as they supply computing allocations today. Agent costs are likely to become a practical planning factor.
- Because generating with an agent has real cost, pre-generated static artifacts are still worth distributing.
- Agent-generated code should be treated as a derived product rather than primary source, much as projects ship the output files of Autoconf and Automake.
- The field is still mostly exploring rather than exploiting.

**Strategic directions for ecosystem software.**
- Focus on capabilities that improve with scale.
- Aim to expand the user base dramatically.
- Make software turnkey, and embed it in every environment where it could be useful.
- Development cycles have become much faster. In recent public Genesis Mission work, a small team went from first concept to a working engineering prototype in under a year.
- Members encouraged everyone to spend as much time as possible learning and experimenting with these tools.
