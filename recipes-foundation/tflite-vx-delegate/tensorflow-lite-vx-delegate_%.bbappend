# meta-edgefirst builds walnascar from the frozen edgefirst-1.2.3 fork branch.
# Torizon tracks the rolling edgefirst branch for its DMA-BUF fixes. This
# function must run after meta-edgefirst's, which the higher layer priority
# guarantees.
python () {
    d.setVar("SRCBRANCH_vx", "edgefirst")
    d.setVar("SRCREV_vx", "6f8189fe3db880470e23cfdc1ac412caa10ad482")
}
