# Source-compatibility fix, not hardware enablement — kept here (see this
# layer's charter) because this is the only layer we control in this
# manifest; the actual fix lives upstream in Toradex's aktualizr fork.
#
# meta-toradex-torizon's committed SRCREV (29a7d4bd0) pins aktualizr-torizon
# to a commit that still uses boost::asio::io_service, which openembedded-
# core's currently-pinned boost (1.87.0) removed entirely
# (boost/asio/io_service.hpp does not exist anywhere in the 1.87.0 source
# tree — confirmed directly). do_compile fails with "fatal error:
# boost/asio/io_service.hpp: No such file or directory" for
# aktualizr-torizon-native's secondary.cc and other translation units.
#
# Toradex's own upstream (github.com/toradex/aktualizr, toradex-master)
# already fixed this — "Support Boost 1.87 (Torizon changes)",
# "Support Boost v1.87", and two follow-up fixes. Bump SRCREV to the
# commit right after that fix series lands, not the current branch tip —
# the tip is 42 more commits ahead with unrelated changes we haven't
# evaluated.
SRCREV = "f9e98b01190a0f1cfe96c268eebd4801cdf5c5af"
