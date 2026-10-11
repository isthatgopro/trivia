# docker/

| English | 繁體中文 |
| --- | --- |
| GCC toolchain image sources: multi-stage `Dockerfile` plus a context-limiting `.dockerignore`. | GCC 工具鏈映像原始檔：多階段 `Dockerfile` 與限制建置 context 的 `.dockerignore`。 |
| Build from the repository root with `docker build -t trivia-gcc:7.5.0 docker/`. | 請在 repository 根目錄執行 `docker build -t trivia-gcc:7.5.0 docker/` 建置。 |
| Original purpose: group the GCC image files (`Dockerfile` + `.dockerignore`) that previously lived at the repository root. | 最初用途：收納原本放在 repository 根目錄的 GCC 映像檔案（`Dockerfile` + `.dockerignore`）。 |

Created / 建立日期：

Last updated / 最後更新：2026-10-11 19:50 UTC+8 (Taipei)
