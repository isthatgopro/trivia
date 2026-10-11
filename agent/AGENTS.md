# AGENTS.md — trivia

GCC 7.5.0 toolchain image on Ubuntu 22.04, plus the TUM IN2393 paper PDF. Three files, no app code, tests, or CI.

## Build
- Only build step: `docker build -t trivia-gcc:7.5.0 .` from repo root.
- Build compiles GCC from source (`make -j$(nproc)`); takes 30+ min even on many cores. Do not rebuild casually to "verify" — prefer `docker build --help` / Dockerfile inspection.
- `ARG GCC_VERSION=7.5.0` is the only knob. Install prefix is `/usr/local/gcc-7.5.0`, exposed via `PATH`/`LD_LIBRARY_PATH`. Keep the two in sync when bumping.

## Conventions
- Single `Dockerfile`, numbered comments describe each stage — preserve that style.
- `IN2393_ml4rg_group11_paper.pdf` is a frozen artifact, never edit or re-export.
- `README.md` is bilingual (English alongside zh-TW). Don't invent scripts it doesn't have.

## Constraints
- No test runner, linter, or workflow config exists. Don't add CI unless asked.
- `apt-get` layer must keep `rm -rf /var/lib/apt/lists/*` in the same `RUN`.
