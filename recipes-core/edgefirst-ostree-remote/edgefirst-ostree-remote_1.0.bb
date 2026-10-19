SUMMARY = "EdgeFirst OSTree remote with commit signature verification"
DESCRIPTION = "Defines the edgefirst remote and ships the ed25519 public key that its commits and summary must be signed with."

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = " \
    file://edgefirst.conf \
    file://edgefirst-torizon-ed25519.pub \
"

S = "${UNPACKDIR}"

do_install() {
    install -d ${D}${sysconfdir}/ostree/remotes.d
    install -m 0644 ${UNPACKDIR}/edgefirst.conf ${D}${sysconfdir}/ostree/remotes.d/edgefirst.conf
    install -d ${D}${datadir}/edgefirst/ostree
    install -m 0644 ${UNPACKDIR}/edgefirst-torizon-ed25519.pub ${D}${datadir}/edgefirst/ostree/edgefirst-torizon-ed25519.pub
}

FILES:${PN} = "${sysconfdir}/ostree/remotes.d ${datadir}/edgefirst/ostree"
CONFFILES:${PN} = "${sysconfdir}/ostree/remotes.d/edgefirst.conf"
