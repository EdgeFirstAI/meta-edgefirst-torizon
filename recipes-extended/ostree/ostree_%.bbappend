# Commit signature verification on devices and signing in the native tools.
# Torizon's meta-updater removes gpgme, so the pull-time checks use ed25519.
PACKAGECONFIG:append = " ed25519-openssl"
PACKAGECONFIG:class-native:append = " ed25519-openssl"
