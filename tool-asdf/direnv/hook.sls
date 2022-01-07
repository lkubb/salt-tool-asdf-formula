{%- from 'tool-asdf/direnv/init.sls' import users %}

include:
  - .package

{%- for user in users | selectattr('rchook', 'defined') %}
direnv is hooked to shell for '{{ user.name }}':
  file.append:
    - name: {{ user.home }}/{{ user.hook }}
    - source: salt://tool-asdf/direnv/files/{{ user.shell }}/hook
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
    - require:
      - direnv {{ version }} is installed for user '{{ user.name }}'
{%- endfor %}
