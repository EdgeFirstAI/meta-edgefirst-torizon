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
# 0001-staging-neutron-export-buffers-as-dma-buf.patch (EDGEAI-1186, from
# meta-edgefirst's recipes-kernel/linux/linux-imx_%.bbappend, retargeted
# here from NXP's linux-imx recipe name to Torizon's linux-toradex-imx):
# replaces anon_inode_getfd() with dma_buf_export() in the Neutron buffer
# allocator, enabling zero-copy sharing with V4L2/GStreamer/GPU. This is
# kernel driver C code, not devicetree — unaffected by the kmeta bump.

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:verdin-imx95 = " \
    file://0001-staging-neutron-export-buffers-as-dma-buf.patch \
"
