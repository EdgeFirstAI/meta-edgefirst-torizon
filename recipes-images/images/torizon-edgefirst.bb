# The Torizon image this one extends, "docker" or "minimal". Set
# EDGEFIRST_TORIZON_BASE in local.conf to change it; the OSTree branch and
# the published image name are the same either way.
EDGEFIRST_TORIZON_BASE ?= "docker"

require recipes-images/images/torizon-${EDGEFIRST_TORIZON_BASE}.bb

# The required Torizon recipe sets both, and the TEZI image metadata is built
# from them.
SUMMARY = "Torizon OS with the EdgeFirst Perception Foundation"
DESCRIPTION = "Toradex Torizon OS plus the EdgeFirst NPU enablement, TensorFlow Lite delegates, edgefirst-client and edgefirst-profiler."

# EdgeFirst Perception Foundation.
IMAGE_INSTALL:append = " packagegroup-edgefirst-torizon"

# seatd hands the display and input devices to members of the seat group, and
# weston.service runs as the torizon user.
EXTRA_USERS_PARAMS += "usermod -a -G seat torizon; "

# Toradex names the OSTree branch <major>/<machine>/<distro>/<image>/<purpose>
# with the recipe name as <image>. Publish under "edgefirst" instead, so the
# branch is e.g. 0/verdin-imx8mp/torizon/edgefirst/testing, and use "develop"
# for the Development purpose.
#
# image.bbclass pulls in the class that assigns OSTREE_BRANCHNAME through
# inherit_defer, after this recipe's plain assignments, so the override has to
# be an anonymous function.
python () {
    purpose = d.getVar("TDX_OSTREE_PURPOSE")
    if purpose == "development":
        purpose = "develop"
    d.setVar("OSTREE_BRANCHNAME",
             "%s/%s/%s/edgefirst/%s" % (d.getVar("TDX_MAJOR"), d.getVar("MACHINE"),
                                         d.getVar("DISTRO"), purpose))
}

# create_image_tasks() freezes every variable the commit, ostree and ota tasks
# reference, except those named in vardepsexclude, before the function above
# runs. Excluding OSTREE_BRANCHNAME leaves it to expand at task run time.
IMAGE_CMD:ostreecommit[vardepsexclude] += "OSTREE_BRANCHNAME"
IMAGE_CMD:ostree[vardepsexclude] += "OSTREE_BRANCHNAME"
IMAGE_CMD:ota[vardepsexclude] += "OSTREE_BRANCHNAME"

# NetworkManager owns the network interfaces, so networkd manages none and
# systemd-networkd-wait-online always times out and shows as a failed unit.
# Mask it the way systemctl mask does. It has to run after
# systemd_handle_machine_id, whose preset-all fails the do_rootfs log check
# when the unit is already masked, so it is appended from an anonymous
# function.
python () {
    d.appendVar("ROOTFS_POSTPROCESS_COMMAND", " mask_networkd_wait_online;")
}
mask_networkd_wait_online() {
    install -d ${IMAGE_ROOTFS}${sysconfdir}/systemd/system
    ln -sf /dev/null ${IMAGE_ROOTFS}${sysconfdir}/systemd/system/systemd-networkd-wait-online.service
}
