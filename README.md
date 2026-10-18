# meta-edgefirst-torizon

Torizon OS integration for the [EdgeFirst Perception Platform](https://github.com/EdgeFirstAI/meta-edgefirst) on Toradex Verdin i.MX 8M Plus and i.MX 95.
It is the vendor layer paired with the generic `meta-edgefirst` and is pinned by the `torizon` branch of [EdgeFirstAI/yocto](https://github.com/EdgeFirstAI/yocto).

## Scope

The Foundation tier: NPU enablement (VSI Vivante on i.MX 8M Plus, eIQ Neutron on i.MX 95), the TensorFlow Lite VX and Neutron delegates, and the `edgefirst-client` and `edgefirst-profiler` tools.
Everything above Foundation runs as containers on Torizon.

`meta-edgefirst` stays generic.
This layer carries only what depends on Torizon or Toradex naming and conventions.

## Contents

- `recipes-core/packagegroups/packagegroup-edgefirst-torizon.bb` composes `packagegroup-edgefirst`, `packagegroup-edgefirst-npu` and `packagegroup-edgefirst-studio` from `meta-edgefirst`.
- `recipes-images/images/torizon-edgefirst.bb` is the EdgeFirst image.
  It requires Toradex's `torizon-docker` recipe, or `torizon-minimal` when `EDGEFIRST_TORIZON_BASE = "minimal"` is set in `local.conf`, installs that packagegroup, and sets the OSTree branch to `0/<machine>/torizon/edgefirst/<purpose>` with `develop`, `testing` or `release` as the purpose.
  The stock `torizon-docker` and `torizon-minimal` images build unmodified.
- `recipes-kernel/linux/linux-toradex-imx_%.bbappend` applies `meta-edgefirst`'s Neutron dma-buf patches to Toradex's kernel recipe, which `meta-edgefirst`'s `linux-imx` bbappend never matches.
  The patches are taken from the `meta-edgefirst` checkout rather than copied.
- `recipes-graphics/imx-gpu-viv`, `recipes-graphics/imx-g2d` and `recipes-kernel/kernel-modules` carry NXP's Vivante 6.4.11.p4.2 recipes (OpenVX, `libnn-imx`, G2D and the `galcore` module) from `meta-imx-bsp`, which is not in the Torizon layer set, and `conf/layer.conf` prefers them over the p3.2 recipes in `meta-freescale`.
  They are the VSI NPU driver and user space of NXP's L6.12.49-2.2.0 release, and the user space and the `galcore` module must be built from the same release.
- `recipes-kernel/linux/linux-toradex-imx/0010` to `0014` bring Toradex's Neutron driver level with NXP's L6.12.49-2.2.0 (interrupt-driven inference, the `send_reset` mutex, the register read-back removal), retry the remoteproc lookup that can lose a boot race, and `0014` adds the mailbox handshake that eIQ Neutron SDK 3.2.x firmware requires.
- `recipes-kernel/linux/device-tree-overlays-imx_%.bbappend` builds `verdin-imx95_efpi-npu-dma-512m_overlay.dtbo`, which raises the `/reserved-memory/npu-dma` pool used by the Neutron NPU from 128 MiB to 512 MiB, and adds it to `overlays.txt` so it is applied at boot.
- `recipes-foundation/tim-vx/tim-vx_%.bbappend` aligns the unpack directory with Torizon's `S`.
- `recipes-sota/aktualizr-torizon/aktualizr-torizon_git.bbappend` moves aktualizr to a revision that builds against the pinned Boost.

## Usage

Build with `bitbake torizon-edgefirst`.
Select this layer through the manifest on the `torizon` branch of `EdgeFirstAI/yocto`, which also pins `meta-edgefirst` and the Toradex layers.

## License

Apache-2.0.
