# ==========================================
# Dockerfile to Build GCC 7.5.0 on Ubuntu 22.04
# ==========================================

# 1. Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# 2. Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# 3. Update package lists and install essential build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    tar \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev \
    flex \
    bison \
    texinfo \
    libisl-dev \
    && rm -rf /var/lib/apt/lists/*

# 4. Define GCC version as a build argument for flexibility
ARG GCC_VERSION=7.5.0

# 5. Set the working directory for source code
WORKDIR /usr/local/src

# 6. Download and extract GCC source code
RUN wget https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz \
    && tar -xf gcc-${GCC_VERSION}.tar.gz \
    && rm gcc-${GCC_VERSION}.tar.gz

# 7. Navigate into the GCC source directory
WORKDIR /usr/local/src/gcc-${GCC_VERSION}

# 8. Download GCC prerequisites (libraries and dependencies)
RUN ./contrib/download_prerequisites

# 9. Create a separate build directory to keep the source tree clean
RUN mkdir build
WORKDIR /usr/local/src/gcc-${GCC_VERSION}/build

# 10. Configure the GCC build with desired options
RUN ../configure --prefix=/usr/local/gcc-${GCC_VERSION} \
    --enable-languages=c,c++ \
    --disable-multilib

# 11. Compile GCC using all available CPU cores for efficiency
RUN make -j$(nproc)

# 12. Install GCC to the specified prefix directory
RUN make install

# 13. Update environment variables to prioritize the newly installed GCC
ENV PATH=/usr/local/gcc-${GCC_VERSION}/bin:$PATH \
    LD_LIBRARY_PATH=/usr/local/gcc-${GCC_VERSION}/lib64:$LD_LIBRARY_PATH

# 14. Verify the GCC installation by checking versions
RUN gcc --version && g++ --version

# 15. Set the default command to bash for interactive use
CMD ["bash"]