# Publish under the "edgefirst" name instead of the recipe's own
# IMAGE_BASENAME ("torizon-docker"), since this is the EdgeFirst Perception
# Platform image, not a generic Torizon image. Keeps Toradex's own
# OSTREE_BRANCHNAME structure (TDX_MAJOR/MACHINE/DISTRO/.../TDX_OSTREE_PURPOSE,
# from meta-toradex-torizon's torizon_base_image_type.inc) so tooling that
# expects that convention still works — only the image-name segment changes.
#
# Resolves to e.g. 0/verdin-imx8mp/torizon/edgefirst/testing.
#
# image.bbclass pulls in image_type_torizon (and thus
# torizon_base_image_type.inc's OSTREE_BRANCHNAME assignment) via
# inherit_defer, which runs after this bbappend's own plain assignments are
# already applied — so a plain assignment here gets silently overwritten.
# Must be an anonymous function so it runs in that same later phase, after
# the deferred class has set its own value.
python () {
    d.setVar("OSTREE_BRANCHNAME",
             "%s/%s/%s/edgefirst/%s" % (d.getVar("TDX_MAJOR"), d.getVar("MACHINE"),
                                         d.getVar("DISTRO"), d.getVar("TDX_OSTREE_PURPOSE")))
}

# The above still isn't enough for do_image_ostreecommit's actual --branch=
# argument: image.bbclass's create_image_tasks() (also an anonymous function,
# defined earlier and so running before this bbappend's) builds that task by
# taking a *copy* of the datastore, deleting only the variables named in
# IMAGE_CMD:ostreecommit[vardepsexclude] from that copy, then fully expanding
# and freezing everything else into the task body right there — before our
# override above has run. A deleted-and-thus-undefined variable is left as a
# literal ${VAR} placeholder in the frozen text instead of being expanded, so
# it re-resolves fresh (against the real, later-updated datastore) at actual
# task execution time; that's why EXTRA_OSTREE_COMMIT (already excluded) picks
# up our fix but the direct --branch=${OSTREE_BRANCHNAME} reference doesn't.
# Exclude OSTREE_BRANCHNAME too so it gets the same late-binding treatment.
IMAGE_CMD:ostreecommit[vardepsexclude] += "OSTREE_BRANCHNAME"

# do_image_ostree (meta-updater's IMAGE_CMD:ostree, which builds the
# ostree-formatted rootfs tree) has its own direct reference — it writes
# OSTREE_BRANCHNAME into usr/share/sota/branchname for on-device inspection.
# Same freeze, same fix.
IMAGE_CMD:ostree[vardepsexclude] += "OSTREE_BRANCHNAME"

# systemd-networkd-wait-online.service is enabled by default but can never
# succeed here: NetworkManager (not networkd) owns the network interfaces,
# so every interface networkd sees reports SETUP=unmanaged, and wait-online
# only tracks interfaces networkd itself manages. It always times out after
# its full wait window and shows up as a failed unit, regardless of Docker
# or of any --ignore= tuning of its interface list (verified live on
# verdin-imx8mp/imx95: docker0/br-* excludes didn't help, since the real
# problem is networkd managing nothing, not which interfaces it waits for).
# NetworkManager-wait-online.service is the one that actually reflects
# network state; mask the redundant, always-failing networkd one the same
# way `systemctl mask` does on a running system: symlink to /dev/null.
#
# Must run strictly after rootfs-postcommands.bbclass's systemd_handle_machine_id
# (also registered via ROOTFS_POSTPROCESS_COMMAND +=, but from a class merged in
# ahead of this bbappend's plain += in the final command order — confirmed via
# `bitbake -e`). That function runs `systemctl --preset-mode=enable-only
# preset-all`, which — if it finds the unit already masked — prints "Failed to
# preset unit: ... is masked" (benign to systemctl itself), and do_rootfs's
# log_check QA scan fails the build on the word "Failed" in that output. A
# plain += lands wherever the merge order puts it; an anonymous function is
# guaranteed to run after every plain assignment is in place (same fix as the
# OSTREE_BRANCHNAME override above), so append the mask step from one instead.
python () {
    d.appendVar("ROOTFS_POSTPROCESS_COMMAND", " mask_networkd_wait_online;")
}
mask_networkd_wait_online() {
    install -d ${IMAGE_ROOTFS}${sysconfdir}/systemd/system
    ln -sf /dev/null ${IMAGE_ROOTFS}${sysconfdir}/systemd/system/systemd-networkd-wait-online.service
}

# EdgeFirst Perception Foundation.
IMAGE_INSTALL:append = " packagegroup-edgefirst-torizon"
