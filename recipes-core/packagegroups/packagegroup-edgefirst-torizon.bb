SUMMARY = "EdgeFirst Perception Foundation for Torizon OS"
DESCRIPTION = "The Foundation set installed into Torizon images: EdgeFirst HAL and \
VideoStream, the NPU runtime and delegate for the SoC, and the EdgeFirst client \
and profiler tools. Everything above Foundation runs as containers."

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS:${PN} = " \
    packagegroup-edgefirst \
    packagegroup-edgefirst-npu \
    packagegroup-edgefirst-studio \
"
