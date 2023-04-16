# vim: ft=sls

{#-
    *Meta-state*.

    Undoes mostly everything performed in the ``tool_asdf`` meta-state
    in reverse order.
#}

# @TODO This is unfinished, all installed
# tools should be uninstalled as well.

include:
  - .completions.clean
  - .config.clean
  - .package.clean
