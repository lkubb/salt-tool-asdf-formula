{%- from 'tool-asdf/map.jinja' import asdf -%}

include:
  - .package

{%- for user in asdf.users | rejectattr('xdg', 'sameas', False) %}
asdf config dir in XDG_CONFIG_HOME exists for user '{{ user.name }}':
  file.directory:
    - name: {{ user.xdg.config }}/asdf
    - user: {{ user.name }}
    - group: {{ user.group }}
    - makedirs: true

asdf configuration is migrated to XDG_CONFIG_HOME for user '{{ user.name }}':
  file.rename:
    - names:
      - {{ user.xdg.config }}/asdf/tool-versions:
        - source: {{ user.home }}/.tool-versions
        - onlyif:
          - test -e {{ user.home }}/.tool-versions
      - {{ user.xdg.config }}/asdf/asdfrc:
        - source: {{ user.home }}/.asdfrc
        - onlyif:
          - test -e {{ user.home }}/.asdfrc
    - require:
      - asdf config dir in XDG_CONFIG_HOME exists for user '{{ user.name }}'
    - require_in:
      - asdf setup is completed

asdf data is migrated to XDG_DATA_HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user.xdg.data }}/asdf
    - source: {{ user.home }}/.asdf
    - makedirs: true
    - onlyif:
      - test -d {{ user.home }}/.asdf
    - require_in:
      - asdf setup is completed

asdf uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        ASDF_CONFIG_FILE: "{{ user.xdg.config }}/asdf/asdfrc"
        ASDF_DATA_DIR: "{{ user.xdg.data }}/asdf"
        ASDF_DEFAULT_TOOL_VERSIONS_FILENAME: "{{ user.xdg.config }}/asdf/tool-versions"
    - require_in:
      - asdf setup is completed

  {%- if user.get('persistenv') %}

persistenv file for asdf for user '{{ user.name }}' exists:
  file.managed:
    - name: {{ user.home }}/{{ user.persistenv }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: false
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: true

asdf knows about XDG locations for user '{{ user.name }}':
  file.append:
    - name: {{ user.home }}/{{ user.persistenv }}
    - text: |
        export ASDF_CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/asdfrc"
        export ASDF_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/asdf"
        export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/tool-versions"
    - require:
      - persistenv file for asdf for user '{{ user.name }}' exists
    - require_in:
      - asdf setup is completed
  {%- endif %}
{%- endfor %}
