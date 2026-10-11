# AGENTS.md — trivia

GCC 7.5.0 toolchain image on Ubuntu 22.04, plus the TUM IN2393 paper PDF. Three files, no app code, tests, or CI.

## Build
- Only build step is `docker build` from repo root; default builds GCC 7.5.0: `docker build -t trivia-gcc:7.5.0 .`
- Knobs (all `--build-arg`): `GCC_VERSION` (default 7.5.0), `BASE_IMAGE` (default ubuntu:22.04), `GCC_MIRROR`, `GCC_LANGUAGES` (default c,c++), `INSTALL_PREFIX` (default `/usr/local/gcc-<version>`), `JOBS` (default nproc). Keep `INSTALL_PREFIX` in sync when bumping `GCC_VERSION`.
- Multi-stage build: `builder` compiles from source, `runtime` copies only the installed prefix. Build compiles GCC from source (`make -j`); takes 30+ min even on many cores. Do not rebuild casually to "verify" — inspect the `Dockerfile` instead.

## Conventions
- Single `Dockerfile`, numbered comments describe each stage — preserve that style. Multi-stage (`builder` → `runtime`); keep `apt-get` cleanup (`rm -rf /var/lib/apt/lists/*`) in the same `RUN`.
- `.dockerignore` keeps the build context to the `Dockerfile` (excludes paper, `agent/`, markdown).
- `IN2393_ml4rg_group11_paper.pdf` is a frozen artifact, never edit or re-export.
- `README.md` is bilingual (English alongside zh-TW). Don't invent scripts it doesn't have.

## Constraints
- No test runner, linter, or workflow config exists. Don't add CI unless asked.
- `apt-get` layer must keep `rm -rf /var/lib/apt/lists/*` in the same `RUN`.
