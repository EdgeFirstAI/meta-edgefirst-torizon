SUMMARY = "EdgeFirst Perception Foundation for Torizon OS"
DESCRIPTION = "The Foundation set installed into Torizon images: EdgeFirst HAL and \
VideoStream, the NPU runtime and delegate for the SoC, the GPU EGL, GLES and GBM \
libraries, and the EdgeFirst client and profiler tools. Everything above Foundation runs as containers."

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS:${PN} = " \
    packagegroup-edgefirst \
    packagegroup-edgefirst-npu \
    packagegroup-edgefirst-studio \
    edgefirst-ostree-remote \
"

# GPU userspace the HAL loads at runtime: libEGL.so.1, libGLESv2.so.2 and
# libgbm.so.1, plus G2D on Vivante. Weston is left out because Torizon runs its
# compositor in a container.
RDEPENDS:${PN}:append:imxviv = " \
    libegl-imx \
    libgles2-imx \
    libgbm-imx \
    imx-gpu-g2d \
"

RDEPENDS:${PN}:append:imxmali = " \
    mali-imx-libegl \
    mali-imx-libgles2 \
    mali-imx-libgbm \
"

RDEPENDS:${PN}:append:mx95-nxp-bsp = " edgefirst-udev-rules"
