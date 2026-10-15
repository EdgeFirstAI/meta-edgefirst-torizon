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
# meta-edgefirst picks SRC_URI (branch/SRCREV) from an anonymous python
# function keyed on LAYERSERIES_CORENAMES. Anonymous functions all run
# in a later parsing phase, after every plain variable assignment in the
# whole recipe+bbappend stack — so a plain SRC_URI assignment here, even
# from this higher-priority layer, gets applied first and is then
# clobbered when meta-edgefirst's anonymous function runs. This must
# also be an anonymous function (parsed after meta-edgefirst's, so it
# runs after it in the same later phase) that appends destsuffix to
# whatever SRC_URI meta-edgefirst already picked, instead of a plain
# assignment that duplicates its branch/SRCREV selection.
python () {
    d.setVar("SRC_URI", d.getVar("SRC_URI") + ";destsuffix=${BP}")
}
