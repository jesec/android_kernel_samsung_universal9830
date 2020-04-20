#!/bin/bash

export ARCH=arm64
mkdir out

VARIANT=$1

DTB_DIR=$(pwd)/out/arch/$ARCH/boot/dts
rm ${DTB_DIR}/exynos/* ${DTB_DIR}/samsung/*

BUILD_CROSS_COMPILE=aarch64-linux-gnu-
CLANG_TRIPLE=aarch64-linux-gnu-

make -j$(nproc) -C $(pwd) O=$(pwd)/out ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE LLVM=1 CLANG_TRIPLE=$CLANG_TRIPLE exynos9830-${VARIANT}_defconfig || exit 1
make -j$(nproc) -C $(pwd) O=$(pwd)/out ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE LLVM=1 CLANG_TRIPLE=$CLANG_TRIPLE || exit 1

cp $(pwd)/out/arch/$ARCH/boot/Image $(pwd)/out/Image

$(pwd)/tools/mkdtimg cfg_create $(pwd)/out/dtb.img dt.configs/exynos9830.cfg -d ${DTB_DIR}/exynos
$(pwd)/tools/mkdtimg cfg_create $(pwd)/out/dtbo.img dt.configs/${VARIANT}.cfg -d ${DTB_DIR}/samsung
