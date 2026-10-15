# linux-toradex-imx is shared across Verdin i.MX8M Plus/i.MX95. Both patches
# below target the i.MX95 Neutron NPU and do not apply to the i.MX8M Plus
# tree, so they are scoped to verdin-imx95 only.
#
# 0001-npu-dma-512m.patch: enlarges the Neutron CMA reserved-memory pool
# from 128 MiB to 512 MiB. TEMPORARILY DISABLED (not in SRC_URI below) —
# the torizon-kernel-meta bump to 19e06246 (see local.conf's
# SRCREV_torizon-meta override, needed for verdin-imx95's
# bsp/verdin-imx95-standard-torizon.scc feature file) restructured how
# the Neutron NPU's memory-region is declared: the npu_dma node this
# patch targets in imx95-verdin.dtsi no longer exists at all (confirmed:
# grep for npu_dma/npu-dma/neutron across the whole freescale/ dts tree
# finds nothing there). NPU memory reservation now appears to live in a
# .dtso overlay model instead (see imx95-19x19-evk-neutron.dtso's
# &neutron_mem node, for the EVK — Verdin's equivalent wasn't
# investigated). This is a sizing/performance patch (128→512 MiB), not
# required for basic Neutron NPU function — re-deriving it against the
# new overlay model is follow-up work, not a build blocker. The default
# pool size still applies without this patch.
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
