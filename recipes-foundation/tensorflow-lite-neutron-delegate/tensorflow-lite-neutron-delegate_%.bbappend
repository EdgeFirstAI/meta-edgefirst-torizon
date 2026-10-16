# meta-edgefirst builds walnascar from the frozen edgefirst-1.2.3 fork branch.
# Torizon tracks the rolling edgefirst branch, as meta-edgefirst does for
# whinlatter and wrynose.
python () {
    d.setVar("SRCBRANCH_neutron", "edgefirst")
    d.setVar("SRCREV_neutron", "dd81103c1305b0ee7e49cde51624cda18f7dd51c")
}
