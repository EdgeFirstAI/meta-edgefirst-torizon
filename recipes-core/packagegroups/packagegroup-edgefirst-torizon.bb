SUMMARY = "EdgeFirst Perception Foundation for Torizon OS"
DESCRIPTION = "The Foundation set installed into Torizon images: EdgeFirst HAL and \
VideoStream, the NPU runtime and delegate for the SoC, the GPU EGL, GLES and GBM \
libraries, the camera and video codec userspace, Wayland with Weston, and the EdgeFirst client \
and profiler tools. Everything above Foundation runs as containers."

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS:${PN} = " \
    packagegroup-edgefirst \
    packagegroup-edgefirst-npu \
    packagegroup-edgefirst-studio \
    edgefirst-ostree-remote \
    v4l-utils \
    weston \
    weston-init \
"

# GPU userspace the HAL loads at runtime: libEGL.so.1, libGLESv2.so.2 and
# libgbm.so.1, plus G2D on Vivante.
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

# Camera and codec stack, without GStreamer. The i.MX 8M Plus VPU is the Hantro
# G1/G2 decoder and VC8000E encoder, driven through their libraries and the
# V4L2 devices; the i.MX 95 has libcamera with the NEO ISP pipeline, the Wave6
# H.264/HEVC codec and the MXC JPEG codec as V4L2 devices.
RDEPENDS:${PN}:append:mx8mp-nxp-bsp = " \
    imx-vpu-hantro \
    imx-vpu-hantro-vc \
"

RDEPENDS:${PN}:append:mx95-nxp-bsp = " \
    packagegroup-edgefirst-camera \
    firmware-imx-vpu-wave \
"
