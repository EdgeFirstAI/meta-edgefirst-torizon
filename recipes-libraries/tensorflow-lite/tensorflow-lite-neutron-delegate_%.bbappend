# meta-edgefirst's bbappend pins SRCREV_neutron to a commit that only
# exists on the edgefirst-1.2.3 branch of EdgeFirstAI/tflite-neutron-delegate,
# but still points SRCBRANCH_neutron at the old rolling "edgefirst" branch
# (whose tip has since moved past this commit, orphaning the pin — the same
# class of bug meta-edgefirst's own 6bc71dc fixed for tflite-vx-delegate,
# tim-vx, imx-gst1.0-plugin, nnstreamer and litert-vx, but which missed this
# recipe). do_fetch fails: "Unable to find revision ... in branch edgefirst
# even from upstream". Repoint at the stable branch that actually contains
# the pinned commit; SRCREV_neutron itself is unchanged.

SRCBRANCH_neutron = "edgefirst-1.2.3"
