# vim: ft=sls

{#-
    Removes asdf completions for all managed users.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as asdf with context %}


{%- if "Darwin" != grains.kernel %}
{%-   for user in asdf.users | selectattr("completions", "defined") | selectattr("completions") %}

asdf shell completions are available for user '{{ user.name }}':
  file.absent:
    - name: {{ user.home | path_join(user.completions, "_asdf") }}
{%-   endfor %}
{%- endif %}
