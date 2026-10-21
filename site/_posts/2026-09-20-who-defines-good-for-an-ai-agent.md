---
layout: post
title: "Who Gets to Define ‘Good’ for an AI Agent?"
date: 2026-09-20 00:00:00 +0800
description: "Why evaluating an AI agent may require more than measuring whether it completed the task."
permalink: /blog/2026/who-defines-good-for-an-ai-agent/
tags:
  - ai-agents
  - agent-evaluation
  - personalization
  - benchmarks
  - human-centered-ai
categories:
  - essays
lang: en
---

> **TL;DR** As AI agents move from answering benchmark questions to operating software, manipulating files, and completing real-world workflows, a basic assumption in evaluation becomes increasingly important: who gets to define what “good” means? APEX-Agents provides a useful model for professional work: realistic environments, natural tasks, agentic execution, and expert-defined rubrics. We can extend this paradigm to consumer and individual-facing work, where the world is the user’s digital environment and the rubric reflects the preferences of the person being served.
>
> The central idea is to build evaluations where **World = files / software**, **Task = your command**, and **Rubric = personal preferences**. A task such as “make a slide deck for my class presentation from the source materials” is not just a test of whether an agent can generate slides. It tests whether the agent can understand the user’s goal, operate within their environment, and produce an outcome that fits what this particular person considers good.

## The hidden assumption: who defines success?

Agent evaluation has traditionally followed a relatively simple structure: a task is given to an agent, the agent produces an output, and that output is compared against a predefined rubric. This works well when the desired outcome is relatively objective. A mathematical answer can be correct or incorrect; a program can pass or fail a test.

But agents are increasingly being evaluated on tasks where there are many valid ways to achieve the goal. OSWorld places agents inside real computer environments, AssistantBench evaluates realistic web tasks, and τ-bench evaluates interactions between users, agents, tools, and domain policies.[1–3] APEX-Agents extends this idea to professional work, where agents complete long-horizon tasks across realistic work environments and are evaluated using expert-authored criteria.[4]

Once evaluation moves from “did the model produce the right answer?” to “did the agent produce a useful outcome?”, the rubric becomes much more important. The rubric is effectively a specification of what counts as success.

And that raises a simple question:

**Who gets to define it?**

## Experts define the rubric, but experts are only one population

For professional work, expert-defined rubrics make a lot of sense. An investment banker, lawyer, or consultant can judge whether a deliverable satisfies relevant professional standards. APEX-Agents demonstrates the usefulness of this setup by evaluating agents on realistic professional tasks using expert-authored criteria.[4]

But experts are only one possible stakeholder.

The person evaluating an output may not be the person who ultimately uses it. An expert may care about completeness and professional rigor. A company may care about cost, compliance, consistency, and workflow. An individual user may care about simplicity, personal taste, convenience, or whether the result fits the way they normally work.

The same task can therefore have different notions of success depending on who the agent is serving. The question is not necessarily whether one rubric is correct and another is wrong. They may simply represent different objectives.

## Users do not agree on what “good” means

This is not only a theoretical possibility. Recent work on personalized benchmarking shows substantial divergence between individual preferences and aggregate model rankings.[5] A global leaderboard can tell us how models perform according to an aggregated population, but aggregation inevitably removes some information about individual differences.

This distinction becomes especially important for agents because agents can repeatedly work for the same person. Over time, the agent may learn that one user prefers concise answers, another prefers detailed explanations, and another strongly values visual structure or particular sources.

A global score may still be useful for measuring general capability. But it does not necessarily tell us whether an agent is good for this person.

The benchmark question therefore changes from:

> “Which agent performs best on this task?”

to:

> “Which agent produces the outcome this stakeholder actually wants?”

## From personalization to evaluation

Personalization is usually framed as a problem of changing the agent’s behavior. Given a user profile or interaction history, can the agent produce a response that better matches that user?

Recent work has pushed this beyond simple text generation. RealPref studies long-horizon preference following, APeB evaluates agents that infer user preferences during product search, and ETAPP evaluates personalization in tool-augmented agents.[6–8] In these settings, preferences can influence not only what the agent says, but what it decides to do.

