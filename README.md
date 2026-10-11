# trivia

| English | 繁體中文 |
| --- | --- |
| GCC 7.5.0 toolchain image on Ubuntu 22.04, plus the TUM IN2393 course paper (PDF). | Ubuntu 22.04 上的 GCC 7.5.0 工具鏈映像，外加 TUM IN2393 課程論文（PDF）。 |
| No app code, tests, or CI — just a `Dockerfile`, the paper, and `agent/AGENTS.md`. | 沒有應用程式碼、測試或 CI——只有 `Dockerfile`、論文和 `agent/AGENTS.md`。 |

## Contents / 內容

| English | 繁體中文 |
| --- | --- |
| `Dockerfile` — multi-stage build of any GCC from source (defaults: 7.5.0 on Ubuntu 22.04, installs to `/usr/local/gcc-<version>`). | `Dockerfile`——多階段建置，可編譯任意 GCC 版本（預設：Ubuntu 22.04 上的 7.5.0，安裝至 `/usr/local/gcc-<版本>`）。 |
| `IN2393_ml4rg_group11_paper.pdf` — frozen paper artifact, do not edit. | `IN2393_ml4rg_group11_paper.pdf`——已定稿的論文檔案，請勿編輯。 |
| `agent/AGENTS.md` — agent working notes for this repo. | `agent/AGENTS.md`——本 repo 的 agent 工作說明。 |

## Quick start / 快速開始

| English | 繁體中文 |
| --- | --- |
| Build the default image (GCC 7.5.0): `docker build -t trivia-gcc:7.5.0 .` | 建置預設映像（GCC 7.5.0）：`docker build -t trivia-gcc:7.5.0 .` |
| Other versions: `docker build --build-arg GCC_VERSION=13.2.0 -t trivia-gcc:13.2.0 .` | 其他版本：`docker build --build-arg GCC_VERSION=13.2.0 -t trivia-gcc:13.2.0 .` |
| Build compiles GCC from source and takes 30+ minutes — do not rebuild just to verify; inspect the `Dockerfile` instead. | 建置會從原始碼編譯 GCC，需 30 分鐘以上——請勿為了驗證而重建，改為檢視 `Dockerfile`。 |
