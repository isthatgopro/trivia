# trivia

| English | 繁體中文 |
| --- | --- |
| A small collection of reusable developer resources: a configurable GCC toolchain image, a preserved TUM IN2393 paper, and a separate `useful_scripts` repository included as a Git submodule. | 一個小型的可重複使用開發資源集合：可設定的 GCC 工具鏈映像、保存的 TUM IN2393 論文，以及以 Git submodule 納入的獨立 `useful_scripts` repository。 |
| The root repository is intentionally lightweight. The Docker image downloads and builds GCC from source; it does not package the paper or utility scripts. | 根 repository 刻意維持輕量。Docker 映像會從原始碼下載並編譯 GCC，不會把論文或工具腳本打包進映像。 |

## Repository layout / Repository 結構

| English | 繁體中文 |
| --- | --- |
| `docker/Dockerfile` — multi-stage GCC builder and runtime image. | `docker/Dockerfile`——多階段 GCC 建置器與執行環境映像。 |
| `docker/.dockerignore` — sends only the Dockerfile as build context because the build downloads its own sources. | `docker/.dockerignore`——只傳送 Dockerfile 作為建置 context，因為建置會自行下載原始碼。 |
| `useful_scripts/` — Git submodule pointing to [isthatgopro/useful_scripts](https://github.com/isthatgopro/useful_scripts). | `useful_scripts/`——指向 [isthatgopro/useful_scripts](https://github.com/isthatgopro/useful_scripts) 的 Git submodule。 |
| `paper/IN2393_ml4rg_group11_paper.pdf` — frozen paper artifact; do not edit or re-export. | `paper/IN2393_ml4rg_group11_paper.pdf`——已定稿的論文檔案，請勿編輯或重新匯出。 |
| `agent/AGENTS.md` — repository-specific instructions for coding agents. | `agent/AGENTS.md`——本 repository 的 coding agent 專用說明。 |

## GCC image / GCC 映像

| English | 繁體中文 |
| --- | --- |
| The default image builds GCC `7.5.0` on Ubuntu `22.04`, installs it under `/usr/local/gcc-7.5.0`, and puts it first on `PATH`. | 預設映像在 Ubuntu `22.04` 上建置 GCC `7.5.0`，安裝至 `/usr/local/gcc-7.5.0`，並優先放入 `PATH`。 |
| The build uses a `builder` stage for compilation and a smaller `runtime` stage containing only the installed toolchain and runtime libraries. | 建置使用 `builder` 階段編譯，再用較小的 `runtime` 階段只保留已安裝的工具鏈與執行期函式庫。 |
| GCC compilation is CPU- and disk-intensive and may take 30+ minutes. Docker Desktop must be running. | GCC 編譯需要大量 CPU 與磁碟空間，可能超過 30 分鐘。Docker Desktop 必須正在執行。 |

### Build examples / 建置範例

```bash
# English / English
docker build -t trivia-gcc:7.5.0 docker/
docker build --build-arg GCC_VERSION=13.2.0 -t trivia-gcc:13.2.0 docker/
docker build \
  --build-arg BASE_IMAGE=ubuntu:24.04 \
  --build-arg GCC_VERSION=14.2.0 \
  --build-arg GCC_LANGUAGES=c,c++,fortran \
  --build-arg JOBS=8 \
  -t trivia-gcc:14.2.0 docker/

# Run the compiler / 執行編譯器
docker run --rm trivia-gcc:7.5.0 gcc --version
docker run --rm -v "$PWD":/work -w /work trivia-gcc:7.5.0 \
  g++ -std=c++17 -O2 -o hello hello.cpp
```

Available build arguments are `BASE_IMAGE`, `GCC_VERSION`, `GCC_MIRROR`,
`GCC_LANGUAGES`, `INSTALL_PREFIX`, and `JOBS`. `JOBS` defaults to the number of
available CPU cores and must be a positive integer when supplied.

可用的建置參數包括 `BASE_IMAGE`、`GCC_VERSION`、`GCC_MIRROR`、
`GCC_LANGUAGES`、`INSTALL_PREFIX` 和 `JOBS`。`JOBS` 預設為可用 CPU 核心數，
手動指定時必須是正整數。

## Useful scripts submodule / Useful scripts 子模組

| English | 繁體中文 |
| --- | --- |
| `docker-user-tool.sh` checks Docker and manages a user-level Compose plugin without installing the Docker Engine. | `docker-user-tool.sh` 檢查 Docker，並管理使用者層級的 Compose plugin，不會安裝 Docker Engine。 |
| `user-apt-tool.sh` downloads and unpacks simple Debian packages into the user directory without changing the system package database. | `user-apt-tool.sh` 將簡單的 Debian 套件下載並解壓到使用者目錄，不會修改系統套件資料庫。 |
| `uv-env-tool.sh` creates isolated Python environments and runs or installs packages through `uv`. | `uv-env-tool.sh` 使用 `uv` 建立隔離的 Python 環境，並在其中執行指令或安裝套件。 |
| `modal_runner/` submits configured Python jobs to Modal with GPU, dependency, output, and billing metadata. | `modal_runner/` 將設定好的 Python 工作送到 Modal，並記錄 GPU、相依套件、輸出與帳務資訊。 |

The submodule is independent. Clone it with the parent repository using:

此子模組保持獨立。使用以下指令連同 parent repository 一起複製：

```bash
git clone --recurse-submodules https://github.com/isthatgopro/trivia.git
```

If the parent repo is already cloned:

如果 parent repo 已經複製完成：

```bash
git submodule update --init --recursive
```

To update the nested repository to a newer commit, run `git pull` inside
`useful_scripts/`, then commit the changed submodule pointer from the parent.

若要更新子 repository，請在 `useful_scripts/` 內執行 `git pull`，再回到 parent
repository 提交更新後的 submodule 指標。

## Paper and provenance / 論文與來源

| English | 繁體中文 |
| --- | --- |
| `paper/IN2393_ml4rg_group11_paper.pdf` is retained as a reference artifact from the TUM IN2393 project. | `paper/IN2393_ml4rg_group11_paper.pdf` 是 TUM IN2393 專案保留的參考論文檔案。 |
| It is not part of the Docker build context and is not copied into generated images. | 它不屬於 Docker build context，也不會被複製到產生的映像中。 |

## License / 授權

The root repository contains mixed-purpose materials. Check the individual
files and the `useful_scripts` repository for their applicable licenses before
redistributing them.

根 repository 包含不同用途的資料。重新散布前，請檢查個別檔案以及
`useful_scripts` repository 適用的授權條款。
