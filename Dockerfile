# ==========================================
# Generic GCC toolchain image on Ubuntu
#
# The build context is intentionally Dockerfile-only; see .dockerignore.
#
# Build any GCC version from source:
#   docker build -t trivia-gcc:7.5.0 .
#   docker build --build-arg GCC_VERSION=13.2.0 -t trivia-gcc:13.2.0 .
#   docker build --build-arg BASE_IMAGE=ubuntu:24.04 \
#                --build-arg GCC_VERSION=14.2.0 -t trivia-gcc:14.2.0 .
# ==========================================

# 1. Base image and toolchain version are build arguments for flexibility
ARG BASE_IMAGE=ubuntu:22.04
ARG GCC_VERSION=7.5.0
ARG GCC_MIRROR=https://ftp.gnu.org/gnu/gcc
ARG GCC_LANGUAGES=c,c++
ARG INSTALL_PREFIX=/usr/local/gcc-${GCC_VERSION}

# 2. Builder stage: compile GCC from source (heavy, cached per version)
FROM ${BASE_IMAGE} AS builder

# Re-declare ARGs for this stage (required after each FROM)
ARG GCC_VERSION
ARG GCC_MIRROR
ARG GCC_LANGUAGES
ARG INSTALL_PREFIX

# 3. Avoid interactive prompts and set default parallelism (override with --build-arg JOBS=N)
ARG JOBS
ENV DEBIAN_FRONTEND=noninteractive

# 4. Install build dependencies in one layer, clean apt lists in the same RUN
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    wget \
    tar \
    xz-utils \
    flex \
    bison \
    texinfo \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev \
    libisl-dev \
    && rm -rf /var/lib/apt/lists/*

# 5. Download GCC source (.tar.gz first, fall back to .tar.xz for newer releases)
WORKDIR /usr/local/src
RUN set -eux; \
    jobs="${JOBS:-$(nproc)}"; \
    case "${jobs}" in ''|*[!0-9]*) echo "JOBS must be a positive integer" >&2; exit 1;; esac; \
    test "${jobs}" -gt 0; \
    echo "JOBS=${jobs}" > /tmp/jobs.env; \
    for ext in tar.gz tar.xz; do \
      if wget "${GCC_MIRROR}/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.${ext}"; then \
        tar -xf "gcc-${GCC_VERSION}.${ext}"; \
        rm "gcc-${GCC_VERSION}.${ext}"; \
        break; \
      fi; \
    done; \
    test -d "gcc-${GCC_VERSION}"

# 6. Fetch GCC prerequisites (gmp/mpfr/mpc/isl) into the source tree
WORKDIR /usr/local/src/gcc-${GCC_VERSION}
RUN ./contrib/download_prerequisites

# 7. Configure out-of-tree with a versioned prefix
RUN mkdir build
WORKDIR /usr/local/src/gcc-${GCC_VERSION}/build
RUN ../configure --prefix="${INSTALL_PREFIX}" \
    --enable-languages="${GCC_LANGUAGES}" \
    --disable-multilib

# 8. Compile using all cores by default, then install
RUN set -eux; . /tmp/jobs.env; make -j"${JOBS}"
RUN make install

# 9. Slim runtime stage: copy only the installed toolchain
FROM ${BASE_IMAGE} AS runtime

ARG GCC_VERSION
ARG INSTALL_PREFIX

LABEL org.opencontainers.image.title="trivia-gcc" \
      org.opencontainers.image.description="GCC toolchain built from source on Ubuntu" \
      org.opencontainers.image.version="${GCC_VERSION}"

# 10. Runtime needs libgmp/mpfr/mpc present for cc1; keep the layer minimal
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libgmp10 \
    libmpfr6 \
    libmpc3 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder ${INSTALL_PREFIX} ${INSTALL_PREFIX}

# 11. Prefer the freshly built toolchain on PATH
ENV PATH=${INSTALL_PREFIX}/bin:$PATH \
    LD_LIBRARY_PATH=${INSTALL_PREFIX}/lib64:${INSTALL_PREFIX}/lib

# 12. Sanity-check the installed compilers
RUN gcc --version && g++ --version

# 13. Interactive default
CMD ["bash"]
