===========================
xiaq's herbstluftwm scripts
===========================

Scripts here are based off herbstluftwm's default config. The main differences
are:

* Some customizations in ``autostart`` (sure)

* Scripts are assumed to be in the same directory so script discovery is
  easier - instead of trying ``$XDG_CONFIG_HOME/herbstluftwm`` before
  ``$HOME/.config/herbstluftwm`` before ``/etc/xdg/herbstluftwm``, just use
  ``$(dirname "$0")``

* ``.sh`` suffixes are removed

* Meaningless refactors to ``panel`` :)

* New ``panels`` script to start/stop/restart panels on all monitors

* New ``conkyfmt`` and ``conkyrc``
