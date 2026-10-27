# Run the compositor as the torizon user, the account applications run as, so
# the Wayland socket and the session belong to the same user. seatd gives the
# display and input devices to the seat group, which the image adds torizon to.
# The Toradex bbappend sets User=root in the unit itself; a drop-in takes
# precedence over it.
do_install:append() {
    install -d ${D}${systemd_system_unitdir}/weston.service.d
    printf '[Service]\nUser=torizon\nGroup=torizon\nWorkingDirectory=/home/torizon\n' \
        > ${D}${systemd_system_unitdir}/weston.service.d/10-torizon.conf
    install -d ${D}${systemd_system_unitdir}/weston.socket.d
    printf '[Socket]\nSocketUser=torizon\nSocketGroup=torizon\n' \
        > ${D}${systemd_system_unitdir}/weston.socket.d/10-torizon.conf
}

FILES:${PN} += "${systemd_system_unitdir}/weston.service.d ${systemd_system_unitdir}/weston.socket.d"
