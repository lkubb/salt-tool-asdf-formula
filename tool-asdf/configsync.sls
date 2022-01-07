{%- from 'tool-asdf/map.jinja' import asdf -%}

include:
  - .package

{%- for user in asdf.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') %}
Asdf configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user._asdf.confdir }}
    - source:
      - salt://dotconfig/{{ user.name }}/asdf
      - salt://dotconfig/asdf
    - context:
        user: {{ user }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
    - file_mode: keep
    - dir_mode: '0700'
    - makedirs: True
    - prereq_in:
      - asdf setup is completed
{%- endfor %}
