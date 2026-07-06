# CARD-WRITING PROCEDURE (texture library) — agent-executable

How to compose ONE library card. One assigned idea per agent. The agent GROUNDS the card in real
external research, captures it as a knowledge file, reads the full craft, then writes → analyzes →
repeats. The procedure is deliberately **neutral across craft dimensions** — what matters for a given
technique comes from the RESEARCH, not from a pre-baked checklist. (Do not bake the composer's current
preoccupations into the brief; let the sources and the craft lead.)

## INPUT CONTRACT (what the orchestrator hands each agent — MINIMAL by design)
The whole reason for dispatching an agent is a **clean break from the orchestrator's biases.** The
orchestrator hands ONE agent ONE assignment and as LITTLE else as possible. PROVIDE only:
- the **technique / texture / concept** to exemplify (e.g. "the descending-fifths melodic sequence");
- the **slot**: a card name + bar count;
- the **pointers**: this procedure + the craft files + the nearest existing cards (so the agent grounds itself);
- the **output format** (the bare-dict shape + how it validates).

That is the ENTIRE brief. A correct invocation reads, in full: *"Compose one card exemplifying
\<technique\> as described by \<research\>, following this procedure — here is the slot and the output
format; every musical choice is yours."*

The orchestrator MUST NOT inject ANY musical choice — these all belong to the agent, derived from its
research and the craft, NOT from the orchestrator's ear:
- NOT key, meter, tempo, character, idiom, or mood;
- NOT rhythm, density, rests, contour, register, dynamics, or any note-level content;
- NOT "keep X the same" / "change Y" / "thin the density" / "add rests" — NEVER hand-steer a card,
  and never hand an agent a prior version to "correct"; re-compose clean.
If the orchestrator finds itself describing how the music should *sound*, it has already failed — that
judgement is the agent's, made against the RESEARCH, not against the orchestrator's preferences.

**Variety across a batch is EMERGENT, never assigned.** Distinct techniques, each independently
grounded in its own research, naturally diverge in key/meter/tempo/character — that is where the spread
comes from. If a batch comes back homogeneous, the fix is RICHER, less-biased documentation and more
genuinely-distinct technique assignments — NOT the orchestrator hand-assigning a spread or seeding
defaults. (Both prior failures were the same mistake: first thin briefs + seeded uniform defaults
[C / 4/4 / ~90 bpm → 5 bland cards], then an "identity envelope" + hand-injected "add rests / thin
density." Both are the orchestrator's bias leaking into the agent's job. Don't.)

## STEP 1 — RESEARCH (an actual external search)
Perform a genuine external search (WebSearch / WebFetch) on the assigned technique. Find: its real
name(s) and variants (distinguish overlapping terms), the mechanics and the WHY, exemplar repertoire
across idioms (classical, jazz, film, game, folk), and concrete note-level examples. Go past what you
already know — if you only return what you walked in with, you've failed. Do not compose from memory.

## STEP 2 — KNOWLEDGE FILE (capture it, NOT distilled)
Write the research to a new markdown knowledge file, `reference/written/surveys/<technique>.md` (next
free annex number). Preserve the richness: the distinguished names, the WHY per item, repertoire,
concrete pitch+rhythm examples with exact notes, citations. Models: the strings survey, the piano-voicing survey,
the complementary-rhythm survey (gap/hocket). This is BOTH the source the card is composed from AND a durable library reference —
do not over-distill into a tidy checklist; the detail is the point.

## STEP 3 — READ THE CRAFT (all of it, holistically)
Read the library-writing craft so the card is composed at full craft on EVERY dimension the technique
touches — let the research (Step 1) tell you which are load-bearing here:
- line / pitch / voice-leading: `reference/written/craft/melody_theory_foundations.md`, melody_primacy, MELODY_CRAFT_DOCTRINE
- harmony & voicing: the piano-voicing survey, the relevant craft annexes
- rhythm & meter: orchestral_rhythm, melody_primacy
- figuration: ornamentation, keyboard_figuration
- orchestration / scoring / interplay: chord_scoring, dialogue_doubling
- the CARD SPEC + format and the quality bar: the card library (technique_library/INDEX.md), the P-card cards, the nearest existing cards
No single axis is privileged. Compose to the WHOLE craft, weighted by what this technique actually needs.

## STEP 4 — WRITE → ANALYZE → REPEAT (refine loop, never one-shot)
- **WRITE** the card as hand-composed NOTE-LISTS (never a generator function).
- **ANALYZE:** render it; walk it against the research and the craft; critique it AS MUSIC by ear —
  does it genuinely exemplify the technique the research described, at the complexity of the existing
  library? Measure with the texture diagnostic (texture_diagnosis) as a correctness floor, not a quality target.
  **Demonstrating the technique is the FLOOR, not the goal — the card must stand on its own as
  memorable, characterful music.** Excitement comes from a HOOK, CONTRAST, dynamic/registral shape,
  surprise, and BREATH — NOT from note density. Rests are load-bearing: silence is an accent (§7/
  doctrine), a rest before a downbeat makes it hit; a line that breathes beats one that never stops.
  Two SYMMETRIC failures, both fatal — do not trade one for the other:
  (a) the bland exercise — one key, ~90 bpm, even quarters-and-eighths, no phrasing ("a guy staring at a turtle");
  (b) the over-busy cram — wall-to-wall 16ths/triplets, no rests, frantic, every bar full.
  Let TEMPO and DENSITY emerge from what the line wants — a great lyrical theme is slow and spacious;
  a dance is quick but still breathes. Do NOT chase a 16th-quota or a tempo target. Phrase with rests;
  vary per phrase. The ear-test is "is it memorable and does it breathe?", not "is it fast/busy?".
- **OBJECTIVE GATE (when the card's point is a named, measurable structure):** some techniques have an
  objective acceptance test the card MUST pass, not just the ear. A melody-library card whose point is
  HARMONIC EXPOSURE (the strong-beat skeleton spells its progression) must pass
  `production_view CARD.rb harmony_with_melody` plus score/audition reading — the chord the line
  implies must match the intended progression in >= (nbars-1) bars. See
  `reference/written/craft/exposing_the_progression.md` for the process and the gate; iterate on weak
  bars until it passes. A card that fails its gate has not earned an audition.
- **ADAPT and iterate** — several passes — until it teaches the technique and stands on its own as music.

## STEP 5 — RETURN
Return the card as NOTE-LISTS + its knowledge file. Correctness floor (silent): bar-sums, in-range for
each instrument, renders clean. The verdict is the ear; the central merge re-auditions and may send it
back.

## WORKFLOW
One library idea per agent. The orchestrator assigns ideas, hands this procedure + the slot, and
auditions returns by ear. An agent that needs a new technique escalates it as a new idea — never
silently lowers craft.

**Variety across a BATCH/SET is EMERGENT, never assigned (see INPUT CONTRACT).** Do NOT hand agents a
key/meter/tempo/character spread, and do NOT seed a uniform default — both are the orchestrator's bias
leaking into the agent's job. Assign genuinely DISTINCT techniques and let each agent's independent
research drive every musical choice; the set diverges because the techniques and their sources do. If
returns come back homogeneous, fix the DOCUMENTATION (make the research richer, the assignments more
distinct) — not the prompts.
