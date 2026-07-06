from pathlib import Path
import json
import subprocess
import unittest


ROOT = Path(__file__).resolve().parents[1]
CARD_ROOT = ROOT / "technique_library" / "dsl" / "cards"
MANIFEST = CARD_ROOT / "manifest.json"


class TechniqueLibraryDSLTests(unittest.TestCase):
    def test_manifest_covers_dsl_card_set(self):
        manifest = json.loads(MANIFEST.read_text())
        manifest_names = {entry["name"] for entry in manifest}

        self.assertEqual(len(manifest), len(list(CARD_ROOT.rglob("*.rb"))))
        self.assertEqual(len(manifest_names), len(manifest))
        self.assertEqual(
            32,
            sum(1 for entry in manifest if entry["category"] == "figures.16th"),
        )
        self.assertLessEqual(
            {
                "piano",
                "voicing",
                "chamberstrings",
                "orchestral",
                "dialogue",
                "figuration",
                "figures.16th",
                "elegy",
                "callresponse",
                "forms",
                "melody",
            },
            {entry["category"] for entry in manifest},
        )
        for entry in manifest:
            path = ROOT / entry["path"]
            self.assertTrue(path.exists(), entry["path"])
            self.assertIn("production_piece", path.read_text(), entry["path"])

    def test_card_sources_use_mixed_dsl_surfaces(self):
        manifest = json.loads(MANIFEST.read_text())
        surfaces = {part["surface"] for entry in manifest for part in entry["parts"]}

        self.assertIn("degrees", surfaces)
        self.assertIn("intervals", surfaces)
        self.assertIn("split_pitch_rhythm", surfaces)

    def test_all_dsl_card_sources_compile(self):
        files = sorted(CARD_ROOT.rglob("*.rb"))
        manifest = json.loads(MANIFEST.read_text())
        self.assertEqual(len(files), len(manifest))

        failures = []
        for path in files:
            result = subprocess.run(
                ["framework/orchestral_dsl/ruby/bin/production_view", str(path), "compile"],
                cwd=ROOT,
                text=True,
                capture_output=True,
                check=False,
            )
            try:
                payload = json.loads(result.stdout)
            except json.JSONDecodeError:
                failures.append((path, "non-json response", result.stdout, result.stderr))
                continue
            if result.returncode != 0 or payload.get("status") != "ok":
                failures.append((path, payload.get("message"), result.stdout, result.stderr))

        self.assertEqual(failures, [])

    def test_ruby_library_cli_reads_dsl_manifest(self):
        result = subprocess.run(
            ["ruby", "tools/lib.rb", "show", "dsl:figures.16th/F01"],
            cwd=ROOT,
            text=True,
            capture_output=True,
            check=False,
        )

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("DSL REF: dsl:figures.16th/F01", result.stdout)
        self.assertIn("surface=intervals", result.stdout)

        terms = subprocess.run(
            ["ruby", "tools/lib.rb", "terms"],
            cwd=ROOT,
            text=True,
            capture_output=True,
            check=False,
        )

        self.assertEqual(terms.returncode, 0, terms.stderr)
        self.assertIn("figures.16th", terms.stdout)


if __name__ == "__main__":
    unittest.main()
