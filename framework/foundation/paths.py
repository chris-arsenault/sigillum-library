"""Project paths for generated outputs and approved raw inputs."""
import os
from pathlib import Path


def _project_root():
    configured = os.environ.get("SIGILLUM_PROJECT_ROOT")
    if configured:
        return Path(configured).expanduser().resolve()
    return Path.cwd().resolve()


ROOT = _project_root()

OUTPUTS = ROOT / "outputs"
MOVEMENT_OUTPUTS = OUTPUTS / "movements"
DSL_CARD_OUTPUTS = OUTPUTS / "dsl_cards"
MOTIF_CATALOG_OUTPUTS = OUTPUTS / "motif_catalog"
STEM_OUTPUTS = OUTPUTS / "stems"
PACKAGE_OUTPUTS = OUTPUTS / "packages"
AUDITION_OUTPUTS = OUTPUTS / "auditions"
SKETCH_OUTPUTS = OUTPUTS / "sketches"
REPORT_OUTPUTS = OUTPUTS / "reports"

RAW_APPROVED = ROOT / "assets" / "raw" / "approved"
RAW_CORPUS = ROOT / "assets" / "raw" / "corpus"

MODEL_OUTPUTS = OUTPUTS / "models"


def ensure_dir(path):
    path = Path(path)
    path.mkdir(parents=True, exist_ok=True)
    return path


def output_dir(*parts):
    return ensure_dir(OUTPUTS.joinpath(*parts))


def raw_approved_path(*parts):
    return RAW_APPROVED.joinpath(*parts)


def movement_output(filename):
    return ensure_dir(MOVEMENT_OUTPUTS) / filename


def dsl_card_output(filename):
    return ensure_dir(DSL_CARD_OUTPUTS) / filename


def motif_catalog_output(filename):
    return ensure_dir(MOTIF_CATALOG_OUTPUTS) / filename


def audition_output(filename):
    return ensure_dir(AUDITION_OUTPUTS) / filename


def sketch_output(group, filename):
    return output_dir("sketches", group) / filename


def report_output(group, filename):
    return output_dir("reports", group) / filename


def model_output(filename):
    return ensure_dir(MODEL_OUTPUTS) / filename


def resolve_movement_midi(name):
    path = Path(name)
    if path.is_absolute() and path.exists():
        return path
    if path.exists():
        return path
    sub = MOVEMENT_OUTPUTS / path.stem / path.name  # per-movement subfolder
    if sub.exists():
        return sub
    legacy = MOVEMENT_OUTPUTS / path.name  # pre-subfolder flat layout
    if legacy.exists():
        return legacy
    return sub
