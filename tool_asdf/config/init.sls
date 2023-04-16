# vim: ft=sls

{#-
    Manages the asdf package configuration by

    * recursively syncing from a dotfiles repo

    Has a dependency on `tool_asdf.package`_.
#}

include:
  - .sync
