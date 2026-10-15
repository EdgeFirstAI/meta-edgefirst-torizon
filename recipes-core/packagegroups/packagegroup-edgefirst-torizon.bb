SUMMARY = "EdgeFirst Perception Foundation for Torizon OS"
DESCRIPTION = "The Foundation set installed into Torizon images: EdgeFirst HAL and \
VideoStream, the NPU delegates and runtimes for the SoC (VX on i.MX 8M Plus, \
Neutron on i.MX 95), and the EdgeFirst client and profiler tools. Everything above \
Foundation runs as containers."

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS:${PN} = " \
    packagegroup-edgefirst \
    edgefirst-client \
    edgefirst-profiler \
"

RDEPENDS:${PN}:append:mx8mp-nxp-bsp = " \
    tensorflow-lite-vx-delegate \
"

RDEPENDS:${PN}:append:mx9-nxp-bsp = " \
    neutron \
    tensorflow-lite-neutron-delegate \
"
