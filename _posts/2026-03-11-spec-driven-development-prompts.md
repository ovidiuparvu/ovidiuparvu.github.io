---
layout: post
title: Useful spec-driven development prompts
comments: true
tags: [sdd,agentic,claude]
---

Based on: https://www.nathanonn.com/claude-code-spec-driven-development-3-phase-method/.

## Specification writing

```plain
[Task/feature description]

Write the md specs for the feature above at @specifications/0001_feature/specs.md.

Use the AskUserQuestion tool to ask me clarifying questions until you are 99% confident you can complete this task successfully.
For each question, add your recommendation (with reason why) below the options. This would help me in making a better decision.
```

## Specification review

```plain
Read the `specifications/0001_feature/specs.md`, analyze the codebase and tell me what could be 
the potential problems with this specs. 

Let's look at it from different angles and try to consider every edge cases.

Use ASCII diagrams to illustrate if needed. Don't edit anything yet. Let's focus on analysis.
```

## Specification revision

```plain
Address all major issues. Update the specs file.

Use the AskUserQuestion tool to ask me clarifying questions until you are 99% confident you can complete this task successfully.
For each question, add your recommendation (with reason why) below the options.
```
