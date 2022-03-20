{%- from 'tool-asdf/map.jinja' import asdf -%}

include:
  - .package

{%- for user in asdf.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') %}
  {%- set dotconfig = user.dotconfig if dotconfig is mapping else {} %}

Asdf configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user._asdf.confdir }}
    - source:
      - salt://dotconfig/{{ user.name }}/asdf
      - salt://dotconfig/asdf
    - context:
        user: {{ user | json }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
  {%- if dotconfig.get('file_mode') %}
    - file_mode: '{{ dotconfig.file_mode }}'
  {%- endif %}
    - dir_mode: '{{ dotconfig.get('dir_mode', '0700') }}'
    - clean: {{ dotconfig.get('clean', False) | to_bool }}
    - makedirs: True
    - require_in:
      - asdf setup is completed
{%- endfor %}
