{%- from 'tool-asdf/direnv/init.sls' import users %}

include:
  - .package

{%- for user in users | selectattr('rchook', 'defined') %}

rchook for asdf direnv exists for user '{{ user.name }}':
  file.managed:
    - name: {{ user.home }}/{{ user.hook }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: false
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: true

direnv is hooked to shell for '{{ user.name }}':
  file.append:
    - name: {{ user.home }}/{{ user.hook }}
    - source: salt://tool-asdf/direnv/files/{{ user.shell }}/hook
    - require:
      - direnv {{ version }} is installed for user '{{ user.name }}'
      - rchook for asdf direnv exists for user '{{ user.name }}'
{%- endfor %}
