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
#
# Toradex's tree predates NXP's lf-6.12.49-2.2.0 Neutron driver. 0010 (NXP
# AIR-11097, interrupt-driven inference completion) and 0011 (NXP LF-16016,
# mutex around send_reset) and 0013 (NXP LF-16577, drop the read-back of the
# SRC reset register that current firmware modifies) bring it level with
# 2.2.0. 0012 retries the remoteproc lookup that can lose a race with
# imx_neutron_rproc at boot and otherwise leaves a NULL handle that the first
# open of /dev/neutron0 dereferences.

EDGEFIRST_KERNEL_PATCHES = "${@next((l for l in d.getVar('BBLAYERS').split() if l.endswith('/meta-edgefirst')), '')}/recipes-kernel/linux/files"
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:${EDGEFIRST_KERNEL_PATCHES}:"

SRC_URI:append:verdin-imx95 = " \
    file://0001-staging-neutron-export-buffers-as-dma-buf.patch \
    file://0003-staging-neutron-import-dma-buf-namespace.patch \
    file://0010-neutron-enable-irq-mode-for-inference-jobs.patch \
    file://0011-neutron-add-mutex-protection-for-send_reset.patch \
    file://0012-neutron-fix-rproc-probe-race-null-deref.patch \
    file://0013-remoteproc-imx_neutron-remove-register-write-verification.patch \
"
