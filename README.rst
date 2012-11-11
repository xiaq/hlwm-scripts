===========================
xiaq's herbstluftwm scripts
===========================

Overview
--------
Scripts here are based off herbstluftwm's default config. The main differences
are:

* Some customizations in ``autostart`` (obviously)

* Scripts are assumed to be in the same directory so script discovery is
  easier - instead of trying ``$XDG_CONFIG_HOME/herbstluftwm`` before
  ``$HOME/.config/herbstluftwm`` before ``/etc/xdg/herbstluftwm``, just use
  ``$(dirname "$0")``

* ``.sh`` suffixes are removed

* New ``panels`` script to start/stop/restart panels on all monitors
  (``restartpanels.sh`` and panel starting code in ``autostart`` gone)

* Changes to ``panel``:

  * Meaningless refactors :)

  * New ``conkyfmt`` and ``conkyrc`` to show system status battery gauge,
    memory gauge and CPU usage *timeline*

  * A screenshot of the panel in action:
    https://www.dropbox.com/s/56pgh3ix8xbp2et/mydzen.png


Bugs
----

A lot :) Specifically I don't have a multi-monitor setup (yet), so it's likely
to be broken with such setups.


Dependencies
------------

* herbstluftwm :)

* bash 4.x

* latest dzen2 with xft patch

* I use the font Wenquanyi MicroHei Mono for window titles because I write
  Chinese. Change ``panel`` if you don't have it

* conky, as source of system status info

* python2 (for ``conkyfmt``)

* trayer, for system tray
