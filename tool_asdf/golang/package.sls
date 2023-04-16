# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/golang/map.jinja" import users %}

include:
  - {{ tplroot }}.package
  - .deps


{%- for user in users %}
{%-   if user.asdf.get("update_auto") %}

Golang plugin is up to date for user '{{ user.name }}':
  asdf.plugin_latest:
    - name: golang
    - user: {{ user.name }}
{%-   endif %}

{%-   for version in user.asdf.golang %}

Go {{ version }} is installed for user '{{ user.name }}':
  asdf.version_installed:
    - name: golang
    - version: '{{ version }}'
    - user: {{ user.name }}
    - require:
      - asdf setup is completed
      - Required packages for compiling Go are available
{%-   endfor %}
{%- endfor %}

asdf golang setup is completed:
  test.nop:
    - require:
      - Required packages for compiling Go are available
