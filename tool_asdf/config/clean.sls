# vim: ft=sls

{#-
    Removes the configuration of the asdf package.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as asdf with context %}


{%- for user in asdf.users %}

asdf config file is cleaned for user '{{ user.name }}':
  file.absent:
    - name: {{ user["_asdf"].conffile }}

{%-   if user.xdg %}

asdf config dir is absent for user '{{ user.name }}':
  file.absent:
    - name: {{ user["_asdf"].confdir }}
{%-   endif %}
{%- endfor %}
