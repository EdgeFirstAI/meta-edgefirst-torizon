# linux-toradex-imx is shared across Verdin i.MX8M Plus/i.MX95. Both patches
# below target the i.MX95 Neutron NPU and do not apply to the i.MX8M Plus
# tree, so they are scoped to verdin-imx95 only.
#
# 0001-npu-dma-512m.patch: enlarges the Neutron CMA reserved-memory pool
# from 128 MiB to 512 MiB.
#
# 0001-staging-neutron-export-buffers-as-dma-buf.patch (EDGEAI-1186, from
# meta-edgefirst's recipes-kernel/linux/linux-imx_%.bbappend, retargeted
# here from NXP's linux-imx recipe name to Torizon's linux-toradex-imx):
# replaces anon_inode_getfd() with dma_buf_export() in the Neutron buffer
# allocator, enabling zero-copy sharing with V4L2/GStreamer/GPU.

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:verdin-imx95 = " \
    file://0001-npu-dma-512m.patch \
    file://0001-staging-neutron-export-buffers-as-dma-buf.patch \
"
