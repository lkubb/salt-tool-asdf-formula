# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as asdf with context %}
{%- from tplroot ~ "/direnv/init.sls" import users %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch %}

include:
  - {{ tplroot }}.direnv.package


{%- for user in users | selectattr("rchook", "defined") %}

rchook for asdf direnv exists for user '{{ user.name }}':
  file.managed:
    - name: {{ user.home | path_join(user.rchook) }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: false
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: true

direnv is hooked to shell for '{{ user.name }}':
  file.append:
    - name: {{ user.home | path_join(user.rchook) }}
    - source: {{ files_switch(
                    ["direnv/" ~ user.shell ~ "/hook"],
                    lookup="direnv is hooked to shell for '{}'".format(user.name),
                    config=asdf,
                    custom_data={"users": [user.name]},
                 )
              }}
    - require:
      - sls: {{ tplroot }}.direnv.package
      - rchook for asdf direnv exists for user '{{ user.name }}'
{%- endfor %}
