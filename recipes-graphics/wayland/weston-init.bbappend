# The Torizon distro allocates accounts from static tables and creates no home
# directories, but weston.service starts in the weston user's home.
do_install:append() {
    install -d ${D}${nonarch_libdir}/tmpfiles.d
    echo 'd /home/weston 0700 weston weston -' > ${D}${nonarch_libdir}/tmpfiles.d/weston-home.conf
}

FILES:${PN} += "${nonarch_libdir}/tmpfiles.d/weston-home.conf"
