# DSL New-Composition Procedure v2 (pointer)

This procedure is now split for stage-at-a-time loading and executed as a guided run.
Do not read all stages up front; the runtime feeds you exactly the stage you are in.

## Run It

```bash
partitura/bin/partitura start <piece_dir> --source <SOURCE.rb>   # emits Stage 0 only
partitura/bin/partitura status                                   # re-orient (fresh contexts start here)
partitura/bin/partitura commit --notes -                         # pass note in, next stage out
partitura/bin/partitura commit --span A-B --notes -              # one span-pass unit (Stage 5)
partitura/bin/partitura commit --stage-complete --notes -        # close an iterative stage
partitura/bin/partitura next --reason "..."                      # escape hatch; logged, blocks closeout
partitura/bin/partitura back --to sN --reason "..."              # reopen an earlier stage
partitura/bin/partitura log                                      # audit trail
```

Add `--miniature` to `start` for the documented true-miniature fallback (collapsed
stages, same pass order). State and the audit log live in `<piece_dir>/procedure/`
alongside the musical artifacts (brief, form contract, ledgers).

## Content

- `dsl_composition/principles.md` - the standing orders: cardinal principle, completion
  standard, source discipline, fresh attention model, research routing, binding craft
  imports. Read once per fresh context.
- `dsl_composition/stages/00_brief.md` ... `10_export_audition_close.md` - the eleven
  stages, one file each. The run payload inlines the current stage.
- `dsl_composition/manifest.json` - stage order, artifacts, and mechanical gates.

The stage files carry the full former content of this document; nothing was dropped.
Gates are floors (artifact exists, source compiles, export current, judgments
recorded) - the musical verdicts still belong to you, in the pass notes.
