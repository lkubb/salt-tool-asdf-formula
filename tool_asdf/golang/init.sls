# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/golang/map.jinja" import users %}

include:
{%- if users | rejectattr("xdg", "sameas", false) | list %}
  - .xdg
{%- endif %}
  - .package
