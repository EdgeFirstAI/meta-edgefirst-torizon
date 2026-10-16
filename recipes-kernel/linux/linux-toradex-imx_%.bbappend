# linux-toradex-imx is shared across Verdin i.MX8M Plus/i.MX95. The patches
# below target the i.MX95 Neutron NPU and do not apply to the i.MX8M Plus
# tree, so they are scoped to verdin-imx95 only.
#
# The Neutron NPU memory pool size is set by the device-tree-overlays-imx
# bbappend.
#
# The Neutron DMA-BUF export patch (0001) and its DMA_BUF namespace import
# (0003) are carried by meta-edgefirst for NXP's raw linux-imx recipe; they
# are reused from there rather than copied. They apply to the 6.12 kernel
# series that both NXP walnascar and linux-toradex-imx are built from.

EDGEFIRST_KERNEL_PATCHES = "${@next((l for l in d.getVar('BBLAYERS').split() if l.endswith('/meta-edgefirst')), '')}/recipes-kernel/linux/files"
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:${EDGEFIRST_KERNEL_PATCHES}:"

SRC_URI:append:verdin-imx95 = " \
    file://0001-staging-neutron-export-buffers-as-dma-buf.patch \
    file://0003-staging-neutron-import-dma-buf-namespace.patch \
"
