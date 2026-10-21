# Name the EdgeFirst release in /etc/os-release next to Torizon's own NAME and
# VERSION. meta-edgefirst adds the same fields for apt-updated boards; Torizon
# updates through OSTree, so the fields are added here and the apt feed stays
# off. EDGEFIRST_VERSION, EDGEFIRST_VENDOR and EDGEFIRST_FEED_BSP are set in
# this layer's layer.conf.

OS_RELEASE_FIELDS += "EDGEFIRST_RELEASE EDGEFIRST_VERSION EDGEFIRST_BSP"

EDGEFIRST_BSP = "${EDGEFIRST_FEED_BSP}"
PRETTY_NAME = "EdgeFirst Yocto ${EDGEFIRST_VERSION} for ${EDGEFIRST_VENDOR} BSP ${EDGEFIRST_BSP_VERSION}"
