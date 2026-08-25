# Fix meta-edgefirst's SRC_URI override losing S/UNPACKDIR alignment
#
# meta-edgefirst's own tim-vx bbappend reassigns SRC_URI wholesale to a
# single git entry with no destsuffix, dropping the base recipe's
# structure that happened to unpack at a directory name matching S
# (${WORKDIR}/${BP}). BitBake's base_do_unpack only moves unpacked
# content from UNPACKDIR into WORKDIR/${BP} (its "compatibility magic",
# see bitbake's base_do_unpack) when the fetcher's destsuffix equals
# ${BP} exactly — without it, the source lands in ${UNPACKDIR}/git and
# is never moved to ${S}, so LIC_FILES_CHKSUM ("file://LICENSE") can't
# find the file and do_populate_lic fails with a fatal QA error, even
# though do_fetch/do_unpack report success.
#
# destsuffix is a git fetcher URL parameter, not a variable flag —
# re-assert the full SRC_URI (same URL/branch meta-edgefirst sets) with
# destsuffix added, rather than trying to patch it in via SRC_URI[destsuffix].
SRC_URI = "git://github.com/EdgeFirstAI/tim-vx-imx.git;protocol=https;branch=edgefirst-1.2.3;destsuffix=${BP}"
