# AGENTS.md — trivia

This repo contains a configurable GCC toolchain image, the TUM IN2393 paper PDF, and the independent `useful_scripts` Git submodule. There is no app code or CI in the parent repo.

## Build
- Only build step is `docker build` with `docker/` as the context; default builds GCC 7.5.0: `docker build -t trivia-gcc:7.5.0 docker/`
- Knobs (all `--build-arg`): `GCC_VERSION` (default 7.5.0), `BASE_IMAGE` (default ubuntu:22.04), `GCC_MIRROR`, `GCC_LANGUAGES` (default c,c++), `INSTALL_PREFIX` (default `/usr/local/gcc-<version>`), `JOBS` (default nproc). Keep `INSTALL_PREFIX` in sync when bumping `GCC_VERSION`.
- Multi-stage build: `builder` compiles from source, `runtime` copies only the installed prefix. Build compiles GCC from source (`make -j`); takes 30+ min even on many cores. Do not rebuild casually to "verify" — inspect the `Dockerfile` instead.

## Conventions
- Single `docker/Dockerfile`, numbered comments describe each stage — preserve that style. Multi-stage (`builder` → `runtime`); keep `apt-get` cleanup (`rm -rf /var/lib/apt/lists/*`) in the same `RUN`.
- `docker/.dockerignore` keeps the build context to the Dockerfile only; the build downloads GCC itself and must not include the paper, `agent/`, or `useful_scripts/`.
- `paper/IN2393_ml4rg_group11_paper.pdf` is a frozen artifact, never edit or re-export.
- `README.md` is bilingual (English alongside zh-TW) and documents the submodule; keep it aligned with the actual Docker arguments and repository layout.
- `useful_scripts/` is a Git submodule. Do not edit its files from the parent repo; make changes in its own checkout/repository, then update the parent submodule pointer.

## Constraints
- No test runner, linter, or workflow config exists. Don't add CI unless asked.
- `apt-get` layer must keep `rm -rf /var/lib/apt/lists/*` in the same `RUN`.
