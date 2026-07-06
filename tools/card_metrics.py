"""Measure auditionable DSL technique cards from the Ruby transport output."""

from __future__ import annotations

import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CARD_ROOT = ROOT / "technique_library" / "dsl" / "cards"
MANIFEST = CARD_ROOT / "manifest.json"


def _transport(path: Path) -> dict:
    result = subprocess.run(
        ["framework/orchestral_dsl/ruby/bin/production_view", str(path), "transport"],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=False,
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip() or result.stdout.strip())
    return json.loads(result.stdout)


def card_stats(entry: dict) -> dict:
    data = _transport(ROOT / entry["path"])
    events_by_part: dict[str, list[dict]] = {}
    for event in data.get("timed_events", []):
        if event.get("rest"):
            continue
        events_by_part.setdefault(event["part"], []).append(event)

    part_stats = {}
    for part, events in events_by_part.items():
        onsets = {round(float(event["offset_ql"]) * 4) / 4 for event in events}
        durations = {round(float(event["duration_ql"]) * 4) / 4 for event in events}
        pitches = {pitch for event in events for pitch in event.get("pitches", [])}
        part_stats[part] = {
            "attacks": len(events),
            "onset_vocab": len(onsets),
            "duration_vocab": len(durations),
            "pitch_vocab": len(pitches),
        }

    return {
        "name": entry["name"],
        "category": entry["category"],
        "surfaces": sorted({part["surface"] for part in entry.get("parts", []) if part.get("surface")}),
        "parts": part_stats,
    }


def main() -> None:
    manifest = json.loads(MANIFEST.read_text())
    for entry in manifest:
        stats = card_stats(entry)
        print(f"\n### {stats['category']}/{stats['name']} surfaces={','.join(stats['surfaces'])}")
        for part, values in stats["parts"].items():
            print(
                f"  {part:20s} attacks {values['attacks']:3d} "
                f"onsets {values['onset_vocab']:2d} durations {values['duration_vocab']:2d} "
                f"pitches {values['pitch_vocab']:3d}"
            )


if __name__ == "__main__":
    main()
