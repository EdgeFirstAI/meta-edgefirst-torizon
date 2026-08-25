# Fix S/UNPACKDIR misalignment in meta-imx-ml's tvm bbappend (unrelated to
# EdgeFirst — this is a generic meta-imx-ml/meta-freescale-ml recipe issue,
# not Torizon- or EdgeFirst-specific; kept here because this is the only
# layer we control in this manifest. Worth reporting upstream separately.)
#
# tvm's SRC_URI has 5 git entries: the main TVM_SRC clone (no explicit
# destsuffix, defaults to "git") plus 4 submodules (dlpack, dmlc-core,
# rang, vta-hw) explicitly placed under destsuffix=git/3rdparty/<name> —
# i.e. the whole tree, main source plus submodules, is designed to land
# together at ${UNPACKDIR}/git. But this recipe doesn't override S, so
# it defaults to ${WORKDIR}/${BP} ("tvm-0.7.0"), which BitBake's
# base_do_unpack "compatibility magic" only populates when the fetcher's
# destsuffix equals ${BP} exactly — it doesn't here ("git" != "tvm-0.7.0"),
# so ${S} stays empty and do_patch fails with "can't find file to patch"
# even though do_fetch/do_unpack both report success and the real content
# (confirmed: CMakeLists.txt, 3rdparty/{dlpack,dmlc-core,rang,vta-hw})
# is sitting right there at ${UNPACKDIR}/git.
S = "${UNPACKDIR}/git"
