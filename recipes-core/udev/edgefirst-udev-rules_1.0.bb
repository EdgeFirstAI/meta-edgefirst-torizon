SUMMARY = "EdgeFirst device permissions"
DESCRIPTION = "Gives the video group access to /dev/neutron0, so edgefirst-profiler and other \
Neutron delegate users do not need root. The Vivante, DRM and dma-heap nodes are already in the video group."

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "file://96-edgefirst-neutron.rules"

S = "${UNPACKDIR}"

PACKAGE_ARCH = "${MACHINE_ARCH}"

do_install() {
    install -d ${D}${nonarch_libdir}/udev/rules.d
    install -m 0644 ${UNPACKDIR}/96-edgefirst-neutron.rules ${D}${nonarch_libdir}/udev/rules.d/
}

FILES:${PN} = "${nonarch_libdir}/udev/rules.d"