But this creates a second problem.

If two users should receive different outcomes, should the evaluator judge those outcomes differently as well?

Imagine an agent is asked to summarize a paper. One user prefers very concise summaries because they use them only to decide which papers to read. Another user wants detailed summaries because they use them for study. A fixed evaluator might reward the second output for completeness and penalize the first for omission.

Yet the first output may be exactly what the first user wanted.

The agent may have personalized correctly while the evaluation function failed to personalize.

## Can the evaluator understand the user?

This makes personalized judging a separate problem from personalized generation.

_Can LLM be a Personalized Judge?_ investigates whether an LLM can judge outputs according to individual preferences represented through personas.[9] The results suggest that simply giving a judge a persona does not automatically produce reliable personalized evaluation.

This is an important distinction. A persona is not necessarily a preference model. And a preference model is not necessarily a rubric that can reliably distinguish between good and bad outcomes.

If we want to evaluate whether an agent did something well for an individual, the evaluator needs some representation of what that individual values in the outcome.

## What if the rubric itself has to be learned?

In many consumer settings, users never explicitly write down their evaluation criteria.

A student does not normally specify:

> “My slide deck should have 30% visual content, 20% information density, and 50% narrative coherence.”

Instead, their preferences appear through behavior. They repeatedly remove text, change layouts, ask for shorter explanations, choose certain examples, or keep modifying the same part of an output.

Those observations can become evidence about a latent preference.

Recent work such as PARL explores preference-aware rubric learning, while PREFINE explores generating user-specific rubrics from preference information.[10,11] This suggests an interesting direction for agent evaluation: instead of treating the rubric as something that must always be written by the benchmark designer, the rubric can itself become an object of inference.

The conceptual shift is small but important:

> The benchmark does not only evaluate the agent. It also has to represent the stakeholder whose preferences define the outcome.

## From users to stakeholders

“User” may actually be too narrow a term.

Consider an agent working inside a company. The employee using the agent may want speed. The manager may care about consistency. The company may care about compliance and cost. The customer may care about the final result.

All of these stakeholders can have different objectives while interacting with the same agent.

This suggests a broader framing: stakeholder-conditioned evaluation. The stakeholder could be a consumer, student, researcher, employee, expert, manager, or organization. What matters is that the evaluation reflects the objectives of the party the agent is intended to serve.

This is also why the consumer setting is interesting. Consumer tasks provide a natural environment where the stakeholder and the beneficiary are often the same person. That makes it possible to study preference-conditioned evaluation without immediately introducing complex organizational conflicts.

## APEX for the individual

This leads to a straightforward extension of the APEX-style paradigm.

Instead of evaluating an agent inside a professional workplace, we evaluate it inside an individual’s digital environment.

The world might contain PDFs, notes, presentations, browser sessions, folders, and software. The task can be an ordinary natural-language command. The agent can freely inspect the environment and operate available tools. The final artifact or changed state becomes the outcome.

For example:

> “Make a slide deck for my class presentation from the source materials.”

The benchmark could provide lecture notes, papers, the professor’s requirements, previous presentations, and presentation software. The agent must determine what information matters, construct the deck, operate the software, and produce a presentation.

The evaluation is then not simply whether the slides contain the correct information. It asks whether the resulting presentation satisfies both the task requirements and the preferences of the individual who will actually present it.

## World = files / software

This makes the environment itself a key component of the benchmark.

For professional agents, the world might contain enterprise applications and work documents. For consumer agents, the world can be the individual’s own collection of files and software.

This gives us a simple abstraction:

> **World = Files + Software**

The environment does not need to represent someone’s entire life. A bounded collection of realistic personal files and applications may be enough to create the conditions under which personal preferences actually matter.

The important thing is that the agent has to act in the world, rather than simply generate a response describing what the user should do.

## Task = your command

The task can then be expressed as a natural command from the individual.

Instead of:

> “Create a 12-slide presentation containing sections A, B, C, and D.”

we can use:

> “Make a slide deck for my class presentation from the source materials.”

