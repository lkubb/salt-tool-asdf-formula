{%- from 'tool-asdf/nodejs/map.jinja' import users %}

include:
  - .package

{%- for user in users | rejectattr('xdg', 'sameas', False) %}
asdf node plugin global configuration is migrated to XDG_CONFIG_HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user.xdg.config }}/asdf/default-npm-packages
    - source: {{ user.home }}/.default-npm-packages
    - makedirs: true
    - onlyif:
      - test -e {{ user.home }}/.default-npm-packages
    - require_in:
  {%- for version in user.asdf.nodejs %}
      - NodeJS {{ version }} is installed for user '{{ user.name }}'
  {%- endfor %}

asdf node uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        ASDF_NPM_DEFAULT_PACKAGES_FILE: "{{ user.xdg.config }}/asdf/default-npm-packages"
    - require_in:
  {%- for version in user.asdf.nodejs %}
      - NodeJS {{ version }} is installed for user '{{ user.name }}'
  {%- endfor %}

  {%- if user.get('persistenv') %}

persistenv file for asdf nodejs for user '{{ user.name }}' exists:
  file.managed:
    - name: {{ user.home }}/{{ user.persistenv }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: true

asdf node plugin knows about XDG location for user '{{ user.name }}':
  file.append:
    - name: {{ user.home }}/{{ user.persistenv }}
    - text: export ASDF_NPM_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/default-npm-packages"
    - require:
      - persistenv file for asdf nodejs for user '{{ user.name }}' exists
    - require_in:
    {%- for version in user.asdf.nodejs %}
      - NodeJS {{ version }} is installed for user '{{ user.name }}'
    {%- endfor %}
  {%- endif %}
{%- endfor %}
