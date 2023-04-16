# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as asdf with context %}

{%- set users = asdf.users | selectattr("asdf.rust", "defined") | list -%} {# casting to list ensures it can be imported #}

include:
{%- if users | rejectattr("xdg", "sameas", false) | list %}
  - .xdg
{%- endif %}
  - .package
