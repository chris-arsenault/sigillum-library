# procedures/ — reusable runbooks

Each runbook executes one library workflow:

- **`partitura/`** — **START HERE FOR NEW PRODUCTION DSL COMPOSITION.** The guided Ruby DSL procedures
  cover research routing, material design, section writing, whole-piece revision, export, and closeout.
  `partitura/bin/partitura start` emits one stage at a time, and `partitura/bin/partitura status`
  restores the current run context.
- **`card_writing_procedure.md`** — research and author an auditionable production-DSL technique card.

Consumer-specific historical runbooks belong in their consumer repositories. They are not authority
for new library or production-DSL work.
