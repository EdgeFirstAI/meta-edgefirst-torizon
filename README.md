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
- `recipes-images/images/torizon-minimal.bbappend` and `torizon-docker.bbappend` install that packagegroup into the Torizon images.
  The `torizon-docker` bbappend also sets the OSTree branch name for EdgeFirst builds.
- `recipes-kernel/linux/linux-toradex-imx_%.bbappend` applies `meta-edgefirst`'s Neutron dma-buf patches to Toradex's kernel recipe, which `meta-edgefirst`'s `linux-imx` bbappend never matches.
  The patches are taken from the `meta-edgefirst` checkout rather than copied.
  `0001-npu-dma-512m.patch` (a 512 MiB Neutron CMA pool) is kept in the tree but not applied.
- `recipes-foundation/tim-vx/tim-vx_%.bbappend` aligns the unpack directory with Torizon's `S`.
- `recipes-foundation/tflite-vx-delegate` and `recipes-foundation/tensorflow-lite-neutron-delegate` build the VX and Neutron delegates from the rolling `edgefirst` branches of their forks instead of the frozen `edgefirst-1.2.3` branches `meta-edgefirst` selects for walnascar. `litert-vx-delegate` is not overridden because the new branch needs the LiteRT 6.18 layout, and no image installs it.
- `recipes-sota/aktualizr-torizon/aktualizr-torizon_git.bbappend` moves aktualizr to a revision that builds against the pinned Boost.

## Usage

Select this layer through the manifest on the `torizon` branch of `EdgeFirstAI/yocto`, which also pins `meta-edgefirst` and the Toradex layers.

## License

Apache-2.0.
