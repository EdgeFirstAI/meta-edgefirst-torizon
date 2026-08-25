# meta-edgefirst-torizon

Torizon-specific hardware-enablement patches for the [EdgeFirst Perception Platform](https://github.com/EdgeFirstAI/meta-edgefirst) on Toradex Verdin i.MX8M Plus / i.MX95, used by the `torizon` branch of [EdgeFirstAI/yocto](https://github.com/EdgeFirstAI/yocto).

## Why this layer exists

`meta-edgefirst`'s own kernel bbappend (`recipes-kernel/linux/linux-imx_%.bbappend`) targets NXP's raw `linux-imx` recipe name. Torizon does not use that recipe — Toradex ships its own downstream kernel fork as `linux-toradex-imx`. A bbappend targeting the wrong recipe name is not an error, it just silently never applies. This layer carries the same patches meta-edgefirst applies for the NXP flavor, retargeted onto the correct recipe name.

The NPU delegate recipes (`tim-vx`, `tflite-vx-delegate`, `litert-vx-delegate`, `tensorflow-lite-neutron-delegate`, `nnstreamer`, `imx-gst1.0-plugin`) come from `meta-freescale-ml`/`meta-imx-ml` under their normal upstream names on Torizon too, so `meta-edgefirst`'s bbappends onto those apply here with no retargeting needed. The kernel recipe name is the one Torizon-specific exception this layer exists to handle.

## What it contains

`recipes-kernel/linux/linux-toradex-imx_%.bbappend`, scoped to `verdin-imx95` (i.MX8M Plus doesn't have the Neutron NPU or the DT node these patch, and `linux-toradex-imx` is shared across both machines' `COMPATIBLE_MACHINE`):

- `0001-npu-dma-512m.patch` — enlarges the Verdin i.MX95 Neutron NPU's CMA reserved-memory pool from 128 MiB to 512 MiB.
- `0001-staging-neutron-export-buffers-as-dma-buf.patch` (EDGEAI-1186) — Neutron NPU DMA-BUF export support (zero-copy V4L2/GStreamer/GPU sharing), copied byte-exact from `meta-edgefirst`'s own patch file.

## Usage

Referenced by [`edgefirst-torizon-walnascar.xml`](https://github.com/EdgeFirstAI/yocto/blob/torizon/edgefirst-torizon-walnascar.xml) on the `torizon` branch of `EdgeFirstAI/yocto` — see that repo for the full build setup.

## License

Apache-2.0, matching `meta-edgefirst` and the rest of the EdgeFirstAI layers.
