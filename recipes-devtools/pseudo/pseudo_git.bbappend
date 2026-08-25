# Host build-environment compatibility fix, not hardware enablement — kept
# here (see this layer's charter for the caveat) because layer bbappends
# are the standard Yocto mechanism for this, matching the reference fix
# already validated in torizon-walnascar's own meta-custom layer.
#
# Bump pseudo to the master (pseudo-1.9) tip 1.9.8 to pick up the openat2()
# wrapper series (upstream commits 899736e..bff561c, "openat2: Implement
# openat2 wrapper" + "Add missing __open_2 wrapper").
#
# Host GNU tar 1.35 opens the extraction target directory via openat2() and
# works relative to that fd. The pinned pseudo 1.9.0 has no openat2 wrapper,
# so it never records that dirfd and every subsequent *at() syscall fails
# during do_package:
#   "got *at() syscall for unknown directory, fd N"
#   "unknown base path for fd N"
# breaking perform_packagecopy for any recipe packaged locally — this is
# not scoped to any single recipe, it breaks packaging broadly across the
# whole build once do_package starts running for real content.
SRCREV = "823895ba708c63f6ae4dcbfc266210f26c02c698"
PV = "1.9.8+git"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# 0001-configure-Prune-PIE-flags.patch is upstreamed by 1.9.8 (configure now
# strips -fpie from the generated Makefile itself), so drop it.
# older-glibc-symbols.patch is refreshed in this layer's files/ for the new
# $(LIBPSEUDO) link rule; glibc238.patch still applies from oe-core unchanged.
SRC_URI:remove = "file://0001-configure-Prune-PIE-flags.patch"