The latter is much closer to how people actually interact with agents. The command specifies the goal, while leaving many decisions to the agent.

This makes the benchmark test more than instruction following. It tests whether the agent can infer what needs to happen, inspect the environment, make decisions, use tools, and eventually produce a useful outcome.

## Rubric = personal preferences

The final component is the most interesting.

The rubric can contain both task-specific requirements and individual preferences. Some criteria may come directly from the task—for example, the professor requires certain topics to be covered. Others may come from the person—for example, they prefer concise slides with large visuals.

The benchmark can therefore separate two kinds of evaluation.

Constraints define what must be satisfied.

Preferences define what the stakeholder would prefer among acceptable outcomes.

This prevents personalization from becoming completely subjective. A user cannot make factual correctness disappear simply by preferring incorrect information. But within the space of valid outcomes, different users can reasonably prefer different results.

## The evaluation we want to build

Putting these pieces together gives a simple evaluation structure:

> **World:** files and software  
> **Task:** user’s natural-language command  
> **Agent:** observes, reasons, and acts  
> **Outcome:** artifact or state produced in the environment  
> **Rubric:** personal preferences + task constraints

The important object is no longer just the final answer. It is the relationship between the agent’s outcome and the stakeholder it is serving.

This also gives us a useful experimental setup. We can hold the world and task constant while changing the stakeholder. We can give different users different preference profiles and see whether the agent produces appropriately different outcomes. We can test whether preferences generalize to new tasks, whether long-term history improves performance, and whether evaluators can reliably recognize stakeholder-specific quality.

## What this leaves unresolved

The difficult part is that personal preferences are often implicit, noisy, and changing. A user may never explicitly tell the agent what they value. Their previous behavior may contain contradictory signals. Preferences that were useful last semester may no longer apply today.

There is also a deeper evaluation problem: if the rubric is learned from user behavior, the system may learn a convenient proxy rather than the underlying preference. The benchmark therefore needs to distinguish between remembering a user’s profile and actually understanding what makes an outcome useful to that user.

These problems make consumer evaluation an interesting extension of the existing agent-evaluation landscape. The goal is not to replace expert benchmarks such as APEX-Agents, but to add another population and another evaluation setting: the individual whose digital environment the agent operates in and whose life the outcome is meant to improve.

The resulting question is simple:

> Can an agent do the task?

Then:

> Can an agent do the task well?

And finally:

> Can an agent do the task well for me?

That last question may require a different kind of benchmark, one where the world is personal, the task is natural, and the definition of “good” belongs to the stakeholder being served.

## References

1. Tianbao Xie et al. _OSWorld: Benchmarking Multimodal Agents for Open-Ended Tasks in Real Computer Environments_. 2024.
2. Ori Yoran et al. _AssistantBench: Can Web Agents Solve Realistic and Time-Consuming Tasks?_ EMNLP 2024.
3. Shunyu Yao et al. _τ-bench: A Benchmark for Tool-Agent-User Interaction in Real-World Domains_. ICLR 2025.
4. Mercor. _APEX-Agents: Benchmark for Long-Horizon, Cross-Application Professional Services Tasks_. 2026.
5. Cristina Garbacea, Heran Wang, and Chenhao Tan. _Personalized Benchmarking: Evaluating LLMs by Individual Preferences_. Findings of ACL 2026.
6. _RealPref: Towards Realistic Personalization: Evaluating Long-Horizon Preference Following in Personalized User-LLM Interactions_. 2026.
7. _APeB: Benchmarking Personalization Ability of Large Language Model Agents_. 2026.
8. Yupu Hao et al. _Evaluating Personalized Tool-Augmented LLMs from the Perspectives of Personalization and Proactivity_. ACL 2025.
9. Yijiang River Dong, Tiancheng Hu, and Nigel Collier. _Can LLM be a Personalized Judge?_ Findings of EMNLP 2024.
10. _Preference-Aware Rubric Learning for Personalized Evaluation_. 2026.
11. _PREFINE: Personalized Story Generation via Simulated User Critics and User-Specific Rubric Generation_. 2025/2026.
