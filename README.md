# trivia

| English | 繁體中文 |
| --- | --- |
| GCC 7.5.0 toolchain image on Ubuntu 22.04, plus the TUM IN2393 course paper (PDF). | Ubuntu 22.04 上的 GCC 7.5.0 工具鏈映像，外加 TUM IN2393 課程論文（PDF）。 |
| No app code, tests, or CI — just a `Dockerfile`, the paper, and `agent/AGENTS.md`. | 沒有應用程式碼、測試或 CI——只有 `Dockerfile`、論文和 `agent/AGENTS.md`。 |

## Contents / 內容

| English | 繁體中文 |
| --- | --- |
| `Dockerfile` — builds GCC 7.5.0 from source (`ARG GCC_VERSION=7.5.0`, installs to `/usr/local/gcc-7.5.0`). | `Dockerfile`——從原始碼編譯 GCC 7.5.0（`ARG GCC_VERSION=7.5.0`，安裝至 `/usr/local/gcc-7.5.0`）。 |
| `IN2393_ml4rg_group11_paper.pdf` — frozen paper artifact, do not edit. | `IN2393_ml4rg_group11_paper.pdf`——已定稿的論文檔案，請勿編輯。 |
| `agent/AGENTS.md` — agent working notes for this repo. | `agent/AGENTS.md`——本 repo 的 agent 工作說明。 |

## Quick start / 快速開始

| English | 繁體中文 |
| --- | --- |
| Build the image: `docker build -t trivia-gcc:7.5.0 .` | 建置映像：`docker build -t trivia-gcc:7.5.0 .` |
| Build compiles GCC from source and takes 30+ minutes — do not rebuild just to verify; inspect the `Dockerfile` instead. | 建置會從原始碼編譯 GCC，需 30 分鐘以上——請勿為了驗證而重建，改為檢視 `Dockerfile`。 |
