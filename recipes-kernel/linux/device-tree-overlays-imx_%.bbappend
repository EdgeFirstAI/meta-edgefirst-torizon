# Neutron NPU buffers come from the dedicated /reserved-memory/npu-dma pool,
# which Toradex sizes at 128 MiB. This overlay raises it to 512 MiB and is
# applied at boot through overlays.txt.
FILESEXTRAPATHS:prepend := "${THISDIR}/device-tree-overlays-imx:"

EDGEFIRST_NPU_OVERLAY = "verdin-imx95_efpi-npu-dma-512m_overlay"

SRC_URI:append:verdin-imx95 = " file://${EDGEFIRST_NPU_OVERLAY}.dts"

do_collect_overlays:prepend:verdin-imx95 () {
    install -m 0644 ${UNPACKDIR}/${EDGEFIRST_NPU_OVERLAY}.dts ${S}/
}

TEZI_EXTERNAL_KERNEL_DEVICETREE_BOOT:append:verdin-imx95 = " ${EDGEFIRST_NPU_OVERLAY}.dtbo"
